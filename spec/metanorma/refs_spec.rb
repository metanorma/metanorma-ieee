require "spec_helper"

RSpec.describe Metanorma::IEEE do
  it "sorts references" do
    VCR.use_cassette "multistandard" do
      input = <<~INPUT
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib-cache:

        <<ref3>>
        <<ref7>>
        <<ref6>>
        <<ref1>>
        <<ref4>>
        <<ref5>>
        <<ref2>>

        [bibliography]
        == Normative References

        * [[[ref5,ISO 639:1967]]] REF5
        * [[[ref7,IETF RFC 7749]]] REF7
        * [[[ref6,REF6]]] REF6
        * [[[ref4,REF4]]] REF4
        * [[[ref2,ISO 15124]]] REF2
        * [[[ref3,REF3]]] REF3
        * [[[ref1,REF1]]] REF1
      INPUT
      out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
      expect(out.xpath("//xmlns:references/xmlns:bibitem/@id")
        .map(&:value)).to be_equivalent_to ["ref2", "ref5", "ref1", "ref3",
                                            "ref4", "ref6", "ref7"]
    end
  end
end
