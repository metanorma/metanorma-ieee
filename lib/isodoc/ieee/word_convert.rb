require "isodoc"
require_relative "init"
require_relative "word_cleanup"
require_relative "word_authority"

module IsoDoc
  module IEEE
    class WordConvert < IsoDoc::WordConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def default_fonts(options)
        { bodyfont: (if options[:script] == "Hans"
                       '"Source Han Sans",serif'
                     else
                       '"Times New Roman",serif'
                     end),
          headerfont: (if options[:script] == "Hans"
                         '"Source Han Sans",sans-serif'
                       else
                         '"Arial",sans-serif'
                       end),
          monospacefont: '"Courier New",monospace',
          normalfontsize: "12.0pt",
          footnotefontsize: "11.0pt",
          smallerfontsize: "10.0pt",
          monospacefontsize: "10.0pt" }
      end

      def default_file_locations(_options)
        { wordstylesheet: html_doc_path("wordstyle.scss"),
          standardstylesheet: html_doc_path("ieee.scss"),
          header: html_doc_path("header.html"),
          wordcoverpage: html_doc_path("word_ieee_titlepage.html"),
          wordintropage: html_doc_path("word_ieee_intro.html"),
          ulstyle: "l3",
          olstyle: "l2" }
      end

      def abstract(isoxml, out)
        f = isoxml.at(ns("//preface/abstract")) || return
        page_break(out)
        out.div **attr_code(id: f["id"], class: "abstract") do |s|
          clause_name(nil, f.at(ns("./title")), s, { class: "AbstractTitle" })
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def make_body3(body, docxml)
        body.div **{ class: "WordSection13" } do |_div3|
          middle_title_ieee(docxml, body)
        end
        section_break(body, continuous: true)
        body.div **{ class: "WordSection14" } do |div3|
          middle docxml, div3
          footnotes div3
          comments div3
        end
      end

      def middle_title(isoxml, out); end

      def middle_title_ieee(_docxml, out)
        out.p(**{ class: "IEEEStdsTitle", style: "margin-top:70.0pt" }) do |p|
          p << @meta.get[:full_doctitle]
        end
      end

      include BaseConvert
      include Init
    end
  end
end
