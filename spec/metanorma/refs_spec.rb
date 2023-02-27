require "spec_helper"

RSpec.describe Metanorma::IEEE do
  it "sorts normative references" do
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

        [[ref5]]
        [%bibitem]
        === “Indiana Jones and your Last Crusade”
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
        .map(&:value)).to be_equivalent_to ["ref2", "ref1", "ref4", "ref5",
                                            "ref3"]
    end
  end

  it "sorts bibliography" do
    VCR.use_cassette "multistandard" do
      input = <<~INPUT
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib-cache:

        [bibliography]
        == Bibliography

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

        [[ref5]]
        [%bibitem]
        === “Indiana Jones and your Last Crusade”
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
        .map(&:value)).to be_equivalent_to ["ref2", "ref1", "ref4", "ref5",
                                            "ref3"]
    end
  end

  it "numbers bibliography" do
    VCR.use_cassette "multistandard1", match_requests_on: %i[method uri body] do
      input = <<~INPUT
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib-cache:

        [bibliography]
        == Bibliography

        * [[[ref1,ISO 639]]] REF5
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
      output = <<~OUTPUT
          <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
           <sections> </sections>
                    <bibliography>
            <references id="_" normative="false" obligation="informative">
              <title>Bibliography</title>
              <p id="_">Bibliographical references are resources that provide additional or helpful material but do not need to be understood or used to implement this standard. Reference to these resources is made for informational use only.</p>
              <bibitem id="ref2" type="standard">
                <title type="main" format="text/plain">The “xml2rfc” Version 2 Vocabulary</title>
                <uri type="src">https://www.rfc-editor.org/info/rfc7749</uri>
                <docidentifier type="IETF" primary="true">RFC 7749</docidentifier>
                <docidentifier type="metanorma-ordinal">[B1]</docidentifier>
                <docidentifier type="DOI">10.17487/RFC7749</docidentifier>
                <docnumber>RFC7749</docnumber>
                <date type="published">
                  <on>2016-02</on>
                </date>
                <contributor>
                  <role type="author"/>
                  <person>
                    <name>
                      <completename language="en" script="Latn">J. Reschke</completename>
                    </name>
                  </person>
                </contributor>
                <contributor>
                  <role type="publisher"/>
                  <organization>
                    <name>RFC Publisher</name>
                  </organization>
                </contributor>
                <contributor>
                  <role type="authorizer"/>
                  <organization>
                    <name>RFC Series</name>
                  </organization>
                </contributor>
                <language>en</language>
                <script>Latn</script>
                <abstract format="text/html" language="en" script="Latn">
                  <p id="_">This document defines the “xml2rfc” version 2 vocabulary: an XML-based language used for writing RFCs and Internet-Drafts.</p>
                  <p id="_">Version 2 represents the state of the vocabulary (as implemented by several tools and as used by the RFC Editor) around 2014.</p>
                  <p id="_">This document obsoletes RFC 2629.</p>
                </abstract>
                <relation type="obsoletedBy">
                  <bibitem>
                    <formattedref format="text/plain">RFC7991</formattedref>
                    <docidentifier type="IETF" primary="true">RFC7991</docidentifier>
                  </bibitem>
                </relation>
                <series>
                  <title format="text/plain">RFC</title>
                  <number>7749</number>
                </series>
                <keyword>XML</keyword>
                <keyword>IETF</keyword>
                <keyword>RFC</keyword>
                <keyword>Internet-Draft</keyword>
                <keyword>Vocabulary</keyword>
              </bibitem>
              <bibitem id="ref1" type="standard">
                             <title type="title-main" format="text/plain" language="en" script="Latn">Code for the representation of names of languages</title>
                <title type="main" format="text/plain" language="en" script="Latn">Code for the representation of names of languages</title>
                <uri type="src">https://www.iso.org/standard/4766.html</uri>
                <uri type="rss">https://www.iso.org/contents/data/standard/00/47/4766.detail.rss</uri>
                <docidentifier type="ISO" primary="true">ISO 639</docidentifier>
                <docidentifier type="metanorma-ordinal">[B2]</docidentifier>
                <docidentifier type="URN">urn:iso:std:iso:639:stage-95.99:ed-1</docidentifier>
                <docnumber>639</docnumber>
                <contributor>
                  <role type="publisher"/>
                  <organization>
                    <name>International Organization for Standardization</name>
                    <abbreviation>ISO</abbreviation>
                    <uri>www.iso.org</uri>
                  </organization>
                </contributor>
                <edition>1</edition>
                <language>en</language>
                <script>Latn</script>
                <status>
                  <stage>95</stage>
                  <substage>99</substage>
                </status>
                <copyright>
                  <from>1988</from>
                  <owner>
                    <organization>
                      <name>ISO</name>
                    </organization>
                  </owner>
                </copyright>
                <relation type="updates">
                  <bibitem type="standard">
                    <formattedref format="text/plain">ISO 639-1:2002</formattedref>
                    <docidentifier type="ISO" primary="true">ISO 639-1:2002</docidentifier>
                    <date type="circulated">
                      <on>2002-07-18</on>
                    </date>
                  </bibitem>
                </relation>
                <relation type="instance">
                  <bibitem type="standard">
                    <title type="title-main" format="text/plain" language="en" script="Latn">Code for the representation of names of languages</title>
                    <title type="main" format="text/plain" language="en" script="Latn">Code for the representation of names of languages</title>
                    <uri type="src">https://www.iso.org/standard/4766.html</uri>
                    <uri type="rss">https://www.iso.org/contents/data/standard/00/47/4766.detail.rss</uri>
                    <docidentifier type="ISO" primary="true">ISO 639:1988</docidentifier>
                    <docidentifier type="URN">urn:iso:std:iso:639:stage-95.99:ed-1</docidentifier>
                    <docnumber>639</docnumber>
                    <date type="published">
                      <on>1988-03</on>
                    </date>
                    <contributor>
                      <role type="publisher"/>
                      <organization>
                        <name>International Organization for Standardization</name>
                        <abbreviation>ISO</abbreviation>
                        <uri>www.iso.org</uri>
                      </organization>
                    </contributor>
                    <edition>1</edition>
                    <language>en</language>
                    <script>Latn</script>
                    <abstract format="text/plain" language="en" script="Latn">Gives a two-letter lower-case code. The symbols were devised primarily for use in terminology, lexicography and linguistic, but they may be used for any application. It also includes guidance on the use of language symbols in some of these applications. The annex includes a classified list of languages and their symbols arranged by families.</abstract>
                    <status>
                      <stage>95</stage>
                      <substage>99</substage>
                    </status>
                    <copyright>
                      <from>1988</from>
                      <owner>
                        <organization>
                          <name>ISO</name>
                        </organization>
                      </owner>
                    </copyright>
                    <relation type="updates">
                      <bibitem type="standard">
                        <formattedref format="text/plain">ISO 639-1:2002</formattedref>
                        <docidentifier type="ISO" primary="true">ISO 639-1:2002</docidentifier>
                        <date type="circulated">
                          <on>2002-07-18</on>
                        </date>
                      </bibitem>
                    </relation>
                    <place>Geneva</place>
                  </bibitem>
                </relation>
                <place>Geneva</place>
              </bibitem>
              <bibitem type="book" id="ref4">
                <title type="main" format="text/plain">Indiana Jones and the Last Crusade</title>
                <title type="title-main" format="text/plain">Indiana Jones and the Last Crusade</title>
                <title type="main" format="text/plain">Indiana Jones and the Last Crusade</title>
                <docidentifier type="metanorma-ordinal">[B3]</docidentifier>
                <contributor>
                  <role type="publisher"/>
                  <organization>
                    <name>International Organization for Standardization</name>
                    <abbreviation>ISO</abbreviation>
                  </organization>
                </contributor>
                <contributor>
                  <role type="author"/>
                  <person>
                    <name>
                      <forename>Indiana</forename>
                      <surname>Jones</surname>
                    </name>
                  </person>
                </contributor>
              </bibitem>
              <bibitem id="ref3">
                <formattedref format="application/x-isodoc+xml">REF4</formattedref>
                <docidentifier>REF4</docidentifier>
                <docidentifier type="metanorma-ordinal">[B4]</docidentifier>
                <docnumber>4</docnumber>
              </bibitem>
            </references>
          </bibliography>
        </ieee-standard>
      OUTPUT
      out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
      out.xpath("//xmlns:bibdata | //xmlns:boilerplate | " \
                "//xmlns:metanorma-extension | //xmlns:fetched").remove
      expect(xmlpp(strip_guid(out.to_xml)))
        .to be_equivalent_to xmlpp(output)
    end
  end

  it "inserts trademarks against IEEE citations" do
    VCR.use_cassette "ieee-multi", match_requests_on: %i[method uri body] do
      input = <<~INPUT
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib-cache:

        == Introduction

        <<ref1>>

        <<ref2>>

        <<ref1>>

        == Overview

        === Scope

        <<ref1>>

        <<ref3>>

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
        * [[[ref3,IEEE 802.1D-1990]]] REF2
      INPUT
      output = <<~OUTPUT
          <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
                   <preface>
            <introduction id='_' obligation='informative'>
              <title>Introduction</title>
              <admonition>This introduction is not part of P, Standard for Document title </admonition>
              <p id='_'>
                <eref type='inline' bibitemid='ref1' citeas='IEEE 1619™-2007'/>
              </p>
              <p id='_'>
                <eref type='inline' bibitemid='ref2' citeas='ISO&#xa0;639:1967'/>
              </p>
              <p id='_'>
                <eref type='inline' bibitemid='ref1' citeas='IEEE&#xa0;1619-2007'/>
              </p>
            </introduction>
          </preface>
          <sections>
            <clause id='_' type='overview' inline-header='false' obligation='normative'>
              <title>Overview</title>
              <clause id='_' type='scope' inline-header='false' obligation='normative'>
                <title>Scope</title>
                <p id='_'>
                  <eref type='inline' bibitemid='ref1' citeas='IEEE 1619™-2007'/>
                </p>
              <p id='_'><eref type='inline' bibitemid='ref3' citeas='IEEE 802.1D®-1990'/></p>
                <p id='_'>
                  <eref type='inline' bibitemid='ref2' citeas='ISO&#xa0;639:1967'/>
                </p>
                <p id='_'>
                  <eref type='inline' bibitemid='ref1' citeas='IEEE&#xa0;1619-2007'/>
                </p>
              </clause>
            </clause>
            <clause id='_' inline-header='false' obligation='normative'>
              <title>Clause</title>
              <p id='_'>
                <eref type='inline' bibitemid='ref1' citeas='IEEE&#xa0;1619-2007'/>
              </p>
            </clause>
          </sections>
          <annex id='_' inline-header='false' obligation='normative'>
            <title>Annex</title>
            <p id='_'>
              <eref type='inline' bibitemid='ref1' citeas='IEEE&#xa0;1619-2007'/>
            </p>
          </annex>
          <bibliography/>
        </ieee-standard>
      OUTPUT
      out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
      out.xpath("//xmlns:bibdata | //xmlns:boilerplate | " \
                "//xmlns:references | //xmlns:metanorma-extension | " \
                "//xmlns:clause[@id = 'boilerplate_word_usage']")
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
        <<ref7>>

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
        * [[[ref7,ARBITRARY_ID]]] REF9

      INPUT
      output = <<~OUTPUT
         <clause id='A' inline-header='false' obligation='normative'>
          <title>Clause</title>
          <p id='_'>
            <eref type='inline' bibitemid='ref1' citeas='ISO&#xa0;639:1967'/>
            <eref type='inline' bibitemid='ref2' citeas='IETF&#xa0;RFC&#xa0;7749'/>
            <eref type='inline' bibitemid='ref3' citeas='REF4'/>
            <eref type='inline' bibitemid='ref4' citeas='ISO&#xa0;639:1967'/>
            <eref type='inline' bibitemid='ref5' citeas='IETF&#xa0;RFC&#xa0;7749'/>
            <eref type='inline' bibitemid='ref6' citeas='[B1]'/>
            <eref type='inline' bibitemid='ref7' citeas='[B2]'/>
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
