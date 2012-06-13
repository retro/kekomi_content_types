module Kekomi
  class ContentTypes
    module Atom
      extend ActiveSupport::Concern

      included do

        Store.instance.add_field_type :atom, self

        unless self.const_defined? "Converter"
          converter = Class.new
          self.const_set "Converter", converter
          converter.send :include, Mongoid::Fields::Serializable
          converter.send :include, Kekomi::ContentTypes::Converter
          converter.for = self
          converter.cast_on_read = true
        end

      end

    end
  end
end