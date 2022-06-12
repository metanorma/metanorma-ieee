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
end
