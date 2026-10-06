require "relaton-render"

module Metanorma
  module Ieee
    #
    # The IEEE flavor's citation renderer: an extension of the
    # relaton-render General facade carrying this gem's CitationStyle
    # instance. Supersedes the 1.x stack this gem carried under
    # lib/relaton/render, which subclassed relaton-render 1.x internals
    # that the 3.0.0.pre engine no longer ships.
    #
    class CitationStyle < ::Relaton::Render::General
      STYLE_PATH = File.join(__dir__, "ieee-style.yml")

      # The IEEE data elements, scoped to this renderer alone: the
      # home-standard resolution by publisher name and the DOI/ISBN
      # kind labels with a colon
      ELEMENTS = {
        identifier: IeeeElements::IeeeIdentifier,
        component_part: IeeeElements::IeeeComponentPart,
        access: IeeeElements::IeeeAccess,
        medium: IeeeElements::IeeeMedium,
      }.freeze

      # 1.x use_terminator?: home standards carry no bibliography
      # terminator
      def terminate_reference(ref, item = nil)
        return ref if item && IeeeElements.home_publisher?(item)

        super
      end

      def initialize(options = {})
        super
        options = deep_symbolize(options)
        @renderer = IeeeElements::IeeeRenderer.new(
          lang: @lang,
          script: options[:script] || "Latn",
          labels: options[:i18nhash] || {},
          style: options[:style] || STYLE_PATH,
          elements: ELEMENTS,
        )
      end
    end
  end
end
