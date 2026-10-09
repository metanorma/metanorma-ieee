# frozen_string_literal: true

module Metanorma
  module Ieee
    # IEEE-specific data elements extending the engine's ISO 690
    # vocabulary, passed to the renderer as its element map
    module IeeeElements
      HOME_PUBLISHERS =
        ["International Organization for Standardization", "ISO",
         "International Electrotechnical Commission", "IEC",
         "Institute of Electrical and Electronics Engineers",
         "IEEE"].freeze

      class << self
        # 1.x home_standard: the SDO standards by publisher NAME
        def home_publisher?(model)
          Array(model.contributor).any? do |c|
            next false unless Array(c.role).any? do |r|
              r.is_a?(String) ? r == "publisher" : r.type == "publisher"
            end

            Array(c.organization&.name)
              .any? { |n| HOME_PUBLISHERS.include?(n.content) }
          end
        end
      end

      # 1.x home_standard: ISO/IEC/IEEE by publisher NAME
      class IeeeRenderer < ::Relaton::Render::Iso690::Renderer
        def home_docid?(model)
          IeeeElements.home_publisher?(model)
        end
      end
    end
  end
end

