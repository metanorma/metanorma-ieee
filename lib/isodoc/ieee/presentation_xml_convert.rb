require_relative "init"
require "isodoc"

module IsoDoc
  module IEEE
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      include Init
    end
  end
end
