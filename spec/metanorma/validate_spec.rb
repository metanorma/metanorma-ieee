require "spec_helper"

RSpec.describe Metanorma::IEEE do
  before(:all) do
    FileUtils.rm_f "test.err"
  end

  it "warns that title should match doctype" do
    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      = Fred
      :docfile: test.adoc
      :doctype: recommended-practice
      :draft: 1.1
      :docsubtype: trial-use
      :no-pdf:

    INPUT
    expect(File.exist?("test.err")).to be true
    expect(File.read("test.err")).to include "Expected title to start as: Draft Trial-Use Recommended Practice"
  end
end
