class Kekomi
  class ContentTypes
    module Atoms
      class Rte < ::String
        include Mongoid::Fields::Serializable
        include Kekomi::ContentTypes::Atom

        def serialize
          self.to_s
        end

      end
    end
  end
end
