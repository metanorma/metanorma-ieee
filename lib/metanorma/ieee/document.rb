# frozen_string_literal: true

require "metanorma/standoc"
# Forward-declare parent namespace so this file is safe to require
# directly (without first requiring metanorma/ieee.rb).
module Metanorma
  module Ieee
  end
end


module Metanorma
  module Ieee::Document
    autoload :Metadata, "metanorma/ieee/document/metadata"
    autoload :Root, "metanorma/ieee/document/root"
    autoload :Sections, "metanorma/ieee/document/sections"
  end
end


# Backwards-compat alias so external consumers that reference
# Metanorma::IeeeDocument keep resolving during the transition.
module Metanorma
  existing = defined?(Metanorma::IeeeDocument) && Metanorma::IeeeDocument
  if !existing.equal?(Metanorma::Ieee::Document)
    Metanorma.send(:remove_const, :IeeeDocument) if existing
    IeeeDocument = Metanorma::Ieee::Document
  end
end

if defined?(Metanorma::Registers::Setup.setup_ieee_register)
  Metanorma::Registers::Setup.setup_ieee_register
end

module Metanorma
  deprecate_constant :IeeeDocument
end
