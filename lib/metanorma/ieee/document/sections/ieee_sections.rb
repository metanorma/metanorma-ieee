# frozen_string_literal: true

module Metanorma
  module Ieee::Document
    module Sections
      # IEEE sections container.
      # Corresponds to ieee.rnc:
      #   sections = element sections {
      #     note?,
      #     ( clause | terms | term-clause | definitions | floating-title )+
      #   }
      #
      # Differs from isodoc default by adding an optional leading note.
      class IeeeSections < Metanorma::Standoc::Document::Sections::Sections
        attribute :note,
                  Metanorma::Document::Components::Blocks::NoteBlock

        xml do
          element "sections"
          ordered

          map_element "note", to: :note

          Metanorma::Standoc::Document::SectionXmlMapping.apply_sections_elements(self)

          Metanorma::Standoc::Document::SectionXmlMapping.apply_sections_attributes(self)
        end
      end
    end
  end
end