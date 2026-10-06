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

      # Items without docids cite author-date ("Aluffi
      # <em>et al.</em> 2022a"): the tag composes from the principal
      # creator, the et-al marker at the style's threshold, and the
      # batch-disambiguated date
      def parse(doc)
        data, style = super
        if Array(data[:authoritative_identifier]).reject(&:empty?).empty?
          tag = author_date_tag(doc)
          data[:authoritative_identifier] = [tag] if tag
        end
        [data, style]
      end

      private

      def author_date_tag(doc)
        block = doc.xpath(
          "ancestor-or-self::*[local-name() = 'references'][1]",
        ).first or return nil
        models = block.xpath(".//*[local-name() = 'bibitem']")
          .filter_map { |b| to_model(b.to_xml) rescue nil }
        return nil if models.empty?

        suffixes = date_disambiguators(models)
        model = to_model(doc.to_xml)
        author = @renderer.in_text_author(model)
        cite = @renderer.citation(model)
        date = cite.split(", ").last.to_s
        "#{author} #{date}#{suffixes[model.id]}"
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
