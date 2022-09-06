require "metanorma/ieee"
require "asciidoctor"
require "isodoc/ieee"
require "html2doc/ieee"

if defined? Metanorma::Registry
  Metanorma::Registry.instance.register(Metanorma::IEEE::Processor)
end
