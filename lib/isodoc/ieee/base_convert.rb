require "isodoc"
require "fileutils"

# isodoc 3.7.x introduced fmt-clause-delim for clause title delimiters but
# omitted it from SPAN_UNWRAP_CLASSES, so the span leaks into HTML/DOC output.
# Fold it into the unwrap list.
module IsoDoc
  module Function
    module Inline
      remove_const(:SPAN_UNWRAP_CLASSES) if const_defined?(:SPAN_UNWRAP_CLASSES, false)
      SPAN_UNWRAP_CLASSES =
        (%w[fmt-caption-label fmt-label-delim fmt-caption-delim fmt-autonum-delim
            fmt-element-name fmt-conn fmt-comma fmt-enum-comma fmt-obligation
            fmt-xref-container fmt-designation-field fmt-clause-delim]).freeze
    end
  end
end

module IsoDoc
  module Ieee
    module BaseConvert
      def clause_attrs(node)
        { id: node["id"], type: node["type"] }
      end

      def top_element_render(elem, out)
        elem.name == "clause" && elem["type"] == "overview" and
          return scope(elem, out, 0)
        super
      end

      def scope(node, out, num)
        out.div **attr_code(id: node["id"]) do |div|
          num = num + 1
          clause_name(node, node&.at(ns("./fmt-title")), div, nil)
          node.elements.each do |e|
            parse(e, div) unless e.name == "fmt-title"
          end
        end
        num
      end

      def middle_clause(_docxml = nil)
        "//clause[parent::sections][not(@type = 'overview')]" \
          "[not(descendant::terms)][not(descendant::references)]"
      end

      def para_attrs(node)
        super.merge(type: node["type"])
      end

      def example_label(_node, div, name)
        return if name.nil?

        div.p class: "example-title" do |p|
          name.children.each { |n| parse(n, p) }
        end
      end

      def span_parse(node, out)
        node["class"] == "fmt-obligation" and
          node["class"] = "obligation"
        super
      end
    end
  end
end
