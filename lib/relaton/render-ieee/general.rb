require "relaton-render"
require_relative "elements"

module Relaton
  module Render
    module Ieee
      # The IEEE flavor's citation renderer: the relaton-render General
      # facade carrying this gem's CitationStyle instance (ieee-style.yml)
      # and its element-map extensions. Supersedes the 1.x liquid
      # template stack this directory carried.
      class General < ::Relaton::Render::General
        STYLE_PATH = File.join(__dir__, "ieee-style.yml")

        def initialize(options = {})
          super
          options = deep_symbolize(options)
          @renderer = ::Relaton::Render::Iso690::Renderer.new(
            lang: @lang,
            script: options[:script] || "Latn",
            labels: options[:i18nhash] || {},
            style: STYLE_PATH,
            elements: Relaton::Render::Ieee::Elements::ELEMENTS,
          )
        end

        # relaton-bib 2.x's Place model maps only structured children
        # (<city>/<region>/<country>/<formattedPlace>); a bare
        # <place>Cambridge, UK</place> text node is dropped. Rewrite those
        # to the structured form before the facade parses.
        def facade_bibitems(bib)
          bib = normalize_place_string(bib) if bib.is_a?(String)
          super
        end

        def normalize_place_string(bib)
          p = Nokogiri::XML(bib) or return bib
          p.errors.empty? or return bib
          normalize_place_node(p.root).to_xml
        end

        def normalize_place_node(xml)
          xml = Nokogiri::XML(xml.to_xml).root
          xml.xpath(".//*[local-name() = 'place' and not(*)]").each do |p|
            text = p.text.strip
            text.empty? and next
            p.children.remove
            p.add_child("<formattedPlace>#{text}</formattedPlace>")
          end
          xml
        end
      end
    end
  end
end
