source "https://rubygems.org"
gem "relaton-render", "~> 3.0" # canonical ieee-sa pack; delta merge, edition precedence, named ieee_* rules
gem "relaton", "~> 3.0" # 3.0.0 final carries the singular_tolerance declarations
# parsanol 1.3.110 shipped the v2 named-tree dialect as the default: every
# uncaptured rule reference surfaces as a capture, so pubid parses plain
# references as per-atom lists ("ISO 8888" -> {number: "[{digit:..."}},
# "Unknown parameter type: space"). The v2 migration is pubid-side work in
# flight; pin the last classic-dialect release until it lands (parsanol#352).
gem "parsanol", "1.3.109"
# leptris 1.9.359 drops Leptris::XML::Declaration#to_xml (blocks_spec);
# 1.9.356 is the last rendering-green line until leptris restores it

git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec
gem "metanorma-mirror", "~> 1.0"

gem "metanorma-standoc", "~> 3.5.1.pre.alpha" # Standoc::Document rename
# released plugin-lutaml 0.7.50 dropped the preprocessor names standoc
# registers (LutamlDataPreprocessor); main carries them (generic#133)
gem "metanorma-plugin-lutaml", github: "metanorma/metanorma-plugin-lutaml", branch: "main"
gem "metanorma-document", "~> 0.5.2.pre.alpha"
gem "isodoc", "~> 3.7.4.pre.alpha"
gem "relaton-bib", "2.2.0.pre.alpha.1"
gem "pubid", "~> 2.0"

eval_gemfile("Gemfile.devel") rescue nil
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main"
gem "metanorma-core", "~> 0.2.5.pre.alpha" # published flavor/taste table (metanorma-core#18)
# moxml 0.5.138's leptris adapter references Leptris::XML::Declaration,
# which only exists in leptris 1.9.359 (the to_xml regression pair,
# leptris#1733); pin the coherent 1.9.356-era moxml line
