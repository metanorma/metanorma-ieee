require_relative "../../relaton/render/general"

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
          [node["citeas"], bib[:ord]].compact.join(" ")
        else
          "#{bib[:author]} " + node["citeas"]
        end
      end

      def biblio_ids_titles(xmldoc)
        xmldoc.xpath(ns("//references[@normative = 'false']/bibitem"))
          .each_with_object({}) do |b, m|
          m[b["id"]] =
            { docid: pref_ref_code(b), type: b["type"],
              title: (b.at(ns("./title")) ||
                     b.at(ns("./formattedref")))&.text,
              author: @author[b["id"]] || (b.at(ns("./title")) ||
                     b.at(ns("./formattedref")))&.text,
              ord: b.at(ns("./docidentifier[@type = 'metanorma' or "\
                           "@type = 'metanorma-ordinal']"))&.text }
        end
      end

      def bibrenderer
        ::Relaton::Render::IEEE::General.new(language: @lang,
                                             i18nhash: @i18n.get)
      end

      def citestyle
        "author-date"
      end

      def references_render(docxml)
        @author = {}
        super
      end

      def bibrender_relaton(xml, renderings)
        f = renderings[xml["id"]][:formattedref]
        f &&= "<formattedref>#{f}</formattedref>"
        keep = "./docidentifier | ./uri | ./note | ./title | ./biblio-tag"
        xml.children =
          "#{f}#{xml.xpath(ns(keep)).to_xml}"
        @author[xml["id"]] = renderings[xml["id"]][:author]
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
