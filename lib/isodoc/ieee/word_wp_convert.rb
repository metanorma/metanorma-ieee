require_relative "word_wp_cleanup"

module IsoDoc
  module Ieee
    class WordWPConvert < WordConvert
      def initialize(options)
        @libdir ||= File.dirname(__FILE__) # rubocop:disable Lint/DisjunctiveAssignmentInConstructor
        options.merge!(default_file_locations(nil)).merge!(default_fonts(nil))
        super
      end

      def init_wp(options); end

      def default_file_locations(_options)
        { wordstylesheet: html_doc_path("wordstyle_wp.scss"),
          standardstylesheet: html_doc_path("ieee_wp.scss"),
          header: html_doc_path("header_wp.html"),
          wordcoverpage: html_doc_path("word_ieee_titlepage_wp.html"),
          wordintropage: html_doc_path("word_ieee_intro_wp.html"),
          ulstyle: "l23", olstyle: "l16" }
      end

      def default_fonts(_options)
        { bodyfont: '"Calibri",sans-serif',
          headerfont: '"Arial Black",sans-serif',
          monospacefont: '"Courier New",monospace',
          normalfontsize: "11.0pt",
          footnotefontsize: "7.0pt",
          smallerfontsize: "10.0pt",
          monospacefontsize: "10.0pt" }
      end

      def convert1(docxml, filename, dir)
        s = docxml.at(ns("//bibdata/ext/subdoctype"))&.text
        s == "industry-connection-report" and
          @wordcoverpage = html_doc_path("word_ieee_titlepage_icr.html")
        super
      end

      def make_body3(body, docxml)
        body.div class: "WordSection3" do |div3|
          middle_title_ieee(docxml, div3)
          content(div3, docxml, ns(self.class::MAIN_ELEMENTS))
        end
        section_break(body)
        body.div class: "WordSection4" do |div3|
          backcover div3
          footnotes div3
          comments div3
        end
      end

      def backcover(out)
        out << populate_template(
          File.read(html_doc_path("word_ieee_colophon_wp.html")), :word
        )
      end

      def figure_attrs(node)
        attr_code(id: node["id"], class: "figure",
                  style: "#{keep_style(node)};text-align:center;")
      end

      ABSTRACT_MARGIN =
        "margin-top:18.0pt;margin-right:7.2pt;margin-bottom:6.0pt;" \
        "margin-left:0cm;".freeze

      def para_parse(node, out)
        node["class"] == "zzSTDTitle1" and
          return middle_title_ieee(node.document.root, out)
        super
      end

      def middle_title_ieee(docxml, out)
        super
        out << BLUELINE
        out.p
      end

      def abstract(clause, out)
        out.div **attr_code(id: clause["id"], class: "abstract_div") do |s|
          abstract_body(clause, s)
        end
        page_break(out)
      end

      def abstract_body(clause, out)
        clause_name(clause, clause.at(ns("./fmt-title")), out,
                    { class: stylesmap[:AbstractTitle],
                      style: ABSTRACT_MARGIN })
        clause.elements.each { |e| parse(e, out) unless e.name == "fmt-title" }
      end

      def clause(node, out)
        super
        node.next_element and page_break(out) # only main clauses
      end

      def figure_parse1(node, out)
        out.div **figure_attrs(node) do |div|
          figure_name_parse(node, div, node.at(ns("./fmt-name")))
          node.children.each do |n|
            parse(n, div) unless n.name == "fmt-name"
          end
        end
      end

      def clause_parse_subtitle(title, heading)
        title&.parent&.name == "annex" or return super
      end

      def variant_title(node, out)
        node.parent.name == "annex" or return super
        out.p { |e| e << "&#xa0;" }
        out.p **attr_code(class: "Unnumberedheading") do |p|
          node.children.each { |c| parse(c, p) }
        end
      end
    end
  end
end
