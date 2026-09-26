# frozen_string_literal: true

require "lutaml/model"

module Metanorma
  module Ieee
    # IEEE's lutaml-model register: creates the :ieee_document context the
    # IEEE models resolve against during parsing. Formerly
    # Metanorma::Registers::Setup.setup_ieee_register in metanorma-
    # document; like the ISO flavor, the substitutions live with the
    # classes they name.
    module Registers
      module_function

      def setup
        sd = Metanorma::Standoc::Document
        ieee = Metanorma::Ieee::Document
        reg = Lutaml::Model::Register.new(:ieee_document)
        Lutaml::Model::GlobalRegister.register(reg)

        reg.register_global_type_substitution(
          from_type: sd::Sections::Sections,
          to_type: ieee::Sections::IeeeSections,
        )
      end
    end
  end
end
