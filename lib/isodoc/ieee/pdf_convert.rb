require "isodoc"
require "fileutils"

module IsoDoc
  module IEEE
    # A {Converter} implementation that generates PDF HTML output, and a
    # document schema encapsulation of the document for validation
    class PdfConvert < IsoDoc::XslfoPdfConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def pdf_stylesheet(docxml)
        # doctype = docxml&.at(ns("//bibdata/ext/doctype"))&.text
        "itu.xsl"
      end
    end
  end
end
