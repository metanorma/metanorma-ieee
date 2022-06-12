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

  it "inserts trademarks against IEEE citations" do
    VCR.use_cassette "ieee-multi" do
      input = <<~INPUT
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:

        == Introduction

        <<ref1>>

        <<ref2>>

        <<ref1>>

        == Overview

        === Scope

        <<ref1>>

        <<ref2>>

        <<ref1>>

        == Clause

        <<ref1>>

        [appendix]
        == Annex

        <<ref1>>

        [bibliography]
        == Normative References

        * [[[ref2,ISO 639:1967]]] REF5
        * [[[ref1,IEEE Std 1619-2007]]] REF1
      INPUT
      output = <<~OUTPUT
         <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
          <preface>
            <introduction id='_' obligation='informative'>
              <title>Introduction</title>
              <admonition>This introduction is not part of P, Document title </admonition>
              <p id='_'>
                <eref type='inline' bibitemid='ref1' citeas='IEEE 1619-2007™'/>
              </p>
              <p id='_'>
                <eref type='inline' bibitemid='ref2' citeas='ISO 639:1967'/>
              </p>
              <p id='_'>
                <eref type='inline' bibitemid='ref1' citeas='IEEE 1619-2007'/>
              </p>
            </introduction>
          </preface>
          <sections>
            <clause id='_' type='overview' inline-header='false' obligation='normative'>
              <title>Overview</title>
              <clause id='_' type='scope' inline-header='false' obligation='normative'>
                <title>Scope</title>
                <p id='_'>
                  <eref type='inline' bibitemid='ref1' citeas='IEEE 1619-2007™'/>
                </p>
                <p id='_'>
                  <eref type='inline' bibitemid='ref2' citeas='ISO 639:1967'/>
                </p>
                <p id='_'>
                  <eref type='inline' bibitemid='ref1' citeas='IEEE 1619-2007'/>
                </p>
              </clause>
            </clause>
            <clause id='_' inline-header='false' obligation='normative'>
              <title>Clause</title>
              <p id='_'>
                <eref type='inline' bibitemid='ref1' citeas='IEEE 1619-2007'/>
              </p>
            </clause>
          </sections>
          <annex id='_' inline-header='false' obligation='normative'>
            <title>Annex</title>
            <p id='_'>
              <eref type='inline' bibitemid='ref1' citeas='IEEE 1619-2007'/>
            </p>
          </annex>
          <bibliography/>
        </ieee-standard>
      OUTPUT
      out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
      out.xpath("//xmlns:bibdata | //xmlns:boilerplate | //xmlns:references")
        .remove
      expect(xmlpp(strip_guid(out.to_xml)))
        .to be_equivalent_to xmlpp(output)
    end
  end
end
