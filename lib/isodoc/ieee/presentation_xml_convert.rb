require_relative "init"
require_relative "presentation_bibdata"
require_relative "presentation_terms"
require_relative "presentation_concepts"
require_relative "presentation_ref"
require_relative "presentation_bibitem"
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

      def ol_numbering_containers
        "//clause | //annex | //foreword | //acknowledgements | " \
            "//introduction | //preface/abstract | //appendix | //terms | " \
            "//term | //definitions | //references | //colophon"
      end

      def ol_numbering(docxml)
        docxml.xpath(ns(ol_numbering_containers)).each do |c|
          i = -1
          (c.xpath(ns(".//ol")) -
          c.xpath(ns("./clause//ol | ./appendix//ol | ./term//ol | " \
                     "./terms//ol | ./definitions//ol | " \
                     "/references//ol | ./colophon//ol"))).each do |o|
            (o.ancestors("ol").size + o.ancestors("ul").size).zero? and
              i += 1 # ol root list
            ol_numbering1(o, i)
          end
        end
      end

      def ol_numbering1(elem, idx)
        ancestors = elem.ancestors.map(&:name).reverse
        ul_loc = ancestors.index("ul")
        ol_loc = ancestors.index("ol")
        # is this a ul//ol list? if so, ignore idx of list in labelling
        ul_root = ul_loc && (!ol_loc || ul_loc < ol_loc)
        elem["type"] = ol_depth_rotate(elem, ul_root ? 0 : idx).to_s
      end

      # overrides IsoDoc:: XrefGen::OlTypeProvider: we trigger
      # @xrefs.list_anchor_names after this is called, with elem["type"] set
      # use the order of the ol in the clause to rotate the labelling
      def ol_depth_rotate(node, idx)
        depth = node.ancestors("ol").size + node.ancestors("ul").size + idx
        type = :alphabet
        type = :arabic if [1, 4, 7].include? depth
        type = :roman if [2, 5, 8].include? depth
        type
      end

      def ul_label_list(_elem)
        if @doctype == "whitepaper" ||
            %w(icap industry-connection-report).include?(@subdoctype)
          %w(&#x25aa; &#x2014;)
        else
          %w(&#x2014;)
        end
      end

      def middle_title_template
        <<~OUTPUT
          <p class='zzSTDTitle1'>{{ full_doctitle -}}
          {% if amd or corr %}<br/>{% endif -%}
          {% if amd %}Amendment {{ amd }}{% endif -%}
          {% if amd and corr %}&#x20;{% endif -%}
          {% if corr %}Corrigenda {{ corr }}{% endif %}</p>
        OUTPUT
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

      def cleanup(docxml)
        termsource_brackets(docxml)
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
