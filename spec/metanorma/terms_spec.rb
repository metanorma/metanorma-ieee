require "spec_helper"

RSpec.describe Metanorma::Ieee do
  it "processes adapted termsources" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Terms and Definitions

      === Term1

      X

      [.source%adapted]
      <<ISO2191,section=1>>

      === Term2

      X

      [NOTE]
      This is a note

      [NOTE,type=license]
      This is not a note but a license statement associated with the source

      [.source]
      <<ISO2191,section=1>>,

    INPUT
    output = <<~OUTPUT
      <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version='#{Metanorma::Ieee::VERSION}' flavor="ieee">
               <sections>
           <terms id='_' obligation='normative'>
             <title id="_">Definitions</title>
             <p id='_'>
               For the purposes of this document, the following terms and definitions
               apply. The
               <em>IEEE Standards Dictionary Online</em>
                should be consulted for terms not defined in this clause.
               <fn id="_" reference='1'>
                 <p id='_'>
                   <em>IEEE Standards Dictionary Online</em>
                    is available at:
                   <link target='http://dictionary.ieee.org'/>
                   . An IEEE Account is required for access to the dictionary, and one
                   can be created at no charge on the dictionary sign-in page.
                 </p>
               </fn>
             </p>
             <term id="_" anchor="term-Term1">
               <preferred>
                 <expression>
                   <name>Term1</name>
                 </expression>
               </preferred>
               <definition id="_">
                 <verbal-definition id="_">
                   <p id='_'>X</p>
                 </verbal-definition>
               </definition>
               <source status='adapted' type='authoritative'>
                 <origin bibitemid='ISO2191' type='inline' citeas=''>
                   <localityStack>
                     <locality type='section'>
                       <referenceFrom>1</referenceFrom>
                     </locality>
                   </localityStack>
                 </origin>
               </source>
             </term>
             <term id="_" anchor="term-Term2">
               <preferred>
                 <expression>
                   <name>Term2</name>
                 </expression>
               </preferred>
               <definition id="_">
                 <verbal-definition id="_">
                   <p id='_'>X</p>
                 </verbal-definition>
               </definition>
               <termnote id="_">
               <p id="_">This is a note
                  <fn reference="1" id="_">
                     <p id="_">Notes to text, tables, and figures are for information only and do not contain requirements needed to implement the standard.</p>
                  </fn>
               </p>
            </termnote>
            <termnote id="_" type="license">
               <p id="_">This is not a note but a license statement associated with the source</p>
            </termnote>
               <source status='modified' type='authoritative'>
                 <origin bibitemid='ISO2191' type='inline' citeas=''>
                   <localityStack>
                     <locality type='section'>
                       <referenceFrom>1</referenceFrom>
                     </locality>
                   </localityStack>
                 </origin>
                 <modification/>
               </source>
             </term>
           </terms>
         </sections>
       </metanorma>
    OUTPUT
    out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    out.xpath("//xmlns:bibdata | //xmlns:boilerplate | //xmlns:references | " \
              "//xmlns:metanorma-extension").remove
    expect(Canon.format_xml(strip_guid(out.to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "renders a full term" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Definitions
      === widget

      alt:[doohickey]

      related:contrast[thing]

      related:see[thingummy]
      related:see[thing]
      related:see[thingummijig]

      related:seealso[whatsit]

      related:equivalent[doovywhack] // Metanorma term for synonym

      [.definition]
      --
      device performing an unspecified function.
      --

      [.definition]
      --
      general metasyntactic variable.
      --

      === thing

      === thingummy

      === thingummijig

      === doovywhack

      === whatsit

    INPUT
    output = <<~OUTPUT
      <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version='#{Metanorma::Ieee::VERSION}' flavor="ieee">
           <sections>
              <terms id="_" obligation="normative">
                 <title id="_">Definitions</title>
                 <p id="_">
                    For the purposes of this document, the following terms and definitions apply. The
                    <em>IEEE Standards Dictionary Online</em>
                    should be consulted for terms not defined in this clause.
                    <fn id="_" reference="1">
                       <p id="_">
                          <em>IEEE Standards Dictionary Online</em>
                          is available at:
                          <link target="http://dictionary.ieee.org"/>
                          . An IEEE Account is required for access to the dictionary, and one can be created at no charge on the dictionary sign-in page.
                       </p>
                    </fn>
                 </p>
                 <term id="_" anchor="term-widget">
                    <preferred>
                       <expression>
                          <name>widget</name>
                       </expression>
                    </preferred>
                    <admitted>
                       <expression>
                          <name>doohickey</name>
                       </expression>
                    </admitted>
                    <related type="contrast">
                       <preferred>
                          <expression>
                             <name>thing</name>
                          </expression>
                       </preferred>
                       <xref target="term-thing">
                          <display-text>thing</display-text>
                       </xref>
                    </related>
                    <related type="see">
                       <preferred>
                          <expression>
                             <name>thingummy</name>
                          </expression>
                       </preferred>
                       <xref target="term-thingummy">
                          <display-text>thingummy</display-text>
                       </xref>
                    </related>
                    <related type="see">
                       <preferred>
                          <expression>
                             <name>thing</name>
                          </expression>
                       </preferred>
                       <xref target="term-thing">
                          <display-text>thing</display-text>
                       </xref>
                    </related>
                    <related type="see">
                       <preferred>
                          <expression>
                             <name>thingummijig</name>
                          </expression>
                       </preferred>
                       <xref target="term-thingummijig">
                          <display-text>thingummijig</display-text>
                       </xref>
                    </related>
                    <related type="seealso">
                       <preferred>
                          <expression>
                             <name>whatsit</name>
                          </expression>
                       </preferred>
                       <xref target="term-whatsit">
                          <display-text>whatsit</display-text>
                       </xref>
                    </related>
                    <related type="equivalent">
                       <preferred>
                          <expression>
                             <name>doovywhack</name>
                          </expression>
                       </preferred>
                       <xref target="term-doovywhack">
                          <display-text>doovywhack</display-text>
                       </xref>
                    </related>
                    // Metanorma term for synonym
                    <definition id="_">
                       <verbal-definition id="_">
                          <p id="_">device performing an unspecified function.</p>
                       </verbal-definition>
                    </definition>
                    <definition id="_">
                       <verbal-definition id="_">
                          <p id="_">general metasyntactic variable.</p>
                       </verbal-definition>
                    </definition>
                 </term>
                 <term id="_" anchor="term-thing">
                    <preferred>
                       <expression>
                          <name>thing</name>
                       </expression>
                    </preferred>
                 </term>
                 <term id="_" anchor="term-thingummy">
                    <preferred>
                       <expression>
                          <name>thingummy</name>
                       </expression>
                    </preferred>
                 </term>
                 <term id="_" anchor="term-thingummijig">
                    <preferred>
                       <expression>
                          <name>thingummijig</name>
                       </expression>
                    </preferred>
                 </term>
                 <term id="_" anchor="term-doovywhack">
                    <preferred>
                       <expression>
                          <name>doovywhack</name>
                       </expression>
                    </preferred>
                 </term>
                 <term id="_" anchor="term-whatsit">
                    <preferred>
                       <expression>
                          <name>whatsit</name>
                       </expression>
                    </preferred>
                 </term>
              </terms>
           </sections>
        </metanorma>
    OUTPUT
    out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    out.xpath("//xmlns:bibdata | //xmlns:boilerplate | //xmlns:references | " \
              "//xmlns:metanorma-extension").remove
    expect(Canon.format_xml(strip_guid(out.to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "deals with missing terms" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Definitions
      === widget

      related:contrast[thing]

      symbol:[thing1]
    INPUT
    output = <<~OUTPUT
      <metanorma xmlns='https://www.metanorma.org/ns/standoc' type='semantic' version='#{Metanorma::Ieee::VERSION}' flavor="ieee">
        <sections>
          <terms id='_' obligation='normative'>
            <title id="_">Definitions</title>
            <p id='_'>
              For the purposes of this document, the following terms and definitions
              apply. The
              <em>IEEE Standards Dictionary Online</em>
               should be consulted for terms not defined in this clause.
              <fn id="_" reference='1'>
                <p id='_'>
                  <em>IEEE Standards Dictionary Online</em>
                   is available at:
                  <link target='http://dictionary.ieee.org'/>
                  . An IEEE Account is required for access to the dictionary, and one
                  can be created at no charge on the dictionary sign-in page.
                </p>
              </fn>
            </p>
            <term id="_" anchor="term-widget">
              <preferred>
                <expression>
                  <name>widget</name>
                </expression>
              </preferred>
              <related type='contrast'>
              <refterm>thing</refterm>
               </related>
                      <definition id="_">
          <verbal-definition id="_">
            <p id='_'>
              <concept>
                <strong>
                  symbol
                  <tt>thing1</tt>
                   not resolved via ID
                  <tt>thing1</tt>
                </strong>
              </concept>
            </p>
          </verbal-definition>
        </definition>
            </term>
          </terms>
        </sections>
      </metanorma>
    OUTPUT
    out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    out.xpath("//xmlns:bibdata | //xmlns:boilerplate | //xmlns:references | " \
              "//xmlns:metanorma-extension").remove
    expect(Canon.format_xml(strip_guid(out.to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end
end
