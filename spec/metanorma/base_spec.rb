require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::IEEE do
  before(:all) do
    @blank_hdr = blank_hdr_gen
  end

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

  it "processes default metadata" do
    output = Asciidoctor.convert(<<~"INPUT", *OPTIONS)
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
      :docstage: 20
      :docsubstage: 20
      :iteration: 3
      :language: en
      :title-intro-en: Introduction
      :title-main-en: Main Title -- Title
      :title-part-en: Title Part
      :title-intro-fr: Introduction Française
      :title-main-fr: Titre Principal
      :title-part-fr: Part du Titre
      :library-ics: 1,2,3
      :copyright-year: 2000
      :horizontal: true
      :confirmed-date: 1000-12-01
      :issued-date: 1001-12-01
      :wg_chair: AB
      :wg_vicechair: CD
      :wg_secretary: CD1
      :wg_members: E, F, Jr.; GH; IJ
      :balloting_group_members: KL; MN
      :std_board_chair: OP
      :std_board_vicechair: QR
      :std_board_pastchair: ST
      :std_board_secretary: UV
      :std_board_members: WX; YZ
      :isbn-pdf: ABC
      :isbn-print: DEF
      :stdid-pdf: GHI
      :stdid-print: JKL
    INPUT
    expect(xmlpp(output.sub(%r{<boilerplate>.*</boilerplate>}m, "")))
      .to be_equivalent_to xmlpp(<<~"OUTPUT")
         <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
          <bibdata type='standard'>
            <title language='en' format='text/plain'>Document title</title>
            <title language='intro-en' format='text/plain'>Introduction</title>
            <title language='main-en' format='text/plain'>Main Title -- Title</title>
            <title language='part-en' format='text/plain'>Title Part</title>
            <title language='intro-fr' format='text/plain'>Introduction Française</title>
            <title language='main-fr' format='text/plain'>Titre Principal</title>
            <title language='part-fr' format='text/plain'>Part du Titre</title>
            <docidentifier type='IEEE'>1000</docidentifier>
           <docidentifier type='IEEE' scope='PDF'>GHI</docidentifier>
           <docidentifier type='IEEE' scope='print'>JKL</docidentifier>
           <docidentifier type='ISBN' scope='PDF'>ABC</docidentifier>
           <docidentifier type='ISBN' scope='print'>DEF</docidentifier>
            <docnumber>1000</docnumber>
            <date type='confirmed'>
              <on>1000-12-01</on>
            </date>
            <date type='issued'>
              <on>1001-12-01</on>
            </date>
            <contributor>
              <role type='editor'>Working Group Chair</role>
              <person>
                <name>
                  <completename>AB</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type='editor'>Working Group Vice-Chair</role>
              <person>
                <name>
                  <completename>CD</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type='editor'>Working Group Secretary</role>
              <person>
                <name>
                  <completename>CD1</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type='editor'>Working Group Member</role>
              <person>
                <name>
                  <completename>E, F, Jr.</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type='editor'>Working Group Member</role>
              <person>
                <name>
                  <completename>GH</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type='editor'>Working Group Member</role>
              <person>
                <name>
                  <completename>IJ</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type='editor'>Balloting Group Member</role>
              <person>
                <name>
                  <completename>KL</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type='editor'>Balloting Group Member</role>
              <person>
                <name>
                  <completename>MN</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type='editor'>Standards Board Chair</role>
              <person>
                <name>
                  <completename>OP</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type='editor'>Standards Board Vice-Chair</role>
              <person>
                <name>
                  <completename>QR</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type='editor'>Standards Board Past Chair</role>
              <person>
                <name>
                  <completename>ST</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type='editor'>Standards Board Secretary</role>
              <person>
                <name>
                  <completename>UV</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type='editor'>Standards Board Member</role>
              <person>
                <name>
                  <completename>KL</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type='editor'>Standards Board Member</role>
              <person>
                <name>
                  <completename>MN</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type='publisher'/>
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
              <stage>20</stage>
              <substage>20</substage>
              <iteration>3</iteration>
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
            <ext>
              <doctype>standard</doctype>
              <editorialgroup>
                <society>SECRETARIAT</society>
                <balloting-group>SC</balloting-group>
                <working-group>WG</working-group>
                <working-group>WG1</working-group>
                <committee>TC</committee>
                <committee>TC1</committee>
              </editorialgroup>
              <ics>
                <code>1</code>
              </ics>
              <ics>
                <code>2</code>
              </ics>
              <ics>
                <code>3</code>
              </ics>
            </ext>
          </bibdata>
          <sections> </sections>
        </ieee-standard>
      OUTPUT
  end

  it "processes sections" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}
      .Foreword

      Text

      [abstract]
      == Abstract

      Text

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

      === Term1

      == Terms, Definitions, Symbols and Abbreviated Terms

      [.boilerplate]
      === Boilerplate

      Boilerplate text

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
      #{@blank_hdr.sub(%r{</script>}, '</script><abstract><p>Text</p></abstract>')}
               <preface>
           <abstract id='_'>
             <title>Abstract</title>
             <p id='_'>Text</p>
           </abstract>
           <foreword id='_' obligation='informative'>
             <title>Foreword</title>
             <p id='_'>Text</p>
           </foreword>
           <introduction id='_' obligation='informative'>
             <title>Introduction</title>
             <admonition>This introduction is not part of P, Document title </admonition>
             <clause id='_' inline-header='false' obligation='informative'>
               <title>Introduction Subsection</title>
             </clause>
           </introduction>
           <clause id='_' inline-header='false' obligation='informative'>
             <title>Dedication</title>
           </clause>
           <acknowledgements id='_' obligation='informative'>
             <title>Acknowledgements</title>
           </acknowledgements>
         </preface>
         <sections>
           <clause id='_' type='overview' inline-header='false' obligation='normative'>
             <title>Overview</title>
             <p id='_'>Text</p>
             <clause id='_' type='scope' inline-header='false' obligation='normative'>
               <title>Scope</title>
               <p id='_'>Text</p>
             </clause>
             <clause id='_' type='purpose' inline-header='false' obligation='normative'>
               <title>Purpose</title>
               <p id='_'>Text</p>
             </clause>
           </clause>
           <terms id='_' obligation='normative'>
             <title>Definitions</title>
             <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
             <p id='_'>
               For the purposes of this document, the following terms and definitions
               apply. The
               <em>IEEE Standards Dictionary Online</em>
                should be consulted for terms not defined in this clause.
               <fn>
                 <p id='_'>
                   <em>IEEE Standards Dictionary Online</em>
                    is available at:
                   <link target='http://dictionary.ieee.org'/>
                   . An IEEE Account is required for access to the dictionary, and one
                   can be created at no charge on the dictionary sign-in page.
                 </p>
               </fn>
             </p>
             <term id='term-Term1'>
               <preferred>
                 <expression>
                   <name>Term1</name>
                 </expression>
               </preferred>
             </term>
           </terms>
           <clause id='_' obligation='normative'>
             <title>Definitions, acronyms and abbreviations</title>
             <p id='_'>Boilerplate text</p>
             <clause id='_' inline-header='false' obligation='normative'>
               <title>Introduction</title>
               <clause id='_' inline-header='false' obligation='normative'>
                 <title>Intro 1</title>
               </clause>
             </clause>
             <terms id='_' obligation='normative'>
               <title>Intro 2</title>
               <clause id='_' inline-header='false' obligation='normative'>
                 <title>Intro 3</title>
               </clause>
             </terms>
             <clause id='_' obligation='normative'>
               <title>Intro 4</title>
               <terms id='_' obligation='normative'>
                 <title>Intro 5</title>
                 <term id='term-Term1-1'>
                   <preferred>
                     <expression>
                       <name>Term1</name>
                     </expression>
                   </preferred>
                 </term>
               </terms>
             </clause>
             <terms id='_' obligation='normative'>
               <title>Normal Terms</title>
               <term id='term-Term2'>
                 <preferred>
                   <expression>
                     <name>Term2</name>
                   </expression>
                 </preferred>
               </term>
             </terms>
             <definitions id='_' obligation='normative'>
               <title>Acronyms and abbreviations</title>
               <clause id='_' inline-header='false' obligation='normative'>
                 <title>General</title>
               </clause>
               <definitions id='_' type='symbols' obligation='normative'>
                 <title>Acronyms and abbreviations</title>
               </definitions>
             </definitions>
           </clause>
           <definitions id='_' type='abbreviated_terms' obligation='normative'>
             <title>Acronyms and abbreviations</title>
           </definitions>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Clause 4</title>
             <clause id='_' inline-header='false' obligation='normative'>
               <title>Introduction</title>
             </clause>
             <clause id='_' inline-header='false' obligation='normative'>
               <title>Clause 4.2</title>
             </clause>
           </clause>
           <terms id='_' obligation='normative'>
             <title>Terms and Definitions</title>
             <p id='_'>No terms and definitions are listed in this document.</p>
             <p id='_'>
               For the purposes of this document, the following terms and definitions
               apply. The
               <em>IEEE Standards Dictionary Online</em>
                should be consulted for terms not defined in this clause.
               <fn>
                 <p id='_'>
                   <em>IEEE Standards Dictionary Online</em>
                    is available at:
                   <link target='http://dictionary.ieee.org'/>
                   . An IEEE Account is required for access to the dictionary, and one
                   can be created at no charge on the dictionary sign-in page.
                 </p>
               </fn>
             </p>
           </terms>
         </sections>
         <annex id='_' inline-header='false' obligation='normative'>
           <title>Annex</title>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Annex A.1</title>
           </clause>
         </annex>
         <annex id='_' obligation='' language='' script=''>
             <title>Bibliography</title>
             <references id='_' normative='false' obligation='informative'>
               <title>Bibliography</title>
               <p id='_'>
                 Bibliographical references are resources that provide additional or
                 helpful material but do not need to be understood or used to implement
                 this standard. Reference to these resources is made for informational
                 use only.
               </p>
             </references>
         </annex>
         <bibliography>
           <references id='_' normative='true' obligation='informative'>
             <title>Normative references</title>
             <p id='_'>There are no normative references in this document.</p>
           </references>
         </bibliography>
         <indexsect id='_'>
           <title>Index</title>
           <p id='_'>This is an index</p>
         </indexsect>
         <indexsect id='_' type='thematic'>
           <title>Thematic Index</title>
         </indexsect>
       </ieee-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end
end
