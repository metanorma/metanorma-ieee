require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::IEEE do
  it "automatically removes 'Clause' before subclauses if not at the start of a sentence" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
        <preface>
          <foreword obligation="informative">
            <title>Foreword</title>
            <p id="X"><xref target="A"/> and <xref target="A"/>.
            This is a preamble.
            <xref target="B"/> and <xref target="B"/>.
            <xref target="A"/> and <xref target="A"/>.
            <eref bibitemid="IEV" citeas="IEV" type="inline">
                    <locality type="clause">
                      <referenceFrom>1.2</referenceFrom>
                    </locality>
                  </eref></p>
                  </foreword>
        </preface>
        <sections>
        <clause id="B">
        <clause id="A"/>
        </clause>
        </sections>
       </iso-standard>
    INPUT
    output = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
         <preface>
            <clause type="toc" id="_" displayorder="1">
                <title depth="1">Contents</title>
            </clause>
           <foreword obligation='informative' displayorder='2'>
             <title>Foreword</title>
             <p id='X'>
               <xref target='A'>Clause 1.1</xref>
                and
               <xref target='A'>1.1</xref>
               . This is a preamble.
               <xref target='B'>Clause 1</xref>
                and
               <xref target='B'>Clause 1</xref>
               .
               <xref target='A'>Clause 1.1</xref>
                and
               <xref target='A'>1.1</xref>
               .
               <eref bibitemid='IEV' citeas='IEV' type='inline'>
                 <locality type='clause'>
                   <referenceFrom>1.2</referenceFrom>
                 </locality>
                 IEV, 1.2
               </eref>
             </p>
           </foreword>
         </preface>
           <sections>
           <p class="zzSTDTitle1" displayorder="3">??? for ???</p>
             <clause id='B' displayorder='4'>
               <title>1.</title>
               <clause id='A'>
                 <title>1.1.</title>
               </clause>
             </clause>
           </sections>
       </iso-standard>
    OUTPUT
    expect(xmlpp(strip_guid(IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
  .convert("test", input, true)))).to be_equivalent_to xmlpp(output)
  end

  it "cross-references formulae" do
    input = <<~INPUT
                  <itu-standard xmlns="http://riboseinc.com/isoxml">
                  <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N3"/>
          <xref target="N4"/>
          </p>
          </foreword>
          <introduction id="intro">
          <formula id="N1">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
        <clause id="xyz"><title>Preparatory</title>
          <formula id="N2" inequality="true">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
      </clause>
          </introduction>
          <annex id="A">
                    <formula id="N3">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
        <clause id="xyz"><title>Preparatory</title>
          <formula id="N4" inequality="true">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
          </annex>
          </itu-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder='2'>
         <p>
           <xref target='N1'>Equation (1)</xref>
           <xref target='N2'>Inequality (2)</xref>
           <xref target='N3'>Equation (A.1)</xref>
           <xref target='N4'>Inequality (A.2)</xref>
         </p>
       </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes figures as hierarchical assets" do
    input = <<~INPUT
        <iso-standard xmlns="http://riboseinc.com/isoxml">
            <preface>
        <foreword id="fwd">
        <p>
        <xref target="N"/>
        <xref target="note1"/>
        <xref target="note2"/>
        <xref target="AN"/>
        <xref target="Anote1"/>
        <xref target="Anote2"/>
        </p>
        </foreword>
        </preface>
        <sections>
        <clause id="scope" type="scope"><title>Scope</title>
        </clause>
        <terms id="terms"/>
        <clause id="widgets"><title>Widgets</title>
        <clause id="widgets1">
        <figure id="N">
            <figure id="note1">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
        <figure id="note2">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
      </figure>
      <p>    <xref target="note1"/> <xref target="note2"/> </p>
        </clause>
        </clause>
        </sections>
        <annex id="annex1">
        <clause id="annex1a">
        </clause>
        <clause id="annex1b">
        <figure id="AN">
            <figure id="Anote1">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
        <figure id="Anote2">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
      </figure>
        </clause>
        </annex>
        </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword id='fwd' displayorder='2'>
        <p>
          <xref target='N'>Figure 1</xref>
          <xref target='note1'>Figure 1-1</xref>
          <xref target='note2'>Figure 1-2</xref>
          <xref target='AN'>Figure A.1</xref>
          <xref target='Anote1'>Figure A.1-1</xref>
          <xref target='Anote2'>Figure A.1-2</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::IEEE::PresentationXMLConvert
      .new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
    output = <<~OUTPUT
      <foreword id='fwd' displayorder='2'>
         <p>
           <xref target='N'>Figure 3.1</xref>
           <xref target='note1'>Figure 3.1-1</xref>
           <xref target='note2'>Figure 3.1-2</xref>
           <xref target='AN'>Figure A.1</xref>
           <xref target='Anote1'>Figure A.1-1</xref>
           <xref target='Anote2'>Figure A.1-2</xref>
         </p>
       </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::IEEE::PresentationXMLConvert
      .new({ hierarchicalassets: true })
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end
end
