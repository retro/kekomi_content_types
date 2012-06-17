require "delegate"

class Kekomi
  class ContentTypes
    module Atoms
      class Integer < DelegateClass(Fixnum)

        include Mongoid::Fields::Serializable
        include Kekomi::ContentTypes::Atom
        

        def serialize
          self.to_i
        end

      end
    end
  end
end
