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
        elsif node["style"] == "title"
          "#{bib[:title]} #{node['citeas']}"
        elsif bib[:author] # default, also if node["style"] == "title"
          "#{bib[:author]} #{node['citeas']}"
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

      def creatornames(bib)
        ::Relaton::Render::Ieee::General
          .new(language: @lang, i18nhash: @i18n.get,
               # template: { (bib["type"] || "misc").to_sym =>
               # "{{ creatornames }}" },
               template: "{{ creatornames }}",
               extenttemplate: { (bib["type"] || "misc").to_sym => "{{page}}" },
               sizetemplate: { (bib["type"] || "misc").to_sym => "{{data}}" })
          .render1(RelatonBib::XMLParser.from_xml(bib.to_xml))
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
        notes = bib.xpath(ns("./note[@type = 'Availability']"))
        notes.map do |note|
          id = UUIDTools::UUID.random_create.to_s
          @new_ids[id] = nil
          "<fn id='#{id}' reference='#{id}'><p>#{note.content}</p></fn>"
        end.join
      end

      def omit_docid_prefix(prefix)
        prefix == "DOI" and return true
        super
      end

      def bracket_if_num(num)
        num.nil? and return nil
        ret = num.dup
        ret.xpath(ns(".//fn")).each(&:remove)
        ret = ret.text.strip.sub(/^\[/, "").sub(/\]$/, "")
        /^B?\d+$/.match?(ret) and return "[#{ret}]"
        ret
      end

      def eref_localities_conflated(refs, target, node)
        droploc = node["droploc"]
        node["droploc"] = true
        ret = resolve_eref_connectives(eref_locality_stacks(refs, target,
                                                            node))
        node["droploc"] = droploc
        p = prefix_clause(target, refs.first.at(ns("./locality")))
        eref_localities1({ target: target, number: "pl",
                           type: p,
                           from: l10n(ret[1..-1].join), node: node,
                           lang: @lang })
      end

      def prefix_clause(target, loc)
        loc["type"] == "clause" or return loc["type"]
        if subclause?(target, loc["type"],
                      loc&.at(ns("./referenceFrom"))&.text)
          ""
        else "clause"
        end
      end

      def subclause?(target, type, from)
        (from&.include?(".") && type == "clause") ||
          target&.gsub(/<[^<>]+>/, "")&.match?(/^IEV$|^IEC 60050-/)
      end

      def eref_localities1(opt)
        opt[:type] == "anchor" and return nil
        opt[:type].downcase!
        opt[:lang] == "zh" and return l10n(eref_localities1_zh(opt))
        ret = ""
        opt[:node]["droploc"] != "true" &&
          !subclause?(opt[:target], opt[:type], opt[:from]) and
          ret = eref_locality_populate(opt[:type], opt[:node], opt[:number])
        ret += " #{opt[:from]}" if opt[:from]
        ret += "&#x2013;#{opt[:upto]}" if opt[:upto]
        ret += ")" if opt[:type] == "list"
        l10n(ret)
      end

      def anchor_linkend1(node)
        linkend = @xrefs.anchor(node["target"], :xref)
        @xrefs.anchor(node["target"], :type) == "clause" &&
          @xrefs.anchor(node["target"], :level) > 1 &&
          !start_of_sentence(node) and
          linkend = strip_initial_clause(linkend)
        container = @xrefs.anchor(node["target"], :container, false)
        linkend = prefix_container(container, linkend, node, node["target"])
        capitalise_xref(node, linkend, anchor_value(node["target"]))
      end

      def strip_initial_clause(linkend)
        x = Nokogiri::XML("<a>#{linkend}</a>")
        x.at(".//span[@class = 'fmt-element-name']")&.remove
        to_xml(x.elements.first.children).strip
      end

      def eref_locality_populate(type, node, number)
        type == "page" and return ""
        super
      end

      def first_biblio_eref_fn(docxml)
        @bibanchors ||= biblio_ids_titles(docxml)
        docxml.xpath("//*[@citeas]").each do |node|
          @bibanchors[node["bibitemid"]] or next
          node.children.empty? or next
          insert_biblio_footnote(node, docxml)
          break
        end
      end

      private

      def insert_biblio_footnote(node, docxml)
        n = node.next_sibling
        # Check if the next sibling is a text node that starts with punctuation
        if n&.text? && (match = n.content.match(/^([.,;:])(?=\s|$)/))
          insert_biblio_footnote_with_punctuation1(n, match, docxml)
        else # Default behavior: insert footnote immediately after the node
          node.next = biblio_ref_inform_fn
        end
      end

      # If so, split the text at the punctuation
      # and replace the text node with punctuation + footnote + remaining text
      def insert_biblio_footnote_with_punctuation1(node, match, docxml)
        punct = match[0]
        remaining_text = node.content[punct.length..-1]
        node.content = punct
        node.add_next_sibling(biblio_ref_inform_fn)
        remaining_text && !remaining_text.empty? and
          node.next_sibling
            .add_next_sibling(Nokogiri::XML::Text.new(
                                remaining_text, docxml
                              ))
      end

      def biblio_ref_inform_fn
        <<~XML
          <fn reference='#{UUIDTools::UUID.random_create}'><p>#{@i18n.biblio_ref_inform_fn}</p></fn>
        XML
      end
    end
  end
end
