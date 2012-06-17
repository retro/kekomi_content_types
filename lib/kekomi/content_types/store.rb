require "singleton"

class Kekomi
  class ContentTypes
    class Store
      include Singleton

      def initialize
        @content_types = {}
        @field_types   = {}
      end

      def add_content_type(content_type, field_definition)
        self.content_types[content_type.to_s] ||= []
        self.content_types[content_type.to_s] << field_definition
      end

      def valid_field?(klass)
        klass = klass.to_s.demodulize
        field_types.has_key? klass
      end

      def field_types
        @field_types
      end

      def valid_field_for?(klass, type)
        valid_types = {
          :block      => [:atom, :collection],
          :collection => [:atom],
          :atom       => [:atom],
          :compound   => [:atom, :collection, :block]
        }
        valid_types[type.to_sym].include? @field_types[klass.to_s.classify.demodulize][:type]
      end

      def add_field_type(type, klass)
        class_name = klass.to_s.demodulize
        if self.valid_field? class_name
          raise Kekomi::ContentTypes::Errors::DuplicateFieldType, "Field type #{class_name} already exists."
        else
          @field_types[class_name] = {
            type: type.to_sym,
            klass: klass
          }
        end
      end

    end
  end
end
