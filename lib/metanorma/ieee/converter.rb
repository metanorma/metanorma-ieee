require "asciidoctor"
require "metanorma/standoc/converter"
require "fileutils"
require "metanorma-utils"

module Metanorma
  module IEEE
    class Converter < Standoc::Converter
      XML_ROOT_TAG = "ieee-standard".freeze
      XML_NAMESPACE = "https://www.metanorma.org/ns/ieee".freeze

      register_for "ieee"

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

      def validate(doc)
        content_validate(doc)
        schema_validate(formattedstr_strip(doc.dup),
                        File.join(File.dirname(__FILE__), "ieee.rng"))
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

=begin
`docnumber`:: In IEEE terms: the designation number for the document.

`draft`:: The draft number.

`doctype`::
Document type. Choices:
+
--
* `standard` (default): This document is a Standard
* `recommended-practice`: This document is a Recommended Practice
* `guide`: This document is a Guide
--

`docsubtype`::
Document type. Choices:
+
--
* `trial-use`: Document published for a limited period of time.
--
=end
    end
  end
end
