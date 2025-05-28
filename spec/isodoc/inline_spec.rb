require "spec_helper"

RSpec.describe IsoDoc::Ieee do
  it "processes eref content" do
    input = <<~INPUT
        <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface>
            <foreword>
              <p id="A">
                <eref bibitemid="IEV" citeas="IEV" type="inline">
                  <locality type="clause">
                    <referenceFrom>1-2-3</referenceFrom>
                  </locality>
                </eref>
                <eref bibitemid="ISO712" citeas="ISO 712" type="inline"/>
                <eref bibitemid="ISO712" type="inline"/>
                <eref bibitemid="ISO712" type="inline">
                  <locality type="table">
                    <referenceFrom>1</referenceFrom>
                  </locality>
                </eref>
                <eref bibitemid="ISO712" type="inline">
                  <locality type="table">
                    <referenceFrom>1</referenceFrom>
                    <referenceTo>1</referenceTo>
                  </locality>
                </eref>
                <eref bibitemid="ISO712" type="inline">
                  <locality type="clause">
                    <referenceFrom>1</referenceFrom>
                  </locality>
                  <locality type="table">
                    <referenceFrom>1</referenceFrom>
                  </locality>
                </eref>
                <eref bibitemid="ISO712" type="inline">
                  <locality type="clause">
                    <referenceFrom>1</referenceFrom>
                  </locality>
                  <locality type="list">
                    <referenceFrom>a</referenceFrom>
                  </locality>
                </eref>
                <eref bibitemid="ISO712" type="inline">
                  <locality type="clause">
                    <referenceFrom>1</referenceFrom>
                  </locality>
                </eref>
                <eref bibitemid="ISO712" type="inline">
                  <locality type="clause">
                    <referenceFrom>1.5</referenceFrom>
                  </locality>
                </eref>
                <eref bibitemid="ISO712" type="inline">
                  <locality type="table">
                    <referenceFrom>1</referenceFrom>
                  </locality>A</eref>
                <eref bibitemid="ISO712" type="inline">
                  <locality type="whole"/>
                </eref>
                <eref bibitemid="ISO712" type="inline">
                  <locality type="locality:prelude">
                    <referenceFrom>7</referenceFrom>
                  </locality>
                </eref>
                <eref bibitemid="ISO712" citeas="ISO 712" type="inline">A</eref>
                <eref bibitemid="ISO712" citeas="ISO/IEC DIR 1" type="inline"/>
              </p>
            </foreword>
          </preface>
          <bibliography>
            <references id="_normative_references" normative="true" obligation="informative">
              <title>Normative References</title>
              <bibitem id="ISO712" type="standard">
                <title format="text/plain">Cereals and cereal products</title>
                <docidentifier>ISO 712</docidentifier>
                <contributor>
                  <role type="publisher"/>
                  <organization>
                    <name>ISO</name>
                  </organization>
                </contributor>
              </bibitem>
            </references>
          </bibliography>
        </iso-standard>
      INPUT
      presxml = <<~OUTPUT
       <p id="A">
          <eref bibitemid="IEV" citeas="IEV" type="inline" id="_">
             <locality type="clause">
                <referenceFrom>1-2-3</referenceFrom>
             </locality>
          </eref>
          <semx element="eref" source="_">
             <fmt-eref bibitemid="IEV" citeas="IEV" type="inline">
                <locality type="clause">
                   <referenceFrom>1-2-3</referenceFrom>
                </locality>
                IEV, 1-2-3
             </fmt-eref>
          </semx>
          <eref bibitemid="ISO712" citeas="ISO 712" type="inline" id="_"/>
          <semx element="eref" source="_">
             <fmt-xref type="inline" target="ISO712">
                <span class="std_publisher">ISO </span>
                <span class="std_docNumber">712</span>
             </fmt-xref>
          </semx>
          <eref bibitemid="ISO712" type="inline" id="_"/>
          <semx element="eref" source="_">
             <fmt-xref type="inline" target="ISO712">ISO 712</fmt-xref>
          </semx>
          <eref bibitemid="ISO712" type="inline" id="_">
             <locality type="table">
                <referenceFrom>1</referenceFrom>
             </locality>
          </eref>
          <semx element="eref" source="_">
             <fmt-xref type="inline" target="ISO712">ISO 712, Table 1</fmt-xref>
          </semx>
          <eref bibitemid="ISO712" type="inline" id="_">
             <locality type="table">
                <referenceFrom>1</referenceFrom>
                <referenceTo>1</referenceTo>
             </locality>
          </eref>
          <semx element="eref" source="_">
             <fmt-xref type="inline" target="ISO712">ISO 712, Table 1–1</fmt-xref>
          </semx>
          <eref bibitemid="ISO712" type="inline" id="_">
             <locality type="clause">
                <referenceFrom>1</referenceFrom>
             </locality>
             <locality type="table">
                <referenceFrom>1</referenceFrom>
             </locality>
          </eref>
          <semx element="eref" source="_">
             <fmt-xref type="inline" target="ISO712">ISO 712, Clause 1, Table 1</fmt-xref>
          </semx>
          <eref bibitemid="ISO712" type="inline" id="_">
             <locality type="clause">
                <referenceFrom>1</referenceFrom>
             </locality>
             <locality type="list">
                <referenceFrom>a</referenceFrom>
             </locality>
          </eref>
          <semx element="eref" source="_">
             <fmt-xref type="inline" target="ISO712">ISO 712, Clause 1, List a)</fmt-xref>
          </semx>
          <eref bibitemid="ISO712" type="inline" id="_">
             <locality type="clause">
                <referenceFrom>1</referenceFrom>
             </locality>
          </eref>
          <semx element="eref" source="_">
             <fmt-xref type="inline" target="ISO712">ISO 712, Clause 1</fmt-xref>
          </semx>
          <eref bibitemid="ISO712" type="inline" id="_">
             <locality type="clause">
                <referenceFrom>1.5</referenceFrom>
             </locality>
          </eref>
          <semx element="eref" source="_">
             <fmt-xref type="inline" target="ISO712">ISO 712, 1.5</fmt-xref>
          </semx>
          <eref bibitemid="ISO712" type="inline" id="_">
             <locality type="table">
                <referenceFrom>1</referenceFrom>
             </locality>
             A
          </eref>
          <semx element="eref" source="_">
             <fmt-xref type="inline" target="ISO712">
                 A</fmt-xref>
          </semx>
          <eref bibitemid="ISO712" type="inline" id="_">
             <locality type="whole"/>
          </eref>
          <semx element="eref" source="_">
             <fmt-xref type="inline" target="ISO712">ISO 712, Whole of text</fmt-xref>
          </semx>
          <eref bibitemid="ISO712" type="inline" id="_">
             <locality type="locality:prelude">
                <referenceFrom>7</referenceFrom>
             </locality>
          </eref>
          <semx element="eref" source="_">
             <fmt-xref type="inline" target="ISO712">ISO 712, Prelude 7</fmt-xref>
          </semx>
          <eref bibitemid="ISO712" citeas="ISO 712" type="inline" id="_">A</eref>
          <semx element="eref" source="_">
             <fmt-xref type="inline" target="ISO712">A</fmt-xref>
          </semx>
          <eref bibitemid="ISO712" citeas="ISO/IEC DIR 1" type="inline" id="_"/>
          <semx element="eref" source="_">
             <fmt-xref type="inline" target="ISO712">
                <span class="std_publisher">ISO </span>
                <span class="std_docNumber">712</span>
             </fmt-xref>
          </semx>
       </p>
      OUTPUT
    output = IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(output)
      .at("//xmlns:p[@id ='A']").to_xml)))
      .to be_equivalent_to Xml::C14n.format(strip_guid(presxml))
  end

  it "combines locality stacks with connectives, omitting subclauses" do
    input = <<~INPUT
      <itu-standard xmlns="https://www.calconnect.org/standards/itu">
                  <p id='_'>
              <eref type='inline' bibitemid='ref1' citeas='XYZ'>
                <localityStack connective='from'>
                  <locality type='clause'>
                    <referenceFrom>3</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack connective='to'>
                  <locality type='clause'>
                    <referenceFrom>5</referenceFrom>
                  </locality>
                </localityStack>
              </eref>
              <eref type='inline' bibitemid='ref1' citeas='XYZ'>
                <localityStack connective='from'>
                  <locality type='clause'>
                    <referenceFrom>3.1</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack connective='to'>
                  <locality type='clause'>
                    <referenceFrom>5.1</referenceFrom>
                  </locality>
                </localityStack>
              </eref>
              <eref type='inline' bibitemid='ref1' citeas='XYZ'>
                <localityStack connective='from'>
                  <locality type='clause'>
                    <referenceFrom>3.1</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack connective='to'>
                  <locality type='clause'>
                    <referenceFrom>5</referenceFrom>
                  </locality>
                </localityStack>
              </eref>
              <eref type='inline' bibitemid='ref1' citeas='XYZ'>
                <localityStack connective='from'>
                  <locality type='clause'>
                    <referenceFrom>3.1</referenceFrom>
                  </locality>
                </localityStack>
                <localityStack connective='to'>
                  <locality type='table'>
                    <referenceFrom>5</referenceFrom>
                  </locality>
                </localityStack>
              </eref>
            </p>
            </itu-standard>
    INPUT
    output = <<~OUTPUT
       <itu-standard xmlns="https://www.calconnect.org/standards/itu" type="presentation">
          <p id="_">
             <eref type="inline" bibitemid="ref1" citeas="XYZ" id="_">
                <localityStack connective="from">
                   <locality type="clause">
                      <referenceFrom>3</referenceFrom>
                   </locality>
                </localityStack>
                <localityStack connective="to">
                   <locality type="clause">
                      <referenceFrom>5</referenceFrom>
                   </locality>
                </localityStack>
             </eref>
             <semx element="eref" source="_">
                <fmt-eref type="inline" bibitemid="ref1" citeas="XYZ" droploc="">
                   <localityStack connective="from">
                      <locality type="clause">
                         <referenceFrom>3</referenceFrom>
                      </locality>
                   </localityStack>
                   <localityStack connective="to">
                      <locality type="clause">
                         <referenceFrom>5</referenceFrom>
                      </locality>
                   </localityStack>
                   XYZ, Clauses 3
                   <span class="fmt-conn">to</span>
                   5
                </fmt-eref>
             </semx>
             <eref type="inline" bibitemid="ref1" citeas="XYZ" id="_">
                <localityStack connective="from">
                   <locality type="clause">
                      <referenceFrom>3.1</referenceFrom>
                   </locality>
                </localityStack>
                <localityStack connective="to">
                   <locality type="clause">
                      <referenceFrom>5.1</referenceFrom>
                   </locality>
                </localityStack>
             </eref>
             <semx element="eref" source="_">
                <fmt-eref type="inline" bibitemid="ref1" citeas="XYZ" droploc="">
                   <localityStack connective="from">
                      <locality type="clause">
                         <referenceFrom>3.1</referenceFrom>
                      </locality>
                   </localityStack>
                   <localityStack connective="to">
                      <locality type="clause">
                         <referenceFrom>5.1</referenceFrom>
                      </locality>
                   </localityStack>
                   XYZ, 3.1
                   <span class="fmt-conn">to</span>
                   5.1
                </fmt-eref>
             </semx>
             <eref type="inline" bibitemid="ref1" citeas="XYZ" id="_">
                <localityStack connective="from">
                   <locality type="clause">
                      <referenceFrom>3.1</referenceFrom>
                   </locality>
                </localityStack>
                <localityStack connective="to">
                   <locality type="clause">
                      <referenceFrom>5</referenceFrom>
                   </locality>
                </localityStack>
             </eref>
             <semx element="eref" source="_">
                <fmt-eref type="inline" bibitemid="ref1" citeas="XYZ" droploc="">
                   <localityStack connective="from">
                      <locality type="clause">
                         <referenceFrom>3.1</referenceFrom>
                      </locality>
                   </localityStack>
                   <localityStack connective="to">
                      <locality type="clause">
                         <referenceFrom>5</referenceFrom>
                      </locality>
                   </localityStack>
                   XYZ, 3.1
                   <span class="fmt-conn">to</span>
                   5
                </fmt-eref>
             </semx>
             <eref type="inline" bibitemid="ref1" citeas="XYZ" id="_">
                <localityStack connective="from">
                   <locality type="clause">
                      <referenceFrom>3.1</referenceFrom>
                   </locality>
                </localityStack>
                <localityStack connective="to">
                   <locality type="table">
                      <referenceFrom>5</referenceFrom>
                   </locality>
                </localityStack>
             </eref>
             <semx element="eref" source="_">
                <fmt-eref type="inline" bibitemid="ref1" citeas="XYZ">
                   <localityStack connective="from">
                      <locality type="clause">
                         <referenceFrom>3.1</referenceFrom>
                      </locality>
                   </localityStack>
                   <localityStack connective="to">
                      <locality type="table">
                         <referenceFrom>5</referenceFrom>
                      </locality>
                   </localityStack>
                   XYZ, 3.1
                   <span class="fmt-conn">to</span>
                   Table 5
                </fmt-eref>
             </semx>
          </p>
       </itu-standard>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)))).to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes concept markup" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword>
          <p id="A">
          <ul>
          <li>
          <concept><refterm>term</refterm>
              <xref target='clause1'/>
            </concept></li>
            <li><concept><refterm>term</refterm>
              <renderterm>term</renderterm>
              <xref target='clause1'/>
            </concept></li>
          <li><concept><refterm>term</refterm>
              <renderterm>w[o]rd</renderterm>
              <xref target='clause1'>Clause #1</xref>
            </concept></li>
            <li><concept><refterm>term</refterm>
              <renderterm>term</renderterm>
              <eref bibitemid="ISO712" type="inline" citeas="ISO 712"/>
            </concept></li>
            <li><concept><refterm>term</refterm>
              <renderterm>word</renderterm>
              <eref bibitemid="ISO712" type="inline" citeas="ISO 712">The Aforementioned Citation</eref>
            </concept></li>
            <li><concept><refterm>term</refterm>
              <renderterm>word</renderterm>
              <eref bibitemid="ISO712" type="inline" citeas="ISO 712">
                <locality type='clause'>
                  <referenceFrom>3.1</referenceFrom>
                </locality>
                <locality type='figure'>
                  <referenceFrom>a</referenceFrom>
                </locality>
              </eref>
            </concept></li>
            <li><concept><refterm>term</refterm>
              <renderterm>word</renderterm>
              <eref bibitemid="ISO712" type="inline" citeas="ISO 712">
              <localityStack connective="and">
                <locality type='clause'>
                  <referenceFrom>3.1</referenceFrom>
                </locality>
              </localityStack>
              <localityStack connective="and">
                <locality type='figure'>
                  <referenceFrom>b</referenceFrom>
                </locality>
              </localityStack>
              </eref>
            </concept></li>
            <li><concept><refterm>term</refterm>
              <renderterm>word</renderterm>
              <eref bibitemid="ISO712" type="inline" citeas="ISO 712">
              <localityStack connective="and">
                <locality type='clause'>
                  <referenceFrom>3.1</referenceFrom>
                </locality>
              </localityStack>
              <localityStack connective="and">
                <locality type='figure'>
                  <referenceFrom>b</referenceFrom>
                </locality>
              </localityStack>
              The Aforementioned Citation
              </eref>
            </concept></li>
            <li><concept><refterm>term</refterm></concept></li>
            <li><concept><refterm>term</refterm>
              <renderterm>word</renderterm>
              <termref base='IEV' target='135-13-13'/>
            </concept></li>
            <li><concept><refterm>term</refterm>
              <renderterm>word</renderterm>
              <termref base='IEV' target='135-13-13'>The IEV database</termref>
            </concept></li>
            <li><concept>
              <strong>error!</strong>
              </concept>
              </li>
            </ul>
          </p>
          </foreword></preface>
          <sections>
          <clause id="clause1"><title>Clause 1</title></clause>
          </sections>
          <bibliography><references id="_normative_references" obligation="informative" normative="true"><title>Normative References</title>
          <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
      <bibitem id="ISO712" type="standard">
        <title format="text/plain">Cereals or cereal products</title>
        <title type="main" format="text/plain">Cereals and cereal products</title>
        <docidentifier type="ISO">ISO 712</docidentifier>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Organization for Standardization</name>
          </organization>
        </contributor>
      </bibitem>
      </references></bibliography>
          </iso-standard>
    INPUT
    presxml = <<~OUTPUT
       <p id="A">
          <ul>
             <li id="_">
                <fmt-name id="_">
                   <semx element="autonum" source="_">–</semx>
                </fmt-name>
                <concept id="_">
                   <refterm>term</refterm>
                   <xref target="clause1" id="_"/>
                </concept>
                <fmt-concept>
                   <semx element="concept" source="_"/>
                </fmt-concept>
             </li>
             <li id="_">
                <fmt-name id="_">
                   <semx element="autonum" source="_">–</semx>
                </fmt-name>
                <concept id="_">
                   <refterm>term</refterm>
                   <renderterm>term</renderterm>
                   <xref target="clause1" id="_"/>
                </concept>
                <fmt-concept>
                   <semx element="concept" source="_">term</semx>
                </fmt-concept>
             </li>
             <li id="_">
                <fmt-name id="_">
                   <semx element="autonum" source="_">–</semx>
                </fmt-name>
                <concept id="_">
                   <refterm>term</refterm>
                   <renderterm>w[o]rd</renderterm>
                   <xref target="clause1" id="_">Clause #1</xref>
                </concept>
                <fmt-concept>
                   <semx element="concept" source="_">w[o]rd</semx>
                </fmt-concept>
             </li>
             <li id="_">
                <fmt-name id="_">
                   <semx element="autonum" source="_">–</semx>
                </fmt-name>
                <concept id="_">
                   <refterm>term</refterm>
                   <renderterm>term</renderterm>
                   <eref bibitemid="ISO712" type="inline" citeas="ISO 712" id="_"/>
                </concept>
                <fmt-concept>
                   <semx element="concept" source="_">term</semx>
                </fmt-concept>
             </li>
             <li id="_">
                <fmt-name id="_">
                   <semx element="autonum" source="_">–</semx>
                </fmt-name>
                <concept id="_">
                   <refterm>term</refterm>
                   <renderterm>word</renderterm>
                   <eref bibitemid="ISO712" type="inline" citeas="ISO 712" id="_">The Aforementioned Citation</eref>
                </concept>
                <fmt-concept>
                   <semx element="concept" source="_">word</semx>
                </fmt-concept>
             </li>
             <li id="_">
                <fmt-name id="_">
                   <semx element="autonum" source="_">–</semx>
                </fmt-name>
                <concept id="_">
                   <refterm>term</refterm>
                   <renderterm>word</renderterm>
                   <eref bibitemid="ISO712" type="inline" citeas="ISO 712" id="_">
                      <locality type="clause">
                         <referenceFrom>3.1</referenceFrom>
                      </locality>
                      <locality type="figure">
                         <referenceFrom>a</referenceFrom>
                      </locality>
                   </eref>
                </concept>
                <fmt-concept>
                   <semx element="concept" source="_">word</semx>
                </fmt-concept>
             </li>
             <li id="_">
                <fmt-name id="_">
                   <semx element="autonum" source="_">–</semx>
                </fmt-name>
                <concept id="_">
                   <refterm>term</refterm>
                   <renderterm>word</renderterm>
                   <eref bibitemid="ISO712" type="inline" citeas="ISO 712" id="_">
                      <localityStack connective="and">
                         <locality type="clause">
                            <referenceFrom>3.1</referenceFrom>
                         </locality>
                      </localityStack>
                      <localityStack connective="and">
                         <locality type="figure">
                            <referenceFrom>b</referenceFrom>
                         </locality>
                      </localityStack>
                   </eref>
                </concept>
                <fmt-concept>
                   <semx element="concept" source="_">word</semx>
                </fmt-concept>
             </li>
             <li id="_">
                <fmt-name id="_">
                   <semx element="autonum" source="_">–</semx>
                </fmt-name>
                <concept id="_">
                   <refterm>term</refterm>
                   <renderterm>word</renderterm>
                   <eref bibitemid="ISO712" type="inline" citeas="ISO 712" id="_">
                      <localityStack connective="and">
                         <locality type="clause">
                            <referenceFrom>3.1</referenceFrom>
                         </locality>
                      </localityStack>
                      <localityStack connective="and">
                         <locality type="figure">
                            <referenceFrom>b</referenceFrom>
                         </locality>
                      </localityStack>
                      The Aforementioned Citation
                   </eref>
                </concept>
                <fmt-concept>
                   <semx element="concept" source="_">word</semx>
                </fmt-concept>
             </li>
             <li id="_">
                <fmt-name id="_">
                   <semx element="autonum" source="_">–</semx>
                </fmt-name>
                <concept id="_">
                   <refterm>term</refterm>
                </concept>
                <fmt-concept>
                   <semx element="concept" source="_"/>
                </fmt-concept>
             </li>
             <li id="_">
                <fmt-name id="_">
                   <semx element="autonum" source="_">–</semx>
                </fmt-name>
                <concept id="_">
                   <refterm>term</refterm>
                   <renderterm>word</renderterm>
                   <termref base="IEV" target="135-13-13"/>
                </concept>
                <fmt-concept>
                   <semx element="concept" source="_">word</semx>
                </fmt-concept>
             </li>
             <li id="_">
                <fmt-name id="_">
                   <semx element="autonum" source="_">–</semx>
                </fmt-name>
                <concept id="_">
                   <refterm>term</refterm>
                   <renderterm>word</renderterm>
                   <termref base="IEV" target="135-13-13">The IEV database</termref>
                </concept>
                <fmt-concept>
                   <semx element="concept" source="_">word</semx>
                </fmt-concept>
             </li>
             <li id="_">
                <fmt-name id="_">
                   <semx element="autonum" source="_">–</semx>
                </fmt-name>
                <concept id="_">
                   <strong>error!</strong>
                </concept>
                <fmt-concept>
                   <semx element="concept" source="_">
                      <strong>error!</strong>
                   </semx>
                </fmt-concept>
             </li>
          </ul>
       </p>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))
    expect(Xml::C14n.format(strip_guid(xml.at("//xmlns:p[@id = 'A']").to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "duplicates MathML with AsciiMath and LaTeXMath" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml" xmlns:m='http://www.w3.org/1998/Math/MathML'>
      <preface><foreword>
      <p id="A">
      <stem type="MathML"><m:math>
        <m:msup> <m:mrow> <m:mo>(</m:mo> <m:mrow> <m:mi>x</m:mi> <m:mo>+</m:mo> <m:mi>y</m:mi> </m:mrow> <m:mo>)</m:mo> </m:mrow> <m:mn>2</m:mn> </m:msup>
      </m:math></stem>
      </p>
      </foreword></preface>
      <sections>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
       <p id="A">
          <stem type="MathML" id="_">
             <m:math>
                <m:msup>
                   <m:mrow>
                      <m:mo>(</m:mo>
                      <m:mrow>
                         <m:mi>x</m:mi>
                         <m:mo>+</m:mo>
                         <m:mi>y</m:mi>
                      </m:mrow>
                      <m:mo>)</m:mo>
                   </m:mrow>
                   <m:mn>2</m:mn>
                </m:msup>
             </m:math>
          </stem>
          <fmt-stem type="MathML">
             <semx element="stem" source="_">
                <m:math>
                   <m:msup>
                      <m:mrow>
                         <m:mo>(</m:mo>
                         <m:mrow>
                            <m:mi>x</m:mi>
                            <m:mo>+</m:mo>
                            <m:mi>y</m:mi>
                         </m:mrow>
                         <m:mo>)</m:mo>
                      </m:mrow>
                      <m:mn>2</m:mn>
                   </m:msup>
                </m:math>
                <latexmath>( x + y )^{2}</latexmath>
                <asciimath>(x + y)^(2)</asciimath>
             </semx>
          </fmt-stem>
       </p>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ieee::PresentationXMLConvert.new({})
      .convert("test", input, true))
    xml = xml.at("//xmlns:p[@id = 'A']")
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end
end
