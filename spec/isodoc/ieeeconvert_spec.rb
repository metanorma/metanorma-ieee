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
           <foreword obligation='informative' displayorder='1'>
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
           <sections displayorder='2'>
             <clause id='B' displayorder='3'>
               <title>1.</title>
               <clause id='A'>
                 <title>1.1.</title>
               </clause>
             </clause>
           </sections>
         </preface>
       </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::IEEE::PresentationXMLConvert.new({})
  .convert("test", input, true))).to be_equivalent_to xmlpp(output)
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
      <foreword displayorder='1'>
         <p>
           <xref target='N1'>Equation (1)</xref>
           <xref target='N2'>Inequality (2)</xref>
           <xref target='N3'>Equation (A.1)</xref>
           <xref target='N4'>Inequality (A.2)</xref>
         </p>
       </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::IEEE::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end
end
