require "metanorma/ieee"
require "asciidoctor"
require "isodoc/ieee"
require "html2doc/ieee"
require "html2doc/ieee_wp"
require "metanorma"

if defined? Metanorma::Registry
  Metanorma::Registry.instance.register(Metanorma::IEEE::Processor)
end
