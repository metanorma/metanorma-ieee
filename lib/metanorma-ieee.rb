require "metanorma/ieee"
require "asciidoctor"
require "isodoc/ieee"

if defined? Metanorma
  Metanorma::Registry.instance.register(Metanorma::IEEE::Processor)
end
