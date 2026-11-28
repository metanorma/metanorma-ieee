source "https://rubygems.org"
gem "relaton", "~> 3.1.8"
gem "parsanol", "~> 1.5.0" # pubid 2.0.50 and lutaml 0.11.8 both require the 1.5 line
# leptris 1.9.359 drops Leptris::XML::Declaration#to_xml (blocks_spec);
# 1.9.356 is the last rendering-green line until leptris restores it

git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec
gem "metanorma-mirror", "~> 1.0"

gem "metanorma-standoc", "~> 3.5.7" # Standoc::Document rename
# released plugin-lutaml 0.7.50 dropped the preprocessor names standoc
# registers (LutamlDataPreprocessor); main carries them (generic#133)
gem "metanorma-plugin-lutaml", github: "metanorma/metanorma-plugin-lutaml", branch: "main"
gem "metanorma-document", "~> 0.5.15"
gem "isodoc", "~> 3.7.9"
gem "pubid", "~> 2.0"

eval_gemfile("Gemfile.devel") rescue nil
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main"
gem "metanorma-core", "~> 0.2.7" # published flavor/taste table (metanorma-core#18)
# moxml 0.5.138's leptris adapter references Leptris::XML::Declaration,
# which only exists in leptris 1.9.359 (the to_xml regression pair,
# leptris#1733); pin the coherent 1.9.356-era moxml line
