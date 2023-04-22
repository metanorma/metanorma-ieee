require "isodoc"
require_relative "init"

module IsoDoc
  module IEEE
    class HtmlConvert < IsoDoc::HtmlConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def default_fonts(options)
        {
          bodyfont: (if options[:script] == "Hans"
                       '"Source Han Sans",serif'
                     else
                       '"Times New Roman",serif'
                     end),
          headerfont: (if options[:script] == "Hans"
                         '"Source Han Sans",sans-serif'
                       else
                         '"Times New Roman",serif'
                       end),
          monospacefont: '"Courier New",monospace',
          normalfontsize: "14px",
          monospacefontsize: "0.8em",
          footnotefontsize: "0.9em",
        }
      end

      def default_file_locations(_options)
        {
          htmlstylesheet: html_doc_path("htmlstyle.scss"),
          htmlcoverpage: html_doc_path("html_ieee_titlepage.html"),
          htmlintropage: html_doc_path("html_ieee_intro.html"),
        }
      end

      def html_cleanup(html)
        para_type_strip(affiliation_table(super))
      end

      def para_type_strip(html)
        html.xpath("//p[@type]").each { |p| p.delete("type") }
        html
      end

      def affiliation_table(html)
        html.xpath("//p[@type = 'officeorgrepmemberhdr']").each do |p|
          affiliation_table1(p)
        end
        html
      end

      def affiliation_table1(para)
        ret = "<table><thead>#{para_to_tr(para)}</thead><tbody>"
        n = para.next_element
        while n&.name == "p" && n["type"] == "officeorgrepmember"
          n1 = n.next_element
          ret += para_to_tr(n.remove)
          n = n1
        end
        ret += "</tbody></table>"
        para.replace(ret)
      end

      def para_to_tr(para)
        ret = para.children.each_with_object([[]]) do |c, m|
          if c.name == "tab" then m << []
          else m[-1] << to_xml(c)
          end
        end.map { |c| "<td>#{c.join}</td>" }
        "<tr>#{ret.join}</tr>"
      end

      def clausedelimspace(node, out)
        if node.at("./ancestor::xmlns:p[@type = 'officeorgrepmemberhdr' " \
                   "or @type = 'officeorgrepmember']")
          out.tab
        else super
        end
      end

      include BaseConvert
      include Init
    end
  end
end
