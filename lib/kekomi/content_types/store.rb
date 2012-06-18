require "singleton"
require "pp"
class Kekomi
  class ContentTypes
    class Store
      include Singleton

      attr_reader :content_types, :field_types

      def initialize
        @content_types = []
        @field_types   = {}
      end

      def valid_field?(klass)
        klass = klass.to_s.demodulize
        field_types.has_key? klass
      end

      def fields_metadata
        metadata = []
        field_types.each_pair do |key, field|
          type = field[:type]
          type = :block if field[:klass].respond_to?(:acts_as_atom)
          metadata << {
            name: key,
            type: type
          }.merge(self.send "#{type}_metadata", field[:klass])
        end
        metadata
      end

      def content_types_metadata
        content_types.map do |content_type|
          {
            name: content_type.to_s.demodulize,
            fields: content_type.serializable_fields.map { |key, klass| {key => klass.to_s.classify.demodulize} }
          }
        end
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

      private

        def atom_metadata(field)
          {}
        end

        def block_metadata(field)
          {
            fields: field.fields.map { |key, klass| {key => klass.to_s.classify.demodulize} }
          }
        end

        def collection_metadata(field)
          {
            allowed: field.allowed.to_s.demodulize
          }
        end

        def compound_metadata(field)
          {
            allowed: field.allowed.map { |f| f.to_s.demodulize }
          }
        end

    end
  end
end
