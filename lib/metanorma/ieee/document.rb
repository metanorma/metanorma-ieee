# frozen_string_literal: true

require "metanorma/standoc"
require "metanorma/iso/document/models"
module Metanorma
  module Ieee
  end
end

module Metanorma
  module Ieee::Document
  end
end

module Metanorma
  existing = defined?(Metanorma::IeeeDocument) && Metanorma::IeeeDocument
  if !existing.equal?(Metanorma::Ieee::Document)
    Metanorma.send(:remove_const, :IeeeDocument) if existing
    IeeeDocument = Metanorma::Ieee::Document
  end
end

require "metanorma/ieee/registers"
Metanorma::Ieee::Registers.setup

# OCP adoption: ONE registration in the metanorma-core flavor table
require "metanorma-core"
require "metanorma/iso/html"

Metanorma::Core::Flavors.register(Metanorma::Core::Flavor.new(
  name: :ieee,
  gem: "metanorma-ieee",
  model_root: Metanorma::Ieee::Document::Root,
  pubid_module: :"Pubid::Ieee",
  renderers: { html: Metanorma::Iso::Html::Renderer },
))
