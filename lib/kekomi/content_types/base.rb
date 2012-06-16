require "pp"

module Kekomi
  class ContentTypes
    module Base
      extend ActiveSupport::Concern

      def serialize_fields
        attributes.each_pair do |key, value|
          attributes[key] = value.serialize if attributes[key].respond_to? :serialize
        end
      end

      def write_attribute(name, value)
        access = name.to_s
        if self.class.serializable_fields.has_key? access
          klass = self.class.serializable_fields[access]
          attribute_will_change! access
          return attributes[access] = value.is_a?(klass) ? value : klass.new(value)
        else
          return super
        end
      end

      def read_attribute(name)
        access = name.to_s
        if self.class.serializable_fields.has_key? access
          value = attributes[access]
          return nil if value.nil?
          unless value.is_a? self.class.serializable_fields[access]
            attribute_will_change! access
            return attributes[access] = self.class.serializable_fields[access].new(HashWithIndifferentAccess.new(value)[:value])
          end
          return value
        else
          return super
        end
      end

      module ClassMethods

        def serializable_fields
          @_serializable_fields ||= {}
        end

        def field(name, options = {})

          options.reverse_merge! :type => :string
          class_name = options[:type].to_s.classify.demodulize
          if Store.instance.valid_field? class_name
            super name, { type: "#{Store.instance.field_types[class_name][:klass]}::Converter".constantize }
            serializable_fields[name.to_s] = Store.instance.field_types[class_name][:klass]

            define_method "#{name}=" do |val|
              write_attribute name, val
            end

            define_method "#{name}" do
              read_attribute name
            end

          else
            raise Kekomi::ContentTypes::Errors::InvalidFieldType, "Field type #{options[:type]} is invalid."
          end
        end

      end

    end
  end
end