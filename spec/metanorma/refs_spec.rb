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

        [bibliography]
        == Normative References

        * [[[ref1,ISO 639:1967]]] REF5
        * [[[ref2,RFC 7749]]] REF7
        * [[[ref3,REF4]]] REF4

        [[ref4]]
        [%bibitem]
        === Indiana Jones and the Last Crusade
        type:: book
        title::
          type::: main
          content::: Indiana Jones and the Last Crusade

        ==== Contributor
        organization::
          name::: International Organization for Standardization
          abbreviation::: ISO
        role::
          type::: publisher

        ==== Contributor
        person::
          name:::
            surname:::: Jones
            forename:::: Indiana

      INPUT
      out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
      expect(out.xpath("//xmlns:references/xmlns:bibitem/@id")
        .map(&:value)).to be_equivalent_to ["ref3", "ref1", "ref4", "ref2"]
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

  it "cites references" do
    VCR.use_cassette "multistandard2" do
      input = <<~INPUT
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib-cache:

        [[A]]
        == Clause

        <<ref1>>
        <<ref2>>
        <<ref3>>
        <<ref4>>
        <<ref5>>
        <<ref6>>

        [bibliography]
        == Normative References

        * [[[ref1,ISO 639:1967]]] REF5
        * [[[ref2,RFC 7749]]] REF7
        * [[[ref3,REF4]]] REF4

        [bibliography]
        == Bibliography

        * [[[ref4,ISO 639:1967]]] REF5
        * [[[ref5,RFC 7749]]] REF7
        * [[[ref6,3]]] REF4

      INPUT
      output = <<~OUTPUT
         <clause id='A' inline-header='false' obligation='normative'>
          <title>Clause</title>
          <p id='_'>
            <eref type='inline' bibitemid='ref1' citeas='ISO 639:1967'/>
            <eref type='inline' bibitemid='ref2' citeas='IETF RFC 7749'/>
            <eref type='inline' bibitemid='ref3' citeas='REF4'/>
            <eref type='inline' bibitemid='ref4' citeas='ISO 639:1967'/>
            <eref type='inline' bibitemid='ref5' citeas='IETF RFC 7749'/>
            <eref type='inline' bibitemid='ref6' citeas='[B1]'/>
          </p>
        </clause>
      OUTPUT
      out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
        .at("//xmlns:clause[@id = 'A']")
      expect(xmlpp(strip_guid(out.to_xml)))
        .to be_equivalent_to xmlpp(output)
    end
  end
end
