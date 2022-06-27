require_relative "init"
require_relative "presentation_terms"
require "isodoc"

module IsoDoc
  module IEEE
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def initialize(options)
        @hierarchical_assets = options[:hierarchical_assets]
        super
      end

      def eref_localities_conflated(refs, target, node)
        droploc = node["droploc"]
        node["droploc"] = true
        ret = resolve_eref_connectives(eref_locality_stacks(refs, target,
                                                            node))
        node["droploc"] = droploc
        eref_localities1(target,
                         prefix_clause(target, refs.first.at(ns("./locality"))),
                         l10n(ret[1..-1].join), nil, node, @lang)
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
        (from&.match?(/\./) && type == "clause") ||
          target&.gsub(/<[^>]+>/, "")&.match(/^IEV$|^IEC 60050-/)
      end

      def eref_localities1(target, type, from, upto, node, lang = "en")
        return nil if type == "anchor"

        type = type.downcase
        lang == "zh" and
          return l10n(eref_localities1_zh(target, type, from, upto,
                                          node))
        ret = ""
        node["droploc"] != "true" && !subclause?(target, type,
                                                 from) and
          ret = eref_locality_populate(type, node)
        ret += " #{from}" if from
        ret += "&#x2013;#{upto}" if upto
        ret += ")" if type == "list"
        l10n(ret)
      end

      def anchor_linkend1(node)
        linkend = @xrefs.anchor(node["target"], :xref)
        @xrefs.anchor(node["target"], :type) == "clause" &&
          @xrefs.anchor(node["target"], :level) > 1 &&
          !start_of_sentence(node) and
          linkend = linkend.sub(/^Clause /, "")
        container = @xrefs.anchor(node["target"], :container, false)
        prefix_container?(container, node) and
          linkend = prefix_container(container, linkend, node["target"])
        capitalise_xref(node, linkend, anchor_value(node["target"]))
      end

      def block_delim
        "&#x2014;"
      end

      def note1(elem)
        return if elem.parent.name == "bibitem" || elem["notag"] == "true"

        n = @xrefs.get[elem["id"]]
        lbl = if n.nil? || n[:label].nil? || n[:label].empty?
                @i18n.note
              else
                l10n("#{@i18n.note} #{n[:label]}")
              end
        prefix_name(elem, block_delim, lbl, "name")
      end

      def display_order(docxml)
        i = 0
        i = display_order_xpath(docxml, "//preface/*", i)
        i = display_order_at(docxml, "//clause[@type = 'overview']", i)
        i = display_order_at(docxml, @xrefs.klass.norm_ref_xpath, i)
        i = display_order_at(docxml, "//sections/terms | "\
                                     "//sections/clause[descendant::terms]", i)
        i = display_order_at(docxml, "//sections/definitions", i)
        i = display_order_xpath(docxml, @xrefs.klass.middle_clause(docxml), i)
        i = display_order_xpath(docxml, "//annex", i)
        i = display_order_xpath(docxml, @xrefs.klass.bibliography_xpath, i)
        display_order_xpath(docxml, "//indexsect", i)
      end

      def bibrenderer
        ::Relaton::Render::IEEE::General.new(language: @lang,
                                             i18nhash: @i18n.get)
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

      def annex1(elem)
      lbl = @xrefs.anchor(elem["id"], :label)
      if t = elem.at(ns("./title"))
        t.children = "<strong>#{t.children.to_xml}</strong>"
      end
      prefix_name(elem, "<br/>", lbl, "title")
    end

      include Init
    end
  end
end
