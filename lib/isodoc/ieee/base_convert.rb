require "isodoc"
require "fileutils"

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

#TODO kill
      def note_p_parsex(node, div)
        name = node&.at(ns("./fmt-name"))&.remove
        div.p do |p|
          name and p.span class: "note_label" do |s|
            name.children.each { |n| parse(n, s) }
          end
          node.first_element_child.children.each { |n| parse(n, p) }
        end
        node.element_children[1..-1].each { |n| parse(n, div) }
      end

#TODO kill
      def note_parse1x(node, div)
        name = node&.at(ns("./name"))&.remove
        name and div.p do |p|
          p.span class: "note_label" do |s|
            name.children.each { |n| parse(n, s) }
          end
        end
        node.children.each { |n| parse(n, div) }
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
