require_relative "init"
require_relative "presentation_bibdata"
require_relative "presentation_terms"
require_relative "presentation_ref"
require "isodoc"

module IsoDoc
  module IEEE
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def initialize(options)
        @hierarchical_assets = options[:hierarchicalassets]
        super
      end

      def eref_localities_conflated(refs, target, node)
        droploc = node["droploc"]
        node["droploc"] = true
        ret = resolve_eref_connectives(eref_locality_stacks(refs, target,
                                                            node))
        node["droploc"] = droploc
        eref_localities1({ target: target, number: "pl",
                           type: prefix_clause(target, refs.first.at(ns("./locality"))),
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
        (from&.match?(/\./) && type == "clause") ||
          target&.gsub(/<[^>]+>/, "")&.match(/^IEV$|^IEC 60050-/)
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
          linkend = linkend.sub(/^Clause /, "")
        container = @xrefs.anchor(node["target"], :container, false)
        prefix_container?(container, node) and
          linkend = prefix_container(container, linkend, node, node["target"])
        capitalise_xref(node, linkend, anchor_value(node["target"]))
      end

      def block_delim
        "&#x2014;"
      end

      def note1(elem)
        return if elem.parent.name == "bibitem" || elem["notag"] == "true"

        n = @xrefs.get[elem["id"]]
        lbl = if n.nil? || n[:label].nil? || n[:label].empty? then @i18n.note
              else l10n("#{@i18n.note} #{n[:label]}")
              end
        prefix_name(elem, block_delim, lbl, "name")
      end

      def annex1(elem)
        if @doctype == "whitepaper"
          annex1_whitepaper(elem)
        else
          annex1_default(elem)
        end
      end

      def annex1_whitepaper(elem)
        lbl = @xrefs.anchor(elem["id"], :label)
        if t = elem.at(ns("./title"))
          t.name = "variant-title"
          t["type"] = "sub"
        end
        elem.children.first.previous = "<title>#{lbl}</title>"
      end

      def annex1_default(elem)
        lbl = @xrefs.anchor(elem["id"], :label)
        if t = elem.at(ns("./title"))
          t.children = "<strong>#{to_xml(t.children)}</strong>"
        end
        prefix_name(elem, "<br/>", lbl, "title")
      end

      def amend1(elem)
        elem.xpath(ns("./description/p")).each do |p|
          p.children = to_xml(p.children).strip
          amend_format(p)
        end
        super
      end

      def amend_format(para)
        2.times do
          para.children.size == 1 &&
            %(em strong).include?(para.children.first.name) and
            para.children = para.elements.first.children
        end
        para.children = "<strong><em>#{to_xml(para.children)}</em></strong>"
      end

      def section(docxml)
        boilerplate(docxml)
        super
      end

      def asciimath_dup(node)
        @suppressasciimathdup and return
        super
        node.parent.at(ns("./latexmath")) and return
        math = node.to_xml.gsub(/ xmlns=["'][^"']+["']/, "")
          .gsub(%r{<[^:/]+:}, "<").gsub(%r{</[^:/]+:}, "</")
        ret = Plurimath::Math.parse(math, "mathml").to_latex
        ret = HTMLEntities.new.encode(ret, :basic)
        node.next = "<latexmath>#{ret}</latexmath>"
      rescue StandardError => e
        warn "Failure to convert MathML to LaTeX\n#{node.parent.to_xml}\n#{e}"
      end

      def formula_where(dlist)
        dlist or return
        dlist["class"] = "formula_dl"
      end

      def ol(docxml)
        ol_numbering(docxml)
        @xrefs.list_anchor_names(docxml.xpath(ns(@xrefs.sections_xpath)))
        docxml.xpath(ns("//ol/li")).each { |f| ol_label(f) }
      end

      def ol_numbering(docxml)
        p = "//clause | //annex | //foreword | //acknowledgements | " \
            "//introduction | //preface/abstract | //appendix | //terms | " \
            "//term | //definitions | //references | //colophon"
        docxml.xpath(ns(p)).each do |c|
          (c.xpath(ns(".//ol")) -
          c.xpath(ns("./clause//ol | ./appendix//ol | ./term//ol | " \
                     "./terms//ol | ./definitions//ol | " \
                     "/references//ol | ./colophon//ol")))
            .each_with_index do |o, i|
            ol_numbering1(o, i)
          end
        end
      end

      def ol_numbering1(elem, idx)
        elem["type"] = ol_depth_rotate(elem, idx).to_s
        elem.xpath(ns("./li")).each do |li|
          li["id"] ||= "_#{UUIDTools::UUID.random_create}"
        end
      end

      def ol_depth_rotate(node, idx)
        depth = node.ancestors("ol").size + idx
        type = :alphabet
        type = :arabic if [2, 5, 8].include? depth
        type = :roman if [3, 6, 9].include? depth
        type
      end

      def middle_title(docxml)
        s = docxml.at(ns("//sections")) or return
        ret = "<p class='zzSTDTitle1'>#{@meta.get[:full_doctitle]}"
        @meta.get[:amd] || @meta.get[:corr] and ret += "<br/>"
        @meta.get[:amd] and ret += "Amendment #{@meta.get[:amd]}"
        @meta.get[:amd] && @meta.get[:corr] and ret += " "
        @meta.get[:corr] and ret += "Corrigenda #{@meta.get[:corr]}"
        ret += "</p>"
        s.children.first.previous = ret
      end

      def preface_rearrange(doc)
        move_abstract(doc)
        super
      end

      def move_abstract(doc)
        doc.at(ns("//bibdata/ext/doctype"))&.text == "whitepaper" or return
        source = doc.at(ns("//preface/abstract")) or return
        dest = doc.at(ns("//sections")) ||
          doc.at(ns("//preface")).after("<sections> </sections>").next_element
        dest.children.empty? and dest.children = " "
        dest.children.first.next = source
      end

      include Init
    end
  end
end
