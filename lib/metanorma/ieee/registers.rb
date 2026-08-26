# frozen_string_literal: true

require "lutaml/model"

module Metanorma
  module Ieee
    # ieee's lutaml-model register: type substitutions from standoc.
    # Formerly Metanorma::Registers::Setup.setup_ieee_register in metanorma-document.
    module Registers
      module_function

      def setup
          sd = Metanorma::StandardDocument
          reg = Lutaml::Model::Register.new(:ieee_document)
          Lutaml::Model::GlobalRegister.register(reg)

          reg.register_global_type_substitution(
            from_type: sd::Sections::Sections,
            to_type: Metanorma::Ieee::Document::Sections::IeeeSections,
          )
      end
    end
  end
end
