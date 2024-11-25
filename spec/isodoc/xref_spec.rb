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
      <foreword obligation="informative" displayorder="2">
          <title id="_">Foreword</title>
          <fmt-title depth="1">
             <span class="fmt-caption-label">
                <semx element="title" source="_">Foreword</semx>
             </span>
          </fmt-title>
          <p id="X">
             <xref target="A">
                <span class="fmt-element-name">Clause</span>
                <semx element="autonum" source="B">1</semx>
                <span class="fmt-autonum-delim">.</span>
                <semx element="autonum" source="A">1</semx>
             </xref>
             and
             <xref target="A">
                <semx element="autonum" source="B">1</semx>
                <span class="fmt-autonum-delim">.</span>
                <semx element="autonum" source="A">1</semx>
             </xref>
             . This is a preamble.
             <xref target="B">
                <span class="fmt-element-name">Clause</span>
                <semx element="autonum" source="B">1</semx>
             </xref>
             and
             <xref target="B">
                <span class="fmt-element-name">Clause</span>
                <semx element="autonum" source="B">1</semx>
             </xref>
             .
             <xref target="A">
                <span class="fmt-element-name">Clause</span>
                <semx element="autonum" source="B">1</semx>
                <span class="fmt-autonum-delim">.</span>
                <semx element="autonum" source="A">1</semx>
             </xref>
             and
             <xref target="A">
                <semx element="autonum" source="B">1</semx>
                <span class="fmt-autonum-delim">.</span>
                <semx element="autonum" source="A">1</semx>
             </xref>
             .
             <eref bibitemid="IEV" citeas="IEV" type="inline">
                <locality type="clause">
                   <referenceFrom>1.2</referenceFrom>
                </locality>
                IEV, 1.2
             </eref>
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
        <foreword displayorder="2">
           <title id="_">Foreword</title>
           <fmt-title depth="1">
              <span class="fmt-caption-label">
                 <semx element="title" source="_">Foreword</semx>
              </span>
           </fmt-title>
           <p>
              <xref target="N1">
                 <span class="fmt-element-name">Equation</span>
                 <span class="fmt-autonum-delim">(</span>
                 <semx element="autonum" source="N1">1</semx>
                 <span class="fmt-autonum-delim">)</span>
              </xref>
              <xref target="N2">
                 <span class="fmt-element-name">Inequality</span>
                 <span class="fmt-autonum-delim">(</span>
                 <semx element="autonum" source="N2">2</semx>
                 <span class="fmt-autonum-delim">)</span>
              </xref>
              <xref target="N3">
                 <span class="fmt-element-name">Equation</span>
                 <span class="fmt-autonum-delim">(</span>
                 <semx element="autonum" source="A">A</semx>
                 <span class="fmt-autonum-delim">.</span>
                 <semx element="autonum" source="N3">1</semx>
                 <span class="fmt-autonum-delim">)</span>
              </xref>
              <xref target="N4">
                 <span class="fmt-element-name">Inequality</span>
                 <span class="fmt-autonum-delim">(</span>
                 <semx element="autonum" source="A">A</semx>
                 <span class="fmt-autonum-delim">.</span>
                 <semx element="autonum" source="N4">2</semx>
                 <span class="fmt-autonum-delim">)</span>
              </xref>
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
      <foreword id="fwd" displayorder="2">
           <title id="_">Foreword</title>
           <fmt-title depth="1">
              <span class="fmt-caption-label">
                 <semx element="title" source="_">Foreword</semx>
              </span>
           </fmt-title>
           <p>
              <xref target="N">
                 <span class="fmt-element-name">Figure</span>
                 <semx element="autonum" source="N">1</semx>
              </xref>
              <xref target="note1">
                 <span class="fmt-element-name">Figure</span>
                 <semx element="autonum" source="N">1</semx>
                 <span class="fmt-autonum-delim">-</span>
                 <semx element="autonum" source="note1">1</semx>
              </xref>
              <xref target="note2">
                 <span class="fmt-element-name">Figure</span>
                 <semx element="autonum" source="N">1</semx>
                 <span class="fmt-autonum-delim">-</span>
                 <semx element="autonum" source="note2">2</semx>
              </xref>
              <xref target="AN">
                 <span class="fmt-element-name">Figure</span>
                 <semx element="autonum" source="annex1">A</semx>
                 <span class="fmt-autonum-delim">.</span>
                 <semx element="autonum" source="AN">1</semx>
              </xref>
              <xref target="Anote1">
                 <span class="fmt-element-name">Figure</span>
                 <semx element="autonum" source="annex1">A</semx>
                 <span class="fmt-autonum-delim">.</span>
                 <semx element="autonum" source="AN">1</semx>
                 <span class="fmt-autonum-delim">-</span>
                 <semx element="autonum" source="Anote1">1</semx>
              </xref>
              <xref target="Anote2">
                 <span class="fmt-element-name">Figure</span>
                 <semx element="autonum" source="annex1">A</semx>
                 <span class="fmt-autonum-delim">.</span>
                 <semx element="autonum" source="AN">1</semx>
                 <span class="fmt-autonum-delim">-</span>
                 <semx element="autonum" source="Anote2">2</semx>
              </xref>
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
             <span class="fmt-caption-label">
                <semx element="title" source="_">Foreword</semx>
             </span>
          </fmt-title>
          <p>
             <xref target="N">
                <span class="fmt-element-name">Figure</span>
                <semx element="autonum" source="widgets">3</semx>
                <span class="fmt-autonum-delim">.</span>
                <semx element="autonum" source="N">1</semx>
             </xref>
             <xref target="note1">
                <span class="fmt-element-name">Figure</span>
                <semx element="autonum" source="widgets">3</semx>
                <span class="fmt-autonum-delim">.</span>
                <semx element="autonum" source="N">1</semx>
                <span class="fmt-autonum-delim">-</span>
                <semx element="autonum" source="note1">1</semx>
             </xref>
             <xref target="note2">
                <span class="fmt-element-name">Figure</span>
                <semx element="autonum" source="widgets">3</semx>
                <span class="fmt-autonum-delim">.</span>
                <semx element="autonum" source="N">1</semx>
                <span class="fmt-autonum-delim">-</span>
                <semx element="autonum" source="note2">2</semx>
             </xref>
             <xref target="AN">
                <span class="fmt-element-name">Figure</span>
                <semx element="autonum" source="annex1">A</semx>
                <span class="fmt-autonum-delim">.</span>
                <semx element="autonum" source="AN">1</semx>
             </xref>
             <xref target="Anote1">
                <span class="fmt-element-name">Figure</span>
                <semx element="autonum" source="annex1">A</semx>
                <span class="fmt-autonum-delim">.</span>
                <semx element="autonum" source="AN">1</semx>
                <span class="fmt-autonum-delim">-</span>
                <semx element="autonum" source="Anote1">1</semx>
             </xref>
             <xref target="Anote2">
                <span class="fmt-element-name">Figure</span>
                <semx element="autonum" source="annex1">A</semx>
                <span class="fmt-autonum-delim">.</span>
                <semx element="autonum" source="AN">1</semx>
                <span class="fmt-autonum-delim">-</span>
                <semx element="autonum" source="Anote2">2</semx>
             </xref>
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
