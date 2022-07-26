module IsoDoc
  module IEEE
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      # Style manual 19
      def anchor_linkend(node, linkend)
        @bibanchors ||= biblio_ids_titles(node.document)
        if node["citeas"] && i = @bibanchors[node["bibitemid"]]
          biblio_anchor_linkend(node, i)
        else super
        end
      end

      def biblio_anchor_linkend(node, bib)
        if %w(techreport standard).include?(bib[:type])
          node["citeas"] + " #{bib[:ord]}"
        else
          "#{bib[:title]} " + node["citeas"]
        end
      end

      def biblio_ids_titles(xmldoc)
        xmldoc.xpath(ns("//references[@normative = 'false']/bibitem"))
          .each_with_object({}) do |b, m|
          m[b["id"]] =
            { docid: pref_ref_code(b), type: b["type"],
              title: (b.at(ns("./title")) ||
                     b.at(ns("./formattedref")))&.text,
              ord: b.at(ns("./docidentifier[@type = 'metanorma' or "\
                           "@type = 'metanorma-ordinal']")).text }
        end
      end

      def bibrenderer
        ::Relaton::Render::IEEE::General.new(language: @lang,
                                             i18nhash: @i18n.get)
      end

      def bibrender_relaton(xml)
        bib = xml.dup
        bib["suppress_identifier"] == true and
          bib.xpath(ns("./docidentifier")).each(&:remove)
        xml.children =
          "#{bibrenderer.render(bib.to_xml)}"\
          "#{xml.xpath(ns('./docidentifier | ./uri | ./note | ./title')).to_xml}"
      end

      def creatornames(bibitem)
        ::Relaton::Render::IEEE::General
          .new(language: @lang, i18nhash: @i18n.get,
               template: { (bibitem["type"] || "misc").to_sym =>
                           "{{ creatornames }}" })
          .parse1(RelatonBib::XMLParser.from_xml(bibitem.to_xml))
      end

      def bibliography_bibitem_number1(bibitem, idx)
        if mn = bibitem.at(ns(".//docidentifier[@type = 'metanorma']"))
          /^\[?\d\]?$/.match?(mn&.text) and
            idx = mn.text.sub(/^\[B?/, "").sub(/\]$/, "").to_i
        end
        unless bibliography_bibitem_number_skip(bibitem)

          idx += 1
          bibitem.at(ns(".//docidentifier")).previous =
            "<docidentifier type='metanorma-ordinal'>[B#{idx}]</docidentifier>"
        end
        idx
      end
    end
  end
end
