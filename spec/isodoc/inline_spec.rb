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
                <formattedref>
                  <em>Cereals and cereal products</em>
                  .
                </formattedref>
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
end
