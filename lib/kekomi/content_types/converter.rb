module Kekomi
  class ContentTypes
    module Converter
      extend ActiveSupport::Concern

      module ClassMethods

        def for=(klass)
          self.instance_variable_set :@_for, klass
        end

        def for
          self.instance_variable_get :@_for
        end

      end

      def serialize(value)
        {
          type:  self.class.for.to_s.demodulize,
          value: (value.is_a?(self.class.for) ? value.serialize : self.class.for.new(value).serialize)
        }
      end

      def deserialize(value)
        self.class.for.new(HashWithIndifferentAccess.new(value)[:value])
      end

    end
  end
end