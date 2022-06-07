require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::IEEE do
  it "has a version number" do
    expect(Metanorma::IEEE::VERSION).not_to be nil
  end

  it "processes a blank document" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}
    INPUT
    output = <<~OUTPUT
      #{@blank_hdr}
      <sections/>
      </ieee-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "converts a blank document" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
      :legacy-do-not-insert-missing-sections:
    INPUT
    output = <<~OUTPUT
        #{@blank_hdr}
        <sections/>
      </ieee-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
    expect(File.exist?("test.html")).to be true
  end
end
