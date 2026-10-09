Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
gem "relaton-render", "3.0.0.pre.alpha.31" # canonical ieee-sa pack # renderings contract, segment join, in-text et-al

git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec


# TEMPORARY: cross-PR branch pins so CI can resolve the in-flight
# metanorma-standoc namespace rename (Metanorma::Standoc::Document)
# and the pubid-2 / relaton-bib 2.2 / metanorma-document 0.5 chain.
# Revert each pin once the corresponding PR merges:
#   - https://github.com/metanorma/metanorma-standoc/pull/1232
#   - https://github.com/metanorma/metanorma-document/pull/45
gem "metanorma-document", github: "metanorma/metanorma-document", branch: "main"
# standoc main carries the Metanorma::Standoc::Document split and the
# relaton 3 prerelease allowance; released 3.5.0 pins relaton-cli ~> 2.1.
gem "metanorma-standoc", github: "metanorma/metanorma-standoc", branch: "main"
# plugin-lutaml main carries LutamlDataPreprocessor (registered by
# standoc main's converter); released 0.7.53 does not define it yet.
gem "metanorma-plugin-lutaml", github: "metanorma/metanorma-plugin-lutaml", branch: "main"
gem "metanorma-utils", github: "metanorma/metanorma-utils", branch: "main" # GcBudget, unreleased past 2.0.7
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main" # CitationStyle port, unreleased
gem "isodoc", github: "metanorma/isodoc", branch: "main" # publisher-token miss guard (#849)
gem "relaton-cli", ">= 3.0.0.pre.alpha.1"
# Pin relaton: Its VERSION is the cache grammar_hash and it ships the ITU
# scraper. A floating `>= 3.0.0.pre.alpha.1` (via metanorma-document) lets
# CI resolve a newer pre-release, which wipes the vendored spec cache and
# rewrites fixtures against live www.itu.int.
gem "relaton", ">= 3.0.0.pre.alpha.11" # ~> form resolves the stale alpha.5 + relaton-render 1.3.0 pair (the crashing one)


eval_gemfile("Gemfile.devel") rescue nil
