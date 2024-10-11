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

      [.source]
      <<ISO2191,section=1>>,
    INPUT
    output = <<~OUTPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::Ieee::VERSION}'>
               <sections>
           <terms id='_' obligation='normative'>
             <title>Definitions</title>
             <p id='_'>
               For the purposes of this document, the following terms and definitions
               apply. The
               <em>IEEE Standards Dictionary Online</em>
                should be consulted for terms not defined in this clause.
               <fn reference='1'>
                 <p id='_'>
                   <em>IEEE Standards Dictionary Online</em>
                    is available at:
                   <link target='http://dictionary.ieee.org'/>
                   . An IEEE Account is required for access to the dictionary, and one
                   can be created at no charge on the dictionary sign-in page.
                 </p>
               </fn>
             </p>
             <term id='term-Term1'>
               <preferred>
                 <expression>
                   <name>Term1</name>
                 </expression>
               </preferred>
               <definition>
                 <verbal-definition>
                   <p id='_'>X</p>
                 </verbal-definition>
               </definition>
               <termsource status='adapted' type='authoritative'>
                 <origin bibitemid='ISO2191' type='inline' citeas=''>
                   <localityStack>
                     <locality type='section'>
                       <referenceFrom>1</referenceFrom>
                     </locality>
                   </localityStack>
                 </origin>
               </termsource>
             </term>
             <term id='term-Term2'>
               <preferred>
                 <expression>
                   <name>Term2</name>
                 </expression>
               </preferred>
               <definition>
                 <verbal-definition>
                   <p id='_'>X</p>
                 </verbal-definition>
               </definition>
               <termsource status='modified' type='authoritative'>
                 <origin bibitemid='ISO2191' type='inline' citeas=''>
                   <localityStack>
                     <locality type='section'>
                       <referenceFrom>1</referenceFrom>
                     </locality>
                   </localityStack>
                 </origin>
                 <modification/>
               </termsource>
             </term>
           </terms>
         </sections>
       </ieee-standard>
    OUTPUT
    out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    out.xpath("//xmlns:bibdata | //xmlns:boilerplate | //xmlns:references | " \
              "//xmlns:metanorma-extension").remove
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
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
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::Ieee::VERSION}'>
         <sections>
           <terms id='_' obligation='normative'>
             <title>Definitions</title>
             <p id='_'>
               For the purposes of this document, the following terms and definitions
               apply. The
               <em>IEEE Standards Dictionary Online</em>
                should be consulted for terms not defined in this clause.
               <fn reference='1'>
                 <p id='_'>
                   <em>IEEE Standards Dictionary Online</em>
                    is available at:
                   <link target='http://dictionary.ieee.org'/>
                   . An IEEE Account is required for access to the dictionary, and one
                   can be created at no charge on the dictionary sign-in page.
                 </p>
               </fn>
             </p>
             <term id='term-doovywhack'>
               <preferred>
                 <expression>
                   <name>doovywhack</name>
                 </expression>
               </preferred>
             </term>
             <term id='term-thing'>
               <preferred>
                 <expression>
                   <name>thing</name>
                 </expression>
               </preferred>
             </term>
             <term id='term-thingummijig'>
               <preferred>
                 <expression>
                   <name>thingummijig</name>
                 </expression>
               </preferred>
             </term>
             <term id='term-thingummy'>
               <preferred>
                 <expression>
                   <name>thingummy</name>
                 </expression>
               </preferred>
             </term>
             <term id='term-whatsit'>
               <preferred>
                 <expression>
                   <name>whatsit</name>
                 </expression>
               </preferred>
             </term>
             <term id='term-widget'>
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
               <related type='contrast'>
                 <preferred>
                   <expression>
                     <name>thing</name>
                   </expression>
                 </preferred>
                 <xref target='term-thing'>thing</xref>
               </related>
               <related type='equivalent'>
                 <preferred>
                   <expression>
                     <name>doovywhack</name>
                   </expression>
                 </preferred>
                 <xref target='term-doovywhack'>doovywhack</xref>
               </related>
               <related type='see'>
                 <preferred>
                   <expression>
                     <name>thing</name>
                   </expression>
                 </preferred>
                 <xref target='term-thing'>thing</xref>
               </related>
               <related type='see'>
                 <preferred>
                   <expression>
                     <name>thingummijig</name>
                   </expression>
                 </preferred>
                 <xref target='term-thingummijig'>thingummijig</xref>
               </related>
               <related type='see'>
                 <preferred>
                   <expression>
                     <name>thingummy</name>
                   </expression>
                 </preferred>
                 <xref target='term-thingummy'>thingummy</xref>
               </related>
               <related type='seealso'>
                 <preferred>
                   <expression>
                     <name>whatsit</name>
                   </expression>
                 </preferred>
                 <xref target='term-whatsit'>whatsit</xref>
               </related>
                // Metanorma term for synonym
               <definition>
                 <verbal-definition>
                   <p id='_'>device performing an unspecified function.</p>
                 </verbal-definition>
               </definition>
               <definition>
                 <verbal-definition>
                   <p id='_'>general metasyntactic variable.</p>
                 </verbal-definition>
               </definition>
             </term>
           </terms>
         </sections>
       </ieee-standard>
    OUTPUT
    out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    out.xpath("//xmlns:bibdata | //xmlns:boilerplate | //xmlns:references | " \
              "//xmlns:metanorma-extension").remove
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
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
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::Ieee::VERSION}'>
        <sections>
          <terms id='_' obligation='normative'>
            <title>Definitions</title>
            <p id='_'>
              For the purposes of this document, the following terms and definitions
              apply. The
              <em>IEEE Standards Dictionary Online</em>
               should be consulted for terms not defined in this clause.
              <fn reference='1'>
                <p id='_'>
                  <em>IEEE Standards Dictionary Online</em>
                   is available at:
                  <link target='http://dictionary.ieee.org'/>
                  . An IEEE Account is required for access to the dictionary, and one
                  can be created at no charge on the dictionary sign-in page.
                </p>
              </fn>
            </p>
            <term id='term-widget'>
              <preferred>
                <expression>
                  <name>widget</name>
                </expression>
              </preferred>
              <related type='contrast'>
              <refterm>thing</refterm>
               </related>
                      <definition>
          <verbal-definition>
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
      </ieee-standard>
    OUTPUT
    out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    out.xpath("//xmlns:bibdata | //xmlns:boilerplate | //xmlns:references | " \
              "//xmlns:metanorma-extension").remove
    expect(Xml::C14n.format(strip_guid(out.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end
end
