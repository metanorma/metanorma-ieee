require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::Ieee do
  before(:all) do
    @blank_hdr = blank_hdr_gen
  end

  it "has a version number" do
    expect(Metanorma::Ieee::VERSION).not_to be nil
  end

  it "processes a blank document" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}
    INPUT
    output = <<~OUTPUT
      #{@blank_hdr}
      <sections/>
      </metanorma>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "converts a blank document" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
    INPUT
    output = <<~OUTPUT
        #{@blank_hdr}
        <sections/>
      </metanorma>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Canon.format_xml(output)
    expect(File.exist?("test.html")).to be true
  end

  it "processes default metadata" do
    output = Nokogiri::XML(Asciidoctor.convert(<<~INPUT, *OPTIONS))
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :no-isobib:
      :docnumber: 1000
      :partnumber: 1
      :edition: 2
      :revdate: 2000-01-01
      :draft: 0.3.4
      :committee: TC
      :technical-committee-number: 1
      :technical-committee-type: A
      :balloting-group: SC
      :balloting-group-type: entity
      :subcommittee-number: 2
      :subcommittee-type: B
      :working-group: WG
      :workgroup-number: 3
      :workgroup-type: C
      :committee_2: TC1
      :technical-committee-number_2: 11
      :technical-committee-type_2: A1
      :subcommittee_2: SC1
      :subcommittee-number_2: 21
      :subcommittee-type_2: B1
      :working-group_2: WG1
      :workgroup-number_2: 31
      :workgroup-type_2: C1
      :society: SECRETARIAT
      :docstage: inactive
      :iteration: 3
      :language: en
      :title-intro-en: Introduction
      :title-main-en: Main Title -- Title
      :title-part-en: Title Part
      :title-intro-fr: Introduction Française
      :title-main-fr: Titre Principal
      :title-part-fr: Part du Titre
      :library-ics: 01.040.11,11.060.01
      :copyright-year: 2000
      :horizontal: true
      :confirmed-date: 1000-12-01
      :updated-date: 2023-12-01
      :issued-date: 1001-12-01
      :obsoleted-date: 1002-12-01
      :feedback-ended-date: 1003-12-01
      :ieee-sasb-approved-date: 1004-12-01
      :wg-chair: span:surname[A] span:forename[B]
      :wg-vicechair: CD
      :wg-secretary: CD1
      :wg-members: span:surname[E], span:forename[F], Jr.; GH; IJ
      :wg-org-members: Alibaba, Inc.; Alphabet, Ltd.
      :balloting-group-members: KL; MN
      :std-board-chair: OP
      :std-board-vicechair: QR
      :std-board-pastchair: span:surname[S] span:forename[T]
      :std-board-secretary: UV
      :std-board-members: WX; YZ
      :isbn-pdf: ABC
      :isbn-print: DEF
      :stdid-pdf: GHI
      :stdid-print: JKL
      :updates: ABC
      :merges: BCD; EFG
      :doctype: recommended-practice
      :docsubtype: amendment
      :trial-use: true
      :amendment-number: A1
      :corrigendum-number: C1
      :program: HIJ
    INPUT
    output.at("//xmlns:note")&.remove
    output = output.at("//xmlns:bibdata")
    expect(Canon.format_xml(output.to_xml))
      .to be_equivalent_to Canon.format_xml(<<~OUTPUT)
      <bibdata type="standard">
         <title language="en" format="text/plain">Document title</title>
         <title type="provenance" language="en" format="application/xml">Revision of ABC<br/>Incorporates BCD and EFG</title>
         <title language="intro-en" format="text/plain">Introduction</title>
         <title language="main-en" format="text/plain">Main Title -- Title</title>
         <title language="part-en" format="text/plain">Title Part</title>
         <title language="intro-fr" format="text/plain">Introduction Française</title>
         <title language="main-fr" format="text/plain">Titre Principal</title>
         <title language="part-fr" format="text/plain">Part du Titre</title>
         <docidentifier type="IEEE" primary="true">IEEE Std 10001-2000/Cor C1-2000</docidentifier>
         <docidentifier type="IEEE" scope="PDF">GHI</docidentifier>
         <docidentifier type="IEEE" scope="print">JKL</docidentifier>
         <docidentifier type="ISBN" scope="PDF">ABC</docidentifier>
         <docidentifier type="ISBN" scope="print">DEF</docidentifier>
         <docnumber>1000</docnumber>
         <date type="obsoleted">
           <on>1002-12-01</on>
         </date>
         <date type="confirmed">
           <on>1000-12-01</on>
         </date>
         <date type="updated">
           <on>2023-12-01</on>
         </date>
         <date type="issued">
           <on>1001-12-01</on>
         </date>
         <date type="feedback-ended">
           <on>1003-12-01</on>
         </date>
         <date type="ieee-sasb-approved">
          <on>1004-12-01</on>
          </date>
         <contributor>
           <role type="author"/>
           <organization>
             <name>Institute of Electrical and Electronic Engineers</name>
             <abbreviation>IEEE</abbreviation>
           </organization>
         </contributor>
         <contributor>
           <role type="publisher"/>
           <organization>
             <name>Institute of Electrical and Electronic Engineers</name>
             <abbreviation>IEEE</abbreviation>
           </organization>
         </contributor>
         <edition>2</edition>
         <version>
           <revision-date>2000-01-01</revision-date>
           <draft>0.3.4</draft>
         </version>
         <language>en</language>
         <script>Latn</script>
         <status>
           <stage>inactive</stage>
         </status>
         <copyright>
           <from>2000</from>
           <owner>
             <organization>
               <name>Institute of Electrical and Electronic Engineers</name>
               <abbreviation>IEEE</abbreviation>
             </organization>
           </owner>
         </copyright>
         <relation type="merges">
           <bibitem>
             <title>--</title>
             <docidentifier>BCD</docidentifier>
           </bibitem>
         </relation>
         <relation type="merges">
           <bibitem>
             <title>--</title>
             <docidentifier>EFG</docidentifier>
           </bibitem>
         </relation>
         <relation type="updates">
           <bibitem>
             <title>--</title>
             <docidentifier>ABC</docidentifier>
           </bibitem>
         </relation>
         <ext>
           <doctype>recommended-practice</doctype>
           <subdoctype>amendment</subdoctype>
           <flavor>ieee</flavor>
           <trial-use>true</trial-use>
           <editorialgroup>
             <society>SECRETARIAT</society>
             <balloting-group type="entity">SC</balloting-group>
             <working-group>WG</working-group>
             <working-group>WG1</working-group>
             <committee>TC</committee>
             <committee>TC1</committee>
           </editorialgroup>
           <ics>
             <code>01.040.11</code>
             <text>Health care technology (Vocabularies)</text>
           </ics>
           <ics>
             <code>11.060.01</code>
             <text>Dentistry in general</text>
           </ics>
           <structuredidentifier>
             <docnumber>1000</docnumber>
             <agency>IEEE</agency>
             <class>recommended-practice</class>
             <edition>2</edition>
             <version>0.3.4</version>
             <amendment>A1</amendment>
             <corrigendum>C1</corrigendum>
             <year>2000</year>
           </structuredidentifier>
           <program>HIJ</program>
         </ext>
       </bibdata>
      OUTPUT
  end

  it "processes metadata with draft, no docstage, no balloting-group-type, docidentifier override" do
    out = Nokogiri::XML(Asciidoctor.convert(<<~INPUT, *OPTIONS))
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :no-isobib:
      :draft: 3
      :balloting-group: BG
      :society: SECRETARIAT
      :docidentifier: OVERRIDE
      :docnumber: 1000

    INPUT
    output = <<~OUTPUT
             <bibdata type="standard">
        <title language="en" format="text/plain">Document title</title>
        <docidentifier primary="true" type="IEEE">OVERRIDE</docidentifier>
        <docnumber>1000</docnumber>
                   <contributor>
             <role type="author"/>
             <organization>
               <name>Institute of Electrical and Electronic Engineers</name>
               <abbreviation>IEEE</abbreviation>
             </organization>
           </contributor>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>Institute of Electrical and Electronic Engineers</name>
            <abbreviation>IEEE</abbreviation>
          </organization>
        </contributor>
        <version>
          <draft>3</draft>
        </version>
        <language>en</language>
        <script>Latn</script>
        <status>
          <stage>draft</stage>
        </status>
        <copyright>
          <from>#{Date.today.year}</from>
          <owner>
            <organization>
              <name>Institute of Electrical and Electronic Engineers</name>
              <abbreviation>IEEE</abbreviation>
            </organization>
          </owner>
        </copyright>
        <ext>
          <doctype>standard</doctype>
          <subdoctype>document</subdoctype>
           <flavor>ieee</flavor>
          <editorialgroup>
            <society>SECRETARIAT</society>
            <balloting-group type="individual">BG</balloting-group>
          </editorialgroup>
          <structuredidentifier>
            <docnumber>1000</docnumber>
            <agency>IEEE</agency>
            <class>standard</class>
            <version>3</version>
          </structuredidentifier>
        </ext>
      </bibdata>
    OUTPUT
    out = out.at("//xmlns:bibdata")
    expect(Canon.format_xml(out.to_xml))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "processes metadata with no draft, no docstage" do
    out = Nokogiri::XML(Asciidoctor.convert(<<~INPUT, *OPTIONS))
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :no-isobib:

    INPUT
    output = <<~OUTPUT
      <bibdata type='standard'>
        <title language='en' format='text/plain'>Document title</title>
                   <contributor>
             <role type="author"/>
             <organization>
               <name>Institute of Electrical and Electronic Engineers</name>
               <abbreviation>IEEE</abbreviation>
             </organization>
           </contributor>
        <contributor>
          <role type='publisher'/>
          <organization>
            <name>Institute of Electrical and Electronic Engineers</name>
            <abbreviation>IEEE</abbreviation>
          </organization>
        </contributor>
        <language>en</language>
        <script>Latn</script>
        <status>
          <stage>approved</stage>
        </status>
        <copyright>
          <from>#{Date.today.year}</from>
          <owner>
            <organization>
              <name>Institute of Electrical and Electronic Engineers</name>
              <abbreviation>IEEE</abbreviation>
            </organization>
          </owner>
        </copyright>
        <ext>
          <doctype>standard</doctype>
          <subdoctype>document</subdoctype>
           <flavor>ieee</flavor>
        </ext>
      </bibdata>
    OUTPUT
    out = out.at("//xmlns:bibdata")
    expect(Canon.format_xml(out.to_xml))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "processes metadata for industry-connection-report white paper" do
    out = Nokogiri::XML(Asciidoctor.convert(<<~INPUT, *OPTIONS))
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :no-isobib:
      :docsubtype: industry-connection-report
      :doctype: whitepaper

    INPUT
    output = <<~OUTPUT
      <bibdata type='standard'>
        <title language='en' format='text/plain'>Document title</title>
                   <contributor>
             <role type="author"/>
             <organization>
               <name>Institute of Electrical and Electronic Engineers</name>
               <abbreviation>IEEE</abbreviation>
             </organization>
           </contributor>
        <contributor>
          <role type='publisher'/>
          <organization>
            <name>Institute of Electrical and Electronic Engineers</name>
            <abbreviation>IEEE</abbreviation>
          </organization>
        </contributor>
        <language>en</language>
        <script>Latn</script>
        <status>
          <stage>approved</stage>
        </status>
        <copyright>
          <from>#{Date.today.year}</from>
          <owner>
            <organization>
              <name>Institute of Electrical and Electronic Engineers</name>
              <abbreviation>IEEE</abbreviation>
            </organization>
          </owner>
        </copyright>
        <ext>
           <doctype>whitepaper</doctype>
           <subdoctype>industry-connection-report</subdoctype>
           <flavor>ieee</flavor>
           <editorialgroup>
             <working-group>IEEE SA Industry Connections activity</working-group>
           </editorialgroup>
         </ext>
       </bibdata>
    OUTPUT
    out = out.at("//xmlns:bibdata")
    expect(Canon.format_xml(out.to_xml))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "processes sections" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}
      .Foreword

      Text

      [abstract]
      == Abstract

      Text

      == Participants

      === Working Group

      == Introduction

      === Introduction Subsection

      == Acknowledgements

      [.preface]
      == Dedication

      == Overview

      Text

      === Scope

      Text

      === Purpose

      Text

      [bibliography]
      == Normative References

      == Definitions

      [.boilerplate]
      === Boilerplate

      Boilerplate text

      === Term1

      == Terms, Definitions, Symbols and Abbreviated Terms

      [.nonterm]
      === Introduction

      ==== Intro 1

      === Intro 2

      [.nonterm]
      ==== Intro 3

      === Intro 4

      ==== Intro 5

      ===== Term1

      === Normal Terms

      ==== Term2

      === Acronyms and abbreviations

      [.nonterm]
      ==== General

      ==== Symbols

      == Abbreviated Terms
      == Clause 4

      === Introduction

      === Clause 4.2

      == Terms and Definitions

      [appendix,normative=true]
      == Annex

      === Annex A.1

      [appendix,normative=false]
      == Bibliography

      [bibliography]
      === Bibliography

      [index]
      == Index

      This is an index

      [index,type=thematic]
      == Thematic Index
    INPUT
    output = <<~OUTPUT
            #{@blank_hdr.sub(%r{</script>}, '</script><abstract><p>Text</p></abstract>').sub(%r{<boilerplate>.*</boilerplate>}m, '')}
          <preface>
             <abstract id="_">
                <title id="_">Abstract</title>
                <p id="_">Text</p>
             </abstract>
             <foreword id="_" obligation="informative">
                <title id="_">Foreword</title>
                <p id="_">Text</p>
             </foreword>
             <introduction id="_" obligation="informative">
                <title id="_">Introduction</title>
                <admonition id="_">This introduction is not part of P, Standard for Document title</admonition>
                <clause id="_" inline-header="false" obligation="informative">
                   <title id="_">Introduction Subsection</title>
                </clause>
             </introduction>
             <clause id="_" inline-header="false" obligation="informative">
                <title id="_">Dedication</title>
             </clause>
             <acknowledgements id="_" obligation="informative">
                <title id="_">Acknowledgements</title>
             </acknowledgements>
          </preface>
          <sections>
             <clause id="_" type="overview" inline-header="false" obligation="normative">
                <title id="_">Overview</title>
                <p id="_">Text</p>
                <clause id="_" type="scope" inline-header="false" obligation="normative">
                   <title id="_">Scope</title>
                   <p id="_">Text</p>
                </clause>
                <clause id="_" type="purpose" inline-header="false" obligation="normative">
                   <title id="_">Purpose</title>
                   <p id="_">Text</p>
                </clause>
                <clause id="_" anchor="boilerplate_word_usage" inline-header="false" obligation="normative">
                   <title id="_">Word usage</title>
                   <p id="_">
                      The word
                      <em>shall</em>
                      indicates mandatory requirements strictly to be followed in order to conform to the standard and from which no deviation is permitted (
                      <em>shall</em>
                      equals
                      <em>is required to</em>
                      ).
                      <fn id="_" reference="6">
                         <p id="_">
                            The use of the word
                            <em>must</em>
                            is deprecated and cannot be used when stating mandatory requirements;
                            <em>must</em>
                            is used only to describe unavoidable situations.
                         </p>
                      </fn>
                      <fn id="_" reference="7">
                         <p id="_">
                            The use of
                            <em>will</em>
                            is deprecated and cannot be used when stating mandatory requirements;
                            <em>will</em>
                            is only used in statements of fact.
                         </p>
                      </fn>
                   </p>
                   <p id="_">
                      The word
                      <em>should</em>
                      indicates that among several possibilities one is recommended as particularly suitable, without mentioning or excluding others; or that a certain course of action is preferred but not necessarily required (
                      <em>should</em>
                      equals
                      <em>is recommended that</em>
                      ).
                   </p>
                   <p id="_">
                      The word
                      <em>may</em>
                      is used to indicate a course of action permissible within the limits of the standard (
                      <em>may</em>
                      equals
                      <em>is permitted to</em>
                      ).
                   </p>
                   <p id="_">
                      The word
                      <em>can</em>
                      is used for statements of possibility and capability, whether material, physical, or causal (
                      <em>can</em>
                      equals
                      <em>is able to</em>
                      ).
                   </p>
                </clause>
             </clause>
             <terms id="_" obligation="normative">
                <title id="_">Definitions</title>
                <p id="_">Boilerplate text</p>
                <term id="_" anchor="term-Term1">
                   <preferred>
                      <expression>
                         <name>Term1</name>
                      </expression>
                   </preferred>
                </term>
             </terms>
             <clause id="_" obligation="normative" type="terms">
                <title id="_">Definitions, acronyms and abbreviations</title>
                <clause id="_" inline-header="false" obligation="normative">
                   <title id="_">Introduction</title>
                   <clause id="_" inline-header="false" obligation="normative">
                      <title id="_">Intro 1</title>
                   </clause>
                </clause>
                <terms id="_" obligation="normative">
                   <title id="_">Intro 2</title>
                   <clause id="_" inline-header="false" obligation="normative">
                      <title id="_">Intro 3</title>
                   </clause>
                </terms>
                <clause id="_" obligation="normative" type="terms">
                   <title id="_">Intro 4</title>
                   <terms id="_" obligation="normative">
                      <title id="_">Intro 5</title>
                      <term id="_" anchor="term-Term1-1">
                         <preferred>
                            <expression>
                               <name>Term1</name>
                            </expression>
                         </preferred>
                      </term>
                   </terms>
                </clause>
                <terms id="_" obligation="normative">
                   <title id="_">Normal Terms</title>
                   <term id="_" anchor="term-Term2">
                      <preferred>
                         <expression>
                            <name>Term2</name>
                         </expression>
                      </preferred>
                   </term>
                </terms>
                <definitions id="_" obligation="normative">
                   <title id="_">Acronyms and abbreviations</title>
                   <clause id="_" inline-header="false" obligation="normative">
                      <title id="_">General</title>
                   </clause>
                   <definitions id="_" type="symbols" obligation="normative">
                      <title id="_">Acronyms and abbreviations</title>
                   </definitions>
                </definitions>
             </clause>
             <definitions id="_" type="abbreviated_terms" obligation="normative">
                <title id="_">Acronyms and abbreviations</title>
             </definitions>
             <clause id="_" inline-header="false" obligation="normative">
                <title id="_">Clause 4</title>
                <clause id="_" inline-header="false" obligation="normative">
                   <title id="_">Introduction</title>
                </clause>
                <clause id="_" inline-header="false" obligation="normative">
                   <title id="_">Clause 4.2</title>
                </clause>
             </clause>
             <terms id="_" obligation="normative">
                <title id="_">Terms and Definitions</title>
             </terms>
          </sections>
          <annex id="_" inline-header="false" obligation="normative">
             <title id="_">Annex</title>
             <clause id="_" inline-header="false" obligation="normative">
                <title id="_">Annex A.1</title>
             </clause>
          </annex>
          <annex id="_" obligation="" language="" script="">
             <title id="_">Bibliography</title>
             <references id="_" normative="false" obligation="informative">
                <title id="_">Bibliography</title>
                <p id="_">Bibliographical references are resources that provide additional or helpful material but do not need to be understood or used to implement this standard. Reference to these resources is made for informational use only.</p>
             </references>
          </annex>
          <bibliography>
             <references id="_" normative="true" obligation="informative">
                <title id="_">Normative references</title>
                <p id="_">There are no normative references in this document.</p>
             </references>
          </bibliography>
          <indexsect id="_">
             <title id="_">Index</title>
             <p id="_">This is an index</p>
          </indexsect>
          <indexsect id="_" type="thematic">
             <title id="_">Thematic Index</title>
          </indexsect>
       </metanorma>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS)
      .sub(%r{<boilerplate>.*</boilerplate>}m, ""))))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "processes sections, white paper" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR.sub(':nodoc:', ":doctype: whitepaper\n:nodoc:")}
      .Foreword

      Text

      [abstract]
      == Abstract

      Text

      == Participants

      === Working Group

      == Introduction

      === Introduction Subsection

      == Acknowledgements

      [.preface]
      == Dedication

      == Overview

      Text

      === Scope

      Text

      === Purpose

      Text

      [bibliography]
      == Normative References

      == Definitions

      [.boilerplate]
      === Boilerplate

      Boilerplate text

      === Term1

      == Terms, Definitions, Symbols and Abbreviated Terms

      [.nonterm]
      === Introduction

      ==== Intro 1

      === Intro 2

      [.nonterm]
      ==== Intro 3

      === Intro 4

      ==== Intro 5

      ===== Term1

      === Normal Terms

      ==== Term2

      === Acronyms and abbreviations

      [.nonterm]
      ==== General

      ==== Symbols

      == Abbreviated Terms
      == Clause 4

      === Introduction

      === Clause 4.2

      == Terms and Definitions

      [appendix,normative=true]
      == Annex

      === Annex A.1

      [appendix,normative=false]
      == Bibliography

      [bibliography]
      === Bibliography

      [index]
      == Index

      This is an index

      [index,type=thematic]
      == Thematic Index
    INPUT
    output = <<~OUTPUT
            #{@blank_hdr.sub('<doctype>standard</doctype>', ' <doctype>whitepaper</doctype>').sub(%r{</script>}, '</script><abstract><p>Text</p></abstract>').sub(%r{<boilerplate>.*</boilerplate>}m, '')}
          <preface>
             <abstract id="_">
                <title id="_">Abstract</title>
                <p id="_">Text</p>
             </abstract>
             <foreword id="_" obligation="informative">
                <title id="_">Foreword</title>
                <p id="_">Text</p>
             </foreword>
             <introduction id="_" obligation="informative">
                <title id="_">Introduction</title>
                <admonition id="_">This introduction is not part of P, Whitepaper for Document title</admonition>
                <clause id="_" inline-header="false" obligation="informative">
                   <title id="_">Introduction Subsection</title>
                </clause>
             </introduction>
             <clause id="_" inline-header="false" obligation="informative">
                <title id="_">Dedication</title>
             </clause>
             <acknowledgements id="_" obligation="informative">
                <title id="_">Acknowledgements</title>
             </acknowledgements>
          </preface>
          <sections>
             <clause id="_" type="overview" inline-header="false" obligation="normative">
                <title id="_">Overview</title>
                <p id="_">Text</p>
                <clause id="_" type="scope" inline-header="false" obligation="normative">
                   <title id="_">Scope</title>
                   <p id="_">Text</p>
                </clause>
                <clause id="_" type="purpose" inline-header="false" obligation="normative">
                   <title id="_">Purpose</title>
                   <p id="_">Text</p>
                </clause>
             </clause>
             <terms id="_" obligation="normative">
                <title id="_">Definitions</title>
                <p id="_">Boilerplate text</p>
                <term id="_" anchor="term-Term1">
                   <preferred>
                      <expression>
                         <name>Term1</name>
                      </expression>
                   </preferred>
                </term>
             </terms>
             <clause id="_" obligation="normative" type="terms">
                <title id="_">Definitions, acronyms and abbreviations</title>
                <clause id="_" inline-header="false" obligation="normative">
                   <title id="_">Introduction</title>
                   <clause id="_" inline-header="false" obligation="normative">
                      <title id="_">Intro 1</title>
                   </clause>
                </clause>
                <terms id="_" obligation="normative">
                   <title id="_">Intro 2</title>
                   <clause id="_" inline-header="false" obligation="normative">
                      <title id="_">Intro 3</title>
                   </clause>
                </terms>
                <clause id="_" obligation="normative" type="terms">
                   <title id="_">Intro 4</title>
                   <terms id="_" obligation="normative">
                      <title id="_">Intro 5</title>
                      <term id="_" anchor="term-Term1-1">
                         <preferred>
                            <expression>
                               <name>Term1</name>
                            </expression>
                         </preferred>
                      </term>
                   </terms>
                </clause>
                <terms id="_" obligation="normative">
                   <title id="_">Normal Terms</title>
                   <term id="_" anchor="term-Term2">
                      <preferred>
                         <expression>
                            <name>Term2</name>
                         </expression>
                      </preferred>
                   </term>
                </terms>
                <definitions id="_" obligation="normative">
                   <title id="_">Acronyms and abbreviations</title>
                   <clause id="_" inline-header="false" obligation="normative">
                      <title id="_">General</title>
                   </clause>
                   <definitions id="_" type="symbols" obligation="normative">
                      <title id="_">Acronyms and abbreviations</title>
                   </definitions>
                </definitions>
             </clause>
             <definitions id="_" type="abbreviated_terms" obligation="normative">
                <title id="_">Acronyms and abbreviations</title>
             </definitions>
             <clause id="_" inline-header="false" obligation="normative">
                <title id="_">Clause 4</title>
                <clause id="_" inline-header="false" obligation="normative">
                   <title id="_">Introduction</title>
                </clause>
                <clause id="_" inline-header="false" obligation="normative">
                   <title id="_">Clause 4.2</title>
                </clause>
             </clause>
             <terms id="_" obligation="normative">
                <title id="_">Terms and Definitions</title>
             </terms>
          </sections>
          <annex id="_" inline-header="false" obligation="normative">
             <title id="_">Annex</title>
             <clause id="_" inline-header="false" obligation="normative">
                <title id="_">Annex A.1</title>
             </clause>
          </annex>
          <annex id="_" obligation="" language="" script="">
             <title id="_">Bibliography</title>
             <references id="_" normative="false" obligation="informative">
                <title id="_">Bibliography</title>
                <p id="_">Bibliographical references are resources that provide additional or helpful material but do not need to be understood or used to implement this standard. Reference to these resources is made for informational use only.</p>
             </references>
          </annex>
          <bibliography>
             <references id="_" normative="true" obligation="informative">
                <title id="_">References</title>
                <p id="_">There are no normative references in this document.</p>
             </references>
          </bibliography>
          <indexsect id="_">
             <title id="_">Index</title>
             <p id="_">This is an index</p>
          </indexsect>
          <indexsect id="_" type="thematic">
             <title id="_">Thematic Index</title>
          </indexsect>
       </metanorma>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS)
      .sub(%r{<boilerplate>.*</boilerplate>}m, ""))))
      .to be_equivalent_to Canon.format_xml(output)
  end
end
