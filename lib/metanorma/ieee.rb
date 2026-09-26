require "metanorma/ieee/version"
require "metanorma/ieee/processor"
require "metanorma/ieee/converter"
require "metanorma/ieee/cleanup"
require "metanorma/ieee/validate"

module Metanorma
  module Ieee
    ORGANIZATION_NAME_SHORT = "IEEE"
    ORGANIZATION_NAME_LONG = "Institute of Electrical and Electronics Engineers"
  end
end


# Registry styling: the flavor owns its index theme, registered
# programmatically with the metanorma-document theme system.
begin
  require "metanorma/html"
  Metanorma::Html::Theme.register_themes_dir(
    File.expand_path("ieee/themes", __dir__),
  )
rescue LoadError
  # metanorma-document unavailable; registry styling inert
end
