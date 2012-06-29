# This code uses https://github.com/yaauie/typed-array as a base,
# but it tries to coerce values in array before setting them.
class Kekomi
  class ContentTypes
    module CoercedArray
      extend ActiveSupport::Concern

      module ClassMethods

        def allow(klass)
          @_allowed = klass
        end

        def allowed
          @_allowed
        end

      end

      # Instance Methods

      # Validates outcome. See Array#initialize
      def initialize(*args, &block)
        args = 0 if args.first.nil?
        ary  = Array.new *args, &block
        self.replace ary
      end

      # Validates outcome. See Array#replace
      def replace(other_ary)
        other_ary ||= []
        other_ary = _coerce_values other_ary
        super other_ary
      end

      # Validates outcome. See Array#&
      def &(ary)
        self.class.new super
      end

      # Validates outcome. See Array#*
      def *(int)
        self.class.new super
      end

      # Validates outcome. See Array#+
      def +(ary)
        self.class.new super
      end

      # Validates outcome. See Array#<<
      def <<(item)
        item = _coerce_value item
        super item
      end

      # Validates outcome. See Array#[]
      def [](idx)
        self.class.new super
      end

      # Validates outcome. See Array#slice
      def slice(*args)
        self.class.new super
      end

      # Validates outcome. See Array#[]=
      def []=(idx, item)
        item = _coerce_value item
        super item
      end

      # Validates outcome. See Array#concat
      def concat(other_ary)
        other_ary = _coerce_values other_ary
        super other_ary
      end

      # Validates outcome. See Array#eql?
      def eql?(other_ary)
        other_ary = _coerce_values other_ary
        super
      end

      # Validates outcome. See Array#fill
      def fill(*args, &block)
        ary = self.to_a
        ary.fill *args, &block
        self.replace ary
      end

      # Validates outcome. See Array#push
      def push(*items)
        items = _coerce_values items
        super items
      end

      # Validates outcome. See Array#unshift
      def unshift(*items)
        items = _coerce_values items
        super items
      end

      # Validates outcome. See Array#map!
      def map!(&block)
        self.replace(self.map &block)
      end

      protected

      # Ensure that all items in the passed Array are allowed
      def _coerce_values(ary)
        ary.map { |item| _coerce_value(item) } unless ary.nil?
      end

      # Ensure that the specific item passed is allowed
      def _coerce_value(item)
        unless item.is_a? self.class.allowed
          item = self.class.allowed.new(item)
        end
        item
      end

    end
  end
end
