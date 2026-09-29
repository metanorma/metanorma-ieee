require "relaton-render"
require_relative "parse"

module Relaton
  module Render
    module Ieee
      class General < ::Relaton::Render::IsoDoc::General
        def config_loc
          YAML.load_file(File.join(File.dirname(__FILE__), "config.yml"))
        end

        def klass_initialize(_options)
          super
          @parseklass = Relaton::Render::Ieee::Parse
        end

        # relaton-bib 2.x's Place model maps only structured children
        # (<city>/<region>/<country>/<formattedPlace>); a bare
        # <place>Cambridge, UK</place> text node is dropped. Rewrite those
        # to the structured form before parsing.
        def xml2relaton(bib)
          super(normalize_place_elements(bib))
        end

        def sanitise_citations_input_string(bib)
          super(normalize_place_string(bib))
        end

        def normalize_place_elements(bib)
          xml = xml_string2noko(bib) or return bib
          normalize_place_node(xml)
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
