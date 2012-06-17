class Kekomi
  class ContentTypes
    module Base
      extend ActiveSupport::Concern

      module ClassMethods

        def serializable_fields
          @_serializable_fields ||= {}
        end

        def field(name, options = {})

          options.reverse_merge! :type => :string
          class_name = options[:type].to_s.classify.demodulize
          if Store.instance.valid_field? class_name
            super name, { type: "#{Store.instance.field_types[class_name][:klass]}".constantize }
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

      included do
        self.validate :validate_fields
      end

      def serialize_fields
        self.class.serializable_fields.each_pair do |key, klass|
          value = attributes[key]
          attribute_will_change! key
          unless value.nil?
            attributes[key] = {
              type:  klass.to_s.demodulize,
              value: attributes[key].serialize
            }
          end
        end
      end

      def write_attribute(name, value)
        access = name.to_s
        if self.class.serializable_fields.has_key? access
          klass = self.class.serializable_fields[access]
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
            return attributes[access] = self.class.serializable_fields[access].new(HashWithIndifferentAccess.new(value)[:value])
          end
          return value
        else
          return super
        end
      end

      protected

        def validate_fields
          self.class.serializable_fields.each_pair do |key, klass|
            field = self.read_attribute(key)
            if !field.nil? and !field.valid?
              field_errors = field.errors
              field_errors.each do |field, error|
                errors.add "#{key}.#{field}", error
              end
            end
          end
        end

    end
  end
end