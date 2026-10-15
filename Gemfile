source "https://rubygems.org"
gem "relaton-render", "= 3.0.0.pre.alpha.43" # canonical ieee-sa pack; delta merge, edition precedence, named ieee_* rules
# the lockfile is not tracked; without an exact pin CI floats the monogem
# to newer alphas whose rendering differs, flipping fixture baselines
gem "relaton", "= 3.0.0.pre.alpha.14"
# leptris 1.9.359 drops Leptris::XML::Declaration#to_xml (blocks_spec);
# 1.9.356 is the last rendering-green line until leptris restores it
gem "leptris", "1.9.356.0"

git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec
gem "metanorma-mirror", "~> 1.0"

# TEMPORARY: cross-PR branch pins so CI can resolve the in-flight
# metanorma-standoc namespace rename (Metanorma::Standoc::Document)
# and the pubid-2 / relaton-bib 2.2 / metanorma-document 0.5 chain.
# Revert each pin once the corresponding PR merges:
#   - https://github.com/metanorma/metanorma-standoc/pull/1232
#   - https://github.com/metanorma/metanorma-document/pull/45
gem "metanorma-standoc", github: "metanorma/metanorma-standoc", branch: "main"
# released plugin-lutaml 0.7.50 dropped the preprocessor names standoc
# registers (LutamlDataPreprocessor); main carries them (generic#133)
gem "metanorma-plugin-lutaml", github: "metanorma/metanorma-plugin-lutaml", branch: "main"
gem "metanorma-document", github: "metanorma/metanorma-document", branch: "main" # TEMPORARY audit chain
gem "isodoc", github: "metanorma/isodoc", branch: "main" # merged as #825
gem "relaton-bib", "2.2.0.pre.alpha.1"
gem "pubid", github: "pubid/pubid", branch: "main"

eval_gemfile("Gemfile.devel") rescue nil
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main"
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "feat/flavor-table" # TEMPORARY audit chain
