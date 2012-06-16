module Kekomi
  class ContentTypes
    module Atoms
      class String < ::String

        include Kekomi::ContentTypes::Atom

        def serialize
          self.to_s
        end
        
      end
    end
  end
end