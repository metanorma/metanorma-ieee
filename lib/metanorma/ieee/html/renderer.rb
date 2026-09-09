# frozen_string_literal: true

module Metanorma
  module Ieee
    module Html
      # IEEE documents render iso-style: the IEEE root and sections
      # register alongside the shared standoc classes the model uses
      # (exact-class dispatch, OGC pattern).
      class Renderer < Metanorma::Iso::Html::Renderer
        register_render "Metanorma::Ieee::Document::Root", :render_document
        register_render "Metanorma::Ieee::Document::Sections::IeeeSections",
                        :render_sections
        register_render "Metanorma::Standoc::Document::Sections::Preface",
                        :render_preface
        register_render "Metanorma::Standoc::Document::Sections::ClauseSection",
                        :render_clause
        register_render "Metanorma::Standoc::Document::Sections::AnnexSection",
                        :render_annex
        register_render "Metanorma::Standoc::Document::Sections::ContentSection",
                        :render_clause
        register_render "Metanorma::Standoc::Document::Sections::TermsSection",
                        :render_terms_section
        register_render "Metanorma::Standoc::Document::Sections::BibliographySection",
                        :render_clause
        register_render "Metanorma::Standoc::Document::Sections::DefinitionSection",
                        :render_clause
      end
    end
  end
end
