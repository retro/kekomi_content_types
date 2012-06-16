module Kekomi
  class ContentTypes
    module Atom
      extend ActiveSupport::Concern

      included do

        Store.instance.add_field_type :atom, self

      end

    end
  end
end
