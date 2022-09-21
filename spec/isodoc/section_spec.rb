require "spec_helper"

RSpec.describe IsoDoc::IEEE do
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
          <abstract obligation="informative" displayorder="1">
            <title>Foreword</title>
            <p id="A">This is a preamble</p>
          </abstract>
          <introduction id="B" obligation="informative" displayorder="2">
            <title>Introduction</title>
            <clause id="C" inline-header="false" obligation="informative">
              <title depth="2">Introduction Subsection</title>
            </clause>
            <p>This is patent boilerplate</p>
          </introduction>
          <acknowledgements obligation="informative" displayorder="3">
            <title>Acknolwedgements</title>
            <p id="A">This is a preamble</p>
          </acknowledgements>
        </preface>
        <sections>
          <clause id="D" obligation="normative" type="overview" displayorder="4">
            <title depth="1">1.<tab/>Overview</title>
            <p id="E">Text</p>
            <clause id="D1" obligation="normative" type="scope">
            <title depth="2">1.1.<tab/>Scope</title>
            </clause>
            <clause id="D2" obligation="normative" type="purpose">
            <title depth="2">1.2.<tab/>Purpose</title>
            </clause>
          </clause>
          <clause id="H" obligation="normative" displayorder="6">
            <title depth="1">3.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <terms id="I" obligation="normative">
              <title depth="2">3.1.<tab/>Normal Terms</title>
              <term id="J">

              <p><strong>Term2</strong>:

      </p>
      </term>
            </terms>
            <definitions id="K"><title>3.2.</title>
              <dl>
                <dt>Symbol</dt>
                <dd>Definition</dd>
              </dl>
            </definitions>
          </clause>
          <definitions id="L" displayorder="7"><title>4.</title>
            <dl>
              <dt>Symbol</dt>
              <dd>Definition</dd>
            </dl>
          </definitions>
          <clause id="M" inline-header="false" obligation="normative" displayorder="8">
            <title depth="1">5.<tab/>Clause 4</title>
            <clause id="N" inline-header="false" obligation="normative">
              <title depth="2">5.1.<tab/>Introduction</title>
            </clause>
            <clause id="O" inline-header="false" obligation="normative">
              <title depth="2">5.2.<tab/>Clause 4.2</title>
            </clause>
          </clause>
        </sections>
        <annex id="P" inline-header="false" obligation="normative" displayorder="9">
          <title><strong>Annex A</strong><br/><span class="obligation">(normative)</span><br/><strong>Annex</strong></title>
          <clause id="Q" inline-header="false" obligation="normative">
            <title depth="2">A.1.<tab/>Annex A.1</title>
            <clause id="Q1" inline-header="false" obligation="normative">
              <title depth="3">A.1.1.<tab/>Annex A.1a</title>
            </clause>
          </clause>
          <references id="Q3" normative="false">
            <title depth="2">A.2.<tab/>Annex Bibliography</title>
          </references>
        </annex>
        <bibliography>
          <references id="R" normative="true" obligation="informative" displayorder="5">
            <title depth="1">2.<tab/>Normative References</title>
          </references>
          <clause id="S" obligation="informative" displayorder="10">
            <title depth="1">Bibliography</title>
            <references id="T" normative="false" obligation="informative">
              <title depth="2">Bibliography Subsection</title>
            </references>
          </clause>
        </bibliography>
      </iso-standard>
    OUTPUT

    html = <<~OUTPUT
      #{HTML_HDR}
           <br/>
           <div>
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
           <div class='Section3' id=''>
             <h1 class='IntroTitle'>Acknolwedgements</h1>
             <p id='A'>This is a preamble</p>
           </div>
           <p class='zzSTDTitle1'/>
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
               <h2>3.2.</h2>
               <dl>
                 <dt>
                   <p>Symbol</p>
                 </dt>
                 <dd>Definition</dd>
               </dl>
             </div>
           </div>
           <div id='L' class='Symbols'>
             <h1>4.</h1>
             <dl>
               <dt>
                 <p>Symbol</p>
               </dt>
               <dd>Definition</dd>
             </dl>
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
               (normative)
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
        <p>
          <br clear='all' class='section'/>
        </p>
        <div class='WordSection2'>
          <p>
            <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
          </p>
          <div class='abstract'>
            <h1 class='AbstractTitle'>Foreword</h1>
            <p id='A'>This is a preamble</p>
          </div>
          <p>
            <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
          </p>
          <div class='Section3' id='B'>
            <h1 class='IntroTitle'>Introduction</h1>
            <div id='C'>
              <h2>Introduction Subsection</h2>
            </div>
            <p>This is patent boilerplate</p>
          </div>
          <p>
            <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
          </p>
          <div class='Section3' id=''>
            <h1 class='IntroTitle'>Acknolwedgements</h1>
            <p id='A'>This is a preamble</p>
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
              <h2>3.2.</h2>
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
            <h1>4.</h1>
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
          <p>
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
          <p>
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
    expect((IsoDoc::IEEE::PresentationXMLConvert.new({})
      .convert("test", input, true)))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(Nokogiri::XML(IsoDoc::IEEE::HtmlConvert.new({})
      .convert("test", presxml, true))
      .at("//body").to_xml))
      .to be_equivalent_to xmlpp(html)
    expect(xmlpp(IsoDoc::IEEE::WordConvert.new({})
      .convert("test", presxml, true)
      .sub(/^.*<body /m, "<body ").sub(%r{</body>.*$}m, "</body>")))
      .to be_equivalent_to xmlpp(word)
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
        <sections/>
      </iso-standard>
    INPUT
    html = <<~OUTPUT
      #{HTML_HDR}
      <p class='zzSTDTitle1'>Title</p>
          </div>
        </body>
    OUTPUT
    word = <<~OUTPUT
      <div class='WordSectionMiddleTitle'>
         <p class='IEEEStdsTitle' style='margin-top:70.0pt'>Draft Recommended Practice for Title</p>
       </div>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::IEEE::HtmlConvert.new({})
      .convert("test", input, true))
      .at("//body").to_xml))
      .to be_equivalent_to xmlpp(html)
    expect(xmlpp(Nokogiri::XML(IsoDoc::IEEE::WordConvert.new({})
      .convert("test", input, true))
      .at("//div[@class = 'WordSectionMiddleTitle']").to_xml))
      .to be_equivalent_to xmlpp(word)
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
        <annex id="a" inline-header="false" obligation="normative" displayorder="1">
        <title><strong>Annex A</strong><br/><span class='obligation'>(normative)</span><br/><strong>Appendix C</strong></title>
        <references id="_" normative="false" obligation="informative">
          <p id="_">
            Bibliographical references are resources that provide additional or
            helpful material but do not need to be understood or used to implement
            this standard. Reference to these resources is made for informational
            use only.
          </p>
          <bibitem id="ABC">
            <formattedref format="application/x-isodoc+xml"> [DEF] </formattedref>
            <docidentifier type="metanorma-ordinal">[B1]</docidentifier><docidentifier>DEF</docidentifier>
          </bibitem>
        </references>
      </annex>
      </iso-standard>
    OUTPUT
    html = <<~OUTPUT
      #{HTML_HDR}
           <p class='zzSTDTitle1'/>
           <br/>
           <div id='a' class='Section3'>
             <h1 class='Annex'>
               <b>Annex A</b><br/>(normative)
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
               <p id='ABC' class='Biblio'>[B1]&#xa0; DEF, [DEF] </p>
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
             DEF, [DEF]
           </p>
         </div>
       </div>
    OUTPUT
    expect(xmlpp(IsoDoc::IEEE::PresentationXMLConvert.new({})
  .convert("test", input, true)))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(Nokogiri::XML(IsoDoc::IEEE::HtmlConvert.new({})
      .convert("test", presxml, true))
      .at("//body").to_xml))
      .to be_equivalent_to xmlpp(html)
    IsoDoc::IEEE::WordConvert.new({}).convert("test", presxml, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'a']]")
    expect(strip_guid(xmlpp(doc.to_xml)))
      .to be_equivalent_to xmlpp(word)
  end

  it "processes participants" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <boilerplate>
              <legal-statement>
             <clause id='boilerplate-participants'>
         <title>Participants</title>
         <clause id='boilerplate-participants-wg'>
           <p id='_'>
             At the time this draft Standard was completed, the Working Group had the
             following membership:
           </p>
           <title>Working Group</title>
           <ul id='_'>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>Socrates</dd>
                 <dt>role</dt>
                 <dd>Chair</dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>Plato</dd>
                 <dt>role</dt>
                 <dd>Technical editor</dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>Heraclitus</dd>
                 <dt>role</dt>
                 <dd>Member</dd>
                 <dt>company</dt>
                 <dd>Apple</dd>
               </dl>
            </li>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>Aristotle</dd>
                 <dt>role</dt>
                 <dd>Member</dd>
               </dl>
             </li>
             <li>
               <dl>
                 <dt>name</dt>
                 <dd>
                   <p id='_'>Anaximander</p>
                 </dd>
                 <dt>role</dt>
                 <dd>member</dd>
               </dl>
             </li>
           </ul>
           <p id='_'>This is an additional clause.</p>
         </clause>
         <clause id='boilerplate-participants-bg'>
           <p id='_'>
             The following members of the Standards Association balloting group voted
             on this Standard. Balloters may have voted for approval, disapproval, or
             abstention.
           </p>
           <title>Balloting Group</title>
           <ul id='_'>
             <li>
               <dl>
                 <dt>name</dt>
                 <dd>
                   <p id='_'>Athanasius of Alexandria</p>
                 </dd>
                 <dt>role</dt>
                 <dd>member</dd>
               </dl>
             </li>
             <li>
               <dl>
                 <dt>name</dt>
                 <dd>
                   <p id='_'>Basil of Caesarea</p>
                 </dd>
                 <dt>role</dt>
                 <dd>member</dd>
               </dl>
             </li>
           </ul>
           <p id='_'>And this is another list</p>
           <ul id='_'>
             <li>
               <dl id='_'>
                 <dt>company</dt>
                 <dd>Microsoft</dd>
                 <dt>role</dt>
                 <dd>Liaison</dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>company</dt>
                 <dd>Alphabet</dd>
                 <dt>role</dt>
                 <dd>IEEE Standards Program Manager, Document Development</dd>
               </dl>
             </li>
           </ul>
         </clause>
         <clause id='boilerplate-participants-sb'>
           <p id='_'>
             When the IEEE SA Standards Board approved this Standard on &#x3c;Date
             Approved&#x3e;, it had the following membership:
           </p>
           <title>Standards Board</title>
           <ul id='_'>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>Aeschylus</dd>
                 <dt>role</dt>
                 <dd>Chair</dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>Sophocles</dd>
                 <dt>role</dt>
                 <dd>Technical editor</dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>Euripides</dd>
                 <dt>role</dt>
                 <dd>member</dd>
               </dl>
             </li>
             <li>
               <dl>
                 <dt>name</dt>
                 <dd>
                   <p id='_'>Aristophanes</p>
                 </dd>
                 <dt>role</dt>
                 <dd>member</dd>
               </dl>
             </li>
           </ul>
           <p type='emeritus_sign' id='_'>*Member Emeritus</p>
           <p id='_'>This is an additional clause.</p>
           <ul id='_'>
             <li>
               <dl id='_'>
                 <dt>company</dt>
                 <dd>Waldorf-Astoria</dd>
                 <dt>role</dt>
                 <dd>member</dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>company</dt>
                 <dd>Ritz</dd>
                 <dt>role</dt>
                 <dd>Member</dd>
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
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
         <boilerplate>
           <legal-statement>
             <clause id='boilerplate-participants'>
               <title depth='1'>Participants</title>
               <clause id='boilerplate-participants-wg'>
                 <p id='_'>
                    At the time this draft Standard was completed, the Working Group
                   had the following membership:
                 </p>
                 <p type='officeholder' align='center'>
                   <strong>Socrates</strong>
                   ,
                   <em>Chair</em>
                 </p>
                 <p type='officeholder' align='center'>
                   <strong>Plato</strong>
                   ,
                   <em>Technical editor</em>
                 </p>
                 <p type='officeorgrepmemberhdr'>
                   <em>Organization Represented</em>
                   <tab/>
                   <em>Name of Representative</em>
                 </p>
                 <p type='officeorgrepmember'>
                   Apple
                   <tab/>
                   Heraclitus
                 </p>
                 <p type='officemember'>Aristotle</p>
                 <p type='officemember'>Anaximander</p>
                 <p id='_'>This is an additional clause.</p>
               </clause>
               <clause id='boilerplate-participants-bg'>
                 <p id='_'>
                    The following members of the Standards Association balloting group
                   voted on this Standard. Balloters may have voted for approval,
                   disapproval, or abstention.
                 </p>
                 <p type='officemember'>Athanasius of Alexandria</p>
                 <p type='officemember'>Basil of Caesarea</p>
                 <p id='_'>And this is another list</p>
                 <p type='officeholder' align='center'>Microsoft, <em>Liaison</em></p>
          <p type='officeholder' align='center'>Alphabet, <br/>
            <em>IEEE Standards Program Manager, Document Development</em>
          </p>
               </clause>
               <clause id='boilerplate-participants-sb'>
                 <p id='_'>
                    When the IEEE SA Standards Board approved this Standard on
                   &#x3c;Date Approved&#x3e;, it had the following membership:
                 </p>
                 <p type='officeholder' align='center'>
                   <strong>Aeschylus</strong>
                   ,
                   <em>Chair</em>
                 </p>
                 <p type='officeholder' align='center'>
                   <strong>Sophocles</strong>
                   ,
                   <em>Technical editor</em>
                 </p>
                 <p type='officemember'>Euripides</p>
                 <p type='officemember'>Aristophanes</p>
                 <p type='emeritus_sign' id='_'>*Member Emeritus</p>
                 <p id='_'>This is an additional clause.</p>
                 <p type='officeorgmember'>Waldorf-Astoria</p>
                 <p type='officeorgmember'>Ritz</p>
               </clause>
             </clause>
           </legal-statement>
         </boilerplate>
       </iso-standard>
    OUTPUT
    html = <<~OUTPUT
      <div id='boilerplate-participants'>
         <h1 class='IntroTitle'>Participants</h1>
         <div id='boilerplate-participants-wg'>
           <p id='_'>
              At the time this draft Standard was completed, the Working Group had the
             following membership:
           </p>
           <p style='text-align:center;'>
             <b>Socrates</b>
              ,
             <i>Chair</i>
           </p>
           <p style='text-align:center;'>
             <b>Plato</b>
              ,
             <i>Technical editor</i>
           </p>
           <table>
             <thead>
               <tr>
                 <td>
                   <i>Organization Represented</i>
                 </td>
                 <td>
                   <i>Name of Representative</i>
                 </td>
               </tr>
             </thead>
             <tbody>
               <tr>
                 <td> Apple </td>
                 <td> Heraclitus </td>
               </tr>
             </tbody>
           </table>
           <p>Aristotle</p>
           <p>Anaximander</p>
           <p id='_'>This is an additional clause.</p>
         </div>
         <div id='boilerplate-participants-bg'>
           <p id='_'>
              The following members of the Standards Association balloting group voted
             on this Standard. Balloters may have voted for approval, disapproval, or
             abstention.
           </p>
           <p>Athanasius of Alexandria</p>
           <p>Basil of Caesarea</p>
           <p id='_'>And this is another list</p>
           <p style='text-align:center;'>
             Microsoft,
             <i>Liaison</i>
           </p>
           <p style='text-align:center;'>
             Alphabet,
             <br/>
             <i>IEEE Standards Program Manager, Document Development</i>
           </p>
         </div>
         <div id='boilerplate-participants-sb'>
           <p id='_'>
              When the IEEE SA Standards Board approved this Standard on &#x3c;Date
             Approved&#x3e;, it had the following membership:
           </p>
           <p style='text-align:center;'>
             <b>Aeschylus</b>
              ,
             <i>Chair</i>
           </p>
           <p style='text-align:center;'>
             <b>Sophocles</b>
              ,
             <i>Technical editor</i>
           </p>
           <p>Euripides</p>
           <p>Aristophanes</p>
           <p id='_'>*Member Emeritus</p>
           <p id='_'>This is an additional clause.</p>
           <p>Waldorf-Astoria</p>
           <p>Ritz</p>
         </div>
       </div>
    OUTPUT
    word = <<~OUTPUT
      <body lang='EN-US' xml:lang='EN-US' link='blue' vlink='#954F72'>
         <p class='IEEEStdsParagraph'>
           <br clear='all' class='section'/>
         </p>
         <span lang='EN-US' xml:lang='EN-US' style='font-size:10.0pt;font-family:&#x22;Times New Roman&#x22;,serif; mso-fareast-font-family:&#x22;Times New Roman&#x22;;color:white;mso-ansi-language:EN-US; mso-fareast-language:JA;mso-bidi-language:AR-SA'>
           <br clear='all' style='page-break-before:always;mso-break-type:section-break'/>
         </span>
         <!-- points to feedback statement as footnote -->
         <div class='WordSection3'>
           <div>
             <a name='boilerplate-disclaimers-destination' id='boilerplate-disclaimers-destination'/>
           </div>
         </div>
         <span lang='EN-US' xml:lang='EN-US' style='font-size:12.0pt;mso-bidi-font-size:10.0pt;font-family: &#x22;Times New Roman&#x22;,serif;mso-fareast-font-family:&#x22;Times New Roman&#x22;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'>
           <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
         </span>
         <div>
           <a name='boilerplate-participants' id='boilerplate-participants'/>
           <p class='IEEEStdsLevel1frontmatter'>Participants</p>
           <p class='IEEEStdsParagraph'>
             <a name='_' id='_'/>
              At the time this draft Standard was completed, the Working Group had the
             following membership:
           </p>
           <p style='text-align:center;' align='center' class='IEEEStdsNamesCtrCxSpFirst'>
             <b>Socrates</b>
              ,
             <i>Chair</i>
           </p>
           <p style='text-align:center;' align='center' class='IEEEStdsNamesCtrCxSpLast'>
             <b>Plato</b>
              ,
             <i>Technical editor</i>
           </p>
           <p class='IEEEStdsNamesList' style='margin-bottom:6.0pt;tab-stops:right 432.0pt;'>
                  <i>Organization Represented</i>
                  <span style='mso-tab-count:1'>&#xa0; </span>
                  <i>Name of Representative</i>
                </p>
                <p class='IEEEStdsNamesList' style='margin-top:6.0pt;tab-stops:right dotted 432.0pt;'>
                  Apple
                  <span style='mso-tab-count:1'>&#xa0; </span>
                  Heraclitus
                </p>
         </div>
         <span lang='EN-US' xml:lang='EN-US' style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &#x22;Times New Roman&#x22;,serif;mso-fareast-font-family:&#x22;Times New Roman&#x22;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'>
           <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
           <div class='WordSection4'>
             <p class='IEEEStdsNamesList'>Aristotle</p>
             <p class='IEEEStdsNamesList'>Anaximander</p>
           </div>
           <span lang='EN-US' xml:lang='EN-US' style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &#x22;Times New Roman&#x22;,serif;mso-fareast-font-family:&#x22;Times New Roman&#x22;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'>
             <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
             <div class='WordSection5'>
               <p class='IEEEStdsParagraph'>&#xa0;</p>
               <p class='IEEEStdsParagraph'>
                 <a name='_' id='_'/>
                 This is an additional clause.
               </p>
               <p class='IEEEStdsParagraph'>
                 <a name='_' id='_'/>
                  The following members of the Standards Association balloting group
                 voted on this Standard. Balloters may have voted for approval,
                 disapproval, or abstention.
               </p>
             </div>
             <span lang='EN-US' xml:lang='EN-US' style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &#x22;Times New Roman&#x22;,serif;mso-fareast-font-family:&#x22;Times New Roman&#x22;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'>
               <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
               <div class='WordSection6'>
                 <p class='IEEEStdsNamesList'>Athanasius of Alexandria</p>
                 <p class='IEEEStdsNamesList'>Basil of Caesarea</p>
               </div>
               <span lang='EN-US' xml:lang='EN-US' style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &#x22;Times New Roman&#x22;,serif;mso-fareast-font-family:&#x22;Times New Roman&#x22;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'>
                 <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
                 <div class='WordSection7'>
                   <p class='IEEEStdsParagraph'>&#xa0;</p>
                   <p class='IEEEStdsParagraph'>
                     <a name='_' id='_'/>
                     And this is another list
                   </p>
                   <p style='text-align:center;' align='center' class='IEEEStdsNamesCtrCxSpFirst'>
              Microsoft,
              <i>Liaison</i>
            </p>
            <p style='text-align:center;' align='center' class='IEEEStdsNamesCtrCxSpMiddle'>
              Alphabet,
              <br/>
              <i>IEEE Standards Program Manager, Document Development</i>
            </p>
                   <p class='IEEEStdsParagraph'>
                     <a name='_' id='_'/>
                      When the IEEE SA Standards Board approved this Standard on Date
                     Approved, it had the following membership:
                   </p>
                   <p style='text-align:center;' align='center' class='IEEEStdsNamesCtrCxSpFirst'>
                     <b>Aeschylus</b>
                      ,
                     <i>Chair</i>
                   </p>
                   <p style='text-align:center;' align='center' class='IEEEStdsNamesCtrCxSpLast'>
                     <b>Sophocles</b>
                      ,
                     <i>Technical editor</i>
                   </p>
                 </div>
                 <span lang='EN-US' xml:lang='EN-US' style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &#x22;Times New Roman&#x22;,serif;mso-fareast-font-family:&#x22;Times New Roman&#x22;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'>
                   <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
                   <div class='WordSection8'>
                     <p class='IEEEStdsNamesList'>Euripides</p>
                     <p class='IEEEStdsNamesList'>Aristophanes</p>
                   </div>
                   <span lang='EN-US' xml:lang='EN-US' style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &#x22;Times New Roman&#x22;,serif;mso-fareast-font-family:&#x22;Times New Roman&#x22;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'>
                     <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
                     <div class='WordSection9'>
                       <p class='IEEEStdsParaMemEmeritus'>
                         <a name='_' id='_'/>
                         *Member Emeritus
                       </p>
                       <p class='IEEEStdsParagraph'>
                         <a name='_' id='_'/>
                         This is an additional clause.
                       </p>
                       <p class='IEEEStdsNamesList'>Waldorf-Astoria</p>
                       <p class='IEEEStdsNamesList'>Ritz</p>
                     </div>
                   </span>
                 </span>
               </span>
             </span>
           </span>
         </span>
         <b style='mso-bidi-font-weight:normal'>
           <span lang='EN-US' xml:lang='EN-US' style='font-size:12.0pt; mso-bidi-font-size:10.0pt;font-family:&#x22;Arial&#x22;,sans-serif;mso-fareast-font-family: &#x22;Times New Roman&#x22;;mso-bidi-font-family:&#x22;Times New Roman&#x22;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'>
             <br clear='all' style='page-break-before:always;mso-break-type:section-break'/>
           </span>
         </b>
         <div class='authority'>
           <div class='boilerplate-legal'> </div>
         </div>
         <p class='IEEEStdsParagraph'>&#xa0;</p>
         <p class='IEEEStdsParagraph'>
           <br clear='all' class='section'/>
         </p>
         <p class='IEEEStdsParagraph'>
           <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
         </p>
         <div style='mso-element:footnote-list'/>
       </body>
    OUTPUT
    FileUtils.rm_rf "test.html"
    FileUtils.rm_rf "test.doc"
    expect(xmlpp(IsoDoc::IEEE::PresentationXMLConvert.new({})
  .convert("test", input, true)))
      .to be_equivalent_to xmlpp(presxml)
    IsoDoc::IEEE::HtmlConvert.new({}).convert("test", presxml, false)
    expect(File.exist?("test.html")).to be true
    expect(xmlpp(Nokogiri::XML(File.read("test.html"))
      .at("//div[@id = 'boilerplate-participants']").to_xml))
      .to be_equivalent_to xmlpp(html)
    IsoDoc::IEEE::WordConvert.new({}).convert("test", presxml, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc")).at("//xmlns:body")
    doc.at("//xmlns:div[@class = 'WordSection1']")&.remove
    doc.at("//xmlns:div[@class = 'WordSection2']")&.remove
    doc.at("//xmlns:div[@class = 'WordSectionContents']")&.remove
    doc.at("//xmlns:div[@class = 'WordSectionMiddleTitle']")&.remove
    doc.at("//xmlns:div[@class = 'WordSectionMain']")&.remove
    expect(strip_guid(xmlpp(doc.to_xml)))
      .to be_equivalent_to xmlpp(word)
  end
end
