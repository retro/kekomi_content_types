module Kekomi
  class ContentTypes
    class Collections
      def self.add(name, &block)
        name = name.to_s.classify
        klass = Class.new(Array)
        self.const_set name, klass
        [CoercedArray, Base].each do |inc|
          klass.send :include, inc
        end
        klass.class_eval &block
        Store.instance.add_field_type :collection, klass
        converter = Class.new(Converter)
        converter.for = klass
        #converter.cast_on_read = true
        klass.const_set "Converter", converter
        klass
      end

      class Converter
          include Mongoid::Fields::Serializable

          def self.for=(klass)
            @_klass = klass
          end

          def self.for
            @_klass
          end

          def serialize(value)
            {
              type: self.class.for.to_s.demodulize,
              value: value.serialize
            }
          end

          def deserialize(value)
            return nil if value.nil?
            if @value.is_a? self.class.for
              @value.deserialize value[:value]
            else
              @value = self.class.for.new value[:value]
            end
            @value
          end
        end

      module Base
        extend ActiveSupport::Concern

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
          #puts "SERIALIZE"
          serialized = self.map do |item|
            item.respond_to?(:serialize) ? item.serialize : item
          end
          #puts serialized.class, serialized, serialized.size
          serialized
        end

        def deserialize(ary)
          #puts "DESERIALIZE", ary
          self.replace ary
        end

      end
    end
  end
end
