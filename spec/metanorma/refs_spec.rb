require "spec_helper"
require "relaton_iso"

RSpec.describe Metanorma::Ieee do
  it "sorts normative references" do
      input = <<~INPUT
        #{LOCAL_CACHED_ISOBIB_BLANK_HDR}

        [bibliography]
        == Normative References

        * [[[ref1,ISO 639:2023]]] REF5
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
      expect(out.xpath("//xmlns:references/xmlns:bibitem/@anchor")
        .map(&:value))
        .to be_equivalent_to ["ref2", "ref1", "ref4", "ref5", "ref3"]
  end

  it "sorts bibliography" do
      input = <<~INPUT
        #{LOCAL_CACHED_ISOBIB_BLANK_HDR}

        [bibliography]
        == Bibliography

        * [[[ref1,ISO 639:2023]]] REF5
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
      expect(out.xpath("//xmlns:references/xmlns:bibitem/@anchor")
        .map(&:value))
        .to be_equivalent_to ["ref2", "ref1", "ref4", "ref5", "ref3"]
  end

  it "numbers bibliography" do
      input = <<~INPUT
        #{LOCAL_CACHED_ISOBIB_BLANK_HDR}

        [bibliography]
        == Bibliography

        * [[[ref1,ISO 639:2023]]] REF5
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
            <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version='#{Metanorma::Ieee::VERSION}' flavor="ieee">
           <sections/>
          <bibliography>
             <references id="_" normative="false" obligation="informative">
                <title id="_">Bibliography</title>
                <p id="_">Bibliographical references are resources that provide additional or helpful material but do not need to be understood or used to implement this standard. Reference to these resources is made for informational use only.</p>
                <bibitem id="_" type="standard" anchor="ref2">
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
                   <series type="stream">
                      <title format="text/plain">IAB</title>
                   </series>
                   <keyword>XML</keyword>
                   <keyword>IETF</keyword>
                   <keyword>RFC</keyword>
                   <keyword>Internet-Draft</keyword>
                   <keyword>Vocabulary</keyword>
                </bibitem>
                <bibitem id="_" type="standard" anchor="ref1">
                   <title type="title-main" format="text/plain" language="en" script="Latn">Code for individual languages and language groups</title>
                   <title type="main" format="text/plain" language="en" script="Latn">Code for individual languages and language groups</title>
                   <uri type="src">https://www.iso.org/standard/74575.html</uri>
                   <uri type="obp">https://www.iso.org/obp/ui/en/#!iso:std:74575:en</uri>
                   <uri type="rss">https://www.iso.org/contents/data/standard/07/45/74575.detail.rss</uri>
                   <docidentifier type="ISO" primary="true">ISO 639:2023</docidentifier>
                   <docidentifier type="metanorma-ordinal">[B2]</docidentifier>
                   <docidentifier type="iso-reference">ISO 639:2023(E)</docidentifier>
                   <docidentifier type="URN">urn:iso:std:iso:639:stage-60.60</docidentifier>
                   <docnumber>639</docnumber>
                   <date type="published">
                      <on>2023-11</on>
                   </date>
                   <contributor>
                      <role type="publisher"/>
                      <organization>
                         <name>International Organization for Standardization</name>
                         <abbreviation>ISO</abbreviation>
                         <uri>www.iso.org</uri>
                      </organization>
                   </contributor>
                   <edition>2</edition>
                   <language>en</language>
                   <language>fr</language>
                   <script>Latn</script>
                   <abstract format="text/plain" language="en" script="Latn">This document specifies the ISO 639 language code and establishes the harmonized terminology and general principles of language coding. It provides rules for the selection, formation, presentation and use of language identifiers as well as language reference names. It also gives provisions (i.e. principles, rules and guidelines) for the selection, formation and presentation of language names in English and French. Furthermore, it introduces provisions for the adoption of standardized language code elements using language names other than English or French.
       NOTE            English, French and Russian are the official ISO languages.
       In addition, this document gives guidance on the use of language identifiers and describes their possible combination with identifiers of other codes.
       Specifically excluded from the ISO 639 language code are reconstructed languages or formal languages, such as computer programming languages and markup languages.
       The ISO 639 language code is maintained by the ISO 639 Maintenance Agency (ISO 639/MA) (see Annex B).</abstract>
                   <status>
                      <stage>60</stage>
                      <substage>60</substage>
                   </status>
                   <copyright>
                      <from>2023</from>
                      <owner>
                         <organization>
                            <name>ISO</name>
                         </organization>
                      </owner>
                   </copyright>
                   <relation type="obsoletes">
                      <bibitem type="standard">
                         <formattedref format="text/plain">ISO 639-1:2002</formattedref>
                         <docidentifier type="ISO" primary="true">ISO 639-1:2002</docidentifier>
                      </bibitem>
                   </relation>
                   <relation type="obsoletes">
                      <bibitem type="standard">
                         <formattedref format="text/plain">ISO 639-2:1998</formattedref>
                         <docidentifier type="ISO" primary="true">ISO 639-2:1998</docidentifier>
                      </bibitem>
                   </relation>
                   <relation type="obsoletes">
                      <bibitem type="standard">
                         <formattedref format="text/plain">ISO 639-3:2007</formattedref>
                         <docidentifier type="ISO" primary="true">ISO 639-3:2007</docidentifier>
                      </bibitem>
                   </relation>
                   <relation type="obsoletes">
                      <bibitem type="standard">
                         <formattedref format="text/plain">ISO 639-4:2010</formattedref>
                         <docidentifier type="ISO" primary="true">ISO 639-4:2010</docidentifier>
                      </bibitem>
                   </relation>
                   <relation type="obsoletes">
                      <bibitem type="standard">
                         <formattedref format="text/plain">ISO 639-5:2008</formattedref>
                         <docidentifier type="ISO" primary="true">ISO 639-5:2008</docidentifier>
                      </bibitem>
                   </relation>
                   <place>Geneva</place>
                </bibitem>
                <bibitem type="book" anchor="ref4" id="_">
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
                <bibitem anchor="ref3" id="_">
                   <formattedref format="application/x-isodoc+xml">REF4</formattedref>
                   <docidentifier>REF4</docidentifier>
                   <docidentifier type="metanorma-ordinal">[B4]</docidentifier>
                   <docnumber>4</docnumber>
                </bibitem>
             </references>
          </bibliography>
       </metanorma>
      OUTPUT
      out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
      out.xpath("//xmlns:bibdata | //xmlns:boilerplate | //xmlns:note | " \
                "//xmlns:metanorma-extension | //xmlns:fetched").remove
      expect(Xml::C14n.format(strip_guid(out.to_xml)))
        .to be_equivalent_to Xml::C14n.format(output)
  end

  it "inserts trademarks against IEEE citations" do
      input = <<~INPUT
        #{LOCAL_CACHED_ISOBIB_BLANK_HDR}

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

        * [[[ref2,ISO 639:2023]]] REF5
        * [[[ref1,IEEE Std 1619-2007]]] REF1
        * [[[ref3,IEEE 802.1D-1990]]] REF2
      INPUT
      output = <<~OUTPUT
          <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version='#{Metanorma::Ieee::VERSION}' flavor="ieee">
                   <preface>
            <introduction id='_' obligation='informative'>
              <title id="_">Introduction</title>
              <admonition id="_">This introduction is not part of P, Standard for Document title </admonition>
              <p id='_'>
                <eref type='inline' bibitemid='ref1' citeas='IEEE 1619™-2007'/>
              </p>
              <p id='_'>
                <eref type='inline' bibitemid='ref2' citeas='ISO&#xa0;639:2023'/>
              </p>
              <p id='_'>
                <eref type='inline' bibitemid='ref1' citeas='IEEE&#xa0;1619-2007'/>
              </p>
            </introduction>
          </preface>
          <sections>
            <clause id='_' type='overview' inline-header='false' obligation='normative'>
              <title id="_">Overview</title>
              <clause id='_' type='scope' inline-header='false' obligation='normative'>
                <title id="_">Scope</title>
                <p id='_'>
                  <eref type='inline' bibitemid='ref1' citeas='IEEE 1619™-2007'/>
                </p>
              <p id='_'><eref type='inline' bibitemid='ref3' citeas='IEEE 802.1D®-1990'/></p>
                <p id='_'>
                  <eref type='inline' bibitemid='ref2' citeas='ISO&#xa0;639:2023'/>
                </p>
                <p id='_'>
                  <eref type='inline' bibitemid='ref1' citeas='IEEE&#xa0;1619-2007'/>
                </p>
              </clause>
            </clause>
            <clause id='_' inline-header='false' obligation='normative'>
              <title id="_">Clause</title>
              <p id='_'>
                <eref type='inline' bibitemid='ref1' citeas='IEEE&#xa0;1619-2007'/>
              </p>
            </clause>
          </sections>
          <annex id='_' inline-header='false' obligation='normative'>
            <title id="_">Annex</title>
            <p id='_'>
              <eref type='inline' bibitemid='ref1' citeas='IEEE&#xa0;1619-2007'/>
            </p>
          </annex>
          <bibliography/>
        </metanorma>
      OUTPUT
      out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
      out.xpath("//xmlns:bibdata | //xmlns:boilerplate | " \
                "//xmlns:references | //xmlns:metanorma-extension | " \
                "//xmlns:clause[@anchor = 'boilerplate_word_usage']")
        .remove
      expect(Xml::C14n.format(strip_guid(out.to_xml)))
        .to be_equivalent_to Xml::C14n.format(output)
  end

  it "cites references" do
      input = <<~INPUT
        #{LOCAL_CACHED_ISOBIB_BLANK_HDR}

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

        * [[[ref1,ISO 639:2023]]] REF5
        * [[[ref2,RFC 7749]]] REF7
        * [[[ref3,REF4]]] REF4

        [bibliography]
        == Bibliography

        * [[[ref4,ISO 639:2023]]] REF5
        * [[[ref5,RFC 7749]]] REF7
        * [[[ref6,3]]] REF4
        * [[[ref7,ARBITRARY_ID]]] REF9

      INPUT
      output = <<~OUTPUT
         <clause id="_" anchor="A" inline-header='false' obligation='normative'>
          <title id="_">Clause</title>
          <p id='_'>
            <eref type='inline' bibitemid='ref1' citeas='ISO&#xa0;639:2023'/>
            <eref type='inline' bibitemid='ref2' citeas='IETF&#xa0;RFC&#xa0;7749'/>
            <eref type='inline' bibitemid='ref3' citeas='REF4'/>
            <eref type='inline' bibitemid='ref4' citeas='ISO&#xa0;639:2023'/>
            <eref type='inline' bibitemid='ref5' citeas='IETF&#xa0;RFC&#xa0;7749'/>
            <eref type='inline' bibitemid='ref6' citeas='[B3]'/>
            <eref type='inline' bibitemid='ref7' citeas='[B4]'/>
          </p>
        </clause>
      OUTPUT
      out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
        .at("//xmlns:clause[@anchor = 'A']")
      expect(Xml::C14n.format(strip_guid(out.to_xml)))
        .to be_equivalent_to Xml::C14n.format(output)
  end

  it "footnotes withdrawn IEEE references" do
      input = <<~INPUT
        #{LOCAL_CACHED_ISOBIB_BLANK_HDR}

        [bibliography]
        == Normative References

        * [[[ref1,IEEE Std 181-1977]]] REF5

        [bibliography]
        == Bibliography

        * [[[ref4,IEEE Std 194-1977]]] REF5
      INPUT
      output = <<~OUTPUT
         <bibliography>
          <references id="_" normative="true" obligation="informative">
            <title id="_">Normative references</title>
            <p id="_">The following referenced documents are indispensable for the application of this document (i.e., they must be understood and used, so each referenced document is cited in text and its relationship to this document is explained). For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments or corrigenda) applies.</p>
            <bibitem id="_" anchor="ref1" type="standard">
              <fetched/>
              <title type="main" format="text/plain">IEEE Standard on Pulse Measurement and Analysis by Objective Techniques</title>
              <uri type="src">https://ieeexplore.ieee.org/document/29013</uri>
              <docidentifier type="IEEE" primary="true">ANSI/IEEE 181-1977</docidentifier>
              <docidentifier type="IEEE" scope="trademark" primary="true">ANSI/IEEE 181™-1977</docidentifier>
              <docidentifier type="ISBN">0-7381-4176-3</docidentifier>
              <docidentifier type="DOI">10.1109/IEEESTD.1977.81097</docidentifier>
              <docnumber>ANSI/IEEE 181-1977</docnumber>
              <date type="created">
                <on>1977</on>
              </date>
              <date type="published">
                <on>2002-12-10</on>
              </date>
              <date type="issued">
                <on>1975-09-04</on>
              </date>
              <contributor>
                <role type="publisher"/>
                <organization>
                  <name>Institute of Electrical and Electronics Engineers</name>
                  <abbreviation>IEEE</abbreviation>
                  <uri>http://www.ieee.org</uri>
                  <address>
                    <city>New York</city>
                    <country>USA</country>
                  </address>
                </organization>
              </contributor>
              <note type="Availability">
                <p id="_">ANSI/IEEE 181-1977 has been withdrawn; however, copies can be obtained from Global Engineering, 15 Inverness Way East, Englewood, CO 80112-5704, USA, tel. (303) 792-2181 (http://global.ihs.com/).
               </p>
              </note>
              <language>en</language>
              <script>Latn</script>
              <status>
                <stage>withdrawn</stage>
              </status>
              <copyright>
                <from>1977</from>
                <owner>
                  <organization>
                    <name>Institute of Electrical and Electronics Engineers</name>
                    <abbreviation>IEEE</abbreviation>
                    <uri>http://www.ieee.org</uri>
                  </organization>
                </owner>
              </copyright>
              <keyword>Impulse testing</keyword>
              <keyword>Measurement standards</keyword>
            </bibitem>
          </references>
          <references id="_" normative="false" obligation="informative">
            <title id="_">Bibliography</title>
            <p id="_">Bibliographical references are resources that provide additional or helpful material but do not need to be understood or used to implement this standard. Reference to these resources is made for informational use only.</p>
            <bibitem id="_" anchor="ref4" type="standard">
              <fetched/>
              <title type="main" format="text/plain">IEEE Standard Pulse Terms and Definitions</title>
              <uri type="src">https://ieeexplore.ieee.org/document/29015</uri>
              <docidentifier type="IEEE" primary="true">IEEE 194-1977</docidentifier>
              <docidentifier type="metanorma-ordinal">[B1]</docidentifier>
              <docidentifier type="IEEE" scope="trademark" primary="true">IEEE 194™-1977</docidentifier>
              <docidentifier type="ISBN">0-7381-4350-2</docidentifier>
              <docidentifier type="DOI">10.1109/IEEESTD.1977.81098</docidentifier>
              <docnumber>IEEE 194-1977</docnumber>
              <date type="created">
                <on>1977</on>
              </date>
              <date type="published">
                <on>2002-12-10</on>
              </date>
              <date type="issued">
                <on>1975-02-17</on>
              </date>
              <contributor>
                <role type="publisher"/>
                <organization>
                  <name>Institute of Electrical and Electronics Engineers</name>
                  <abbreviation>IEEE</abbreviation>
                  <uri>http://www.ieee.org</uri>
                  <address>
                    <city>New York</city>
                    <country>USA</country>
                  </address>
                </organization>
              </contributor>
              <note type="Availability">
                <p id="_">IEEE 194-1977 has been withdrawn; however, copies can be obtained from Global Engineering, 15 Inverness Way East, Englewood, CO 80112-5704, USA, tel. (303) 792-2181 (http://global.ihs.com/).
        </p>
              </note>
              <language>en</language>
              <script>Latn</script>
              <status>
                <stage>withdrawn</stage>
              </status>
              <copyright>
                <from>1977</from>
                <owner>
                  <organization>
                    <name>Institute of Electrical and Electronics Engineers</name>
                    <abbreviation>IEEE</abbreviation>
                    <uri>http://www.ieee.org</uri>
                  </organization>
                </owner>
              </copyright>
              <keyword>Measurement standards</keyword>
              <keyword>Terminology</keyword>
              <keyword>Pulse circuits</keyword>
              <keyword>Pulse generation</keyword>
              <keyword>Standards</keyword>
            </bibitem>
          </references>
        </bibliography>
      OUTPUT
      out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
        .at("//xmlns:bibliography")
      out.xpath("//xmlns:abstract").each(&:remove)
      expect(Xml::C14n.format(strip_guid(out.to_xml)))
        .to be_equivalent_to Xml::C14n.format(output)
  end

  it "footnotes availability of references" do
      input = <<~INPUT
        #{LOCAL_CACHED_ISOBIB_BLANK_HDR}

        [bibliography]
        == Normative References

        * [[[ref1,ISO/IEC 27001]]] REF01
        * [[[ref2,ISO 10642]]] REF02
        * [[[ref3,IEC 61131-3]]] REF03
        * [[[ref4,ITU-T G.984.2]]] REF04
        * [[[ref5,ITU-R P.839]]] REF05
        * [[[ref6,IEEE Std 81-1983]]] REF06
        * [[[ref7,IEEE 43-2013 Redline]]] REF07
        * [[[ref8,FIPS 140-2]]] REF08
        * [[[ref9,NIST SP 800-171]]] REF09
        * [[[ref10,W3C XPTR]]] REF10
        * [[[ref11,ETSI GS NFV 002]]] REF11
        * [[[ref21,ISO/IEC 2382]]] REF12
        * [[[ref22,ISO 639]]] REF13
        * [[[ref23,IEC 60050]]] REF14
        * [[[ref24,ITU-T K.20]]] REF15
        * [[[ref25,ITU-R P.838]]] REF16
        * [[[ref26,IEEE Std 194-1977]]] REF17
        * [[[ref28,FIPS 140-3]]] REF18
        * [[[ref29,NIST SP 800-30]]] REF19
        * [[[ref30,W3C XML]]] REF20
        * [[[ref31,ETSI GS ZSM 012 V1.1.1]]] REF21
      INPUT
      output = <<~OUTPUT
       <bibliography>
          <references id="_" normative="true" obligation="informative">
             <title id="_">Normative references</title>
             <p id="_">The following referenced documents are indispensable for the application of this document (i.e., they must be understood and used, so each referenced document is cited in text and its relationship to this document is explained). For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments or corrigenda) applies.</p>
             <bibitem id="_" anchor="ref11">
                <docidentifier type="ETSI" primary="true">ETSI GS NFV 002 V1.2.1 (2014-12)</docidentifier>
                <note type="Availability">
                   <p id="_">ETSI publications are available the European Telecommunications Standards Institute (http://www.etsi.org).</p>
                </note>
             </bibitem>
             <bibitem id="_" anchor="ref31">
                <docidentifier type="ETSI" primary="true">ETSI GS ZSM 012 V1.1.1 (2022-12)</docidentifier>
             </bibitem>
             <bibitem id="_" anchor="ref23" type="standard">
                <docidentifier type="IEC" primary="true">IEC 60050</docidentifier>
                <docidentifier type="URN">urn:iec:std:iec:60050::::</docidentifier>
                <note type="Availability">
                   <p id="_">IEC publications are available from the International Electrotechnical Commission (http://www.iec.ch/). IEC publications are also available in the United States from the American National Standards Institute (http://www.ansi.org/).</p>
                </note>
             </bibitem>
             <bibitem id="_" anchor="ref3" type="standard">
                <docidentifier type="IEC" primary="true">IEC 61131-3</docidentifier>
                <docidentifier type="URN">urn:iec:std:iec:61131-3::::</docidentifier>
             </bibitem>
             <bibitem id="_" anchor="ref26" type="standard">
                <docidentifier type="IEEE" primary="true">IEEE 194-1977</docidentifier>
                <docidentifier type="IEEE" scope="trademark" primary="true">IEEE 194™-1977</docidentifier>
                <docidentifier type="ISBN">0-7381-4350-2</docidentifier>
                <docidentifier type="DOI">10.1109/IEEESTD.1977.81098</docidentifier>
                <note type="Availability">
                   <p id="_">IEEE 194-1977 has been withdrawn; however, copies can be obtained from Global Engineering, 15 Inverness Way East, Englewood, CO 80112-5704, USA, tel. (303) 792-2181 (http://global.ihs.com/).</p>
                </note>
             </bibitem>
             <bibitem id="_" anchor="ref7" type="standard">
                <docidentifier type="IEEE" primary="true">IEEE 43-2013 Redline</docidentifier>
                <docidentifier type="IEEE" scope="trademark" primary="true">IEEE 43™-2013 Redline</docidentifier>
                <docidentifier type="ISBN">978-0-7381-9093-8</docidentifier>
                <note type="Availability">
                   <p id="_">IEEE publications are available from The Institute of Electrical and Electronics Engineers (http://standards.ieee.org/).</p>
                </note>
             </bibitem>
             <bibitem id="_" anchor="ref6" type="standard">
                <docidentifier type="IEEE" primary="true">IEEE 81-1983</docidentifier>
                <docidentifier type="IEEE" scope="trademark" primary="true">IEEE 81™-1983</docidentifier>
                <docidentifier type="ISBN">978-0-7381-0660-1</docidentifier>
                <docidentifier type="DOI">10.1109/IEEESTD.1983.82378</docidentifier>
             </bibitem>
             <bibitem id="_" anchor="ref21" type="standard">
                <docidentifier type="ISO" primary="true">ISO/IEC 2382</docidentifier>
                <docidentifier type="iso-reference">ISO/IEC 2382(E)</docidentifier>
                <docidentifier type="URN">urn:iso:std:iso-iec:2382:stage-90.93</docidentifier>
                <note type="Availability">
                   <p id="_">ISO/IEC documents are available from the International Organization for Standardization (https://www.iso.org/). ISO/IEC publications are also available in the United States from Global Engineering Documents (https://global.ihs.com/). Electronic copies are available in the United States from the American National Standards Institute (https://www.ansi.org/)</p>
                </note>
             </bibitem>
             <bibitem id="_" anchor="ref1" type="standard">
                <docidentifier type="ISO" primary="true">ISO/IEC 27001</docidentifier>
                <docidentifier type="iso-reference">ISO/IEC 27001(E)</docidentifier>
                <docidentifier type="URN">urn:iso:std:iso-iec:27001:stage-60.60</docidentifier>
             </bibitem>
             <bibitem id="_" anchor="ref2" type="standard">
                <docidentifier type="ISO" primary="true">ISO 10642</docidentifier>
                <docidentifier type="iso-reference">ISO 10642(E)</docidentifier>
                <docidentifier type="URN">urn:iso:std:iso:10642:stage-90.92</docidentifier>
                <note type="Availability">
                   <p id="_">ISO publications are available from the ISO Central Secretariat (http://www.iso.org/). ISO publications are also available in the United States from the American National Standards Institute (http://www.ansi.org/).</p>
                </note>
             </bibitem>
             <bibitem id="_" anchor="ref22" type="standard">
                <docidentifier type="ISO" primary="true">ISO 639</docidentifier>
                <docidentifier type="iso-reference">ISO 639(E)</docidentifier>
                <docidentifier type="URN">urn:iso:std:iso:639:stage-60.60</docidentifier>
             </bibitem>
             <bibitem id="_" anchor="ref25" type="standard">
                <docidentifier type="ITU" primary="true">ITU-R P.838-3</docidentifier>
             </bibitem>
             <bibitem id="_" anchor="ref5" type="standard">
                <docidentifier type="ITU" primary="true">ITU-R P.839-4</docidentifier>
             </bibitem>
             <bibitem id="_" anchor="ref4" type="standard">
                <docidentifier type="ITU" primary="true">ITU-T G.984.2 (08/2019)</docidentifier>
                <note type="Availability">
                   <p id="_">ITU-T publications are available from the International Telecommunications Union (http://www.itu.int/).</p>
                </note>
             </bibitem>
             <bibitem id="_" anchor="ref24" type="standard">
                <docidentifier type="ITU" primary="true">ITU-T K.20 (11/2022)</docidentifier>
             </bibitem>
             <bibitem id="_" anchor="ref8" type="standard">
                <docidentifier type="NIST" primary="true">NIST FIPS 140-2 fpd</docidentifier>
                <note type="Availability">
                   <p id="_">NIST publications are available from the National Institute of Standards and Technology (http://www.nist.gov/).</p>
                </note>
             </bibitem>
             <bibitem id="_" anchor="ref28" type="standard">
                <docidentifier type="NIST" primary="true">NIST FIPS 140-3 2pd</docidentifier>
             </bibitem>
             <bibitem id="_" anchor="ref9" type="standard">
                <docidentifier type="NIST" primary="true">NIST SP 800-171 fpd</docidentifier>
                <note type="Availability">
                   <p id="_">FIPS publications are available from the National Technical Information Service (NTIS) (http://csrc.nist.gov).</p>
                </note>
             </bibitem>
             <bibitem id="_" anchor="ref29" type="standard">
                <docidentifier type="NIST" primary="true">NIST SP 800-30 fpd</docidentifier>
                <docidentifier type="DOI">NIST.SP.800-30</docidentifier>
             </bibitem>
             <bibitem id="_" anchor="ref30" type="standard">
                <docidentifier type="W3C" primary="true">W3C xml</docidentifier>
                <note type="Availability">
                   <p id="_">W3C recommendations are available from the World Wide Web Consortium (https://www.w3.org).</p>
                </note>
             </bibitem>
             <bibitem id="_" anchor="ref10" type="standard">
                <docidentifier type="W3C" primary="true">W3C xptr</docidentifier>
             </bibitem>
          </references>
       </bibliography>
      OUTPUT
      out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
        .at("//xmlns:bibliography")
      out.xpath("//xmlns:bibitem/*[local-name() != 'note' and local-name() != 'docidentifier']")
        .each(&:remove)
      expect(Xml::C14n.format(strip_guid(out.to_xml)))
        .to be_equivalent_to Xml::C14n.format(output)
  end

  it "removes ordinals from Normative references" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib-cache:

      == Clause

      <<ref1>>
      <<ref2>>
      <<ref3>>

      [bibliography]
      == Normative References

      * [[[ref1,1]]] Reference 1
      * [[[ref2,A]]] Reference 2

      [bibliography]
      == Bibliography

      * [[[ref3,2]]] Reference 2

    INPUT
    output = <<~OUTPUT
        #{blank_hdr_gen}
         <sections>
           <clause id="_" inline-header="false" obligation="normative">
             <title id="_">Clause</title>
             <p id="_">
               <eref type="inline" bibitemid="ref1" citeas="ref1"/>
               <eref type="inline" bibitemid="ref2" citeas="A"/>
               <eref type="inline" bibitemid="ref3" citeas="[B1]"/>
             </p>
           </clause>
         </sections>
         <bibliography>
           <references id="_" normative="true" obligation="informative">
             <title id="_">Normative references</title>
             <p id="_">The following referenced documents are indispensable for the application of this document (i.e., they must be understood and used, so each referenced document is cited in text and its relationship to this document is explained). For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments or corrigenda) applies.</p>
             <bibitem id="_" anchor="ref1">
               <formattedref format="application/x-isodoc+xml">Reference 1</formattedref>
             </bibitem>
             <bibitem id="_" anchor="ref2">
               <formattedref format="application/x-isodoc+xml">Reference 2</formattedref>
               <docidentifier>A</docidentifier>
             </bibitem>
           </references>
           <references id="_" normative="false" obligation="informative">
             <title id="_">Bibliography</title>
             <p id="_">Bibliographical references are resources that provide additional or helpful material but do not need to be understood or used to implement this standard. Reference to these resources is made for informational use only.</p>
             <bibitem id="_" anchor="ref3">
               <formattedref format="application/x-isodoc+xml">Reference 2</formattedref>
               <docidentifier type="metanorma">[B1]</docidentifier>
             </bibitem>
           </references>
         </bibliography>
      </metanorma>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end
end
