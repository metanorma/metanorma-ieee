# frozen_string_literal: true

module Metanorma
  module Ieee::Document
    class Root < Lutaml::Model::Serializable
      include Metanorma::Standoc::Document::RootAttributes

      def self.lutaml_default_register
        :ieee_document
      end

      attribute :bibdata, Metadata::IeeeBibliographicItem
      attribute :preface,
                Metanorma::Standoc::Document::Sections::Preface
      attribute :sections,
                IeeeDocument::Sections::IeeeSections
      attribute :annex,
                Metanorma::Standoc::Document::Sections::AnnexSection,
                collection: true

      xml do
        element "metanorma"
        namespace Metanorma::Standoc::Document::Namespace

        Metanorma::Standoc::Document::RootXmlMapping.apply(self)
      end
    end
  end
end