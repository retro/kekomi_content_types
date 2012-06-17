module Kekomi
  class ContentTypes
    class Compound

      def self.add(name, &block)
        name  = name.to_s.classify
        klass = Class.new(Array)
        self.const_set name, klass
        [Mongoid::Fields::Serializable, ActiveModel::Validations, CoercedArray, Base].each do |inc|
          klass.send :include, inc
        end
        klass.class_eval &block
        klass.validate :validate_members
        Store.instance.add_field_type :collection, klass
        klass
      end

      module Base
        extend ActiveSupport::Concern

        module ClassMethods

          def allow(klass)
            klass = Store.instance.field_types[klass.to_s.classify.demodulize][:klass]
            if Store.instance.valid_field_for? klass, :compound
              allowed << klass unless allowed.include?(klass)
              allowed
            else
               raise Kekomi::ContentTypes::Errors::InvalidFieldType, "Field type #{options[:type]} is invalid."
            end
          end
          def allowed
            @_allowed ||= []
            @_allowed
          end
        end

        def serialize
          self.map do |item|
            {
              type: item.class.to_s.demodulize,
              value: item.respond_to?(:serialize) ? item.serialize : item
            }
          end
        end

        def deserialize(ary)
          self.replace ary
        end

        def _coerce_value(item)
          item = item.is_a?(Hash) ? HashWithIndifferentAccess.new(item) : item
          if item.is_a? HashWithIndifferentAccess
            klass = Store.instance.field_types[item[:type].to_s.classify][:klass]
            if self.class.allowed.include? klass
              item = klass.new(item[:value])
            end
          end
          raise Kekomi::ContentTypes::Errors::InvalidFieldType, "Field type #{item.class} is not allowed in compound field." unless self.class.allowed.include? item.class
          item
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
