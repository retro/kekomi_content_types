require "delegate"

module Kekomi
  class ContentTypes
    module Atoms
      class Integer < DelegateClass(Fixnum)

        include Kekomi::ContentTypes::Atom

        def serialize
          self.to_i
        end

      end
    end
  end
end
