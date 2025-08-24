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
            <source status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </source>
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
      <source status='adapted'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'>t1</termref>
          </origin>
          <modification>
            <p id='_'/>
          </modification>
        </source>
        <source status='adapted'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'/>
          </origin>
          <modification>
            <p id='_'>with adjustments</p>
          </modification>
        </source>
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
      <source status="identical">
        <origin bibitemid="ISO7301" type="inline" droploc="true" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
      </source></term>
      </terms>
      </sections>
      </iso-standard>
    INPUT

    presxml = <<~PRESXML
       <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1" id="_">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <p class="zzSTDTitle1" displayorder="2"/>
             <terms id="_" obligation="normative" displayorder="3">
                <title id="_">Terms and Definitions</title>
                <fmt-title depth="1" id="_">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Terms and Definitions</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="_">1</semx>
                </fmt-xref-label>
                <p>For the purposes of this document, the following terms and definitions apply.</p>
                <term id="paddy1">
                   <preferred id="_">
                      <expression>
                         <name>paddy</name>
                      </expression>
                      <field-of-application id="_">in agriculture</field-of-application>
                      <usage-info id="_">dated</usage-info>
                      <source status="modified" id="_">
                         <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                            <locality type="clause">
                               <referenceFrom>3.1</referenceFrom>
                            </locality>
                         </origin>
                         <modification id="_">
                            <p id="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
                         </modification>
                      </source>
                   </preferred>
                   <domain id="_">rice</domain>
                   <definition id="_">
                      <verbal-definition>
                         <p id="_">rice retaining its husk after threshing</p>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>paddy</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="field-of-application" source="_">in agriculture</semx>
                               ,
                               <semx element="usage-info" source="_">dated</semx>
                               &gt;
                            </span>
                         </semx>
                          <span class="fmt-termsource-delim">(</span>
                         <semx element="source" source="_">
                            <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011" id="_">
                               <locality type="clause">
                                  <referenceFrom>3.1</referenceFrom>
                               </locality>
                            </origin>
                            <semx element="origin" source="_">
                               <fmt-origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                                  <locality type="clause">
                                     <referenceFrom>3.1</referenceFrom>
                                  </locality>
                                  <span class="std_publisher">ISO </span>
                                  <span class="std_docNumber">7301</span>
                                  :
                                  <span class="std_year">2011</span>
                                  , 3.1
                               </fmt-origin>
                            </semx>
                            , modified —
                            <semx element="modification" source="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</semx>
                         </semx>
                          <span class="fmt-termsource-delim">)</span>:
                         <semx element="definition" source="_">rice retaining its husk after threshing</semx>
                          <span class="fmt-termsource-delim">(</span>adapted from
                         <semx element="source" source="_">
                            <origin citeas="" id="_">
                               <termref base="IEV" target="xyz">t1</termref>
                            </origin>
                            <semx element="origin" source="_">
                               <fmt-origin citeas="">
                                  <termref base="IEV" target="xyz">t1</termref>
                               </fmt-origin>
                            </semx>
                            , adapted
                         </semx>
                         ;
                         <semx element="source" source="_">
                            <origin citeas="" id="_">
                               <termref base="IEV" target="xyz"/>
                            </origin>
                            <semx element="origin" source="_">
                               <fmt-origin citeas="">
                                  <termref base="IEV" target="xyz"/>
                               </fmt-origin>
                            </semx>
                            , adapted —
                            <semx element="modification" source="_">with adjustments</semx>
                         </semx>
                          <span class="fmt-termsource-delim">)</span>
                      </p>
                   </fmt-definition>
                   <termexample id="_" keep-with-next="true" keep-lines-together="true" autonum="1">
                      <fmt-name id="_">
                         <em>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Example</span>
                               <semx element="autonum" source="_">1</semx>
                            </span>
                         </em>
                         <em>
                            <span class="fmt-caption-delim">:</span>
                         </em>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy1">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy1">1</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <p id="_">Foreign seeds, husks, bran, sand, dust.</p>
                      <ul>
                         <li id="_">
                            <fmt-name id="_">
                               <semx element="autonum" source="_">—</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                   </termexample>
                   <termexample id="_" autonum="2">
                      <fmt-name id="_">
                         <em>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Example</span>
                               <semx element="autonum" source="_">2</semx>
                            </span>
                         </em>
                         <em>
                            <span class="fmt-caption-delim">:</span>
                         </em>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy1">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy1">1</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <ul>
                         <li id="_">
                            <fmt-name id="_">
                               <semx element="autonum" source="_">—</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                   </termexample>
                   <source status="adapted" id="_">
                      <origin citeas="">
                         <termref base="IEV" target="xyz">t1</termref>
                      </origin>
                      <modification id="_">
                         <p id="_"/>
                      </modification>
                   </source>
                   <source status="adapted" id="_">
                      <origin citeas="">
                         <termref base="IEV" target="xyz"/>
                      </origin>
                      <modification id="_">
                         <p original-id="_">with adjustments</p>
                      </modification>
                   </source>
                </term>
                <term id="paddy">
                   <preferred id="_">
                      <expression>
                         <name>paddy</name>
                      </expression>
                   </preferred>
                   <admitted id="_">
                      <letter-symbol>
                         <name>paddy rice</name>
                      </letter-symbol>
                      <field-of-application id="_">in agriculture</field-of-application>
                   </admitted>
                   <admitted id="_">
                      <expression>
                         <name>rough rice</name>
                      </expression>
                   </admitted>
                   <deprecates id="_">
                      <expression>
                         <name>cargo rice</name>
                      </expression>
                   </deprecates>
                   <definition id="_">
                      <verbal-definition>
                         <p original-id="_">rice retaining its husk after threshing</p>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>paddy</strong>
                         </semx>
                         :
                         <semx element="definition" source="_">rice retaining its husk after threshing</semx>
                         <em>Syn:</em>
                         <semx element="related" source="_">
                            <fmt-preferred>
                               <semx element="admitted" source="_">
                                  <strong>paddy rice</strong>
                                  <span class="fmt-designation-field">
                                     , &lt;
                                     <semx element="field-of-application" source="_">in agriculture</semx>
                                     &gt;
                                  </span>
                               </semx>
                            </fmt-preferred>
                         </semx>
                         ;
                         <semx element="related" source="_">
                            <fmt-preferred>
                               <semx element="admitted" source="_">
                                  <strong>rough rice</strong>
                               </semx>
                            </fmt-preferred>
                         </semx>
                         .  <span class="fmt-termsource-delim">(</span>
                         <semx element="source" source="_">
                            <origin bibitemid="ISO7301" type="inline" droploc="true" citeas="ISO 7301:2011" id="_">
                               <locality type="clause">
                                  <referenceFrom>3.1</referenceFrom>
                               </locality>
                            </origin>
                            <semx element="origin" source="_">
                               <fmt-origin bibitemid="ISO7301" type="inline" droploc="true" citeas="ISO 7301:2011">
                                  <locality type="clause">
                                     <referenceFrom>3.1</referenceFrom>
                                  </locality>
                                  <span class="std_publisher">ISO </span>
                                  <span class="std_docNumber">7301</span>
                                  :
                                  <span class="std_year">2011</span>
                                  , 3.1
                               </fmt-origin>
                            </semx>
                         </semx>
                          <span class="fmt-termsource-delim">)</span>
                      </p>
                   </fmt-definition>
                   <termexample id="_" autonum="">
                      <fmt-name id="_">
                         <em>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Example</span>
                            </span>
                         </em>
                         <em>
                            <span class="fmt-caption-delim">:</span>
                         </em>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Example</span>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy">2</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Example</span>
                      </fmt-xref-label>
                      <ul>
                         <li id="_">
                            <fmt-name id="_">
                               <semx element="autonum" source="_">—</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                   </termexample>
                   <termnote id="_" keep-with-next="true" keep-lines-together="true" autonum="1">
                      <fmt-name id="_">
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">NOTE</span>
                            <semx element="autonum" source="_">1</semx>
                         </span>
                         <span class="fmt-label-delim">—</span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy">2</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
                   </termnote>
                   <termnote id="_" autonum="2">
                      <fmt-name id="_">
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">NOTE</span>
                            <semx element="autonum" source="_">2</semx>
                         </span>
                         <span class="fmt-label-delim">—</span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy">2</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <ul>
                         <li id="_">
                            <fmt-name id="_">
                               <semx element="autonum" source="_">—</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                      <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
                   </termnote>
                   <source status="identical" id="_">
                      <origin bibitemid="ISO7301" type="inline" droploc="true" citeas="ISO 7301:2011">
                         <locality type="clause">
                            <referenceFrom>3.1</referenceFrom>
                         </locality>
                      </origin>
                   </source>
                </term>
                <term id="_">
                   <fmt-definition id="_">
                      <p>
                         <semx element="admitted" source="_">
                            <strong>paddy rice</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="field-of-application" source="_">in agriculture</semx>
                               &gt;
                            </span>
                         </semx>
                         :
                         <em>See:</em>
                         <semx element="related" source="_">
                            <fmt-preferred>
                               <semx element="preferred" source="_">
                                  <strong>paddy</strong>
                               </semx>
                            </fmt-preferred>
                         </semx>
                         .
                      </p>
                   </fmt-definition>
                </term>
                <term id="_">
                   <fmt-definition id="_">
                      <p>
                         <semx element="admitted" source="_">
                            <strong>rough rice</strong>
                         </semx>
                         :
                         <em>See:</em>
                         <semx element="related" source="_">
                            <fmt-preferred>
                               <semx element="preferred" source="_">
                                  <strong>paddy</strong>
                               </semx>
                            </fmt-preferred>
                         </semx>
                         .
                      </p>
                   </fmt-definition>
                </term>
             </terms>
          </sections>
       </iso-standard>
    PRESXML

    html = <<~"OUTPUT"
      #{HTML_HDR}
             <p class="zzSTDTitle1"/>
             <div id="_">
                <h1>1.  Terms and Definitions</h1>
                <p>For the purposes of this document, the following terms and definitions apply.</p>
                <p class="TermNum" id="paddy1"/>
                <p>
                   <b>paddy</b>
                   , &lt;rice&gt;, &lt;in agriculture, dated&gt;  <span class="fmt-termsource-delim">(</span>
                   <span class="std_publisher">ISO </span>
                   <span class="std_docNumber">7301</span>
                   :
                   <span class="std_year">2011</span>
                    , 3.1, modified — The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here
                  <span class="fmt-termsource-delim">)</span>
                  : rice retaining its husk after threshing
                  <span class="fmt-termsource-delim">(</span>
                  adapted from t1, adapted; Termbase IEV, term ID xyz, adapted — with adjustments
                  <span class="fmt-termsource-delim">)</span>
                </p>
                <div id="_" class="example" style="page-break-after: avoid;page-break-inside: avoid;">
                   <p class="example-title">
                      <i>Example 1</i>
                      <i>:</i>
                   </p>
                   <p id="_">Foreign seeds, husks, bran, sand, dust.</p>
                   <div class="ul_wrap">
                      <ul>
                         <li id="_">A</li>
                      </ul>
                   </div>
                </div>
                <div id="_" class="example">
                   <p class="example-title">
                      <i>Example 2</i>
                      <i>:</i>
                   </p>
                   <div class="ul_wrap">
                      <ul>
                         <li id="_">A</li>
                      </ul>
                   </div>
                </div>
                <p class="TermNum" id="paddy"/>
                <p>
                   <b>paddy</b>
                   : rice retaining its husk after threshing
                   <i>Syn:</i>
                   <b>paddy rice</b>
                   , &lt;in agriculture&gt;;
                   <b>rough rice</b>
                   .  <span class="fmt-termsource-delim">(</span>
                   <span class="std_publisher">ISO </span>
                   <span class="std_docNumber">7301</span>
                   :
                   <span class="std_year">2011</span>
                   , 3.1<span class="fmt-termsource-delim">)</span>
                </p>
                <div id="_" class="example">
                   <p class="example-title">
                      <i>Example</i>
                      <i>:</i>
                   </p>
                   <div class="ul_wrap">
                      <ul>
                         <li id="_">A</li>
                      </ul>
                   </div>
                </div>
                <div id="_" class="Note" style="page-break-after: avoid;page-break-inside: avoid;">
                   <p>
                      <span class="termnote_label">NOTE 1—</span>
                      The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.
                   </p>
                </div>
                <div id="_" class="Note">
                   <p>
                      <span class="termnote_label">NOTE 2—</span>
                   </p>
                   <div class="ul_wrap">
                      <ul>
                         <li id="_">A</li>
                      </ul>
                   </div>
                   <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
                </div>
                <p class="TermNum" id="_"/>
                <p>
                   <b>paddy rice</b>
                   , &lt;in agriculture&gt;:
                   <i>See:</i>
                   <b>paddy</b>
                   .
                </p>
                <p class="TermNum" id="_"/>
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
       <body lang="EN-US" link="blue" vlink="#954F72">
          <div class="WordSection1">
             <p> </p>
          </div>
          <p class="section-break">
             <br clear="all" class="section"/>
          </p>
          <div class="WordSection2">
             <div class="WordSectionContents">
                <h1 class="IEEEStdsLevel1frontmatter">Contents</h1>
             </div>
             <p> </p>
          </div>
          <p class="section-break">
             <br clear="all" class="section"/>
          </p>
          <div class="WordSectionMiddleTitle">
             <p class="IEEEStdsTitle" style="margin-left:0cm;margin-top:70.0pt"/>
          </div>
          <p class="section-break">
             <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
          </p>
          <div class="WordSectionMain">
             <div id="_">
                <h1>
                   1.
                   <span style="mso-tab-count:1">  </span>
                   Terms and Definitions
                </h1>
                <p>For the purposes of this document, the following terms and definitions apply.</p>
                <p class="TermNum" id="paddy1"/>
                <p>
                   <b>paddy</b>
                   , &lt;rice&gt;, &lt;in agriculture, dated&gt;
                   <span class="fmt-termsource-delim">(</span>
                   <span class="std_publisher">ISO </span>
                   <span class="std_docNumber">7301</span>
                   :
                   <span class="std_year">2011</span>
                   , 3.1, modified — The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here
                   <span class="fmt-termsource-delim">)</span>
                   : rice retaining its husk after threshing
                   <span class="fmt-termsource-delim">(</span>
                   adapted from t1, adapted; Termbase IEV, term ID xyz, adapted — with adjustments
                   <span class="fmt-termsource-delim">)</span>
                </p>
                <div id="_" class="example" style="page-break-after: avoid;page-break-inside: avoid;">
                   <p class="example-title">
                      <i>Example 1</i>
                      <i>:</i>
                   </p>
                   <p id="_">Foreign seeds, husks, bran, sand, dust.</p>
                   <div class="ul_wrap">
                      <ul>
                         <li id="_">A</li>
                      </ul>
                   </div>
                </div>
                <div id="_" class="example">
                   <p class="example-title">
                      <i>Example 2</i>
                      <i>:</i>
                   </p>
                   <div class="ul_wrap">
                      <ul>
                         <li id="_">A</li>
                      </ul>
                   </div>
                </div>
                <p class="TermNum" id="paddy"/>
                <p>
                   <b>paddy</b>
                   : rice retaining its husk after threshing
                   <i>Syn:</i>
                   <b>paddy rice</b>
                   , &lt;in agriculture&gt;;
                   <b>rough rice</b>
                   .
                   <span class="fmt-termsource-delim">(</span>
                   <span class="std_publisher">ISO </span>
                   <span class="std_docNumber">7301</span>
                   :
                   <span class="std_year">2011</span>
                   , 3.1
                   <span class="fmt-termsource-delim">)</span>
                </p>
                <div id="_" class="example">
                   <p class="example-title">
                      <i>Example</i>
                      <i>:</i>
                   </p>
                   <div class="ul_wrap">
                      <ul>
                         <li id="_">A</li>
                      </ul>
                   </div>
                </div>
                <div id="_" class="Note" style="page-break-after: avoid;page-break-inside: avoid;">
                   <p>
                      <span class="note_label">NOTE 1—</span>
                      The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.
                   </p>
                </div>
                <div id="_" class="Note">
                   <p>
                      <span class="note_label">NOTE 2—</span>
                      The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.
                   </p>
                </div>
                <p class="TermNum" id="_"/>
                <p>
                   <b>paddy rice</b>
                   , &lt;in agriculture&gt;:
                   <i>See:</i>
                   <b>paddy</b>
                   .
                </p>
                <p class="TermNum" id="_"/>
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
    pres_output = IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
    expect(Canon.format_xml(strip_guid(pres_output)))
      .to be_equivalent_to Canon.format_xml(presxml)
    expect(Canon.format_xml(strip_guid(Nokogiri::XML(IsoDoc::Ieee::HtmlConvert.new({})
      .convert("test", pres_output, true))
      .at("//body").to_xml))).to be_equivalent_to Canon.format_xml(html)
    expect(Canon.format_xml(strip_guid(Nokogiri::XML(IsoDoc::Ieee::WordConvert.new({})
      .convert("test", pres_output, true))
      .at("//body").to_xml))).to be_equivalent_to Canon.format_xml(word)
  end

  it "sorts terms" do
    input = <<~INPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic'>
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
      <ieee-standard xmlns="https://www.metanorma.org/ns/ieee" type="presentation">
         <preface>
            <clause type="toc" id="_" displayorder="1">
               <fmt-title id="_" depth="1">Contents</fmt-title>
            </clause>
         </preface>
         <sections>
            <p class="zzSTDTitle1" displayorder="2"/>
            <terms id="_" obligation="normative" displayorder="3">
               <title id="_">Definitions</title>
               <fmt-title id="_" depth="1">
                  <span class="fmt-caption-label">
                     <semx element="autonum" source="_">1</semx>
                     <span class="fmt-autonum-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Definitions</semx>
               </fmt-title>
               <fmt-xref-label>
                  <span class="fmt-element-name">Clause</span>
                  <semx element="autonum" source="_">1</semx>
               </fmt-xref-label>
               <p id="_">
                  For the purposes of this document, the following terms and definitions apply. The
                  <em>IEEE Standards Dictionary Online</em>
                  should be consulted for terms not defined in this clause.
                  <fn id="_" original-reference="" reference="1" target="_">
                     <p original-id="_">
                        <em>IEEE Standards Dictionary Online</em>
                        is available at:
                        <link target="http://dictionary.ieee.org" id="_"/>
                        <semx element="link" source="_">
                           <fmt-link target="http://dictionary.ieee.org"/>
                        </semx>
                        . An IEEE Account is required for access to the dictionary, and one can be created at no charge on the dictionary sign-in page.
                     </p>
                     <fmt-fn-label>
                        <span class="fmt-caption-label">
                           <sup>
                              <semx element="autonum" source="_">1</semx>
                           </sup>
                        </span>
                     </fmt-fn-label>
                  </fn>
               </p>
               <term id="term-prozac">
                  <preferred id="_">
                     <expression>
                        <name>prozac</name>
                     </expression>
                  </preferred>
                  <fmt-definition id="_">
                     <p>
                        <semx element="preferred" source="_">
                           <strong>prozac</strong>
                        </semx>
                        :
                     </p>
                  </fmt-definition>
               </term>
               <term id="term-x1">
                  <preferred id="_">
                     <letter-symbol>
                        <name>
                           <stem type="MathML">
                              <math xmlns="http://www.w3.org/1998/Math/MathML">
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
                  <fmt-definition id="_">
                     <p>
                        <semx element="preferred" source="_">
                           <strong>
                              <stem type="MathML" id="_">
                                 <math xmlns="http://www.w3.org/1998/Math/MathML">
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
                              <fmt-stem type="MathML">
                                 <semx element="stem" source="_">
                                    <math xmlns="http://www.w3.org/1998/Math/MathML">
                                       <mstyle mathvariant="bold">
                                          <msub>
                                             <mrow>
                                                <mi>x</mi>
                                             </mrow>
                                             <mrow>
                                                <mn>1</mn>
                                             </mrow>
                                          </msub>
                                       </mstyle>
                                    </math>
                                    <latexmath>\\mathbf{x_{1}}</latexmath>
                                    <asciimath>mathbf(x_(1))</asciimath>
                                 </semx>
                              </fmt-stem>
                           </strong>
                        </semx>
                        :
                     </p>
                  </fmt-definition>
               </term>
               <term id="term-Xanax">
                  <preferred id="_">
                     <expression>
                        <name>Xanax</name>
                     </expression>
                  </preferred>
                  <fmt-definition id="_">
                     <p>
                        <semx element="preferred" source="_">
                           <strong>Xanax</strong>
                        </semx>
                        :
                     </p>
                  </fmt-definition>
               </term>
            </terms>
         </sections>
         <fmt-footnote-container>
            <fmt-fn-body id="_" target="_" reference="1">
               <semx element="fn" source="_">
                  <p id="_">
                     <fmt-fn-label>
                        <span class="fmt-caption-label">
                           <sup>
                              <semx element="autonum" source="_">1</semx>
                           </sup>
                        </span>
                        <span class="fmt-caption-delim">
                           <tab/>
                        </span>
                     </fmt-fn-label>
                     <em>IEEE Standards Dictionary Online</em>
                     is available at:
                     <link target="http://dictionary.ieee.org" id="_"/>
                     <semx element="link" source="_">
                        <fmt-link target="http://dictionary.ieee.org"/>
                     </semx>
                     . An IEEE Account is required for access to the dictionary, and one can be created at no charge on the dictionary sign-in page.
                  </p>
               </semx>
            </fmt-fn-body>
         </fmt-footnote-container>
      </ieee-standard>
    OUTPUT
    expect(Canon.format_xml(strip_guid(IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
        .convert("test", input, true))))
      .to be_equivalent_to Canon.format_xml(output)
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
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title id="_" depth="1">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <p class="zzSTDTitle1" displayorder="2"/>
             <terms id="_" obligation="normative" displayorder="3">
                <title id="_">Terms and Definitions</title>
                <fmt-title id="_" depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Terms and Definitions</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="_">1</semx>
                </fmt-xref-label>
                <term id="_">
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>muddy rice</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                            , n, noun
                         </semx>
                         :
                         <em>See:</em>
                         <semx element="related" source="_">
                            <fmt-preferred>
                               <semx element="preferred" source="_">
                                  <strong>paddy</strong>
                                  <span class="fmt-designation-field">
                                     , &lt;
                                     <semx element="domain" source="_">rice</semx>
                                     &gt;
                                  </span>
                                  , m, f, sg, noun, en Latn US, /pædiː/
                               </semx>
                            </fmt-preferred>
                         </semx>
                         .
                      </p>
                   </fmt-definition>
                </term>
                <term id="paddy1">
                   <preferred geographic-area="US" id="_">
                      <expression language="en" script="Latn">
                         <name>paddy</name>
                         <pronunciation>pædiː</pronunciation>
                         <grammar>
                            <gender>masculine</gender>
                            <gender>feminine</gender>
                            <number>singular</number>
                            <isPreposition>false</isPreposition>
                            <isNoun>true</isNoun>
                            <grammar-value>irregular declension</grammar-value>
                         </grammar>
                      </expression>
                   </preferred>
                   <preferred id="_">
                      <expression>
                         <name>muddy rice</name>
                         <grammar>
                            <gender>neuter</gender>
                            <isNoun>true</isNoun>
                            <grammar-value>irregular declension</grammar-value>
                         </grammar>
                      </expression>
                   </preferred>
                   <domain id="_">rice</domain>
                   <definition id="_">
                      <verbal-definition>
                         <p id="_">rice retaining its husk after threshing</p>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>paddy</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                            , m, f, sg, noun, en Latn US, /pædiː/
                         </semx>
                         :
                         <semx element="definition" source="_">rice retaining its husk after threshing</semx>
                         <em>Syn:</em>
                         <semx element="related" source="_">
                            <fmt-preferred>
                               <semx element="preferred" source="_">
                                  <strong>muddy rice</strong>
                                  <span class="fmt-designation-field">
                                     , &lt;
                                     <semx element="domain" source="_">rice</semx>
                                     &gt;
                                  </span>
                                  , n, noun
                               </semx>
                            </fmt-preferred>
                         </semx>
                         .
                      </p>
                   </fmt-definition>
                </term>
             </terms>
          </sections>
       </iso-standard>
    PRESXML
    expect(Canon.format_xml(strip_guid(IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Canon.format_xml(presxml)
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
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title id="_" depth="1">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <p class="zzSTDTitle1" displayorder="2"/>
             <terms id="_" obligation="normative" displayorder="3">
                <title id="_">Terms and Definitions</title>
                <fmt-title id="_" depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Terms and Definitions</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="_">1</semx>
                </fmt-xref-label>
                <term id="paddy1">
                   <preferred id="_">
                      <expression>
                         <name/>
                      </expression>
                   </preferred>
                   <preferred isInternational="true" id="_">
                      <graphical-symbol>
                         <figure autonum="1" original-id="_">
                            <pre original-id="_">&lt;LITERAL&gt; FIGURATIVE</pre>
                         </figure>
                      </graphical-symbol>
                   </preferred>
                   <domain id="_">rice</domain>
                   <definition id="_">
                      <verbal-definition>
                         <p id="_">rice retaining its husk after threshing</p>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong/>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                         </semx>
                         <semx element="preferred" source="_">
                            <figure id="_" autonum="1">
                               <fmt-name id="_">
                                  <span class="fmt-caption-label">
                                     <span class="fmt-element-name">Figure</span>
                                     <semx element="autonum" source="_">1</semx>
                                  </span>
                               </fmt-name>
                               <fmt-xref-label>
                                  <span class="fmt-element-name">Figure</span>
                                  <semx element="autonum" source="_">1</semx>
                               </fmt-xref-label>
                               <pre id="_">&lt;LITERAL&gt; FIGURATIVE</pre>
                            </figure>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                         </semx>
                         :
                         <semx element="definition" source="_">rice retaining its husk after threshing</semx>
                      </p>
                   </fmt-definition>
                </term>
             </terms>
          </sections>
       </iso-standard>
    PRESXML
    expect(Canon.format_xml(strip_guid(IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Canon.format_xml(presxml)
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
                    <source status='identical' type='authoritative'>
                      <origin bibitemid='ISO2191' type='inline' citeas=''>
                        <localityStack>
                          <locality type='section'>
                            <referenceFrom>1</referenceFrom>
                          </locality>
                        </localityStack>
                      </origin>
                    </source>
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
                <source status='identical' type='authoritative'>
                  <origin bibitemid='ISO2191' type='inline' citeas=''>
                    <localityStack>
                      <locality type='section'>
                        <referenceFrom>2</referenceFrom>
                      </locality>
                    </localityStack>
                  </origin>
                </source>
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
                    <source status='identical' type='authoritative'>
                      <origin bibitemid='ISO2191' type='inline' citeas=''>
                        <localityStack>
                          <locality type='section'>
                            <referenceFrom>3</referenceFrom>
                          </locality>
                        </localityStack>
                      </origin>
                    </source>
                  </non-verbal-representation>
                </definition>
              </term>
            </terms>
          </sections>
      </iso-standard>
    INPUT
    presxml = <<~PRESXML
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
         <preface>
            <clause type="toc" id="_" displayorder="1">
               <fmt-title depth="1" id="_">Contents</fmt-title>
            </clause>
         </preface>
         <sections>
            <p class="zzSTDTitle1" displayorder="2"/>
            <terms id="A" obligation="normative" displayorder="3">
               <title id="_">Terms and definitions</title>
               <fmt-title depth="1" id="_">
                  <span class="fmt-caption-label">
                     <semx element="autonum" source="A">1</semx>
                     <span class="fmt-autonum-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Terms and definitions</semx>
               </fmt-title>
               <fmt-xref-label>
                  <span class="fmt-element-name">Clause</span>
                  <semx element="autonum" source="A">1</semx>
               </fmt-xref-label>
               <p id="B">For the purposes of this document, the following terms and definitions apply.</p>
               <term id="term-term-2">
                  <preferred id="_">
                     <expression>
                        <name>Term 2</name>
                     </expression>
                  </preferred>
                  <definition id="_">
                     <non-verbal-representation>
                        <figure autonum="1" original-id="E">
                           <pre original-id="F">Literal</pre>
                        </figure>
                        <formula autonum="1" original-id="G">
                           <stem type="MathML">
                              <math xmlns="http://www.w3.org/1998/Math/MathML">
                                 <mi>x</mi>
                                 <mo>=</mo>
                                 <mi>y</mi>
                              </math>
                           </stem>
                        </formula>
                        <source status="identical" type="authoritative" id="_">
                           <origin bibitemid="ISO2191" type="inline" citeas="">
                              <localityStack>
                                 <locality type="section">
                                    <referenceFrom>3</referenceFrom>
                                 </locality>
                              </localityStack>
                           </origin>
                        </source>
                     </non-verbal-representation>
                  </definition>
                  <fmt-definition id="_">
                     <p>
                        <semx element="preferred" source="_">
                           <strong>Term 2</strong>
                        </semx>
                        :
                     </p>
                     <semx element="definition" source="_">
                        <figure id="E" autonum="1">
                           <fmt-name id="_">
                              <span class="fmt-caption-label">
                                 <span class="fmt-element-name">Figure</span>
                                 <semx element="autonum" source="E">1</semx>
                              </span>
                           </fmt-name>
                           <fmt-xref-label>
                              <span class="fmt-element-name">Figure</span>
                              <semx element="autonum" source="E">1</semx>
                           </fmt-xref-label>
                           <pre id="F">Literal</pre>
                        </figure>
                        <formula id="G" autonum="1">
                           <fmt-name id="_">
                              <span class="fmt-caption-label">
                                 <span class="fmt-autonum-delim">(</span>
                                 1
                                 <span class="fmt-autonum-delim">)</span>
                              </span>
                           </fmt-name>
                           <fmt-xref-label>
                              <span class="fmt-element-name">Equation</span>
                              <span class="fmt-autonum-delim">(</span>
                              <semx element="autonum" source="G">1</semx>
                              <span class="fmt-autonum-delim">)</span>
                           </fmt-xref-label>
                           <stem type="MathML" id="_">
                              <math xmlns="http://www.w3.org/1998/Math/MathML">
                                 <mi>x</mi>
                                 <mo>=</mo>
                                 <mi>y</mi>
                              </math>
                           </stem>
                           <fmt-stem type="MathML">
                              <semx element="stem" source="_">
                                 <math xmlns="http://www.w3.org/1998/Math/MathML">
                                    <mi>x</mi>
                                    <mo>=</mo>
                                    <mi>y</mi>
                                 </math>
                                 <latexmath>x = y</latexmath>
                                 <asciimath>x = y</asciimath>
                              </semx>
                           </fmt-stem>
                        </formula>
                         <span class="fmt-termsource-delim">(</span>
                        <semx element="source" source="_">
                           <origin bibitemid="ISO2191" type="inline" citeas="" id="_">
                              <localityStack>
                                 <locality type="section">
                                    <referenceFrom>3</referenceFrom>
                                 </locality>
                              </localityStack>
                           </origin>
                           <semx element="origin" source="_">
                              <fmt-origin bibitemid="ISO2191" type="inline" citeas="">
                                 <localityStack>
                                    <locality type="section">
                                       <referenceFrom>3</referenceFrom>
                                    </locality>
                                 </localityStack>
                                 , Section 3
                              </fmt-origin>
                           </semx>
                        </semx>
                         <span class="fmt-termsource-delim">)</span>
                     </semx>
                  </fmt-definition>
               </term>
               <term id="term-term">
                  <preferred id="_">
                     <expression>
                        <name>Term</name>
                     </expression>
                  </preferred>
                  <definition id="_">
                     <verbal-definition>
                        <p id="C">Definition</p>
                        <source status="identical" type="authoritative" id="_">
                           <origin bibitemid="ISO2191" type="inline" citeas="">
                              <localityStack>
                                 <locality type="section">
                                    <referenceFrom>1</referenceFrom>
                                 </locality>
                              </localityStack>
                           </origin>
                        </source>
                     </verbal-definition>
                     <non-verbal-representation>
                        <table autonum="1" original-id="D">
                           <thead>
                              <tr>
                                 <th valign="top" align="left">A</th>
                                 <th valign="top" align="left">B</th>
                              </tr>
                           </thead>
                           <tbody>
                              <tr>
                                 <td valign="top" align="left">C</td>
                                 <td valign="top" align="left">D</td>
                              </tr>
                           </tbody>
                        </table>
                     </non-verbal-representation>
                  </definition>
                  <fmt-definition id="_">
                     <p>
                        <semx element="preferred" source="_">
                           <strong>Term</strong>
                        </semx>
                        :
                     </p>
                     <semx element="definition" source="_">
                        Definition  <span class="fmt-termsource-delim">(</span>
                        <semx element="source" source="_">
                           <origin bibitemid="ISO2191" type="inline" citeas="" id="_">
                              <localityStack>
                                 <locality type="section">
                                    <referenceFrom>1</referenceFrom>
                                 </locality>
                              </localityStack>
                           </origin>
                           <semx element="origin" source="_">
                              <fmt-origin bibitemid="ISO2191" type="inline" citeas="">
                                 <localityStack>
                                    <locality type="section">
                                       <referenceFrom>1</referenceFrom>
                                    </locality>
                                 </localityStack>
                                 , Section 1
                              </fmt-origin>
                           </semx>
                        </semx>
                         <span class="fmt-termsource-delim">)</span>
                        <table id="D" autonum="1">
                           <fmt-name id="_">
                              <span class="fmt-caption-label">
                                 <span class="fmt-element-name">Table</span>
                                 <semx element="autonum" source="D">1</semx>
                              </span>
                           </fmt-name>
                           <fmt-xref-label>
                              <span class="fmt-element-name">Table</span>
                              <semx element="autonum" source="D">1</semx>
                           </fmt-xref-label>
                           <thead>
                              <tr>
                                 <th valign="top" align="left">A</th>
                                 <th valign="top" align="left">B</th>
                              </tr>
                           </thead>
                           <tbody>
                              <tr>
                                 <td valign="top" align="left">C</td>
                                 <td valign="top" align="left">D</td>
                              </tr>
                           </tbody>
                        </table>
                     </semx>
                     <p>
                        <span class="fmt-termsource-delim">(</span>
                        <semx element="source" source="_">
                           <origin bibitemid="ISO2191" type="inline" citeas="" id="_">
                              <localityStack>
                                 <locality type="section">
                                    <referenceFrom>2</referenceFrom>
                                 </locality>
                              </localityStack>
                           </origin>
                           <semx element="origin" source="_">
                              <fmt-origin bibitemid="ISO2191" type="inline" citeas="">
                                 <localityStack>
                                    <locality type="section">
                                       <referenceFrom>2</referenceFrom>
                                    </locality>
                                 </localityStack>
                                 , Section 2
                              </fmt-origin>
                           </semx>
                        </semx>
                         <span class="fmt-termsource-delim">)</span>
                     </p>
                  </fmt-definition>
                  <source status="identical" type="authoritative" id="_">
                     <origin bibitemid="ISO2191" type="inline" citeas="">
                        <localityStack>
                           <locality type="section">
                              <referenceFrom>2</referenceFrom>
                           </locality>
                        </localityStack>
                     </origin>
                  </source>
               </term>
            </terms>
         </sections>
      </iso-standard>
    PRESXML
    expect(Canon.format_xml(strip_guid(IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Canon.format_xml(presxml)
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
       <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
         <preface>
            <clause type="toc" id="_" displayorder="1">
               <fmt-title depth="1" id="_">Contents</fmt-title>
            </clause>
         </preface>
         <sections>
            <p class="zzSTDTitle1" displayorder="2"/>
            <terms id="A" obligation="normative" displayorder="3">
               <title id="_">Terms and definitions</title>
               <fmt-title depth="1" id="_">
                  <span class="fmt-caption-label">
                     <semx element="autonum" source="A">1</semx>
                     <span class="fmt-autonum-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Terms and definitions</semx>
               </fmt-title>
               <fmt-xref-label>
                  <span class="fmt-element-name">Clause</span>
                  <semx element="autonum" source="A">1</semx>
               </fmt-xref-label>
               <term id="C">
                  <preferred language="fr" script="Latn" type="prefix" id="_">
                     <expression>
                        <name>First Designation</name>
                     </expression>
                  </preferred>
                  <admitted language="fr" script="Latn" type="prefix" id="_">
                     <expression>
                        <name>Second Designation</name>
                     </expression>
                  </admitted>
                  <related type="contrast" id="_">
                     <preferred original-id="_">
                        <expression>
                           <name>Fourth Designation</name>
                           <grammar>
                              <gender>neuter</gender>
                           </grammar>
                        </expression>
                     </preferred>
                     <xref target="second"/>
                  </related>
                  <related type="seealso" id="_">
                     <preferred original-id="_">
                        <expression>
                           <name>Third Designation</name>
                           <grammar>
                              <gender>neuter</gender>
                           </grammar>
                        </expression>
                     </preferred>
                     <xref target="second"/>
                  </related>
                  <related type="contrast" id="_">
                     <preferred original-id="_">
                        <expression>
                           <name>Fifth Designation</name>
                           <grammar>
                              <gender>neuter</gender>
                           </grammar>
                        </expression>
                     </preferred>
                     <xref target="second"/>
                  </related>
                  <definition id="_">
                     <verbal-definition>
                        <p>Definition 2</p>
                     </verbal-definition>
                  </definition>
                  <fmt-definition id="_">
                     <p>
                        <semx element="preferred" source="_">
                           <strong>First Designation</strong>
                        </semx>
                        :
                        <semx element="definition" source="_">Definition 2</semx>
                        <em>Contrast:</em>
                        <semx element="related" source="_">
                           <preferred id="_">
                              <expression>
                                 <name>Fifth Designation</name>
                                 <grammar>
                                    <gender>neuter</gender>
                                 </grammar>
                              </expression>
                           </preferred>
                           <fmt-preferred>
                              <semx element="preferred" source="_">
                                 <strong>Fifth Designation</strong>
                                 , n
                              </semx>
                           </fmt-preferred>
                        </semx>
                        ;
                        <semx element="related" source="_">
                           <preferred id="_">
                              <expression>
                                 <name>Fourth Designation</name>
                                 <grammar>
                                    <gender>neuter</gender>
                                 </grammar>
                              </expression>
                           </preferred>
                           <fmt-preferred>
                              <semx element="preferred" source="_">
                                 <strong>Fourth Designation</strong>
                                 , n
                              </semx>
                           </fmt-preferred>
                        </semx>
                        .
                        <em>Syn:</em>
                        <semx element="related" source="_">
                           <fmt-preferred>
                              <semx element="admitted" source="_">
                                 <strong>Second Designation</strong>
                              </semx>
                           </fmt-preferred>
                        </semx>
                        .
                        <em>See also:</em>
                        <semx element="related" source="_">
                           <preferred id="_">
                              <expression>
                                 <name>Third Designation</name>
                                 <grammar>
                                    <gender>neuter</gender>
                                 </grammar>
                              </expression>
                           </preferred>
                           <fmt-preferred>
                              <semx element="preferred" source="_">
                                 <strong>Third Designation</strong>
                                 , n
                              </semx>
                           </fmt-preferred>
                        </semx>
                        .
                     </p>
                  </fmt-definition>
               </term>
               <term id="_">
                  <fmt-definition id="_">
                     <p>
                        <semx element="admitted" source="_">
                           <strong>Second Designation</strong>
                        </semx>
                        :
                        <em>See:</em>
                        <semx element="related" source="_">
                           <fmt-preferred>
                              <semx element="preferred" source="_">
                                 <strong>First Designation</strong>
                              </semx>
                           </fmt-preferred>
                        </semx>
                        .
                     </p>
                  </fmt-definition>
               </term>
               <term id="second">
                  <preferred id="_">
                     <expression>
                        <name>Second Term</name>
                     </expression>
                     <field-of-application id="_">Field</field-of-application>
                     <usage-info id="_">Usage Info 1</usage-info>
                  </preferred>
                  <definition id="_">
                     <verbal-definition>
                        <p>Definition 1</p>
                     </verbal-definition>
                  </definition>
                  <fmt-definition id="_">
                     <p>
                        <semx element="preferred" source="_">
                           <strong>Second Term</strong>
                           <span class="fmt-designation-field">
                              , &lt;
                              <semx element="field-of-application" source="_">Field</semx>
                              ,
                              <semx element="usage-info" source="_">Usage Info 1</semx>
                              &gt;
                           </span>
                        </semx>
                        :
                        <semx element="definition" source="_">Definition 1</semx>
                     </p>
                  </fmt-definition>
               </term>
            </terms>
         </sections>
      </iso-standard>
    OUTPUT
    expect(Canon.format_xml(strip_guid(IsoDoc::Ieee::PresentationXMLConvert
       .new(presxml_options)
       .convert("test", input, true))))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "processes missing related terms" do
    input = <<~INPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
         <sections>
           <terms id='A' obligation='normative' displayorder='1'>
             <title depth='1'>
               Terms and definitions
             </title>
             <term id='C'>
             <preferred>First Designation</preferred>
             <definition>Definition 2</definition>
             <related type='contrast'>
          <xref target='second'/>
        </related>
             <related type='seealso'>
             <preferred>Third Designation</preferred>
        </related>
             </term>
             <term id='second'>
             <preferred>Second Term</preferred>
               <definition>Definition 1</definition>
             </term>
           </terms>
         </sections>
       </iso-standard>
    INPUT
    output = <<~OUTPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
         <preface>
            <clause type="toc" id="_" displayorder="1">
               <fmt-title id="_" depth="1">Contents</fmt-title>
            </clause>
         </preface>
         <sections>
            <p class="zzSTDTitle1" displayorder="2"/>
            <terms id="A" obligation="normative" displayorder="3">
               <title depth="1" id="_">
               Terms and definitions
             </title>
               <fmt-title id="_" depth="1">
                  <span class="fmt-caption-label">
                     <semx element="autonum" source="A">1</semx>
                     <span class="fmt-autonum-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">
               Terms and definitions
             </semx>
               </fmt-title>
               <fmt-xref-label>
                  <span class="fmt-element-name">Clause</span>
                  <semx element="autonum" source="A">1</semx>
               </fmt-xref-label>
               <term id="C">
                  <preferred id="_">First Designation</preferred>
                  <definition id="_">Definition 2</definition>
                  <fmt-definition id="_">
                     <p>
                        **TERM NOT FOUND**:
                        <semx element="definition" source="_">Definition 2</semx>
                        <em>Contrast:</em>
                        <semx element="related" source="_">
                           **RELATED TERM NOT FOUND**
                        </semx>
                        .
                        <em>See also:</em>
                        <semx element="related" source="_">
                           <preferred id="_">Third Designation</preferred>
                        </semx>
                        .
                     </p>
                  </fmt-definition>
                  <related type="contrast" id="_">
                     <xref target="second"/>
                  </related>
                  <related type="seealso" id="_">
                     <preferred original-id="_">Third Designation</preferred>
                  </related>
               </term>
               <term id="second">
                  <preferred id="_">Second Term</preferred>
                  <definition id="_">Definition 1</definition>
                  <fmt-definition id="_">
                     <p>
                        **TERM NOT FOUND**:
                        <semx element="definition" source="_">Definition 1</semx>
                     </p>
                  </fmt-definition>
               </term>
            </terms>
         </sections>
      </iso-standard>
    OUTPUT
    expect(Canon.format_xml(strip_guid(IsoDoc::Ieee::PresentationXMLConvert
        .new(presxml_options)
        .convert("test", input, true))))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "processes termnotes with license information" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
      <term id="paddy1">
      <preferred><expression><name>Rice</name></expression></preferred>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></verbal-definition></definition>
               <termnote id="N1">
               <p id="_">This is a note</p>
            </termnote>
            <termnote id="N2" type="license">
               <p id="_">This is not a note but a license statement associated with the source</p>
            </termnote>
               <termnote id="N3">
               <p id="_">This is another note</p>
            </termnote>
            <source status="identical">
        <origin bibitemid="ISO7301" type="inline" droploc="true" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
      </source>
      </term>
                </terms>
        </sections>
      </iso-standard>
    INPUT
    output = <<~PRESXML
       <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1" id="_">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <p class="zzSTDTitle1" displayorder="2"/>
             <terms id="_" obligation="normative" displayorder="3">
                <title id="_">Terms and Definitions</title>
                <fmt-title depth="1" id="_">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Terms and Definitions</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="_">1</semx>
                </fmt-xref-label>
                <term id="paddy1">
                   <preferred id="_">
                      <expression>
                         <name>Rice</name>
                      </expression>
                   </preferred>
                   <definition id="_">
                      <verbal-definition>
                         <p id="_">rice retaining its husk after threshing</p>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>Rice</strong>
                         </semx>
                         :
                         <semx element="definition" source="_">rice retaining its husk after threshing</semx>
                         <span class="fmt-termsource-delim">(</span>
                         <semx element="source" source="_">
                            <origin bibitemid="ISO7301" type="inline" droploc="true" citeas="ISO 7301:2011" id="_">
                               <locality type="clause">
                                  <referenceFrom>3.1</referenceFrom>
                               </locality>
                            </origin>
                            <semx element="origin" source="_">
                               <fmt-origin bibitemid="ISO7301" type="inline" droploc="true" citeas="ISO 7301:2011">
                                  <locality type="clause">
                                     <referenceFrom>3.1</referenceFrom>
                                  </locality>
                                  <span class="std_publisher">ISO </span>
                                  <span class="std_docNumber">7301</span>
                                  :
                                  <span class="std_year">2011</span>
                                  , 3.1
                               </fmt-origin>
                            </semx>
                         </semx>
                         <span class="fmt-termsource-delim">)</span>
                         <fn id="N2" type="license" reference="1" original-reference="_" target="_">
                            <p original-id="_">This is not a note but a license statement associated with the source</p>
                            <fmt-fn-label>
                               <span class="fmt-caption-label">
                                  <sup>
                                     <semx element="autonum" source="N2">1</semx>
                                  </sup>
                               </span>
                            </fmt-fn-label>
                         </fn>
                      </p>
                   </fmt-definition>
                   <termnote id="N1" autonum="1">
                      <fmt-name id="_">
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">NOTE</span>
                            <semx element="autonum" source="N1">1</semx>
                         </span>
                         <span class="fmt-label-delim">—</span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="N1">1</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy1">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy1">1</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="N1">1</semx>
                      </fmt-xref-label>
                      <p id="_">This is a note</p>
                   </termnote>
                   <termnote id="N3" autonum="2">
                      <fmt-name id="_">
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">NOTE</span>
                            <semx element="autonum" source="N3">2</semx>
                         </span>
                         <span class="fmt-label-delim">—</span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="N3">2</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy1">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy1">1</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Note</span>
                         <semx element="autonum" source="N3">2</semx>
                      </fmt-xref-label>
                      <p id="_">This is another note</p>
                   </termnote>
                   <source status="identical" id="_">
                      <origin bibitemid="ISO7301" type="inline" droploc="true" citeas="ISO 7301:2011">
                         <locality type="clause">
                            <referenceFrom>3.1</referenceFrom>
                         </locality>
                      </origin>
                   </source>
                </term>
             </terms>
          </sections>
          <fmt-footnote-container>
             <fmt-fn-body id="_" target="N2" reference="1">
                <semx element="fn" source="N2">
                   <p id="_">
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <semx element="autonum" source="N2">1</semx>
                            </sup>
                         </span>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      This is not a note but a license statement associated with the source
                   </p>
                </semx>
             </fmt-fn-body>
          </fmt-footnote-container>
       </iso-standard>
    PRESXML
    expect(Canon.format_xml(strip_guid(IsoDoc::Ieee::PresentationXMLConvert
       .new(presxml_options)
       .convert("test", input, true))))
      .to be_equivalent_to Canon.format_xml(output)
  end
end
