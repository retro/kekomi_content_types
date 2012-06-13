module Kekomi
  class ContentTypes
    module Base
      extend ActiveSupport::Concern

      module ClassMethods

        def field(name, options = {})
          options.reverse_merge! :type => :string
          class_name = options[:type].to_s.classify.demodulize
          if Store.instance.valid_field? class_name
            super name, { type: "#{Store.instance.field_types[class_name][:klass]}::Converter".constantize }
          else
            raise Kekomi::ContentTypes::Errors::InvalidFieldType, "Field type #{options[:type]} is invalid."
          end
        end

      end

    end
  end
end