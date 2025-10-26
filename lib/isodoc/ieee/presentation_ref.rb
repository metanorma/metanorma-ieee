module IsoDoc
  module Ieee
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def xref_empty?(node)
        if node["citeas"] &&
            @bibanchors[node["bibitemid"]] && !node.children.empty?
          true
        else super
        end
      end

      def inline(docxml)
        @bibanchors ||= biblio_ids_titles(docxml, false)
        @normrefanchors ||= biblio_ids_titles(docxml, true)
        super
      end

      # Style manual 19
      def anchor_linkend(node, linkend)
        if node["citeas"] && bib = @bibanchors[node["bibitemid"]]
          biblio_anchor_linkend(node, bib, linkend)
        else
        node["citeas"] && (bib = @normrefanchors[node["bibitemid"]]) &&
          !%w(standard).include?(bib[:type]) and
          node["style"] ||= "author_date"
        super
        end
      end

      # force Author-Date referencing on non-standards in norm ref
      # KILL
      def normref_anchor_linkend(node, bib)
        @ref_renderings or return nil
        %w(standard).include?(bib[:type]) and return nil
        cit = @ref_renderings[node["bibitemid"]][:citation][:author_date]&.strip
        cit&.empty? and cit = nil
        cit
      end

      def biblio_anchor_linkend(node, bib, linkend)
        if %w(standard).include?(bib[:type])
          biblio_anchor_linkend_std(node, bib, linkend)
        else biblio_anchor_linkend_nonstd(node, bib)
        end
      end

      def linkend_content(node)
        c1 = non_locality_elems(node).select { |c| !c.text? || /\S/.match(c) }
        c2 = node.xpath(ns("./locality | ./localityStack"))
        [c1, c2]
      end

      def biblio_anchor_linkend_std(node, bib, linkend)
        c1, c2 = linkend_content(node)
        node["style"] == "no-biblio-tag" or tag = bib[:ord]
        if !c1.empty?
          c2.each(&:remove)
          [c1.map(&:to_xml).join, tag].compact.join(" ")
        elsif node.at(ns("./location"))
          linkend
        elsif node["citeas"] == bib[:ord] then node["citeas"]
        else [linkend, tag].compact.join(" ")
        end
      end

      def biblio_anchor_linkend_nonstd(node, bib)
        c1, c2 = linkend_content(node)
        node["style"] == "no-biblio-tag" or tag = node["citeas"]
        if !c1.empty?
          c2.each(&:remove)
          "#{c1.map(&:to_xml).join} #{tag}".strip
        elsif node.at(ns("./location"))
          tag
        elsif node["style"] == "title" && bib[:title]
          "#{bib[:title]} #{tag}".strip
        elsif bib[:author] # default, also if node["style"] == "title"
          "#{bib[:author]} #{tag}".strip
        else tag.strip
        end
      end

      def biblio_ids_titles(xmldoc, normative)
        xmldoc.xpath(ns("//references[@normative = '#{normative}']/bibitem"))
          .each_with_object({}) do |b, acc|
          biblio_ids_titles1(b, acc)
        end
      end

      def biblio_ids_titles1(bib, acc)
        acc[bib["id"]] =
          { docid: pref_ref_code(bib), type: bib["type"],
            title: bib.at(ns("./title")) || bib.at(ns("./formattedref")),
            author: @author[bib["id"]] || (bib.at(ns("./title")) ||
                   bib.at(ns("./formattedref"))),
            ord: bib.at(ns("./docidentifier[@type = 'metanorma' or " \
                         "@type = 'metanorma-ordinal']")) }
        %i(title author ord).each do |k|
          acc[bib["id"]][k].is_a?(Nokogiri::XML::Node) and
            acc[bib["id"]][k] = acc[bib["id"]][k].text
        end
      end

      def citestyle
        "author-date"
      end

      def expand_citeas(text)
        std_docid_semantic(super)
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
