require "asciidoctor"
require "metanorma/standoc/converter"
require "fileutils"
require "metanorma-utils"
require_relative "front"
require_relative "cleanup"
require_relative "validate"

module Metanorma
  module IEEE
    class Converter < Standoc::Converter
      XML_ROOT_TAG = "ieee-standard".freeze
      XML_NAMESPACE = "https://www.metanorma.org/ns/ieee".freeze

      register_for "ieee"

      def clause_parse(attrs, xml, node)
        case node.title
        when "Purpose" then attrs[:type] = "purpose"
        when "Overview" then attrs[:type] = "overview"
        when "Scope" then attrs[:type] = "scope"
        when "Word Usage" then attrs[:type] = "word-usage"
        end
        super
      end

      def outputs(node, ret)
        File.open("#{@filename}.xml", "w:UTF-8") { |f| f.write(ret) }
        presentation_xml_converter(node).convert("#{@filename}.xml")
        html_converter(node).convert("#{@filename}.presentation.xml",
                                     nil, false, "#{@filename}.html")
        doc_converter(node).convert("#{@filename}.presentation.xml",
                                    nil, false, "#{@filename}.doc")
        node.attr("no-pdf") or
          pdf_converter(node)&.convert("#{@filename}.presentation.xml",
                                       nil, false, "#{@filename}.pdf")
      end

      def presentation_xml_converter(node)
        IsoDoc::IEEE::PresentationXMLConvert.new(html_extract_attributes(node))
      end

      def html_converter(node)
        IsoDoc::IEEE::HtmlConvert.new(html_extract_attributes(node))
      end

      def pdf_converter(node)
        IsoDoc::IEEE::PdfConvert.new(pdf_extract_attributes(node))
      end

      def doc_converter(node)
        IsoDoc::IEEE::WordConvert.new(doc_extract_attributes(node))
      end
    end
  end
end
