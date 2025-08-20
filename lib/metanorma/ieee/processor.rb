require "metanorma/processor"

module Metanorma
  module Ieee
    class Processor < Metanorma::Processor
      def initialize
        @short = :ieee
        @input_format = :asciidoc
        @asciidoctor_backend = :ieee
      end

      def output_formats
        super.merge(
          html: "html",
          doc: "doc",
          pdf: "pdf",
          ieee: "ieee.xml",
        )
      end

      def fonts_manifest
        {
          "Arial" => nil,
          "Courier New" => nil,
          "Times New Roman" => nil,
          "Source Han Sans" => nil,
          "Source Han Sans Normal" => nil,
          "STIX Two Math" => nil,
          "Montserrat ExtraBold" => nil,
        }
      end

      def version
        "Metanorma::Ieee #{Metanorma::Ieee::VERSION}"
      end

      def output(isodoc_node, inname, outname, format, options = {})
        options_preprocess(options)
        case format
        when :html
          IsoDoc::Ieee::HtmlConvert.new(options).convert(inname, isodoc_node,
                                                         nil, outname)
        when :doc
          IsoDoc::Ieee::WordConvert.new(options).convert(inname, isodoc_node,
                                                         nil, outname)
        when :pdf
          IsoDoc::Ieee::PdfConvert.new(options).convert(inname, isodoc_node,
                                                        nil, outname)
        when :presentation
          IsoDoc::Ieee::PresentationXMLConvert.new(options).convert(
            inname, isodoc_node, nil, outname
          )
        when :ieee
          IsoDoc::Ieee::IeeeXMLConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        else
          super
        end
      end
    end
  end
end
