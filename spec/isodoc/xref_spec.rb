require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::Ieee do
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
        <foreword obligation="informative" displayorder="2" id="_">
           <title id="_">Foreword</title>
           <fmt-title depth="1">
              <semx element="title" source="_">Foreword</semx>
           </fmt-title>
           <p id="X">
              <xref target="A" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="A">
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="B">1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="A">1</semx>
                 </fmt-xref>
              </semx>
              and
              <xref target="A" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="A">
                    <semx element="autonum" source="B">1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="A">1</semx>
                 </fmt-xref>
              </semx>
              . This is a preamble.
              <xref target="B" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="B">
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="B">1</semx>
                 </fmt-xref>
              </semx>
              and
              <xref target="B" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="B">
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="B">1</semx>
                 </fmt-xref>
              </semx>
              .
              <xref target="A" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="A">
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="B">1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="A">1</semx>
                 </fmt-xref>
              </semx>
              and
              <xref target="A" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="A">
                    <semx element="autonum" source="B">1</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="A">1</semx>
                 </fmt-xref>
              </semx>
              .
              <eref bibitemid="IEV" citeas="IEV" type="inline" id="_">
                 <locality type="clause">
                    <referenceFrom>1.2</referenceFrom>
                 </locality>
              </eref>
              <semx element="eref" source="_">
                 <fmt-eref bibitemid="IEV" citeas="IEV" type="inline">
                    <locality type="clause">
                       <referenceFrom>1.2</referenceFrom>
                    </locality>
                    IEV, 1.2
                 </fmt-eref>
              </semx>
           </p>
        </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)).at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
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
        <foreword displayorder="2" id="_">
           <title id="_">Foreword</title>
           <fmt-title depth="1">
              <semx element="title" source="_">Foreword</semx>
           </fmt-title>
           <p>
              <xref target="N1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N1">
                    <span class="fmt-element-name">Equation</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="N1">1</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
              <xref target="N2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N2">
                    <span class="fmt-element-name">Inequality</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="N2">2</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
              <xref target="N3" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N3">
                    <span class="fmt-element-name">Equation</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="A">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="N3">1</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
              <xref target="N4" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N4">
                    <span class="fmt-element-name">Inequality</span>
                    <span class="fmt-autonum-delim">(</span>
                    <semx element="autonum" source="A">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="N4">2</semx>
                    <span class="fmt-autonum-delim">)</span>
                 </fmt-xref>
              </semx>
           </p>
        </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes figures as hierarchical assets" do
    input = <<~INPUT
        <iso-standard xmlns="http://riboseinc.com/isoxml">
            <preface>
        <foreword id="fwd">
        <p>
        <xref target="N0"/>
        <xref target="note01"/>
        <xref target="note02"/>
        <xref target="N1"/>
        <xref target="note11"/>
        <xref target="note12"/>
        <xref target="N2"/>
        <xref target="note21"/>
        <xref target="note22"/>
        <xref target="AN"/>
        <xref target="Anote1"/>
        <xref target="Anote2"/>
        </p>
        </foreword>
        <introduction id="intro">
        <figure id="N0">
            <figure id="note01">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
        <figure id="note02">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
      </figure>
        </introdution>
        <acknowledgements id="ack">
        <figure id="N1">
            <figure id="note11">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
        <figure id="note12">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
      </figure>
        </acknowledgements>
        </preface>
        <sections>
        <clause id="scope" type="scope"><title>Scope</title>
        </clause>
        <terms id="terms"/>
        <clause id="widgets"><title>Widgets</title>
        <clause id="widgets1">
        <figure id="N2">
            <figure id="note21">
      <name>Split-it-right sample divider</name>
      <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
      </figure>
        <figure id="note22">
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
        <foreword id="fwd" displayorder="2">
           <title id="_">Foreword</title>
           <fmt-title depth="1">
              <semx element="title" source="_">Foreword</semx>
           </fmt-title>
           <p>
              <xref target="N0" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N0">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="N0">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note01" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note01">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="N0">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note01">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note02" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note02">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="N0">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note02">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="N1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N1">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="N1">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="note11" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note11">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="N1">2</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note11">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note12" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note12">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="N1">2</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note12">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="N2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N2">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="N2">3</semx>
                 </fmt-xref>
              </semx>
              <xref target="note21" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note21">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="N2">3</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note21">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note22" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note22">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="N2">3</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note22">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="AN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote1">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="AN">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="Anote1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote2">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="AN">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="Anote2">2</semx>
                 </fmt-xref>
              </semx>
           </p>
        </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(IsoDoc::Ieee::PresentationXMLConvert
      .new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
    output = <<~OUTPUT
        <foreword id="fwd" displayorder="2">
           <title id="_">Foreword</title>
           <fmt-title depth="1">
              <semx element="title" source="_">Foreword</semx>
           </fmt-title>
           <p>
              <xref target="N0" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N0">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="intro">Preface</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="N0">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note01" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note01">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="intro">Preface</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="N0">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note01">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note02" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note02">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="intro">Preface</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="N0">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note02">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="N1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N1">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="ack">Preface</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="N1">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="note11" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note11">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="ack">Preface</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="N1">2</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note11">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note12" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note12">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="ack">Preface</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="N1">2</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note12">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="N2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N2">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="widgets">3</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="N2">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note21" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note21">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="widgets">3</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="N2">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note21">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note22" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note22">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="widgets">3</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="N2">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="note22">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="AN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote1">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="AN">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="Anote1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote2">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="AN">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="Anote2">2</semx>
                 </fmt-xref>
              </semx>
           </p>
        </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(IsoDoc::Ieee::PresentationXMLConvert
      .new({ hierarchicalassets: true })
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end
end
