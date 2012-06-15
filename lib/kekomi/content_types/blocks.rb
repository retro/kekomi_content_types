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
              if Kekomi::ContentTypes::Store.instance.valid_field_for? klass, block_type
                klass = Kekomi::ContentTypes::Store.instance.field_types[klass][:klass]
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
      end
    end
  end
end


