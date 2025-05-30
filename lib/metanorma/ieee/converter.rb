require "asciidoctor"
require "metanorma/standoc/converter"
require "fileutils"
require "metanorma-utils"
require_relative "front"
require_relative "cleanup"
require_relative "validate"

module Metanorma
  module Ieee
    class Converter < Standoc::Converter
      register_for "ieee"

      def init(node)
        super
        @document_scheme ||= "ieee-sa-2021"
        @hierarchical_assets = node.attr("hierarchical-object-numbering")
      end

      PREFACE_CLAUSE_NAMES =
        %w(abstract foreword introduction acknowledgements participants
           metanorma-extension misc-container).freeze

      def sectiontype_streamline(ret)
        case ret
        when "definitions", "definitions, acronyms and abbreviations"
          "terms and definitions"
        when "acronyms and abbreviations" then "symbols and abbreviated terms"
        else super
        end
      end

      def clause_attrs_preprocess(attrs, node)
        case node.title.downcase
        when "purpose" then attrs[:type] = "purpose"
        when "overview" then attrs[:type] = "overview"
        when "scope" then attrs[:type] = "scope"
        when "word usage" then attrs[:type] = "word-usage"
        when "participants" then attrs[:type] = "participants"
        end
        super
      end

      def termsource_attrs(node, matched)
        ret = super
        node.option? "adapted" and ret[:status] = "adapted"
        ret
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

      def boilerplate_file(xmldoc)
        file = "boilerplate.adoc"
        doctype = xmldoc.at("//bibdata/ext/doctype")&.text
        doctype == "whitepaper" and file = "boilerplate_wp.adoc"
        File.join(@libdir, file)
      end

      def html_extract_attributes(node)
        super.merge(hierarchicalassets:
                    node.attr("hierarchical-object-numbering"),
                    ieeedtd: node.attr("ieee-dtd"))
      end

      def doc_extract_attributes(node)
        super.merge(hierarchicalassets:
                    node.attr("hierarchical-object-numbering"),
                    ulstyle: "l11", olstyle: "l16")
      end

      def presentation_xml_converter(node)
        IsoDoc::Ieee::PresentationXMLConvert
          .new(html_extract_attributes(node)
          .merge(output_formats: ::Metanorma::Ieee::Processor.new.output_formats))
      end

      def html_converter(node)
        IsoDoc::Ieee::HtmlConvert.new(html_extract_attributes(node))
      end

      def pdf_converter(node)
        return nil if node.attr("no-pdf")

        IsoDoc::Ieee::PdfConvert.new(pdf_extract_attributes(node))
      end

      def doc_converter(node)
        IsoDoc::Ieee::WordConvert.new(doc_extract_attributes(node))
      end

      def ieee_xml_converter(node)
        return nil if node.attr("no-pdf")

        IsoDoc::Iso::IeeeXMLConvert.new(html_extract_attributes(node))
      end
    end
  end
end
