module Kekomi
  class ContentTypes
    module Base
      extend ActiveSupport::Concern

      def serialize_fields
        attributes.each_pair do |key, value|
          attributes[key] = value.serialize if attributes[key].respond_to? :serialize
        end
      end

      module ClassMethods

        def field(name, options = {})
          options.reverse_merge! :type => :string
          class_name = options[:type].to_s.classify.demodulize
          if Store.instance.valid_field? class_name
            super name, { type: "#{Store.instance.field_types[class_name][:klass]}::Converter".constantize }
            define_method "#{name}=" do |val|
              attribute_will_change!(name.to_s)
              attributes[name.to_s] = Store.instance.field_types[class_name][:klass].new(val)
            end

            define_method "#{name}" do
              value = attributes[name.to_s]
              unless value.is_a? Store.instance.field_types[class_name][:klass]
                attributes[name.to_s] = Store.instance.field_types[class_name][:klass].new(HashWithIndifferentAccess.new(value)[:value])
              end
              attribute_will_change!(name.to_s)
              attributes[name.to_s]
            end

          else
            raise Kekomi::ContentTypes::Errors::InvalidFieldType, "Field type #{options[:type]} is invalid."
          end
        end

      end

    end
  end
end