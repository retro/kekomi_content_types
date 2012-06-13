module Kekomi
  class ContentTypes
    module Atoms
      class Markdown < ::String

        include Kekomi::ContentTypes::Atom

        def serialize
          self.to_s
        end

        def html
          @__html
        end

        class Converter

          def self.for
            Kekomi::ContentTypes::Atoms::Markdown
          end

          def serialize(value)
            markdown = (value.is_a?(self.class.for) ? value.serialize : self.class.for.new(value).serialize)
            {
              type:  self.class.for.to_s.demodulize,
              value: markdown,
              html_value: Kramdown::Document.new(markdown).to_html
            }
          end

          def deserialize(value)
            value = HashWithIndifferentAccess.new(value)
            markdown = self.class.for.new(value[:value])
            markdown.instance_variable_set :@__html, value[:html_value]
            markdown
          end
        end

      end
    end
  end
end