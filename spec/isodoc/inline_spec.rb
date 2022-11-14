require "spec_helper"

RSpec.describe IsoDoc::IEEE do
  it "processes eref content" do
    output = IsoDoc::IEEE::PresentationXMLConvert.new({})
      .convert("test", <<~"INPUT", true)
        <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface>
            <foreword>
              <p>
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
                    <abbreviation>ISO</abbreviation>
                  </organization>
                </contributor>
              </bibitem>
            </references>
          </bibliography>
        </iso-standard>
      INPUT
    expect(xmlpp(output)
      .sub(%r{<i18nyaml>.*</i18nyaml>}m, ""))
      .to be_equivalent_to xmlpp(<<~"OUTPUT")
        <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
          <preface>
            <foreword displayorder='1'>
              <p>
                <eref bibitemid='IEV' citeas='IEV' type='inline'>
                  <locality type='clause'>
                    <referenceFrom>1-2-3</referenceFrom>
                  </locality>
                  IEV, 1-2-3
                </eref>
                <eref bibitemid='ISO712' citeas='ISO 712' type='inline'>ISO 712</eref>
                <eref bibitemid='ISO712' type='inline'>ISO 712</eref>
                <eref bibitemid='ISO712' type='inline'>
                  <locality type='table'>
                    <referenceFrom>1</referenceFrom>
                  </locality>
                  ISO 712, Table 1
                </eref>
                <eref bibitemid='ISO712' type='inline'>
                  <locality type='table'>
                    <referenceFrom>1</referenceFrom>
                    <referenceTo>1</referenceTo>
                  </locality>
                  ISO 712, Table 1&#x2013;1
                </eref>
                <eref bibitemid='ISO712' type='inline'>
                  <locality type='clause'>
                    <referenceFrom>1</referenceFrom>
                  </locality>
                  <locality type='table'>
                    <referenceFrom>1</referenceFrom>
                  </locality>
                  ISO 712, Clause 1, Table 1
                </eref>
                <eref bibitemid='ISO712' type='inline'>
                  <locality type='clause'>
                    <referenceFrom>1</referenceFrom>
                  </locality>
                  <locality type='list'>
                    <referenceFrom>a</referenceFrom>
                  </locality>
                  ISO 712, Clause 1, List a)
                </eref>
                <eref bibitemid='ISO712' type='inline'>
                  <locality type='clause'>
                    <referenceFrom>1</referenceFrom>
                  </locality>
                  ISO 712, Clause 1
                </eref>
                <eref bibitemid='ISO712' type='inline'>
                  <locality type='clause'>
                    <referenceFrom>1.5</referenceFrom>
                  </locality>
                  ISO 712, 1.5
                </eref>
                <eref bibitemid='ISO712' type='inline'>
                  <locality type='table'>
                    <referenceFrom>1</referenceFrom>
                  </locality>
                  A
                </eref>
                <eref bibitemid='ISO712' type='inline'>
                  <locality type='whole'/>
                  ISO 712, Whole of text
                </eref>
                <eref bibitemid='ISO712' type='inline'>
                  <locality type='locality:prelude'>
                    <referenceFrom>7</referenceFrom>
                  </locality>
                  ISO 712, Prelude 7
                </eref>
                <eref bibitemid='ISO712' citeas='ISO 712' type='inline'>A</eref>
                <eref bibitemid='ISO712' citeas='ISO/IEC DIR 1' type='inline'>ISO/IEC DIR 1</eref>
              </p>
            </foreword>
          </preface>
          <bibliography>
            <references id='_normative_references' normative='true' obligation='informative' displayorder='2'>
              <title depth='1'>
                1.
                <tab/>
                Normative References
              </title>
              <bibitem id='ISO712' type='standard'>
                <formattedref>Cereals and cereal products.</formattedref>
                <title format='text/plain'>Cereals and cereal products</title>
                <docidentifier>ISO 712</docidentifier>
              </bibitem>
            </references>
          </bibliography>
        </iso-standard>
      OUTPUT
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
          <itu-standard xmlns='https://www.calconnect.org/standards/itu' type='presentation'>
        <p id='_'>
          <eref type='inline' bibitemid='ref1' citeas='XYZ' droploc=''>
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
            XYZ, Clause 3 to 5
          </eref>
          <eref type='inline' bibitemid='ref1' citeas='XYZ' droploc=''>
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
            XYZ, 3.1 to 5.1
          </eref>
          <eref type='inline' bibitemid='ref1' citeas='XYZ' droploc=''>
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
            XYZ, 3.1 to 5
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
            XYZ, 3.1 to Table 5
          </eref>
        </p>
      </itu-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::IEEE::PresentationXMLConvert.new({})
      .convert("test", input, true))).to be_equivalent_to xmlpp(output)
  end

  it "processes concept markup" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword>
          <p>
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
      <foreword displayorder='1'>
        <p>
          <ul>
            <li> </li>
            <li>term</li>
            <li>w[o]rd</li>
            <li>term</li>
            <li>word</li>
            <li>word</li>
            <li>word</li>
            <li>word</li>
            <li/>
            <li>word</li>
            <li>word</li>
              <li>
                <strong>error!</strong>
              </li>
          </ul>
        </p>
        </foreword>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::IEEE::PresentationXMLConvert.new({})
      .convert("test", input, true))
    expect(xmlpp(xml.at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "duplicates MathML with AsciiMath and LaTeXMath" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml" xmlns:m='http://www.w3.org/1998/Math/MathML'>
      <preface><foreword>
      <p>
      <stem type="MathML"><m:math>
        <m:msup> <m:mrow> <m:mo>(</m:mo> <m:mrow> <m:mi>x</m:mi> <m:mo>+</m:mo> <m:mi>y</m:mi> </m:mrow> <m:mo>)</m:mo> </m:mrow> <m:mn>2</m:mn> </m:msup>
      </m:math></stem>
      </p>
      </foreword></preface>
      <sections>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' xmlns:m='http://www.w3.org/1998/Math/MathML' type='presentation'>
        <preface>
          <foreword displayorder='1'>
            <p>
              <stem type='MathML'>
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
                 <latexmath>{(x+y)}^{2}</latexmath>
                 <asciimath>(x+y)^2</asciimath>
              </stem>
            </p>
          </foreword>
        </preface>
        <sections> </sections>
      </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::IEEE::PresentationXMLConvert.new({})
      .convert("test", input, true)))
      .to be_equivalent_to xmlpp(output)
  end

end
