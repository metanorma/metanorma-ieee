require "spec_helper"

RSpec.describe IsoDoc::Ieee do
  it "processes section names" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
        <preface>
          <abstract obligation="informative">
            <title>Foreword</title>
            <p id="A">This is a preamble</p>
          </abstract>
          <introduction id="B" obligation="informative">
            <title>Introduction</title>
            <clause id="C" inline-header="false" obligation="informative">
              <title>Introduction Subsection</title>
            </clause>
            <p>This is patent boilerplate</p>
          </introduction>
          <acknowledgements obligation="informative">
            <title>Acknolwedgements</title>
            <p id="A">This is a preamble</p>
          </acknowledgements>
        </preface>
        <sections>
          <clause id="D" obligation="normative" type="overview">
            <title>Overview</title>
            <p id="E">Text</p>
            <clause id="D1" obligation="normative" type="scope">
            <title>Scope</title>
            </clause>
            <clause id="D2" obligation="normative" type="purpose">
            <title>Purpose</title>
            </clause>
          </clause>
          <clause id="H" obligation="normative">
            <title>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <terms id="I" obligation="normative">
              <title>Normal Terms</title>
              <term id="J">
                <preferred><expression><name>Term2</name></expression></preferred>
              </term>
            </terms>
            <definitions id="K">
              <dl>
                <dt>Symbol</dt>
                <dd>Definition</dd>
              </dl>
            </definitions>
          </clause>
          <definitions id="L">
            <dl>
              <dt>Symbol</dt>
              <dd>Definition</dd>
            </dl>
          </definitions>
          <clause id="M" inline-header="false" obligation="normative">
            <title>Clause 4</title>
            <clause id="N" inline-header="false" obligation="normative">
              <title>Introduction</title>
            </clause>
            <clause id="O" inline-header="false" obligation="normative">
              <title>Clause 4.2</title>
            </clause>
          </clause>
        </sections>
        <annex id="P" inline-header="false" obligation="normative">
          <title>Annex</title>
          <clause id="Q" inline-header="false" obligation="normative">
            <title>Annex A.1</title>
            <clause id="Q1" inline-header="false" obligation="normative">
              <title>Annex A.1a</title>
            </clause>
          </clause>
          <references id="Q3" normative="false">
            <title>Annex Bibliography</title>
          </references>
        </annex>
        <bibliography>
          <references id="R" normative="true" obligation="informative">
            <title>Normative References</title>
          </references>
          <clause id="S" obligation="informative">
            <title>Bibliography</title>
            <references id="T" normative="false" obligation="informative">
              <title>Bibliography Subsection</title>
            </references>
          </clause>
        </bibliography>
      </iso-standard>
    INPUT

    presxml = <<~OUTPUT
       <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
           <preface>
              <clause type="toc" id="_" displayorder="1">
                 <fmt-title depth="1">Contents</fmt-title>
              </clause>
              <abstract obligation="informative" displayorder="2" id="_">
                 <title id="_">Foreword</title>
                 <fmt-title depth="1">
                    <semx element="title" source="_">Foreword</semx>
                 </fmt-title>
                 <p id="A">This is a preamble</p>
              </abstract>
              <introduction id="B" obligation="informative" displayorder="3">
                 <title id="_">Introduction</title>
                 <fmt-title depth="1">
                    <semx element="title" source="_">Introduction</semx>
                 </fmt-title>
                 <clause id="C" inline-header="false" obligation="informative">
                    <title id="_">Introduction Subsection</title>
                    <fmt-title depth="2">
                       <semx element="title" source="_">Introduction Subsection</semx>
                    </fmt-title>
                 </clause>
                 <p>This is patent boilerplate</p>
              </introduction>
              <acknowledgements obligation="informative" displayorder="4" id="_">
                 <title id="_">Acknolwedgements</title>
                 <fmt-title depth="1">
                    <semx element="title" source="_">Acknolwedgements</semx>
                 </fmt-title>
                 <p id="A">This is a preamble</p>
              </acknowledgements>
           </preface>
           <sections>
              <p class="zzSTDTitle1" displayorder="5">??? for ???</p>
              <clause id="D" obligation="normative" type="overview" displayorder="6">
                 <title id="_">Overview</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="D">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Overview</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="D">1</semx>
                 </fmt-xref-label>
                 <p id="E">Text</p>
                 <clause id="D1" obligation="normative" type="scope">
                    <title id="_">Scope</title>
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="D">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="D1">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Scope</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Clause</span>
                       <semx element="autonum" source="D">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="D1">1</semx>
                    </fmt-xref-label>
                 </clause>
                 <clause id="D2" obligation="normative" type="purpose">
                    <title id="_">Purpose</title>
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="D">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="D2">2</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Purpose</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Clause</span>
                       <semx element="autonum" source="D">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="D2">2</semx>
                    </fmt-xref-label>
                 </clause>
              </clause>
              <clause id="H" obligation="normative" displayorder="8">
                 <title id="_">Terms, Definitions, Symbols and Abbreviated Terms</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="H">3</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Terms, Definitions, Symbols and Abbreviated Terms</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="H">3</semx>
                 </fmt-xref-label>
                 <terms id="I" obligation="normative">
                    <title id="_">Normal Terms</title>
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="H">3</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="I">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Normal Terms</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Clause</span>
                       <semx element="autonum" source="H">3</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="I">1</semx>
                    </fmt-xref-label>
                     <term id="J">
                      <preferred id="_">
                         <expression>
                            <name>Term2</name>
                         </expression>
                      </preferred>
                      <fmt-definition>
                         <p>
                            <semx element="preferred" source="_">
                               <strong>Term2</strong>
                            </semx>
                            :
                         </p>
                      </fmt-definition>
                   </term>
                 </terms>
                 <definitions id="K">
                    <title id="_">Acronyms and abbreviations</title>
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="H">3</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="K">2</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Acronyms and abbreviations</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Clause</span>
                       <semx element="autonum" source="H">3</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="K">2</semx>
                    </fmt-xref-label>
                    <dl>
                       <dt>Symbol</dt>
                       <dd>Definition</dd>
                    </dl>
                 </definitions>
              </clause>
              <definitions id="L" displayorder="9">
                 <title id="_">Acronyms and abbreviations</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="L">4</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Acronyms and abbreviations</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="L">4</semx>
                 </fmt-xref-label>
                 <dl>
                    <dt>Symbol</dt>
                    <dd>Definition</dd>
                 </dl>
              </definitions>
              <clause id="M" inline-header="false" obligation="normative" displayorder="10">
                 <title id="_">Clause 4</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="M">5</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Clause 4</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="M">5</semx>
                 </fmt-xref-label>
                 <clause id="N" inline-header="false" obligation="normative">
                    <title id="_">Introduction</title>
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="M">5</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="N">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Introduction</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Clause</span>
                       <semx element="autonum" source="M">5</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="N">1</semx>
                    </fmt-xref-label>
                 </clause>
                 <clause id="O" inline-header="false" obligation="normative">
                    <title id="_">Clause 4.2</title>
                    <fmt-title depth="2">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="M">5</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="O">2</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Clause 4.2</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Clause</span>
                       <semx element="autonum" source="M">5</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="O">2</semx>
                    </fmt-xref-label>
                 </clause>
              </clause>
              <references id="R" normative="true" obligation="informative" displayorder="7">
                 <title id="_">Normative References</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="R">2</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Normative References</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Clause</span>
                    <semx element="autonum" source="R">2</semx>
                 </fmt-xref-label>
              </references>
           </sections>
           <annex id="P" inline-header="false" obligation="normative" autonum="A" displayorder="11">
              <title id="_">
                 <strong>Annex</strong>
              </title>
              <fmt-title>
                 <strong>
                    <span class="fmt-caption-label">
                       <span class="fmt-element-name">Annex</span>
                       <semx element="autonum" source="P">A</semx>
                    </span>
                 </strong>
                 <br/>
                 <span class="fmt-obligation">(normative)</span>
                 <span class="fmt-caption-delim">
                    <br/>
                 </span>
                 <semx element="title" source="_">
                    <strong>Annex</strong>
                 </semx>
              </fmt-title>
              <fmt-xref-label>
                 <span class="fmt-element-name">Annex</span>
                 <semx element="autonum" source="P">A</semx>
              </fmt-xref-label>
              <clause id="Q" inline-header="false" obligation="normative" autonum="A.1">
                 <title id="_">Annex A.1</title>
                 <fmt-title depth="2">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="P">A</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="Q">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Annex A.1</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Annex</span>
                    <semx element="autonum" source="P">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Q">1</semx>
                 </fmt-xref-label>
                 <clause id="Q1" inline-header="false" obligation="normative" autonum="A.1.1">
                    <title id="_">Annex A.1a</title>
                    <fmt-title depth="3">
                       <span class="fmt-caption-label">
                          <semx element="autonum" source="P">A</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="Q">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                          <semx element="autonum" source="Q1">1</semx>
                          <span class="fmt-autonum-delim">.</span>
                       </span>
                       <span class="fmt-caption-delim">
                          <tab/>
                       </span>
                       <semx element="title" source="_">Annex A.1a</semx>
                    </fmt-title>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Annex</span>
                       <semx element="autonum" source="P">A</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="Q">1</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="Q1">1</semx>
                    </fmt-xref-label>
                 </clause>
              </clause>
              <references id="Q3" normative="false" autonum="A.2">
                 <title id="_">Annex Bibliography</title>
                 <fmt-title depth="2">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="P">A</semx>
                       <span class="fmt-autonum-delim">.</span>
                       <semx element="autonum" source="Q3">2</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Annex Bibliography</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <span class="fmt-element-name">Annex</span>
                    <semx element="autonum" source="P">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Q3">2</semx>
                 </fmt-xref-label>
              </references>
           </annex>
           <bibliography>
              <clause id="S" obligation="informative" displayorder="12">
                 <title id="_">Bibliography</title>
                 <fmt-title depth="1">
                    <semx element="title" source="_">Bibliography</semx>
                 </fmt-title>
                 <references id="T" normative="false" obligation="informative">
                    <title id="_">Bibliography Subsection</title>
                    <fmt-title depth="2">
                       <semx element="title" source="_">Bibliography Subsection</semx>
                    </fmt-title>
                 </references>
              </clause>
           </bibliography>
        </iso-standard>
    OUTPUT

    html = <<~OUTPUT
      #{HTML_HDR}
           <br/>
           <div id="_">
             <h1 class='AbstractTitle'>Foreword</h1>
             <p id='A'>This is a preamble</p>
           </div>
           <br/>
           <div class='Section3' id='B'>
             <h1 class='IntroTitle'>Introduction</h1>
             <div id='C'>
               <h2>Introduction Subsection</h2>
             </div>
             <p>This is patent boilerplate</p>
           </div>
           <br/>
           <div class='Section3' id='_'>
             <h1 class='IntroTitle'>Acknolwedgements</h1>
             <p id='A'>This is a preamble</p>
           </div>
           <p class="zzSTDTitle1">??? for ???</p>
           <div id='D'>
             <h1>1.&#xa0; Overview</h1>
             <p id='E'>Text</p>
             <div id='D1' type='scope'>
               <h2>1.1.&#xa0; Scope</h2>
             </div>
             <div id='D2' type='purpose'>
               <h2>1.2.&#xa0; Purpose</h2>
             </div>
           </div>
           <div>
             <h1>2.&#xa0; Normative References</h1>
           </div>
           <div id='H'>
             <h1>3.&#xa0; Terms, Definitions, Symbols and Abbreviated Terms</h1>
             <div id='I'>
               <h2>3.1.&#xa0; Normal Terms</h2>
               <p class='TermNum' id='J'/>
               <p>
                 <b>Term2</b>
                 :
               </p>
             </div>
             <div id='K'>
           <h2>3.2.  Acronyms and abbreviations</h2>
               <div class="figdl">
               <dl>
                 <dt>
                   <p>Symbol</p>
                 </dt>
                 <dd>Definition</dd>
               </dl>
               </div>
             </div>
           </div>
           <div id='L' class='Symbols'>
         <h1>4.  Acronyms and abbreviations</h1>
             <div class="figdl">
             <dl>
               <dt>
                 <p>Symbol</p>
               </dt>
               <dd>Definition</dd>
             </dl>
             </div>
           </div>
           <div id='M'>
             <h1>5.&#xa0; Clause 4</h1>
             <div id='N'>
               <h2>5.1.&#xa0; Introduction</h2>
             </div>
             <div id='O'>
               <h2>5.2.&#xa0; Clause 4.2</h2>
             </div>
           </div>
           <br/>
           <div id='P' class='Section3'>
             <h1 class='Annex'>
               <b>Annex A</b>
               <br/>
               <span class="obligation">(normative)</span>
               <br/>
               <b>Annex</b>
             </h1>
             <div id='Q'>
               <h2>A.1.&#xa0; Annex A.1</h2>
               <div id='Q1'>
                 <h3>A.1.1.&#xa0; Annex A.1a</h3>
               </div>
             </div>
             <div>
               <h2 class='Section3'>A.2.&#xa0; Annex Bibliography</h2>
             </div>
           </div>
           <br/>
           <div>
             <h1 class='Section3'>Bibliography</h1>
             <div>
               <h2 class='Section3'>Bibliography Subsection</h2>
             </div>
           </div>
         </div>
       </body>
    OUTPUT

    word = <<~OUTPUT
          <body lang='EN-US' link='blue' vlink='#954F72'>
        <div class='WordSection1'>
          <p>&#xa0;</p>
        </div>
        <p class="section-break">
          <br clear='all' class='section'/>
        </p>
        <div class='WordSection2'>
            <div class="WordSectionContents">
          <h1 class="IEEEStdsLevel1frontmatter">Contents</h1>
        </div>
          <p class="page-break">
            <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
          </p>
          <div class='abstract' id="_">
            <h1 class='AbstractTitle'>Foreword</h1>
            <p id='A'>This is a preamble</p>
          </div>
          <p class="page-break">
            <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
          </p>
          <div class='Section3' id='B'>
            <h1 class='IntroTitle'>Introduction</h1>
            <div id='C'>
              <h2>Introduction Subsection</h2>
            </div>
            <p>This is patent boilerplate</p>
          </div>
          <p class="page-break">
            <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
          </p>
          <div class='Section3' id='_'>
            <h1 class='IntroTitle'>Acknolwedgements</h1>
            <p id='A'>This is a preamble</p>
          </div>
          <p>&#xa0;</p>
        </div>
        <p class="section-break">
          <br clear='all' class='section'/>
        </p>
        <div class='WordSectionMiddleTitle'>
          <p class='IEEEStdsTitle' style='margin-left:0cm;margin-top:70.0pt'>??? for ???</p>
        </div>
        <p class="section-break">
          <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
        </p>
        <div class='WordSectionMain'>
          <div id='D'>
            <h1>
              1.
              <span style='mso-tab-count:1'>&#xa0; </span>
              Overview
            </h1>
            <p id='E'>Text</p>
            <div id='D1' type='scope'>
              <h2>
                1.1.
                <span style='mso-tab-count:1'>&#xa0; </span>
                Scope
              </h2>
            </div>
            <div id='D2' type='purpose'>
              <h2>
                1.2.
                <span style='mso-tab-count:1'>&#xa0; </span>
                Purpose
              </h2>
            </div>
          </div>
          <div>
            <h1>
              2.
              <span style='mso-tab-count:1'>&#xa0; </span>
              Normative References
            </h1>
          </div>
          <div id='H'>
            <h1>
              3.
              <span style='mso-tab-count:1'>&#xa0; </span>
              Terms, Definitions, Symbols and Abbreviated Terms
            </h1>
            <div id='I'>
              <h2>
                3.1.
                <span style='mso-tab-count:1'>&#xa0; </span>
                Normal Terms
              </h2>
              <p class='TermNum' id='J'/>
              <p>
                <b>Term2</b>
                :
              </p>
            </div>
            <div id='K'>
                   <h2>
                      3.2.
                      <span style="mso-tab-count:1">  </span>
                      Acronyms and abbreviations
                   </h2>
              <table class='dl'>
                <tr>
                  <td valign='top' align='left'>
                    <p align='left' style='margin-left:0pt;text-align:left;'>Symbol</p>
                  </td>
                  <td valign='top'>Definition</td>
                </tr>
              </table>
            </div>
          </div>
          <div id='L' class='Symbols'>
                <h1>
                   4.
                   <span style="mso-tab-count:1">  </span>
                   Acronyms and abbreviations
                </h1>
            <table class='dl'>
              <tr>
                <td valign='top' align='left'>
                  <p align='left' style='margin-left:0pt;text-align:left;'>Symbol</p>
                </td>
                <td valign='top'>Definition</td>
              </tr>
            </table>
          </div>
          <div id='M'>
            <h1>
              5.
              <span style='mso-tab-count:1'>&#xa0; </span>
              Clause 4
            </h1>
            <div id='N'>
              <h2>
                5.1.
                <span style='mso-tab-count:1'>&#xa0; </span>
                Introduction
              </h2>
            </div>
            <div id='O'>
              <h2>
                5.2.
                <span style='mso-tab-count:1'>&#xa0; </span>
                Clause 4.2
              </h2>
            </div>
          </div>
          <p class="page-break">
            <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
          </p>
          <div id='P' class='Annex'>
            <h1 class='Annex'>
              <br/>
              <span style='font-weight:normal;'>(normative)</span>
              <br/>
              <b>Annex</b>
            </h1>
            <div id='Q'>
              <h2>
                A.1.
                <span style='mso-tab-count:1'>&#xa0; </span>
                Annex A.1
              </h2>
              <div id='Q1'>
                <h3>
                  A.1.1.
                  <span style='mso-tab-count:1'>&#xa0; </span>
                  Annex A.1a
                </h3>
              </div>
            </div>
            <div>
              <h2 class='Section3'>
                A.2.
                <span style='mso-tab-count:1'>&#xa0; </span>
                Annex Bibliography
              </h2>
            </div>
          </div>
          <p class="page-break">
            <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
          </p>
          <div>
            <h1 class='Section3'>Bibliography</h1>
            <div>
              <h2 class='Section3'>Bibliography Subsection</h2>
            </div>
          </div>
        </div>
      </body>
    OUTPUT
    pres_output = IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
    expect(Xml::C14n.format(strip_guid(pres_output)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(IsoDoc::Ieee::HtmlConvert.new({})
      .convert("test", pres_output, true))
      .at("//body").to_xml)))
      .to be_equivalent_to Xml::C14n.format(html)
    expect(Xml::C14n.format(strip_guid(IsoDoc::Ieee::WordConvert.new({})
      .convert("test", pres_output, true)
      .sub(/^.*<body /m, "<body ").sub(%r{</body>.*$}m, "</body>"))))
      .to be_equivalent_to Xml::C14n.format(word)
  end

  it "processes middle title" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
        <bibdata>
          <title format="text/plain" language="en">Title</title>
          <version><draft>2</draft></version>
          <ext>
            <doctype>Recommended Practice</doctype>
            <structuredidentifier>
              <project-number origyr="2016-05-01" part="1">17301</project-number>
            </structuredidentifier>
          </ext>
        </bibdata>
        <preface>
           <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause> 
        </preface>
        <sections>
        <clause/>
        </sections>
      </iso-standard>
    INPUT
    presxml = <<~PRESXML
      <sections>
          <p class="zzSTDTitle1" displayorder="2">Draft Recommended Practice for Title</p>
          <clause id="_" displayorder="3">
             <fmt-title depth="1">
                <span class="fmt-caption-label">
                   <semx element="autonum" source="_">1</semx>
                   <span class="fmt-autonum-delim">.</span>
                </span>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Clause</span>
                <semx element="autonum" source="_">1</semx>
             </fmt-xref-label>
          </clause>
       </sections>
    PRESXML
    html = <<~OUTPUT
      <div class="main-section">
         <br/>
         <div id="_" class="TOC">
           <h1 class="IntroTitle">Contents</h1>
         </div>
         <p class="zzSTDTitle1">Draft Recommended Practice for Title</p>
         <div id="_">
           <h1>1.</h1>
         </div>
       </div>
    OUTPUT
    word = <<~OUTPUT
      <div class='WordSectionMiddleTitle'>
         <p class='IEEEStdsTitle' style='margin-left:0cm;margin-top:70.0pt'>Draft Recommended Practice for Title</p>
       </div>
    OUTPUT
    pres_output = IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(pres_output)
                .at("//xmlns:sections").to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(IsoDoc::Ieee::HtmlConvert.new({})
      .convert("test", pres_output, true))
      .at("//div[@class = 'main-section']").to_xml)))
      .to be_equivalent_to Xml::C14n.format(html)
    expect(Xml::C14n.format(Nokogiri::XML(IsoDoc::Ieee::WordConvert.new({})
      .convert("test", pres_output, true))
      .at("//div[@class = 'WordSectionMiddleTitle']").to_xml))
      .to be_equivalent_to Xml::C14n.format(word)
  end

  it "processes bibliography annex" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
           <annex id='a' inline-header='false' obligation='normative'>
           <title>Appendix C</title>
           <references id='_' normative='false' obligation='informative'>
             <title>Bibliography</title>
             <p id='_'>
               Bibliographical references are resources that provide additional or
               helpful material but do not need to be understood or used to implement
               this standard. Reference to these resources is made for informational
               use only.
             </p>
             <bibitem id='ABC'>
               <formattedref format='application/x-isodoc+xml'/>
               <docidentifier>DEF</docidentifier>
             </bibitem>
           </references>
         </annex>
         </iso-standard>
    INPUT
    presxml = <<~OUTPUT
        <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
           <preface>
              <clause type="toc" id="_" displayorder="1">
                 <fmt-title depth="1">Contents</fmt-title>
              </clause>
           </preface>
           <annex id="a" inline-header="false" obligation="normative" autonum="A" displayorder="2">
              <title id="_">
                 <strong>Appendix C</strong>
              </title>
              <fmt-title>
                 <strong>
                    <span class="fmt-caption-label">
                       <span class="fmt-element-name">Annex</span>
                       <semx element="autonum" source="a">A</semx>
                    </span>
                 </strong>
                 <br/>
                 <span class="fmt-obligation">(normative)</span>
                 <span class="fmt-caption-delim">
                    <br/>
                 </span>
                 <semx element="title" source="_">
                    <strong>Appendix C</strong>
                 </semx>
              </fmt-title>
              <fmt-xref-label>
                 <span class="fmt-element-name">Annex</span>
                 <semx element="autonum" source="a">A</semx>
              </fmt-xref-label>
              <references id="_" normative="false" obligation="informative">
                 <p id="_">
                 Bibliographical references are resources that provide additional or
                 helpful material but do not need to be understood or used to implement
                 this standard. Reference to these resources is made for informational
                 use only.
               </p>
                 <bibitem id="ABC">
                    <formattedref format="application/x-isodoc+xml"/>
                    <docidentifier type="metanorma-ordinal">[B1]</docidentifier>
                    <docidentifier>DEF</docidentifier>
                    <docidentifier scope="biblio-tag">DEF</docidentifier>
                    <biblio-tag>
                       [B1]
                       <tab/>
                       DEF,
                    </biblio-tag>
                 </bibitem>
              </references>
           </annex>
        </iso-standard>
    OUTPUT
    html = <<~OUTPUT
      #{HTML_HDR}
           <br/>
           <div id='a' class='Section3'>
             <h1 class='Annex'>
               <b>Annex A</b><br/><span class='obligation'>(normative)</span>
               <br/>
               <b>Appendix C</b>
             </h1>
             <div>
               <p id='_'>
                  Bibliographical references are resources that provide additional or
                 helpful material but do not need to be understood or used to implement
                 this standard. Reference to these resources is made for informational
                 use only.
               </p>
               <p id='ABC' class='Biblio'>[B1]&#xa0; DEF, </p>
             </div>
           </div>
         </div>
       </body>
    OUTPUT
    word = <<~OUTPUT
      <div>
         <a name='a' id='a'/>
         <h1 style='mso-list:l13 level1 lfo33;'>
           <br/>
           <span style='font-weight:normal;'>(normative)</span>
           <br/>
           <b>Appendix C</b>
         </h1>
         <div>
           <p class='IEEEStdsParagraph'>
             <a name='_' id='_'/>
              Bibliographical references are resources that provide additional or
             helpful material but do not need to be understood or used to implement
             this standard. Reference to these resources is made for informational use
             only.
           </p>
           <p class='IEEEStdsBibliographicEntry'>
             <a name='ABC' id='ABC'/>
             DEF,
           </p>
         </div>
       </div>
    OUTPUT
    pres_output = IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
    expect(Xml::C14n.format(strip_guid(pres_output)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(IsoDoc::Ieee::HtmlConvert.new({})
      .convert("test", pres_output, true))
      .at("//body").to_xml)))
      .to be_equivalent_to Xml::C14n.format(html)
    IsoDoc::Ieee::WordConvert.new({}).convert("test", pres_output, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'a']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(word)
  end

  it "processes participants" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <boilerplate>
              <legal-statement>
           <clause id="boilerplate-participants" type="participants" inline-header="false" obligation="normative">
         <title>Participants</title>
         <clause id="boilerplate-participants-wg" inline-header="false" obligation="normative">
           <p id="_">At the time this draft Standard was completed, the  had the following membership:</p>
           <ul id="_">
             <li>
               <dl id="_">
                 <dt>name</dt>
                 <dd>
                   <p id="_">
                     <span class="surname">Socrates</span>
                     <span class="forename">Adalbert</span>
                   </p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">Chair</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id="_">
                 <dt>name</dt>
                 <dd>
                   <p id="_">Plato</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">Technical editor</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id="_">
                 <dt>name</dt>
                 <dd>
                   <p id="_">Aristotle</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">Member</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id="_">
                 <dt>name</dt>
                 <dd>
                   <p id="_">Anaximander</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">member</p>
                 </dd>
               </dl>
             </li>
           </ul>
           <p id="_">This is an additional clause.</p>
         </clause>
         <clause id="boilerplate-participants-bg" inline-header="false" obligation="normative">
           <p id="_">The following members of the   Standards Association balloting group voted on this Standard. Balloters may have voted for approval, disapproval, or abstention.</p>
           <ul id="_">
             <li>
               <dl id="_">
                 <dt>name</dt>
                 <dd>
                   <p id="_">Athanasius of Alexandria</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">member</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id="_">
                 <dt>name</dt>
                 <dd>
                   <p id="_"><span class="forename">Basil</span> of <span class="surname">Caesarea</span></p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">member</p>
                 </dd>
               </dl>
             </li>
           </ul>
           <p id="_">And this is another list</p>
           <ul id="_">
             <li>
               <dl id="_">
                 <dt>company</dt>
                 <dd>
                   <p id="_">
                     <span class="organization">Microsoft</span>
                   </p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">member</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id="_">
                 <dt>company</dt>
                 <dd>
                   <p id="_">
                     <span class="organization">Alphabet</span>
                   </p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">Member</p>
                 </dd>
               </dl>
             </li>
           </ul>
         </clause>
         <clause id="boilerplate-participants-sb" inline-header="false" obligation="normative">
           <p id="_">When the IEEE SA Standards Board approved this Standard on &lt;Date Approved&gt;, it had the following membership:</p>
           <ul id="_">
             <li>
               <dl id="_">
                 <dt>name</dt>
                 <dd>
                   <p id="_">Aeschylus</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">Chair</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id="_">
                 <dt>name</dt>
                 <dd>
                   <p id="_">Sophocles</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">Technical editor</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id="_">
                 <dt>name</dt>
                 <dd>
                   <p id="_">Euripides</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">member</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id="_">
                 <dt>name</dt>
                 <dd>
                   <p id="_">Aristophanes*</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">member</p>
                 </dd>
               </dl>
             </li>
           </ul>
           <p id="_" type="emeritus_sign"><span class="cite_fn">*</span>Member Emeritus</p>
           <p id="_">This is an additional clause.</p>
           <ul id="_">
             <li>
               <dl id="_">
                 <dt>company</dt>
                 <dd>
                   <p id="_">
                     <span class="organization">Waldorf-Astoria</span>
                   </p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">member</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id="_">
                 <dt>company</dt>
                 <dd>
                   <p id="_">
                     <span class="organization">Ritz</span>
                   </p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">Member</p>
                 </dd>
               </dl>
             </li>
           </ul>
           <p id="_">And again:</p>
           <ul id="_">
             <li>
               <dl id="_">
                 <dt>name</dt>
                 <dd>
                   <p id="_">name1</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">member</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id="_">
                 <dt>name</dt>
                 <dd>
                   <p id="_">name2</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id="_">member</p>
                 </dd>
               </dl>
             </li>
           </ul>
         </clause>
       </clause>
              </legal-statement>
      </boilerplate>
         </iso-standard>
    INPUT
    presxml = <<~OUTPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
         <boilerplate>
           <legal-statement>
             <clause id="boilerplate-participants" type="participants" inline-header="false" obligation="normative">
               <title id="_">Participants</title>
            <fmt-title depth="1">
                  <semx element="title" source="_">Participants</semx>
            </fmt-title>
               <clause id="boilerplate-participants-wg" inline-header="false" obligation="normative">
                 <p id="_">At the time this draft Standard was completed, the  had the following membership:</p>
                 <p type="officeholder" align="center"><strong><span class="surname">Socrates</span><span class="forename">Adalbert</span></strong>, <em><span class="au_role">Chair</span></em></p>
                 <p type="officeholder" align="center"><strong>Plato</strong>, <em><span class="au_role">Technical editor</span></em></p>
                 <p type="officemember">Aristotle</p>
                 <p type="officemember">Anaximander</p>
                 <p id="_">This is an additional clause.</p>
               </clause>
               <clause id="boilerplate-participants-bg" inline-header="false" obligation="normative">
                 <p id="_">The following members of the   Standards Association balloting group voted on this Standard. Balloters may have voted for approval, disapproval, or abstention.</p>
                 <p type="officemember">Athanasius of Alexandria</p>
                 <p type="officemember"><span class="forename">Basil</span> of <span class="surname">Caesarea</span></p>
                 <p id="_">And this is another list</p>
                 <p type="officeorgmember">
                   <span class="organization">Microsoft</span>
                 </p>
                 <p type="officeorgmember">
                   <span class="organization">Alphabet</span>
                 </p>
               </clause>
               <clause id="boilerplate-participants-sb" inline-header="false" obligation="normative">
                 <p id="_">When the IEEE SA Standards Board approved this Standard on &lt;Date Approved&gt;, it had the following membership:</p>
                 <p type="officeholder" align="center"><strong>Aeschylus</strong>, <em><span class="au_role">Chair</span></em></p>
                 <p type="officeholder" align="center"><strong>Sophocles</strong>, <em><span class="au_role">Technical editor</span></em></p>
                 <p type="officemember">Euripides</p>
                 <p type="officemember">Aristophanes<span class="cite_fn">*</span></p>
                 <p id="_" type="emeritus_sign"><span class="cite_fn">*</span>Member Emeritus</p>
                 <p id="_">This is an additional clause.</p>
                 <p type="officeorgmember">
                   <span class="organization">Waldorf-Astoria</span>
                 </p>
                 <p type="officeorgmember">
                   <span class="organization">Ritz</span>
                 </p>
                 <p id="_">And again:</p>
                 <p type="officemember">name1</p>
                 <p type="officemember">name2</p>
               </clause>
             </clause>
           </legal-statement>
         </boilerplate>
       </iso-standard>
    OUTPUT
    html = <<~OUTPUT
      <div id="boilerplate-participants" type="participants">
         <h1 class="IntroTitle"><a class="anchor" href="#boilerplate-participants"/><a class="header" href="#boilerplate-participants">Participants</a></h1>
         <div id="boilerplate-participants-wg">
           <p id="_">At the time this draft Standard was completed, the  had the following membership:</p>
           <p style="text-align:center;"><b><span class="surname">Socrates</span><span class="forename">Adalbert</span></b>, <i><span class="au_role">Chair</span></i></p>
           <p style="text-align:center;"><b>Plato</b>, <i><span class="au_role">Technical editor</span></i></p>
           <p>Aristotle</p>
           <p>Anaximander</p>
           <p id="_">This is an additional clause.</p>
         </div>
         <div id="boilerplate-participants-bg">
           <p id="_">The following members of the   Standards Association balloting group voted on this Standard. Balloters may have voted for approval, disapproval, or abstention.</p>
           <p>Athanasius of Alexandria</p>
           <p><span class="forename">Basil</span> of <span class="surname">Caesarea</span></p>
           <p id="_">And this is another list</p>
           <p>
             <span class="organization">Microsoft</span>
           </p>
           <p>
             <span class="organization">Alphabet</span>
           </p>
         </div>
         <div id="boilerplate-participants-sb">
           <p id="_">When the IEEE SA Standards Board approved this Standard on &lt;Date Approved&gt;, it had the following membership:</p>
           <p style="text-align:center;"><b>Aeschylus</b>, <i><span class="au_role">Chair</span></i></p>
           <p style="text-align:center;"><b>Sophocles</b>, <i><span class="au_role">Technical editor</span></i></p>
           <p>Euripides</p>
           <p>Aristophanes<span class="cite_fn">*</span></p>
           <p id="_"><span class="cite_fn">*</span>Member Emeritus</p>
           <p id="_">This is an additional clause.</p>
           <p>
             <span class="organization">Waldorf-Astoria</span>
           </p>
           <p>
             <span class="organization">Ritz</span>
           </p>
           <p id="_">And again:</p>
           <p>name1</p>
           <p>name2</p>
         </div>
       </div>
    OUTPUT
    word = <<~OUTPUT
      <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US">
         <p class="IEEEStdsParagraph">
           <br clear="all" class="section"/>
         </p>
         <span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Times New Roman&quot;,serif; mso-fareast-font-family:&quot;Times New Roman&quot;;color:white;mso-ansi-language:EN-US; mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
           <br clear="all" style="page-break-before:always;mso-break-type:section-break"/>
         </span>
         <!-- points to feedback statement as footnote -->
         <div class="WordSection3">
           <div>
             <a name="boilerplate-disclaimers-destination" id="boilerplate-disclaimers-destination"/>
           </div>
         </div>
         <span lang="EN-US" style="font-size:12.0pt;mso-bidi-font-size:10.0pt;font-family: &quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
           <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
         </span>
         <div type="participants">
           <a name="boilerplate-participants" id="boilerplate-participants"/>
           <p class="IEEEStdsLevel1frontmatter">Participants</p>
           <p class="IEEEStdsParagraph"><a name="_" id="_"/>At the time this draft Standard was completed, the  had the following membership:</p>
           <p style="text-align:center;" align="center" class="IEEEStdsNamesCtrCxSpFirst"><b><span class="au_surname">Socrates</span><span class="au_fname">Adalbert</span></b>, <i><span class="au_role">Chair</span></i></p>
           <p style="text-align:center;" align="center" class="IEEEStdsNamesCtrCxSpLast"><b>Plato</b>, <i><span class="au_role">Technical editor</span></i></p>
         </div>
         <span lang="EN-US" style="font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
           <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
           <div class="WordSection4">
             <p class="IEEEStdsNamesList">Aristotle</p>
             <p class="IEEEStdsNamesList">Anaximander</p>
           </div>
           <span lang="EN-US" style="font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
             <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
             <div class="WordSection5">
               <p class="IEEEStdsParagraph"> </p>
               <p class="IEEEStdsParagraph"><a name="_" id="_"/>This is an additional clause.</p>
               <p class="IEEEStdsParagraph"><a name="_" id="_"/>The following members of the   Standards Association balloting group voted on this Standard. Balloters may have voted for approval, disapproval, or abstention.</p>
             </div>
             <span lang="EN-US" style="font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
               <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
               <div class="WordSection6">
                 <p class="IEEEStdsNamesList">Athanasius of Alexandria</p>
                 <p class="IEEEStdsNamesList"><span class="au_fname">Basil</span> of <span class="au_surname">Caesarea</span></p>
               </div>
               <span lang="EN-US" style="font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
                 <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
                 <div class="WordSection7">
                   <p class="IEEEStdsParagraph"> </p>
                   <p class="IEEEStdsParagraph"><a name="_" id="_"/>And this is another list</p>
                   <p class="IEEEStdsNamesList">
                     <span class="organization">Microsoft</span>
                   </p>
                   <p class="IEEEStdsNamesList">
                     <span class="organization">Alphabet</span>
                   </p>
                   <p class="IEEEStdsParagraph"><a name="_" id="_"/>When the IEEE SA Standards Board approved this Standard on Date Approved, it had the following membership:</p>
                   <p style="text-align:center;" align="center" class="IEEEStdsNamesCtrCxSpFirst"><b>Aeschylus</b>, <i><span class="au_role">Chair</span></i></p>
                   <p style="text-align:center;" align="center" class="IEEEStdsNamesCtrCxSpLast"><b>Sophocles</b>, <i><span class="au_role">Technical editor</span></i></p>
                 </div>
                 <span lang="EN-US" style="font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
                   <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
                   <div class="WordSection8">
                     <p class="IEEEStdsNamesList">Euripides</p>
                     <p class="IEEEStdsNamesList">Aristophanes<span class="cite_fn">*</span></p>
                   </div>
                   <span lang="EN-US" style="font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
                     <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
                     <div class="WordSection9">
                       <p class="IEEEStdsParagraph"> </p>
                       <p class="IEEEStdsParaMemEmeritus"><a name="_" id="_"/><span class="cite_fn">*</span>Member Emeritus</p>
                       <p class="IEEEStdsParagraph"><a name="_" id="_"/>This is an additional clause.</p>
                       <p class="IEEEStdsNamesList">
                         <span class="organization">Waldorf-Astoria</span>
                       </p>
                       <p class="IEEEStdsNamesList">
                         <span class="organization">Ritz</span>
                       </p>
                       <p class="IEEEStdsParagraph"><a name="_" id="_"/>And again:</p>
                     </div>
                     <span lang="EN-US" style="font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
                       <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
                       <div class="WordSection10">
                         <p class="IEEEStdsNamesList">name1</p>
                         <p class="IEEEStdsNamesList">name2</p>
                       </div>
                     </span>
                   </span>
                 </span>
               </span>
             </span>
           </span>
         </span>
         <b style="mso-bidi-font-weight:normal">
           <span lang="EN-US" style="font-size:12.0pt; mso-bidi-font-size:10.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-fareast-font-family: &quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
             <br clear="all" style="page-break-before:always;mso-break-type:section-break"/>
           </span>
         </b>
         <div class="authority">
           <div class="boilerplate-legal"/>
         </div>
         <p class="IEEEStdsParagraph"> </p>
         <p class="IEEEStdsParagraph">
           <br clear="all" class="section"/>
         </p>
         <p class="IEEEStdsParagraph">
           <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
         </p>
         <div style="mso-element:footnote-list"/>
       </body>
    OUTPUT
    FileUtils.rm_rf "test.html"
    FileUtils.rm_rf "test.doc"
    pres_output = IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
    expect(Xml::C14n.format(strip_guid(pres_output)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    IsoDoc::Ieee::HtmlConvert.new({}).convert("test", pres_output, false)
    expect(File.exist?("test.html")).to be true
    expect(strip_guid(Xml::C14n.format(Nokogiri::XML(File.read("test.html"))
      .at("//div[@id = 'boilerplate-participants']").to_xml)))
      .to be_equivalent_to Xml::C14n.format(html)
    IsoDoc::Ieee::WordConvert.new({}).convert("test", pres_output, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc")).at("//xmlns:body")
    doc.at("//xmlns:div[@class = 'WordSection1']")&.remove
    doc.at("//xmlns:div[@class = 'WordSection2']")&.remove
    doc.at("//xmlns:div[@class = 'WordSectionContents']")&.remove
    doc.at("//xmlns:div[@class = 'WordSectionMiddleTitle']")&.remove
    doc.at("//xmlns:div[@class = 'WordSectionMain']")&.remove
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(word)
  end
end
