require "metanorma/ieee/version"
require "metanorma/ieee/document"
require "metanorma/ieee/processor"
require "metanorma/ieee/converter"
require "metanorma/ieee/cleanup"
require "metanorma/ieee/validate"

module Metanorma
  module Ieee
    autoload :CitationStyle, "metanorma/ieee/citation_style"
    autoload :IeeeElements, "metanorma/ieee/ieee_elements"
    ORGANIZATION_NAME_SHORT = "IEEE"
    ORGANIZATION_NAME_LONG = "Institute of Electrical and Electronics Engineers"
  end
end

