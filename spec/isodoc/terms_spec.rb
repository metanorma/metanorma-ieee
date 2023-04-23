require "spec_helper"

RSpec.describe IsoDoc do
  it "processes IsoXML terms" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
          <p>For the purposes of this document, the following terms and definitions apply.</p>
      <term id="paddy1"><preferred><expression><name>paddy</name></expression>
      <field-of-application>in agriculture</field-of-application>
      <usage-info>dated</usage-info>
            <termsource status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </termsource>
      </preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></verbal-definition></definition>
      <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f892"  keep-with-next="true" keep-lines-together="true">
        <p id="_65c9a509-9a89-4b54-a890-274126aeb55c">Foreign seeds, husks, bran, sand, dust.</p>
        <ul>
        <li>A</li>
        </ul>
      </termexample>
      <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f894">
        <ul>
        <li>A</li>
        </ul>
      </termexample>
      <termsource status='adapted'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'>t1</termref>
          </origin>
          <modification>
            <p id='_'/>
          </modification>
        </termsource>
        <termsource status='adapted'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'/>
          </origin>
          <modification>
            <p id='_'>with adjustments</p>
          </modification>
        </termsource>
      </term>
      <term id="paddy"><preferred><expression><name>paddy</name></expression></preferred>
      <admitted><letter-symbol><name>paddy rice</name></letter-symbol>
      <field-of-application>in agriculture</field-of-application>
      </admitted>
      <admitted><expression><name>rough rice</name></expression></admitted>
      <deprecates><expression><name>cargo rice</name></expression></deprecates>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></verbal-definition></definition>
      <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f893">
        <ul>
        <li>A</li>
        </ul>
      </termexample>
      <termnote id="_671a1994-4783-40d0-bc81-987d06ffb74e"  keep-with-next="true" keep-lines-together="true">
        <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
      </termnote>
      <termnote id="_671a1994-4783-40d0-bc81-987d06ffb74f">
      <ul><li>A</li></ul>
        <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
      </termnote>
      <termsource status="identical">
        <origin bibitemid="ISO7301" type="inline" droploc="true" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
      </termsource></term>
      </terms>
      </sections>
      </iso-standard>
    INPUT

    presxml = <<~PRESXML
          <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
            <preface> <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause> </preface>
        <sections>
          <terms id='_' obligation='normative' displayorder='2'>
            <title depth='1'>
              1.
              <tab/>
              Terms and Definitions
            </title>
            <p>For the purposes of this document, the following terms and definitions apply.</p>
            <term id='paddy1'>
              <p>
                <strong>paddy</strong>
                , &#x3c;rice&#x3e;, &#x3c;in agriculture, dated&#x3e;: rice retaining
                its husk after threshing (<origin bibitemid='ISO7301' type='inline' citeas='ISO 7301:2011'><locality type='clause'><referenceFrom>3.1</referenceFrom></locality>ISO&#xa0;7301:2011, 3.1</origin>, modified &#x2013; The term "cargo rice" is shown as deprecated, and
                Note 1 to entry is not included here)
              </p>
              <termexample id='_' keep-with-next='true' keep-lines-together='true'>
                <name>Example 1</name>
                <p id='_'>Foreign seeds, husks, bran, sand, dust.</p>
                <ul>
                  <li>A</li>
                </ul>
              </termexample>
              <termexample id='_'>
                <name>Example 2</name>
                <ul>
                  <li>A</li>
                </ul>
              </termexample>
              <termsource status='adapted'>
                adapted from
                <origin citeas=''>
                  <termref base='IEV' target='xyz'>t1</termref>
                </origin>
                , modified ;
                <origin citeas=''>
                  <termref base='IEV' target='xyz'/>
                </origin>
                , modified &#x2013; with adjustments
              </termsource>
            </term>
            <term id='paddy'>
              <p>
                <strong>paddy</strong>
                : rice retaining its husk after threshing
                <em>Syn:</em>
                <strong>paddy rice</strong>
                , &#x3c;in agriculture&#x3e;;
                <strong>rough rice</strong>. (<origin bibitemid='ISO7301' type='inline' droploc='true' citeas='ISO 7301:2011'><locality type='clause'><referenceFrom>3.1</referenceFrom></locality>ISO&#xa0;7301:2011, 3.1</origin>)</p>
              <deprecates>DEPRECATED: cargo rice</deprecates>
              <termexample id='_'>
                <name>Example</name>
                <ul>
                  <li>A</li>
                </ul>
              </termexample>
              <termnote id='_' keep-with-next='true' keep-lines-together='true'>
                <name>NOTE 1</name>
                <p id='_'>The starch of waxy rice consists almost entirely of amylopectin. The
                  kernels have a tendency to stick together after cooking.
                </p>
              </termnote>
              <termnote id='_'>
                <name>NOTE 2</name>
                <ul>
                  <li>A</li>
                </ul>
                <p id='_'>
                  The starch of waxy rice consists almost entirely of amylopectin. The
                  kernels have a tendency to stick together after cooking.
                </p>
              </termnote>
            </term>
                  <term>
        <p>
          <strong>paddy rice</strong>
          , &#x3c;in agriculture&#x3e;:
          <em>See:</em>
          <strong>paddy</strong>
          .
        </p>
      </term>
      <term>
        <p>
          <strong>rough rice</strong>
          :
          <em>See:</em>
          <strong>paddy</strong>
          .
        </p>
      </term>
          </terms>
        </sections>
      </iso-standard>
    PRESXML

    html = <<~"OUTPUT"
       #{HTML_HDR}
            <p class='zzSTDTitle1'/>
            <div id='_'>
              <h1> 1. &#xa0; Terms and Definitions </h1>
              <p>For the purposes of this document, the following terms and definitions apply.</p>
              <p class='TermNum' id='paddy1'/>
              <p>
                <b>paddy</b>
                 , &#x3c;rice&#x3e;, &#x3c;in agriculture, dated&#x3e;: rice retaining
                its husk after threshing (ISO&#xa0;7301:2011, 3.1,  modified &#x2013;
                The term "cargo rice" is shown as deprecated, and Note 1 to entry is not
                included here)
              </p>
              <div id='_' class='example' style='page-break-after: avoid;page-break-inside: avoid;'>
                <p class='example-title'>Example 1:</p>
                <p id='_'>Foreign seeds, husks, bran, sand, dust.</p>
                <ul>
                  <li>A</li>
                </ul>
              </div>
              <div id='_' class='example'>
                <p class='example-title'>Example 2:</p>
                <ul>
                  <li>A</li>
                </ul>
              </div>
              <p>
                 adapted from t1 , modified ; Termbase IEV, term ID xyz , modified &#x2013; with
                adjustments
              </p>
              <p class='TermNum' id='paddy'/>
              <p>
                <b>paddy</b>
                 : rice retaining its husk after threshing
                <i>Syn:</i>
                <b>paddy rice</b>
                 , &#x3c;in agriculture&#x3e;;
                <b>rough rice</b>. (ISO&#xa0;7301:2011, 3.1)
              </p>
              <p class='DeprecatedTerms' style='text-align:left;'>DEPRECATED: cargo rice</p>
              <div id='_' class='example'>
                <p class='example-title'>Example:</p>
                <ul>
                  <li>A</li>
                </ul>
              </div>
              <div id='_' class='Note' style='page-break-after: avoid;page-break-inside: avoid;'>
                <p>NOTE 1&#x2014;The starch of waxy rice consists almost entirely of
                  amylopectin. The kernels have a tendency to stick together after
                  cooking.
                </p>
              </div>
              <div id='_' class='Note'>
                <p>NOTE 2&#x2014;
                  <ul>
                    <li>A</li>
                  </ul>
                  <p id='_'>
                     The starch of waxy rice consists almost entirely of amylopectin.
                    The kernels have a tendency to stick together after cooking.
                  </p>
                </p>
              </div>
                   <p class='TermNum' id=''/>
      <p>
        <b>paddy rice</b>
         , &#x3c;in agriculture&#x3e;:
        <i>See:</i>
        <b>paddy</b>
         .
      </p>
      <p class='TermNum' id=''/>
      <p>
        <b>rough rice</b>
         :
        <i>See:</i>
        <b>paddy</b>
         .
      </p>
            </div>
          </div>
        </body>
    OUTPUT

    word = <<~WORD
      <body lang='EN-US' link='blue' vlink='#954F72'>
         <div class='WordSection1'>
           <p>&#xa0;</p>
         </div>
         <p>
           <br clear='all' class='section'/>
         </p>
         <div class='WordSection2'>
             <div class="WordSectionContents">
            <h1 class="IEEEStdsLevel1frontmatter">Contents</h1>
          </div>
           <p>&#xa0;</p>
         </div>
         <p>
           <br clear='all' class='section'/>
         </p>
         <div class='WordSectionMiddleTitle'>
           <p class='IEEEStdsTitle' style='margin-top:70.0pt'>??? for ???</p>
         </div>
         <p>
           <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
         </p>
         <div class='WordSectionMain'>
           <div id='_'>
             <h1>
                1.
               <span style='mso-tab-count:1'>&#xa0; </span>
                Terms and Definitions
             </h1>
             <p>For the purposes of this document, the following terms and definitions apply.</p>
             <p class='TermNum' id='paddy1'/>
             <p>
               <b>paddy</b>
                , &#x3c;rice&#x3e;, &#x3c;in agriculture, dated&#x3e;: rice retaining
               its husk after threshing (ISO&#xa0;7301:2011, 3.1, modified &#x2013;
               The term "cargo rice" is shown as deprecated, and Note 1 to entry is not
               included here)
             </p>
             <div id='_' class='example' style='page-break-after: avoid;page-break-inside: avoid;'>
               <p class='example-title'>Example 1:</p>
               <p id='_'>Foreign seeds, husks, bran, sand, dust.</p>
               <ul>
                 <li>A</li>
               </ul>
             </div>
             <div id='_' class='example'>
               <p class='example-title'>Example 2:</p>
               <ul>
                 <li>A</li>
               </ul>
             </div>
             <p>
                adapted from t1 , modified ; Termbase IEV, term ID xyz , modified &#x2013; with
               adjustments
             </p>
             <p class='TermNum' id='paddy'/>
             <p>
               <b>paddy</b>
                : rice retaining its husk after threshing
               <i>Syn:</i>
               <b>paddy rice</b>
                , &#x3c;in agriculture&#x3e;;
               <b>rough rice</b>. (ISO&#xa0;7301:2011, 3.1)
             </p>
             <p class='DeprecatedTerms' style='text-align:left;'>DEPRECATED: cargo rice</p>
             <div id='_' class='example'>
               <p class='example-title'>Example:</p>
               <ul>
                 <li>A</li>
               </ul>
             </div>
             <div id='_' class='Note' style='page-break-after: avoid;page-break-inside: avoid;'>
               <p>
                 <span class='note_label'>NOTE 1&#x2014;</span>
                 The starch of waxy rice consists almost entirely of amylopectin. The
                 kernels have a tendency to stick together after cooking.
               </p>
             </div>
             <div id='_' class='Note'>
               <p>
                 <span class='note_label'>NOTE 2&#x2014;</span>
                 <ul>
                   <li>A</li>
                 </ul>
                 <p id='_'>
                    The starch of waxy rice consists almost entirely of amylopectin.
                   The kernels have a tendency to stick together after cooking.
                 </p>
               </p>
             </div>
                   <p class='TermNum' id=''/>
      <p>
        <b>paddy rice</b>
         , &#x3c;in agriculture&#x3e;:
        <i>See:</i>
        <b>paddy</b>
         .
      </p>
      <p class='TermNum' id=''/>
      <p>
        <b>rough rice</b>
         :
        <i>See:</i>
        <b>paddy</b>
         .
      </p>
           </div>
         </div>
         </body>
    WORD

    expect(xmlpp(strip_guid(IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(Nokogiri::XML(IsoDoc::IEEE::HtmlConvert.new({})
      .convert("test", presxml, true))
      .at("//body").to_xml)).to be_equivalent_to xmlpp(html)
    expect(xmlpp(Nokogiri::XML(IsoDoc::IEEE::WordConvert.new({})
      .convert("test", presxml, true))
                .at("//body").to_xml)).to be_equivalent_to xmlpp(word)
  end

  it "sorts terms" do
    input = <<~INPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
         <sections>
           <terms id='_' obligation='normative'>
             <title>Definitions</title>
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
             <term id='term-prozac'>
               <preferred>
                 <expression>
                   <name>prozac</name>
                 </expression>
               </preferred>
             </term>
           </terms>
         </sections>
       </ieee-standard>
    INPUT
    output = <<~OUTPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='presentation' version='#{Metanorma::IEEE::VERSION}'>
            <preface> <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause> </preface>
        <sections>
          <terms id='_' obligation='normative' displayorder='2'>
            <title depth='1'>
              1.
              <tab/>
              Definitions
            </title>
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
              <p>
                <strong>prozac</strong>
                :
              </p>
            </term>
            <term id='term-x1'>
              <p><strong><stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><mstyle mathvariant="bold"><msub><mrow><mi>x</mi></mrow><mrow><mn>1</mn></mrow></msub></mstyle></math><latexmath>\\mathbf{{x}_{1}}</latexmath><asciimath>mathbf(x_(1))</asciimath></stem></strong>:   </p>
            </term>
            <term id='term-Xanax'>
              <p>
                <strong>Xanax</strong>
                :
              </p>
            </term>
          </terms>
        </sections>
      </ieee-standard>
    OUTPUT
    expect(xmlpp(strip_guid(IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
        .convert("test", input, true)))).to be_equivalent_to xmlpp(output)
  end

  it "processes IsoXML term with multiple paragraph definitions" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
          <p>For the purposes of this document, the following terms and definitions apply.</p>
      <term id="paddy1"><preferred><expression><name>paddy</name></expression></preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747e">rice retaining its husk after threshing, mark 2</p>
      <p>rice retaining its husk after threshing, mark 3</p>
      <termsource status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </termsource>
      </verbal-definition>
      </definition>
      <termsource status='identical'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'>t1</termref>
          </origin>
        </termsource>
      </term>
    INPUT
    presxml = <<~PRESXML
          <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
            <preface> <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause> </preface>
        <sections>
          <terms id='_' obligation='normative' displayorder='2'>
            <title depth='1'>
              1.
              <tab/>
              Terms and Definitions
            </title>
            <p>For the purposes of this document, the following terms and definitions apply.</p>
            <term id='paddy1'>
              <p>
                <strong>paddy</strong>
                , &#x3c;rice&#x3e;: rice retaining its husk after threshing, mark 2
                rice retaining its husk after threshing, mark 3
                <origin bibitemid='ISO7301' type='inline' citeas='ISO 7301:2011'>
                  <locality type='clause'>
                    <referenceFrom>3.1</referenceFrom>
                  </locality>
                  ISO&#xa0;7301:2011, 3.1
                </origin>
                , modified &#x2013; The term "cargo rice" is shown as deprecated, and
                Note 1 to entry is not included here (<origin citeas=''>
                  <termref base='IEV' target='xyz'>t1</termref>
                </origin>)
              </p>
            </term>
          </terms>
        </sections>
      </iso-standard>
    PRESXML
    expect(xmlpp(strip_guid(IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)))).to be_equivalent_to xmlpp(presxml)
  end

  it "processes IsoXML term with multiple definitions" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
          <p>For the purposes of this document, the following terms and definitions apply.</p>
      <term id="paddy1"><preferred><expression><name>paddy</name></expression></preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its <xref target="paddy1"><em>husk</em></xref> after threshing</p></verbal-definition></definition>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747e">rice retaining its husk after threshing, mark 2</p>
      <termsource status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </termsource>
      </verbal-definition>
      </definition>
      <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f892"  keep-with-next="true" keep-lines-together="true">
        <p id="_65c9a509-9a89-4b54-a890-274126aeb55c">Foreign seeds, husks, bran, sand, dust.</p>
        <ul>
        <li>A</li>
        </ul>
      </termexample>
      <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f894">
        <ul>
        <li>A</li>
        </ul>
      </termexample>
      <termsource status='identical'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'>t1</termref>
          </origin>
        </termsource>
        <termsource status='modified'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'/>
          </origin>
          <modification>
            <p id='_'>with adjustments</p>
          </modification>
        </termsource>
      </term>
    INPUT
    presxml = <<~PRESXML
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
            <preface> <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause> </preface>
         <sections>
           <terms id="_" obligation="normative" displayorder="2">
             <title depth="1">1.<tab/>Terms and Definitions</title>
             <p>For the purposes of this document, the following terms and definitions apply.</p>
             <term id="paddy1">
               <p><strong>paddy</strong>, &lt;rice&gt;: <p><strong>(A)</strong> rice retaining its <xref target="paddy1"><em>husk</em></xref> after threshing
         <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality>ISO&#xa0;7301:2011,  3.1</origin>, modified
            –
           The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here

       </p><p><strong>(B)</strong> rice retaining its husk after threshing, mark 2</p>  (<origin citeas=""><termref base="IEV" target="xyz">t1</termref></origin>
         ;
           <origin citeas=""><termref base="IEV" target="xyz"/></origin>, modified
            –
             with adjustments)</p>
               <termexample id="_" keep-with-next="true" keep-lines-together="true">
                 <name>Example  1</name>
                 <p id="_">Foreign seeds, husks, bran, sand, dust.</p>
                 <ul>
                   <li>A</li>
                 </ul>
               </termexample>
               <termexample id="_">
                 <name>Example  2</name>
                 <ul>
                   <li>A</li>
                 </ul>
               </termexample>
             </term>
           </terms>
         </sections>
       </iso-standard>
    PRESXML
    expect(xmlpp(strip_guid(IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)))).to be_equivalent_to xmlpp(presxml)

    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
          <p>For the purposes of this document, the following terms and definitions apply.</p>
      <term id="paddy1"><preferred><expression><name>paddy</name></expression></preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></verbal-definition></definition>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747e">rice retaining its husk after threshing, mark 2</p>
      </verbal-definition>
      </definition>
      <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f892"  keep-with-next="true" keep-lines-together="true">
        <p id="_65c9a509-9a89-4b54-a890-274126aeb55c">Foreign seeds, husks, bran, sand, dust.</p>
        <ul>
        <li>A</li>
        </ul>
      </termexample>
      <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f894">
        <ul>
        <li>A</li>
        </ul>
      </termexample>
      <termsource status='identical'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'>t1</termref>
          </origin>
        </termsource>
        <termsource status='modified'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'/>
          </origin>
          <modification>
            <p id='_'>with adjustments</p>
          </modification>
        </termsource>
      </term>
    INPUT
    presxml = <<~PRESXML
          <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
            <preface> <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause> </preface>
        <sections>
          <terms id='_' obligation='normative' displayorder='2'>
            <title depth='1'>
              1.
              <tab/>
              Terms and Definitions
            </title>
            <p>For the purposes of this document, the following terms and definitions apply.</p>
            <term id='paddy1'>
              <p>
                <strong>paddy</strong>
                , &#x3c;rice&#x3e;:
                <strong>(A)</strong>
                &#xa0;rice retaining its husk after threshing
                <strong>(B)</strong>
                &#xa0;rice retaining its husk after threshing, mark 2 (
                <origin citeas=''>
                  <termref base='IEV' target='xyz'>t1</termref>
                </origin>
                 ;
                <origin citeas=''>
                  <termref base='IEV' target='xyz'/>
                </origin>
                , modified &#x2013; with adjustments)
              </p>
              <termexample id='_' keep-with-next='true' keep-lines-together='true'>
                <name>Example 1</name>
                <p id='_'>Foreign seeds, husks, bran, sand, dust.</p>
                <ul>
                  <li>A</li>
                </ul>
              </termexample>
              <termexample id='_'>
                <name>Example 2</name>
                <ul>
                  <li>A</li>
                </ul>
              </termexample>
            </term>
          </terms>
        </sections>
      </iso-standard>
    PRESXML
    expect(xmlpp(strip_guid(IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)))).to be_equivalent_to xmlpp(presxml)
  end

  it "processes IsoXML term with multiple preferred or preferred and admitted terms" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
      <term id="paddy1">
      <preferred><expression><name>A</name></expression></preferred>
      <preferred><expression><name>B</name></expression></preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></verbal-definition></definition>
      </term>
      <term id="paddy2">
      <preferred><expression><name language="eng">C</name></expression></preferred>
      <preferred><expression><name language="eng">D</name></expression><abbreviation-type>initialism</abbreviation-type></preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747a">rice retaining its husk after threshing</p></verbal-definition></definition>
      </term>
      <term id="paddy1a">
      <preferred><expression><name>E</name></expression></preferred>
      <admitted><expression><name>F</name></expression></admitted>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></verbal-definition></definition>
      </term>
      <term id="paddy2a">
      <preferred><expression><name language="eng">G</name></expression></preferred>
      <admitted><expression><name language="eng">H</name></expression><abbreviation-type>initialism</abbreviation-type></admitted>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747a">rice retaining its husk after threshing</p></verbal-definition></definition>
      </term>
      <term id="paddy3">
      <preferred geographic-area="US"><expression><name>I</name></expression></preferred>
      <preferred><expression><name>J</name></expression></preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747b">rice retaining its husk after threshing</p></verbal-definition></definition>
      </term>
            <term id="paddy4">
      <preferred><expression language="eng"><name>K</name></expression></preferred>
      <preferred><expression language="fra"><name>L</name></expression></preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747c">rice retaining its husk after threshing</p></verbal-definition></definition>
      </term>
                </terms>
        </sections>
      </iso-standard>
    INPUT
    presxml = <<~PRESXML
          <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
           <preface> <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause> </preface>
        <sections>
          <terms id='_' obligation='normative' displayorder='2'>
            <title depth='1'>
              1.
              <tab/>
              Terms and Definitions
            </title>
            <term id='paddy1'>
              <p>
                <strong>A</strong>
                , &#x3c;rice&#x3e;: rice retaining its husk after threshing
                <em>Syn:</em>
                <strong>B</strong>
                .
              </p>
            </term>
            <term>
              <p>
                <strong>B</strong>
                :
                <em>See:</em>
                <strong>A</strong>
                .
              </p>
            </term>
            <term id='paddy2'>
              <p>
                <strong>C (D)</strong>
                , &#x3c;rice&#x3e;: rice retaining its husk after threshing
              </p>
            </term>
            <term id='paddy1a'>
              <p>
                <strong>E</strong>
                , &#x3c;rice&#x3e;: rice retaining its husk after threshing
                <em>Syn:</em>
                <strong>F</strong>
                .
              </p>
            </term>
            <term>
              <p>
                <strong>F</strong>
                :
                <em>See:</em>
                <strong>E</strong>
                .
              </p>
            </term>
            <term id='paddy2a'>
              <p>
                <strong>G (H)</strong>
                , &#x3c;rice&#x3e;: rice retaining its husk after threshing
              </p>
            </term>
            <term id='paddy3'>
              <p>
                <strong>I</strong>
                , &#x3c;rice&#x3e;, US: rice retaining its husk after threshing
                <em>Syn:</em>
                <strong>J</strong>
                .
              </p>
            </term>
            <term>
              <p>
                <strong>J</strong>
                :
                <em>See:</em>
                <strong>I</strong>
                .
              </p>
            </term>
            <term id='paddy4'>
              <p>
                <strong>K</strong>
                , &#x3c;rice&#x3e;, eng: rice retaining its husk after threshing
                <em>Syn:</em>
                <strong>L</strong>
                , fra.
              </p>
            </term>
            <term>
              <p>
                <strong>L</strong>
                , fra:
                <em>See:</em>
                <strong>K</strong>
                , eng.
              </p>
            </term>
          </terms>
        </sections>
      </iso-standard>
    PRESXML
    expect(xmlpp(strip_guid(IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)))).to be_equivalent_to xmlpp(presxml)
  end

  it "processes IsoXML term with grammatical information" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
      <term id="paddy1">
      <preferred geographic-area="US"><expression language="en" script="Latn"><name>paddy</name>
         <pronunciation>pædiː</pronunciation>
                  <grammar>
              <gender>masculine</gender>
              <gender>feminine</gender>
              <number>singular</number>
              <isPreposition>false</isPreposition>
              <isNoun>true</isNoun>
              <grammar-value>irregular declension</grammar-value>
            </grammar>
      </expression></preferred>
      <preferred><expression><name>muddy rice</name>
                        <grammar>
              <gender>neuter</gender>
              <isNoun>true</isNoun>
              <grammar-value>irregular declension</grammar-value>
            </grammar>
      </expression></preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></verbal-definition></definition>
      </term>
                </terms>
        </sections>
      </iso-standard>
    INPUT
    presxml = <<~PRESXML
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
            <preface> <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause> </preface>
         <sections>
           <terms id='_' obligation='normative' displayorder='2'>
             <title depth='1'>
               1.
               <tab/>
               Terms and Definitions
             </title>
             <term>
               <p>
                 <strong>muddy rice</strong>
                 , n, noun:
                 <em>See:</em>
                 <strong>paddy</strong>
                 , m, f, sg, noun, en Latn, /p&#xe6;di&#x2d0;/.
               </p>
             </term>
             <term id='paddy1'>
               <p>
                 <strong>paddy</strong>
                 , &#x3c;rice&#x3e;, m, f, sg, noun, en Latn US, /p&#xe6;di&#x2d0;/:
                 rice retaining its husk after threshing
                 <em>Syn:</em>
                 <strong>muddy rice</strong>
                 , n, noun.
               </p>
             </term>
           </terms>
         </sections>
       </iso-standard>
    PRESXML
    expect(xmlpp(strip_guid(IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)))).to be_equivalent_to xmlpp(presxml)
  end

  it "processes IsoXML term with empty or graphical designations" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
      <term id="paddy1">
      <preferred><expression><name/></expression></preferred>
      <preferred isInternational='true'><graphical-symbol><figure id='_'><pre id='_'>&lt;LITERAL&gt; FIGURATIVE</pre></figure>
                 </graphical-symbol>
               </preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></verbal-definition></definition>
      </term>
                </terms>
        </sections>
      </iso-standard>
    INPUT
    presxml = <<~PRESXML
          <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
            <preface> <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause> </preface>
        <sections>
          <terms id='_' obligation='normative' displayorder='2'>
            <title depth='1'>
              1.
              <tab/>
              Terms and Definitions
            </title>
            <term id='paddy1'>
              <p>
                <strong/>
                , &#x3c;rice&#x3e;: rice retaining its husk after threshing
              </p>
              <preferred isInternational='true'>
                <figure id='_'>
                  <name>Figure 1</name>
                  <pre id='_'>&#x3c;LITERAL&#x3e; FIGURATIVE</pre>
                </figure>
              </preferred>
            </term>
          </terms>
        </sections>
      </iso-standard>
    PRESXML
    expect(xmlpp(strip_guid(IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)))).to be_equivalent_to xmlpp(presxml)
  end

  it "processes IsoXML term with nonverbal definitions" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
                    <sections>
            <terms id='A' obligation='normative'>
              <title>Terms and definitions</title>
              <p id='B'>For the purposes of this document, the following terms and definitions apply.</p>
              <term id='term-term'>
                <preferred>
                  <expression>
                    <name>Term</name>
                  </expression>
                </preferred>
                <definition>
                  <verbal-definition>
                    <p id='C'>Definition</p>
                    <termsource status='identical' type='authoritative'>
                      <origin bibitemid='ISO2191' type='inline' citeas=''>
                        <localityStack>
                          <locality type='section'>
                            <referenceFrom>1</referenceFrom>
                          </locality>
                        </localityStack>
                      </origin>
                    </termsource>
                  </verbal-definition>
                  <non-verbal-representation>
                    <table id='D'>
                      <thead>
                        <tr>
                          <th valign='top' align='left'>A</th>
                          <th valign='top' align='left'>B</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr>
                          <td valign='top' align='left'>C</td>
                          <td valign='top' align='left'>D</td>
                        </tr>
                      </tbody>
                    </table>
                  </non-verbal-representation>
                </definition>
                <termsource status='identical' type='authoritative'>
                  <origin bibitemid='ISO2191' type='inline' citeas=''>
                    <localityStack>
                      <locality type='section'>
                        <referenceFrom>2</referenceFrom>
                      </locality>
                    </localityStack>
                  </origin>
                </termsource>
              </term>
              <term id='term-term-2'>
                <preferred>
                  <expression>
                    <name>Term 2</name>
                  </expression>
                </preferred>
                <definition>
                  <non-verbal-representation>
                    <figure id='E'>
                      <pre id='F'>Literal</pre>
                    </figure>
                    <formula id='G'>
                      <stem type='MathML'>
                        <math xmlns='http://www.w3.org/1998/Math/MathML'>
                          <mi>x</mi>
                          <mo>=</mo>
                          <mi>y</mi>
                        </math>
                      </stem>
                    </formula>
                    <termsource status='identical' type='authoritative'>
                      <origin bibitemid='ISO2191' type='inline' citeas=''>
                        <localityStack>
                          <locality type='section'>
                            <referenceFrom>3</referenceFrom>
                          </locality>
                        </localityStack>
                      </origin>
                    </termsource>
                  </non-verbal-representation>
                </definition>
              </term>
            </terms>
          </sections>
      </iso-standard>
    INPUT
    presxml = <<~PRESXML
         <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
           <preface> <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause> </preface>
                  <sections>
          <terms id="A" obligation="normative" displayorder="2">
            <title depth="1">1.<tab/>Terms and definitions</title>
            <p id="B">For the purposes of this document, the following terms and definitions apply.</p>
            <term id="term-term-2">
              <p><strong>Term 2</strong>: <figure id="E"><name>Figure 1</name><pre id="F">Literal</pre></figure><formula id="G"><name>1</name><stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><mi>x</mi><mo>=</mo><mi>y</mi></math><latexmath>x = y</latexmath><asciimath>x = y</asciimath></stem></formula><termsource status="identical" type="authoritative"><origin bibitemid="ISO2191" type="inline" citeas=""><localityStack><locality type="section"><referenceFrom>3</referenceFrom></locality></localityStack>, Section 3</origin></termsource></p>
            </term>
            <term id="term-term">
              <p><strong>Term</strong>: <p>Definition
                      <origin bibitemid="ISO2191" type="inline" citeas=""><localityStack><locality type="section"><referenceFrom>1</referenceFrom></locality></localityStack>, Section 1</origin></p><table id="D"><name>Table 1</name><thead><tr><th valign="top" align="left">A</th><th valign="top" align="left">B</th></tr></thead><tbody><tr><td valign="top" align="left">C</td><td valign="top" align="left">D</td></tr></tbody></table>  (<origin bibitemid="ISO2191" type="inline" citeas=""><localityStack><locality type="section"><referenceFrom>2</referenceFrom></locality></localityStack>, Section 2</origin>)</p>
            </term>
          </terms>
        </sections>
      </iso-standard>
    PRESXML
    expect(xmlpp(strip_guid(IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)))).to be_equivalent_to xmlpp(presxml)
  end

  it "processes related terms and admitted terms" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <sections>
      <terms id='A' obligation='normative'>
            <title>Terms and definitions</title>
            <term id='second'>
        <preferred>
          <expression>
            <name>Second Term</name>
          </expression>
        <field-of-application>Field</field-of-application>
        <usage-info>Usage Info 1</usage-info>
        </preferred>
        <definition><verbal-definition><p>Definition 1</p></verbal-definition></definition>
      </term>
      <term id="C">
      <preferred language='fr' script='Latn' type='prefix'>
                <expression>
                  <name>First Designation</name>
                  </expression></preferred>
      <admitted language='fr' script='Latn' type='prefix'>
                <expression>
                  <name>Second Designation</name>
                  </expression></admitted>
        <related type='contrast'>
          <preferred>
            <expression>
              <name>Fourth Designation</name>
              <grammar>
                <gender>neuter</gender>
              </grammar>
            </expression>
          </preferred>
          <xref target='second'/>
        </related>
          <related type='seealso'>
          <preferred>
            <expression>
              <name>Third Designation</name>
              <grammar>
                <gender>neuter</gender>
              </grammar>
            </expression>
          </preferred>
          <xref target='second'/>
        </related>
         <related type='contrast'>
          <preferred>
            <expression>
              <name>Fifth Designation</name>
              <grammar>
                <gender>neuter</gender>
              </grammar>
            </expression>
          </preferred>
          <xref target='second'/>
        </related>
        <definition><verbal-definition><p>Definition 2</p></verbal-definition></definition>
      </term>
          </terms>
        </sections>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
            <preface> <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause> </preface>
        <sections>
          <terms id='A' obligation='normative' displayorder='2'>
            <title depth='1'>
              1.
              <tab/>
              Terms and definitions
            </title>
            <term id='second'>
              <p>
                <strong>Second Term</strong>
                , &#x3c;Field, Usage Info 1&#x3e;: Definition 1
              </p>
            </term>
            <term id='C'>
              <p>
                <strong>First Designation</strong>
                : Definition 2
                <em>Contrast:</em>
                  <strong>Fourth Designation</strong>
                  , n;
                  <strong>Fifth Designation</strong>
                  , n.
                <em>Syn:</em>
                <strong>Second Designation</strong> .
                <em>See also:</em>
                  <strong>Third Designation</strong>
                  , n.
              </p>
            </term>
            <term>
        <p>
          <strong>Second Designation</strong>
          :
          <em>See:</em>
          <strong>First Designation</strong>
          .
        </p>
      </term>
          </terms>
        </sections>
      </iso-standard>
    OUTPUT
    expect(xmlpp(strip_guid(IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
       .convert("test", input, true)))).to be_equivalent_to xmlpp(output)
  end

  it "processes missing related terms" do
    input = <<~INPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
         <sections>
           <terms id='A' obligation='normative' displayorder='1'>
             <title depth='1'>
               1.
               <tab/>
               Terms and definitions
             </title>
             <term id='C'>
               <p>
                 <strong>First Designation</strong>
                 : Definition 2
                 <em>Contrast:</em>
                  **RELATED TERM NOT FOUND**.
                 <em>See also:</em>
                 <strong>Third Designation</strong>
                 , n.
               </p>
             </term>
             <term id='second'>
               <p>
                 <strong>Second Term</strong>
                 , &#x3c;Field, Usage Info 1&#x3e;: Definition 1
               </p>
             </term>
           </terms>
         </sections>
       </iso-standard>
    INPUT
    output = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
            <preface> <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause> </preface>
         <sections>
           <terms id='A' obligation='normative' displayorder='2'>
             <title depth='1'>
               1.
               <tab/>
                1.
               <tab/>
                Terms and definitions
             </title>
             <term id='C'>
               <p>**TERM NOT FOUND**: </p>
               <p>
                 <strong>First Designation</strong>
                  : Definition 2
                 <em>Contrast:</em>
                  **RELATED TERM NOT FOUND**.
                 <em>See also:</em>
                 <strong>Third Designation</strong>
                  , n.
               </p>
             </term>
             <term id='second'>
               <p>**TERM NOT FOUND**: </p>
               <p>
                 <strong>Second Term</strong>
                  , &#x3c;Field, Usage Info 1&#x3e;: Definition 1
               </p>
             </term>
           </terms>
         </sections>
       </iso-standard>
    OUTPUT
    expect(xmlpp(strip_guid(IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
        .convert("test", input, true)))).to be_equivalent_to xmlpp(output)
  end
end
