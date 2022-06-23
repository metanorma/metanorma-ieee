require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::IEEE do
  before(:all) do
    @blank_hdr = blank_hdr_gen
  end

  it "inserts boilerplate in front of sections" do
    input = <<~INPUT
      = Draft Recommended Practice for Widgets
      Author
      :docfile: test.adoc
      :nodoc:
      :draft: 1.2
      :docnumber: 10000
      :doctype: recommended-practice

      == Introduction

      This is the introduction.

      [bibliography]
      == Normative References

      * [[[GHI,JKL]]]

      [appendix]
      == Appendix C

      [bibliography]
      === Bibliography

      * [[[ABC,DEF]]]
    INPUT
    output = <<~OUTPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
             <preface>
         <introduction id='_' obligation='informative'>
           <title>Introduction</title>
           <admonition>This introduction is not part of P10000/D1.2,
              Draft Recommended Practice for Widgets
            </admonition>
           <p id='_'>This is the introduction.</p>
         </introduction>
       </preface>
         <sections> </sections>
         <annex id='_' inline-header='false' obligation='normative'>
           <title>Appendix C</title>
           <references id='_' normative='false' obligation='informative'>
             <title>Bibliography</title>
             <p id='_'>
               Bibliographical references are resources that provide additional or
               helpful material but do not need to be understood or used to implement
               this standard. Reference to these resources is made for informational
               use only.
             </p>
             <bibitem id='ABC'>
               <formattedref format='application/x-isodoc+xml'/>
               <docidentifier>DEF</docidentifier>
             </bibitem>
           </references>
         </annex>
       <bibliography>
         <references id='_' normative='true' obligation='informative'>
           <title>Normative references</title>
           <p id='_'>
             The following referenced documents are indispensable for the application
             of this document (i.e., they must be understood and used, so each
             referenced document is cited in text and its relationship to this
             document is explained). For dated references, only the edition cited
             applies. For undated references, the latest edition of the referenced
             document (including any amendments or corrigenda) applies.
           </p>
           <bibitem id='GHI'>
             <formattedref format='application/x-isodoc+xml'/>
             <docidentifier>JKL</docidentifier>
           </bibitem>
         </references>
       </bibliography>
      </ieee-standard>
    OUTPUT
    ret = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    ret.at("//xmlns:bibdata").remove
    ret.at("//xmlns:boilerplate").remove
    expect(xmlpp(strip_guid(ret.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "does not insert boilerplate in front of bibliography if already provided" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [appendix]
      == Appendix C

      [bibliography]
      === Bibliography

      [NOTE,type = boilerplate]
      This is boilerplate

      * [[[ABC,DEF]]]
    INPUT
    output = <<~OUTPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
         <sections> </sections>
         <annex id='_' inline-header='false' obligation='normative'>
           <title>Appendix C</title>
           <references id='_' normative='false' obligation='informative'>
             <title>Bibliography</title>
             <p id='_'>This is boilerplate</p>
             <bibitem id='ABC'>
               <formattedref format='application/x-isodoc+xml'/>
               <docidentifier>DEF</docidentifier>
             </bibitem>
           </references>
         </annex>
       </ieee-standard>
    OUTPUT
    ret = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    ret.at("//xmlns:bibdata").remove
    ret.at("//xmlns:boilerplate").remove
    expect(xmlpp(strip_guid(ret.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "removes extraneous instances of overview clauses" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Overview

      === Scope

      === Purpose

      == Scope

      == Purpose

      == Overview

    INPUT
    output = <<~OUTPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
               <sections>
           <clause id='_' type='overview' inline-header='false' obligation='normative'>
             <title>Overview</title>
             <clause id='_' type='scope' inline-header='false' obligation='normative'>
               <title>Scope</title>
             </clause>
             <clause id='_' type='purpose' inline-header='false' obligation='normative'>
               <title>Purpose</title>
             </clause>
           </clause>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Scope</title>
           </clause>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Purpose</title>
           </clause>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Overview</title>
           </clause>
         </sections>
       </ieee-standard>
    OUTPUT
    ret = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    ret.at("//xmlns:bibdata").remove
    ret.at("//xmlns:boilerplate").remove
    expect(xmlpp(strip_guid(ret.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "inserts footnote note on first note" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Overview

      NOTE: First note

      === Scope

      === Purpose

      == Scope

      NOTE: Second note

      == Purpose

      == Overview

    INPUT
    output = <<~OUTPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
         <sections>
           <clause id='_' type='overview' inline-header='false' obligation='normative'>
             <title>Overview</title>
             <note id='_'>
               <p id='_'>
                 First note
                 <fn reference='1'>
                   <p id='_'>Notes to text, tables, and figures are for information only and do
                    not contain requirements needed to implement the standard.</p>
                 </fn>
               </p>
             </note>
             <clause id='_' type='scope' inline-header='false' obligation='normative'>
               <title>Scope</title>
             </clause>
             <clause id='_' type='purpose' inline-header='false' obligation='normative'>
               <title>Purpose</title>
             </clause>
           </clause>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Scope</title>
             <note id='_'>
               <p id='_'>Second note</p>
             </note>
           </clause>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Purpose</title>
           </clause>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Overview</title>
           </clause>
         </sections>
       </ieee-standard>
    OUTPUT
    ret = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    ret.at("//xmlns:bibdata").remove
    ret.at("//xmlns:boilerplate").remove
    expect(xmlpp(strip_guid(ret.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes footnotes" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      Hello!footnote:[Footnote text]

      Hello.footnote:abc[This is a repeated footnote]

      Repetition.footnote:abc[]
    INPUT
    output = <<~OUTPUT
      <sections>
        <p id='_'>
          Hello!
          <fn reference='1'>
            <p id='_'>Footnote text</p>
          </fn>
        </p>
        <p id='_'>
          Hello.
          <fn reference='2'>
            <p id='_'>This is a repeated footnote</p>
          </fn>
        </p>
        <p id='_'>
          Repetition.
          <fn reference='3'>
            <p id='_'>See Footnote 2.</p>
          </fn>
        </p>
      </sections>
    OUTPUT
    ret = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    expect(xmlpp(strip_guid(ret.at("//xmlns:sections").to_xml)))
      .to be_equivalent_to(output)
  end
end
