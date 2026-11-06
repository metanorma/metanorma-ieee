source "https://rubygems.org"
gem "relaton", "~> 3.1.1"
# parsanol 1.3.123 is the current pubid-compatible line (pubid pins ~> 1.3.12x);
# 1.3.123 restores the 1.3.121 binding behaviour (parsanol#421).
gem "parsanol", "~> 1.3.123" # pubid ~> 2.0.3 requires the 1.3.12x line; 1.3.123 carries the JIS binding fix (parsanol#421)
# leptris 1.9.359 drops Leptris::XML::Declaration#to_xml (blocks_spec);
# 1.9.356 is the last rendering-green line until leptris restores it

git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec
gem "metanorma-mirror", "~> 1.0"

gem "metanorma-standoc", "~> 3.5.7" # Standoc::Document rename
# released plugin-lutaml 0.7.50 dropped the preprocessor names standoc
# registers (LutamlDataPreprocessor); main carries them (generic#133)
gem "metanorma-plugin-lutaml", github: "metanorma/metanorma-plugin-lutaml", branch: "main"
gem "metanorma-document", "~> 0.5.3"
gem "isodoc", "~> 3.7.9"
gem "pubid", "~> 2.0"

eval_gemfile("Gemfile.devel") rescue nil
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main"
gem "metanorma-core", "~> 0.2.7" # published flavor/taste table (metanorma-core#18)
# moxml 0.5.138's leptris adapter references Leptris::XML::Declaration,
# which only exists in leptris 1.9.359 (the to_xml regression pair,
# leptris#1733); pin the coherent 1.9.356-era moxml line
