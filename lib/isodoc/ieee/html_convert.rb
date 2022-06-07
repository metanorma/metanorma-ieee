require "isodoc"
require_relative "init"

module IsoDoc
  module IEEE
    # A {Converter} implementation that generates HTML output, and a document
    # schema encapsulation of the document for validation
    #
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

      include BaseConvert
      include Init
    end
  end
end
