module Kekomi
  class ContentTypes
    module Atom
      extend ActiveSupport::Concern

      included do

        Store.instance.add_field_type :atom, self

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
