module Kekomi
  class ContentTypes
    class Blocks

      def self.add(name, &block)
        name = name.to_s.classify
        klass = Class.new
        self.const_set name, klass
        [Base].each do |inc|
          klass.send :include, inc
        end
        klass.class_eval &block
        klass.add_writers
        Store.instance.add_field_type (klass.acts_as_atom?? :atom : :block), klass
        klass
      end
      
      module Base
        extend ActiveSupport::Concern

        def initialize(args={})
          set_values args
        end

        def deserialize(args={})
          set_values args
        end

        def set_values(args={})
          unless args.blank?
            self.class.fields.each_pair do |key, value|
              meth = "#{key}=".to_sym
              if self.respond_to? meth
                self.send meth, args.delete(key)
              end
            end
          end
        end

        def serialize
          serialized = {}
          self.class.fields.each_pair do |key, field|
            meth = "#{key}".to_sym
            value = self.send(meth)
            serialized[meth] = value.respond_to?(:serialize) ? value.serialize : value
          end
          serialized
        end

        module ClassMethods

          def acts_as_atom?
            @_acts_as_atom || false
          end

          def acts_as_atom
            @_acts_as_atom = true
          end

          def field(name, type = :string)
            @_fields ||= {}
            @_fields[name.to_sym] = type
            attr_reader name.to_sym

            define_method :"[]=" do |k, v|
              if self.class.fields.has_key? k.to_sym
                self.send "#{k}=", v
              else
                raise NoMethodError.new("NoMethodError")
              end
            end

            define_method :"[]" do |k|
              if self.class.fields.has_key? k.to_sym
                self.send k.to_sym
              else
                raise NoMethodError.new("NoMethodError")
              end
            end
          end

          def add_writers
            @_fields.each_pair do |key, klass|
              klass = klass.to_s.classify
              block_type = self.acts_as_atom?? :atom : :block
              if Store.instance.valid_field_for? klass, block_type
                klass = Store.instance.field_types[klass][:klass]
                if self.method_defined? "#{key}=".to_sym
                  alias_method "orig_#{key}=", "#{key}="
                  define_method "#{key}=" do |val|
                    self.send :"orig_#{key}=", klass.new(val)
                  end
                else
                  define_method "#{key}=" do |val|
                    self.send :instance_variable_set, :"@#{key}", klass.new(val)
                  end
                end
              else
                raise Kekomi::ContentTypes::Errors::InvalidFieldType, "Field type #{options[:type]} is invalid."
              end
            end
          end

          def fields
            @_fields ||= {}
          end

        end

        included do

          unless self.const_defined? "Converter"

            converter = Class.new
            self.const_set "Converter", converter
            [Mongoid::Fields::Serializable, Kekomi::ContentTypes::Converter].each do | mod |
              converter.send :include, mod
            end
            converter.for = self
            converter.cast_on_read = true

          end

        end
      end
    end
  end
end


