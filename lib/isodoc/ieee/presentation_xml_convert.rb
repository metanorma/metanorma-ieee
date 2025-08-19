require_relative "init"
require_relative "presentation_bibdata"
require_relative "presentation_terms"
require_relative "presentation_concepts"
require_relative "presentation_ref"
require "isodoc"

module IsoDoc
  module Ieee
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def initialize(options)
        @hierarchical_assets = options[:hierarchicalassets]
        super
      end

      def block_delim
        "&#x2014;"
      end

      def note_delim(_elem)
        "&#x2014;"
      end

      def annex1(elem)
        if @doctype == "whitepaper"
          annex1_whitepaper(elem)
        else
          super
        end
      end

      def annex1_whitepaper(elem)
        lbl = @xrefs.anchor(elem["id"], :label)
        if t = elem.at(ns("./title"))
          d = t.dup
          # TODO fmt-variant-title
          d.name = "variant-title"
          d["type"] = "sub"
          t.next = d
        end
        elem.add_first_child "<fmt-title>#{lbl}</fmt-title>"
      end

      def annex_delim(_elem)
        "<br/>"
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
      end

      # overrides IsoDoc:: XrefGen::OlTypeProvider: we trigger
      # @xrefs.list_anchor_names after this is called, with elem["type"] set
      def ol_depth_rotate(node, idx)
        depth = node.ancestors("ol").size + idx
        type = :alphabet
        type = :arabic if [2, 5, 8].include? depth
        type = :roman if [3, 6, 9].include? depth
        type
      end

      def ul_label_list(_elem)
        if @doctype == "whitepaper" ||
            %w(icap industry-connection-report).include?(@subdoctype)
          %w(&#x25aa; &#x2014;)
        else
          %w(&#x2013;)
        end
      end

      def middle_title(docxml)
        s = middle_title_insert(docxml) or return
        s.previous = middle_title_body
      end

      def middle_title_body
        ret = "<p class='zzSTDTitle1'>#{@meta.get[:full_doctitle]}"
        @meta.get[:amd] || @meta.get[:corr] and ret += "<br/>"
        @meta.get[:amd] and ret += "Amendment #{@meta.get[:amd]}"
        @meta.get[:amd] && @meta.get[:corr] and ret += " "
        @meta.get[:corr] and ret += "Corrigenda #{@meta.get[:corr]}"
        ret += "</p>"
        ret
      end

      def middle_title_insert(docxml)
        s = docxml.at(ns("//sections")) or return
        s.children.first
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

      def example1(elem)
        super
        n = elem.at(ns("./fmt-name")) or return
        n << l10n("<span class='fmt-caption-delim'>:</span>")
        n.children.wrap("<em></em>")
      end

      # before processing, move license termnotes to fn at end of term,
      # so they aren't numbered as termnotes
      def conversions(docxml)
        docxml.xpath(ns("//termnote[@type='license']"))
          .each_with_index do |n, i|
          license_termnote(n, i)
        end
        super
      end

      def document_footnotes(docxml)
        first_biblio_eref_fn(docxml)
        super
      end

      include Init
    end
  end
end
