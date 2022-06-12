require "spec_helper"

RSpec.describe Metanorma::IEEE do
  it "sorts terms" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Definitions

      === stem:[x_1]

      === Xanax

      === prozac
    INPUT
    output = <<~OUTPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
         <sections>
           <terms id='_' obligation='normative'>
             <title>Terms and definitions</title>
             <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
             <p id='_'>
               For the purposes of this document, the following terms and definitions
               apply. The
               <em>IEEE Standards Dictionary Online</em>
                should be consulted for terms not defined in this clause.
               <fn>
                 <p id='_'>
                   <em>IEEE Standards Dictionary Online</em>
                    is available at:
                   <link target='http://dictionary.ieee.org'/>
                   . An IEEE Account is required for access to the dictionary, and one
                   can be created at no charge on the dictionary sign-in page.
                 </p>
               </fn>
             </p>
             <term id='term-prozac'>
               <preferred>
                 <expression>
                   <name>prozac</name>
                 </expression>
               </preferred>
             </term>
             <term id='term-x1'>
               <preferred>
                 <letter-symbol>
                   <name>
                     <stem type='MathML'>
                       <math xmlns='http://www.w3.org/1998/Math/MathML'>
                         <msub>
                           <mrow>
                             <mi>x</mi>
                           </mrow>
                           <mrow>
                             <mn>1</mn>
                           </mrow>
                         </msub>
                       </math>
                     </stem>
                   </name>
                 </letter-symbol>
               </preferred>
             </term>
             <term id='term-Xanax'>
               <preferred>
                 <expression>
                   <name>Xanax</name>
                 </expression>
               </preferred>
             </term>
           </terms>
         </sections>
       </ieee-standard>
    OUTPUT
    out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    out.xpath("//xmlns:bibdata | //xmlns:boilerplate | //xmlns:references")
      .remove
    expect(xmlpp(strip_guid(out.to_xml)))
      .to be_equivalent_to xmlpp(output)
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
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
         <sections>
           <terms id='_' obligation='normative'>
             <title>Terms and definitions</title>
             <p id='_'>For the purposes of this document, the following terms and definitions apply.</p>
             <p id='_'>
               For the purposes of this document, the following terms and definitions
               apply. The
               <em>IEEE Standards Dictionary Online</em>
                should be consulted for terms not defined in this clause.
               <fn>
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
    out.xpath("//xmlns:bibdata | //xmlns:boilerplate | //xmlns:references")
      .remove
    expect(xmlpp(strip_guid(out.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end
end
