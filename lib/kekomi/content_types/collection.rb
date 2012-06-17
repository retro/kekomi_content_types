class Kekomi
  class ContentTypes
    class Collection

      def self.add(name, &block)
        name  = name.to_s.classify
        klass = Class.new(Array)
        self.const_set name, klass
        [Mongoid::Fields::Serializable, ActiveModel::Validations, CoercedArray, Base].each do |inc|
          klass.send :include, inc
        end
        klass.class_eval &block
        Store.instance.add_field_type :collection, klass
        klass.validate :validate_members
        klass
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
          self.map do |item|
            item.respond_to?(:serialize) ? item.serialize : item
          end
        end


        def deserialize(ary)
          self.replace ary
        end

        protected

          def validate_members
            self.each_with_index do |item, i|
              unless item.valid?
                member_errors = item.errors
                member_errors.each do |field, error|
                  errors.add :"#{i}.#{field}", error
                end
              end
            end
          end

      end
    end
  end
end
