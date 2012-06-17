class Kekomi
  class ContentTypes
    module Atom
      extend ActiveSupport::Concern

      included do

        Store.instance.add_field_type :atom, self

      end

      def valid?
        true
      end

    end
  end
end
