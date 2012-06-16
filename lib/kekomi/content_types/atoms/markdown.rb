module Kekomi
  class ContentTypes
    module Atoms
      class Markdown < ::String

        include Kekomi::ContentTypes::Atom

        def serialize
          self.to_s
        end

      end
    end
  end
end
