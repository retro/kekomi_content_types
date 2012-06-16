module Kekomi
  class ContentTypes
    class Collections
      def self.add(name, &block)
        name  = name.to_s.classify
        klass = Class.new(Array)
        self.const_set name, klass
        [Mongoid::Fields::Serializable, CoercedArray, Base].each do |inc|
          klass.send :include, inc
        end
        klass.class_eval &block
        Store.instance.add_field_type :collection, klass
        klass
      end

      module Base
        extend ActiveSupport::Concern
        extend Mongoid::Fields::Serializable

        module ClassMethods

          def allow(klass)
            klass = Store.instance.field_types[klass.to_s.classify.demodulize][:klass]
            if Store.instance.valid_field_for? klass, :collection
              @_allowed = klass
              @_allowed
            else
               raise Kekomi::ContentTypes::Errors::InvalidFieldType, "Field type #{options[:type]} is invalid."
            end
          end
        end

        def serialize
          self.map do |item|
            item.respond_to?(:serialize) ? item.serialize : item
          end
        end

        def deserialize(ary)
          self.replace ary
        end

      end
    end
  end
end
