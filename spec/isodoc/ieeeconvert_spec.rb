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
end
