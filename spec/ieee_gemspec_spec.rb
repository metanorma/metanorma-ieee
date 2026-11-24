# frozen_string_literal: true

require "rubygems"

RSpec.describe "metanorma-ieee gemspec" do
  # metanorma/ieee/document requires metanorma/iso/document and subclasses
  # the ISO document model; without the dependency the JSON output of
  # metanorma-cli#518 fails to load the IEEE model.
  it "declares metanorma-iso as a runtime dependency" do
    spec = Gem::Specification.load(File.expand_path("../metanorma-ieee.gemspec", __dir__))

    expect(spec.runtime_dependencies.map(&:name)).to include("metanorma-iso")
  end
end
