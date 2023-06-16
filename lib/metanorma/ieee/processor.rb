require "metanorma/processor"

module Metanorma
  module IEEE
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
          "Noto Serif" => nil,
          "Noto Serif HK" => nil,
          "Noto Serif JP" => nil,
          "Noto Serif KR" => nil,
          "Noto Serif SC" => nil,
          "Noto Serif TC" => nil,
          "Noto Sans Mono" => nil,
          "Noto Sans Mono CJK HK" => nil,
          "Noto Sans Mono CJK JP" => nil,
          "Noto Sans Mono CJK KR" => nil,
          "Noto Sans Mono CJK SC" => nil,
          "Noto Sans Mono CJK TC" => nil,
        }
      end

      def version
        "Metanorma::IEEE #{Metanorma::IEEE::VERSION}"
      end

      def output(isodoc_node, inname, outname, format, options = {})
        case format
        when :html
          IsoDoc::IEEE::HtmlConvert.new(options).convert(inname, isodoc_node,
                                                         nil, outname)
        when :doc
          IsoDoc::IEEE::WordConvert.new(options).convert(inname, isodoc_node,
                                                         nil, outname)
        when :pdf
          IsoDoc::IEEE::PdfConvert.new(options).convert(inname, isodoc_node,
                                                        nil, outname)
        when :presentation
          IsoDoc::IEEE::PresentationXMLConvert.new(options).convert(
            inname, isodoc_node, nil, outname
          )
        when :ieee
          IsoDoc::IEEE::IEEEXMLConvert.new(options)
            .convert(inname, isodoc_node, nil, outname)
        else
          super
        end
      end
    end
  end
end
