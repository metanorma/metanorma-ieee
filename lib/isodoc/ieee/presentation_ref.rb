require_relative "../../relaton/render/general"

module IsoDoc
  module Ieee
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
        elsif bib[:author]
          "#{bib[:author]} " + node["citeas"]
        else
          node["citeas"]
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
              ord: b.at(ns("./docidentifier[@type = 'metanorma' or " \
                           "@type = 'metanorma-ordinal']"))&.text }
        end
      end

      def citestyle
        "author-date"
      end

      def references_render(docxml)
        @author = {}
        super
      end

      def bibrender_relaton(xml, renderings)
        bibrender_relaton1(xml, renderings)
        author_date(xml, renderings)
        @author[xml["id"]] = renderings[xml["id"]][:author]
      end

      def bibrender_relaton1(xml, renderings)
        f = renderings[xml["id"]][:formattedref] or return
        fn = availability_note(xml)
        f = "<formattedref>#{f}#{fn}</formattedref>"
        if x = xml.at(ns("./formattedref"))
          x.replace(f)
        elsif xml.children.empty?
          xml << f
        else
          xml.children.first.previous = f
        end
      end

      def author_date(xml, renderings)
        author_date?(xml) or return
        cit = renderings[xml["id"]][:citation]
        xml << "<docidentifier type='metanorma'>#{cit}</docidentifier>"
        xml.at(ns("./biblio-tag"))&.remove
        xml << "<biblio-tag>#{cit}, </biblio-tag>"
      end

      def author_date?(xml)
        ret = !xml["type"]
        ret ||= %w(standard techreport website webresource)
          .include?(xml["type"])
        ret ||= xml.at(".//ancestor::xmlns:references[@normative = 'false']")
        ret ||= xml.at(ns("./docidentifier[@type = 'metanorma']"))
        ret and return false
        true
      end

      def creatornames(bibitem)
        ::Relaton::Render::Ieee::General
          .new(language: @lang, i18nhash: @i18n.get,
               # template: { (bibitem["type"] || "misc").to_sym =>
               # "{{ creatornames }}" },
               template: "{{ creatornames }}",
               extenttemplate: { (bibitem["type"] || "misc").to_sym => "{{page}}" },
               sizetemplate: { (bibitem["type"] || "misc").to_sym => "{{data}}" })
          .render1(RelatonBib::XMLParser.from_xml(bibitem.to_xml))
      end

      def bibliography_bibitem_number1(bibitem, idx, normative)
        bibitem.xpath(ns(".//docidentifier[@type = 'metanorma' or " \
                         "@type = 'metanorma-ordinal']")).each do |mn|
          /^\[?B?\d\]?$/.match?(mn&.text) and mn.remove
        end
        unless bibliography_bibitem_number_skip(bibitem) || normative
          idx += 1
          docidentifier_insert_pt(bibitem).next =
            "<docidentifier type='metanorma-ordinal'>[B#{idx}]</docidentifier>"
        end
        idx
      end

      def docidentifier_insert_pt(bibitem)
        bibitem.at(ns(".//docidentifier"))&.previous ||
          bibitem.at(ns(".//title")) ||
          bibitem.at(ns(".//formattedref"))
      end

      def expand_citeas(text)
        std_docid_semantic(super)
      end

      def availability_note(bib)
        note = bib.at(ns("./note[@type = 'Availability']")) or return ""
        id = UUIDTools::UUID.random_create.to_s
        "<fn id='_#{id}' reference='#{id}'><p>#{note.content}</p></fn>"
      end

      def omit_docid_prefix(prefix)
        prefix == "DOI" and return true
        super
      end

      def bracket_if_num(num)
        return nil if num.nil?

        num = num.text.sub(/^\[/, "").sub(/\]$/, "")
        return "[#{num}]" if /^B?\d+$/.match?(num)

        num
      end
    end
  end
end
