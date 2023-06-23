require "spec_helper"
require "fileutils"

RSpec.describe IsoDoc::IEEE::WordConvert do
  it "processes middle title" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata>
      <title language="en" type="main">Title</title>
      <ext>
      <doctype>Guide</doctype>
      </ext>
      </bibdata>
      <preface><introduction id="_introduction" obligation="informative" displayorder="1" id="A">
      <title>Introduction</title><admonition>This introduction is not part of P1000/D0.3.4, Draft Standard for Empty
      </admonition>
      <p id="_7d8a8a7f-3ded-050d-1da9-978f17519335">This is an introduction</p>
      </introduction></preface>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
      <div class='WordSectionMiddleTitle'>
      <p class='IEEEStdsTitle' style='margin-top:70.0pt'>Guide for Title</p>
      </div>
    OUTPUT
    IsoDoc::IEEE::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[@class = 'WordSectionMiddleTitle']")
    expect(strip_guid(xmlpp(doc.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes middle title for amendment/corrigendum" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
       <iso-standard xmlns="http://riboseinc.com/isoxml">
       <bibdata>
       <title language="en" type="main">Title</title>
       <ext>
       <doctype>Guide</doctype>
       <structuredidentifier>
        <docnumber>1000</docnumber>
        <agency>IEEE</agency>
        <class>recommended-practice</class>
        <edition>2</edition>
        <version>0.3.4</version>
        <amendment>A1</amendment>
        <corrigendum>C1</corrigendum>
        <year>2000</year>
      </structuredidentifier>
       </ext>
       </bibdata>
       <preface><introduction id="_introduction" obligation="informative" displayorder="1" id="A">
       <title>Introduction</title><admonition>This introduction is not part of P1000/D0.3.4, Draft Standard for Empty
       </admonition>
       <p id="_7d8a8a7f-3ded-050d-1da9-978f17519335">This is an introduction</p>
       </introduction></preface>
       </iso-standard>
    INPUT
    output = <<~OUTPUT
      <div class='WordSectionMiddleTitle'>
      <p class='IEEEStdsTitle' style='margin-top:70.0pt'>Guide for Title<br/>Amendment A1 Corrigenda C1</p>
      </div>
    OUTPUT
    IsoDoc::IEEE::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[@class = 'WordSectionMiddleTitle']")
    expect(strip_guid(xmlpp(doc.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes introduction" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
        <preface><introduction id="_introduction" obligation="informative" displayorder="1" id="A">
      <title>Introduction</title><admonition>This introduction is not part of P1000/D0.3.4, Draft Standard for Empty
      </admonition>
      <p id="_7d8a8a7f-3ded-050d-1da9-978f17519335">This is an introduction</p>
      </introduction></preface>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
      <div class='Section3'>
        <a name="_" id="_"/>
        <p class='IEEEStdsLevel1frontmatter'>Introduction</p>
        <p class='IEEEStdsIntroduction'>This introduction is not part of P1000/D0.3.4, Draft Standard for Empty </p>
        <p class='IEEEStdsParagraph'>
          <a name="_" id="_"/>
          This is an introduction
        </p>
      </div>
    OUTPUT
    IsoDoc::IEEE::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//*[@class = 'IEEEStdsIntroduction']/..")
    expect(strip_guid(xmlpp(doc.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes abstract" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
        <preface><abstract id="_introduction" obligation="informative" displayorder="1" id="A">
      <title>Introduction</title><admonition>This introduction is not part of P1000/D0.3.4, Draft Standard for Empty
      </admonition>
      <p>Text</p>
      <ul><li><p>List</p></li></ul>
      <p id="_7d8a8a7f-3ded-050d-1da9-978f17519335">This is an introduction</p>
      </abstract></preface>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
      <div>
        <a name='abstract-destination' id='abstract-destination'/>
        <div class='IEEEStdsAbstractBody'>This introduction is not part of P1000/D0.3.4, Draft Standard for Empty </div>
        <p class='IEEEStdsAbstractBody'>Text</p>
        <p style="mso-list:l11 level1 lfo1-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;font-family: &quot;Arial&quot;, sans-serif;" class="IEEEStdsUnorderedListCxSpFirst">List</p>
        <p class='IEEEStdsAbstractBody'>
          <a name="_" id="_"/>
          This is an introduction
        </p>
      </div>
    OUTPUT
    IsoDoc::IEEE::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//*[@name = 'abstract-destination']/..")
    expect(strip_guid(xmlpp(doc.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes footnotes" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <boilerplate>
          <feedback-statement>
        <clause>
          <p align="left" id="_e934c824-e425-4780-49ab-b5b213d3ad03">The Institute of Electrical and Electronics Engineers, Inc.<br/> 3 Park Avenue, New York, NY 10016-5997, USA</p>
        </clause>
           <clause>
        <p id="_7c8abde4-b041-07c0-6748-0cf04bff9724">Copyright © 2000 by The Institute of Electrical and Electronics Engineers, Inc.</p>
        </clause>
            <clause>
        <p id="_3db6f550-190c-379c-93b3-c26e27566acd">IEEE is a registered trademark in the U.S. Patent &amp; Trademark Office, owned by The Institute of Electrical and Electronics Engineers, Incorporated.</p>
      </clause>
      <clause>
        <table unnumbered="true">
          <tbody>
            <tr><td>PDF:</td>     <td>ISBN 978-0-XXXX-XXXX-X</td> <td>STDXXXXX</td></tr>
            <tr><td>Print:</td>   <td>ISBN 978-0-XXXX-XXXX-X</td> <td>STDPDXXXXX</td></tr>
          </tbody>
        </table>
      </clause>
            <clause>
        <p id="_c46d91eb-fa3d-4310-9757-5dfad377d35c">IEEE prohibits discrimination, harassment, and bullying.</p>
        </clause>
        </feedback_statement>
                 </boilerplate>
              <preface>
              <foreword>
              <p>A.<fn reference="2">
            <p id="_1e228e29-baef-4f38-b048-b05a051747e4">Formerly denoted as 15 % (m/m).</p>
          </fn></p>
              <p>B.<fn reference="2">
            <p id="_1e228e29-baef-4f38-b048-b05a051747e4">Formerly denoted as 15 % (m/m).</p>
          </fn></p>
              <p>C.<fn reference="1">
            <p id="_1e228e29-baef-4f38-b048-b05a051747e4">Hello! denoted as 15 % (m/m).</p>
          </fn></p>
              </foreword>
              </preface>
              </iso-standard>
    INPUT
    references = <<~OUTPUT
          <div>
        <p class='IEEEStdsCRFootnote'>
          <a class='FootnoteRef' href='#_ftn1' type='footnote' style='mso-footnote-id:ftn1' name="_" title='' id="_">
            <span class='MsoFootnoteReference'>
              <span style='mso-special-character:footnote'/>
            </span>
          </a>
        </p>
        <p class='IEEEStdsParagraph'>
          A.
          <span style='mso-bookmark:_Ref'>
            <a class='FootnoteRef' href='#_ftn2' type='footnote' style='mso-footnote-id:ftn2' name="_" title='' id="_">
              <span class='MsoFootnoteReference'>
                <span style='mso-special-character:footnote'/>
              </span>
            </a>
          </span>
        </p>
        <p class='IEEEStdsParagraph'>
          C.
          <span style='mso-bookmark:_Ref'>
            <a class='FootnoteRef' href='#_ftn3' type='footnote' style='mso-footnote-id:ftn3' name="_" title='' id="_">
              <span class='MsoFootnoteReference'>
                <span style='mso-special-character:footnote'/>
              </span>
            </a>
          </span>
        </p>
      </div>
    OUTPUT
    footnotes = <<~OUTPUT
          <div style='mso-element:footnote-list'>
        <div style='mso-element:footnote' id='ftn1'>
          <p style='text-align:left;' align='left' class='IEEEStdsCRTextReg'>
            <a name="_" id="_"/>
            <a style='mso-footnote-id:ftn1' href='#_ftn1' name="_" title='' id="_"/>
            <a style='mso-footnote-id:ftn0' href='#_ftnref0' name="_" title='' id="_"/>
            The Institute of Electrical and Electronics Engineers, Inc.
            <br/>
             3 Park Avenue, New York, NY 10016-5997, USA
          </p>
          <p class='IEEEStdsCRTextReg'>&#xa0;</p>
          <p class='IEEEStdsCRTextReg'>
            <a name="_" id="_"/>
            Copyright &#xa9; 2000 by The Institute of Electrical and Electronics
            Engineers, Inc.
          </p>
          <p class='IEEEStdsCRTextReg'>&#xa0;</p>
          <p class='IEEEStdsCRTextReg'>
            <a name="_" id="_"/>
            IEEE is a registered trademark in the U.S. Patent Trademark Office, owned
            by The Institute of Electrical and Electronics Engineers, Incorporated.
          </p>
          <p class='IEEEStdsCRTextReg'>&#xa0;</p>
          <p class='IEEEStdsCRTextReg'>
            PDF:
            <span style='mso-tab-count:1'> </span>
            ISBN 978-0-XXXX-XXXX-X
            <span style='mso-tab-count:1'> </span>
            STDXXXXX
          </p>
          <p class='IEEEStdsCRTextReg'>
            Print:
            <span style='mso-tab-count:1'> </span>
            ISBN 978-0-XXXX-XXXX-X
            <span style='mso-tab-count:1'> </span>
            STDPDXXXXX
          </p>
          <p class='IEEEStdsCRTextItal'>&#xa0;</p>
          <p class='IEEEStdsCRTextItal'>
            <a name="_" id="_"/>
            IEEE prohibits discrimination, harassment, and bullying.
          </p>
        </div>
        <div style='mso-element:footnote' id='ftn2'>
          <p class='IEEEStdsFootnote'>
            <a name="_" id="_"/>
            <a style='mso-footnote-id:ftn2' href='#_ftn2' name="_" title='' id="_">
              <span class='MsoFootnoteReference'>
                <span style='mso-special-character:footnote'/>
              </span>
            </a>
            Formerly denoted as 15 % (m/m).
          </p>
        </div>
        <div style='mso-element:footnote' id='ftn3'>
          <p class='IEEEStdsFootnote'>
            <a name="_" id="_"/>
            <a style='mso-footnote-id:ftn3' href='#_ftn3' name="_" title='' id="_">
              <span class='MsoFootnoteReference'>
                <span style='mso-special-character:footnote'/>
              </span>
            </a>
            Hello! denoted as 15 % (m/m).
          </p>
        </div>
      </div>
    OUTPUT
    IsoDoc::IEEE::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[@style = 'mso-element:footnote-list']")
    expect(strip_guid(xmlpp(doc.to_xml)))
      .to be_equivalent_to xmlpp(footnotes)
    doc = Nokogiri::XML(word2xml("test.doc"))
      .xpath("//xmlns:p[.//xmlns:a[@class = 'FootnoteRef']]")
    expect(strip_guid(xmlpp("<div>#{doc.to_xml}</div>")))
      .to be_equivalent_to xmlpp(references)
  end

  it "processes lists" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
        <iso-standard xmlns="http://riboseinc.com/isoxml">
                <sections>
      <clause id="A"><p>
      <ol>
      <li><p>A</p></li>
      <li><p>B</p></li>
      <li><ol>
      <li>C</li>
      <li>D</li>
      <li><ol>
      <li>E</li>
      <li>F</li>
      <li><ol>
      <li>G</li>
      <li>H</li>
      <li><ol>
      <li>I</li>
      <li>J</li>
      <li><ol>
      <li>K</li>
      <li>L</li>
      <li>M</li>
      </ol></li>
      <li>N</li>
      </ol></li>
      <li>O</li>
      </ol></li>
      <li>P</li>
      </ol></li>
      <li>Q</li>
      </ol></li>
      <li>R</li>
      </ol>
      <ul>
      <li><p>A</p></li>
      <li><p>B</p></li>
      <li><p>B1</p><ul>
      <li>C</li>
      <li>D</li>
      <li><ul>
      <li>E</li>
      <li>F</li>
      </ul></li>
      <li>Q</li>
      </ul></li>
      <li>R</li>
      </ul>
      </p></clause>
      </sections>
            </iso-standard>
    INPUT
    word = <<~OUTPUT
          <div>
        <a name="A" id="A"/>
        <p class="IEEEStdsLevel1Header"/>
        <p class="IEEEStdsParagraph">
          <p style="mso-list:l16 level1 lfo2-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsNumberedListLevel1CxSpFirst">A</p>
          <p style="mso-list:l16 level1 lfo2-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsNumberedListLevel1CxSpMiddle">B</p>
          <p style="mso-list:l16 level1 lfo2-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsNumberedListLevel1CxSpMiddle">
            <p style="mso-list:l16 level2 lfo2-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsNumberedListLevel2CxSpFirst">C</p>
            <p style="mso-list:l16 level2 lfo2-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsNumberedListLevel2CxSpMiddle">D</p>
            <p style="mso-list:l16 level2 lfo2-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsNumberedListLevel2CxSpMiddle">
              <p style="mso-list:l16 level6 lfo2-3;text-indent:-0.79cm; margin-left:2.68cm;" class="IEEEStdsNumberedListLevel3CxSpFirst">E</p>
              <p style="mso-list:l16 level6 lfo2-3;text-indent:-0.79cm; margin-left:2.68cm;" class="IEEEStdsNumberedListLevel3CxSpMiddle">F</p>
              <p style="mso-list:l16 level6 lfo2-3;text-indent:-0.79cm; margin-left:2.68cm;" class="IEEEStdsNumberedListLevel3CxSpMiddle">
                <p style="mso-list:l16 level6 lfo2-4;text-indent:-0.79cm; margin-left:3.44cm;" class="IEEEStdsNumberedListLevel4CxSpFirst">G</p>
                <p style="mso-list:l16 level6 lfo2-4;text-indent:-0.79cm; margin-left:3.44cm;" class="IEEEStdsNumberedListLevel4CxSpMiddle">H</p>
                <p style="mso-list:l16 level6 lfo2-4;text-indent:-0.79cm; margin-left:3.44cm;" class="IEEEStdsNumberedListLevel4CxSpMiddle">
                  <p style="mso-list:l16 level6 lfo2-5;text-indent:-0.79cm; margin-left:4.2cm;" class="IEEEStdsNumberedListLevel5CxSpFirst">I</p>
                  <p style="mso-list:l16 level6 lfo2-5;text-indent:-0.79cm; margin-left:4.2cm;" class="IEEEStdsNumberedListLevel5CxSpMiddle">J</p>
                  <p style="mso-list:l16 level6 lfo2-5;text-indent:-0.79cm; margin-left:4.2cm;" class="IEEEStdsNumberedListLevel5CxSpMiddle">
                    <p style="mso-list:l16 level7 lfo2-6;text-indent:-0.79cm; margin-left:4.960000000000001cm;" class="IEEEStdsNumberedListLevel6CxSpFirst">K</p>
                    <p style="mso-list:l16 level7 lfo2-6;text-indent:-0.79cm; margin-left:4.960000000000001cm;" class="IEEEStdsNumberedListLevel6CxSpMiddle">L</p>
                    <p style="mso-list:l16 level7 lfo2-6;text-indent:-0.79cm; margin-left:4.960000000000001cm;" class="IEEEStdsNumberedListLevel6CxSpLast">M</p>
                  </p>
                  <p style="mso-list:l16 level6 lfo2-5;text-indent:-0.79cm; margin-left:4.2cm;" class="IEEEStdsNumberedListLevel5CxSpLast">N</p>
                </p>
                <p style="mso-list:l16 level6 lfo2-4;text-indent:-0.79cm; margin-left:3.44cm;" class="IEEEStdsNumberedListLevel4CxSpLast">O</p>
              </p>
              <p style="mso-list:l16 level6 lfo2-3;text-indent:-0.79cm; margin-left:2.68cm;" class="IEEEStdsNumberedListLevel3CxSpLast">P</p>
            </p>
            <p style="mso-list:l16 level2 lfo2-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsNumberedListLevel2CxSpLast">Q</p>
          </p>
          <p style="mso-list:l16 level1 lfo2-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsNumberedListLevel1CxSpLast">R</p>
          <p style="mso-list:l11 level1 lfo1-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsUnorderedListCxSpFirst">A</p>
          <p style="mso-list:l11 level1 lfo1-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsUnorderedListCxSpMiddle">B</p>
          <p style="mso-list:l11 level1 lfo1-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsUnorderedListCxSpMiddle">B1
      <p style="mso-list:l21 level1 lfo1-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsUnorderedListLevel2">C</p><p style="mso-list:l21 level1 lfo1-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsUnorderedListLevel2">D</p><p style="mso-list:l21 level1 lfo1-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsUnorderedListLevel2"><p style="mso-list:l21 level2 lfo1-3;text-indent:-0.79cm; margin-left:2.68cm;" class="IEEEStdsUnorderedListLevel2">E</p><p style="mso-list:l21 level2 lfo1-3;text-indent:-0.79cm; margin-left:2.68cm;" class="IEEEStdsUnorderedListLevel2">F</p></p><p style="mso-list:l21 level1 lfo1-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsUnorderedListLevel2">Q</p></p>
          <p style="mso-list:l11 level1 lfo1-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsUnorderedListCxSpLast">R</p>
        </p>
      </div>
    OUTPUT
    IsoDoc::IEEE::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'A']]")
    expect(strip_guid(xmlpp(doc.to_xml)))
      .to be_equivalent_to xmlpp(word)
  end

  it "processes notes" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
        <iso-standard xmlns="http://riboseinc.com/isoxml">
                <sections>
      <clause id="A">
      <clause id="B">
      <note id="n1"><p>First</p></note>
      <p>Blah blah>
      <note id="n2"><p>Second</p><p>Multi-para note</p></note>
      </clause>
      <clause id="C">
      <note id="n3"><p>Third</p><quote>Quotation</quote></note>
      </clause>
      <clause id="D">
      <note id="n4"><p>Fourth</p></note>
      <note id="n5"><p>Fifth</p></note>
      </clause>
      </clause>
      </sections>
            </iso-standard>
    INPUT
    word = <<~OUTPUT
          <div>
        <a name='A' id='A'/>
        <p class='IEEEStdsLevel1Header'>1.</p>
        <div>
          <a name='B' id='B'/>
          <p class='IEEEStdsLevel2Header'>1.1.</p>
          <div>
            <a name='n1' id='n1'/>
            <p class='IEEEStdsMultipleNotes' style='mso-list:l17 level1 lfo1;'>First</p>
          </div>
          <p class='IEEEStdsParagraph'>Blah blah </p>
          <div>
            <a name='n2' id='n2'/>
            <p class='IEEEStdsMultipleNotes' style='mso-list:l17 level1 lfo1;'>Second</p>
            <p class='IEEEStdsSingleNote' style='mso-list:l17 level1 lfo1;'>Multi-para note</p>
          </div>
          <div>
            <a name='C' id='C'/>
            <p class='IEEEStdsLevel3Header'>1.1.1.</p>
            <div>
              <a name='n3' id='n3'/>
              <p class='IEEEStdsSingleNote'>
                <span class='note_label'>NOTE&#x2014;</span>
                Third
              </p>
              <div class='Quote'>Quotation</div>
            </div>
          </div>
          <div>
            <a name='D' id='D'/>
            <p class='IEEEStdsLevel3Header'>1.1.2.</p>
            <div>
              <a name='n4' id='n4'/>
              <p class='IEEEStdsMultipleNotes' style='mso-list:l17 level1 lfo2;'>Fourth</p>
            </div>
            <div>
              <a name='n5' id='n5'/>
              <p class='IEEEStdsMultipleNotes' style='mso-list:l17 level1 lfo2;'>Fifth</p>
            </div>
          </div>
        </div>
      </div>
    OUTPUT
    presxml = IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    IsoDoc::IEEE::WordConvert.new({}).convert("test", presxml, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'A']]")
    expect(strip_guid(xmlpp(doc.to_xml)))
      .to be_equivalent_to xmlpp(word)
  end

  it "processes termnotes" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
        <iso-standard xmlns="http://riboseinc.com/isoxml">
                <sections>
      <terms id="A">
      <term id="B"><preferred><expression><name>Alpha</name></expression></preferred>
      <termnote id="n1"><p>First</p></termnote>
      <termnote id="n2"><p>Second</p><p>Multi-para note</p></termnote>
      </term>
      <term id="C"><preferred><expression><name>Beta</name></expression></preferred>
      <termnote id="n3"><p>Third</p><quote>Quotation</quote></termnote>
      </term>
      <term id="D"><preferred><expression><name>Gamma</name></expression></preferred>
      <termnote id="n4"><p>Fourth</p></termnote>
      <termnote id="n5"><p>Fifth</p></termnote>
      </term>
      </terms>
      </sections>
            </iso-standard>
    INPUT
    word = <<~OUTPUT
          <div>
        <a name="A" id="A"/>
        <p class="IEEEStdsLevel1Header">1.</p>
        <p class="TermNum">
          <a name="B" id="B"/>
        </p>
        <p class="IEEEStdsParagraph"><b>Alpha</b>:   </p>
        <div>
          <a name="n1" id="n1"/>
          <p class="IEEEStdsMultipleNotes" style="mso-list:l17 level1 lfo1;">First</p>
        </div>
        <div>
          <a name="n2" id="n2"/>
          <p class="IEEEStdsMultipleNotes" style="mso-list:l17 level1 lfo1;">Second<p class="IEEEStdsSingleNote" style="mso-list:l17 level1 lfo1;">Multi-para note</p></p>
        </div>
        <p class="TermNum">
          <a name="C" id="C"/>
        </p>
        <p class="IEEEStdsParagraph"><b>Beta</b>:   </p>
        <div>
          <a name="n3" id="n3"/>
          <p class="IEEEStdsSingleNote"><span class="note_label">NOTE—</span>Third<div class="Quote">Quotation</div></p>
        </div>
        <p class="TermNum">
          <a name="D" id="D"/>
        </p>
        <p class="IEEEStdsParagraph"><b>Gamma</b>:   </p>
        <div>
          <a name="n4" id="n4"/>
          <p class="IEEEStdsMultipleNotes" style="mso-list:l17 level1 lfo2;">Fourth</p>
        </div>
        <div>
          <a name="n5" id="n5"/>
          <p class="IEEEStdsMultipleNotes" style="mso-list:l17 level1 lfo2;">Fifth</p>
        </div>
      </div>
    OUTPUT
    presxml = IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    IsoDoc::IEEE::WordConvert.new({}).convert("test", presxml, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'A']]")
    expect(strip_guid(xmlpp(doc.to_xml)))
      .to be_equivalent_to xmlpp(word)
  end

  it "processes boilerplate" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
      <ieee-standard xmlns="https://www.metanorma.org/ns/ieee" type="semantic" version="0.0.1">
      <bibdata type="standard">
      <title language="en" format="text/plain">Empty</title>

      <title language="intro-en" format="text/plain">Introduction</title>

      <title language="main-en" format="text/plain">Main Title -- Title</title>

      <title language="part-en" format="text/plain">Title Part</title>

      <title language="intro-fr" format="text/plain">Introduction Française</title>

      <title language="main-fr" format="text/plain">Titre Principal</title>

      <title language="part-fr" format="text/plain">Part du Titre</title>
      <docidentifier type="IEEE">1000</docidentifier><docnumber>1000</docnumber>
      <date type="confirmed"><on>1000-12-01</on></date>
      <date type="confirmed" format="ddMMMyyyy"><on>01 Dec 1000</on></date>
      <date type="issued"><on>1001-12-01</on></date>
      <date type="issued" format="ddMMMyyyy"><on>01 Dec 1001</on></date>
      <contributor><role type="editor">Working Group Chair</role><person>
      <name><completename>AB</completename></name>
      </person></contributor><contributor><role type="editor">Working Group Vice-Chair</role><person>
      <name><completename>CD</completename></name>
      </person></contributor><contributor><role type="editor">Working Group Member</role><person>
      <name><completename>E, F, Jr.</completename></name>
      </person></contributor><contributor><role type="editor">Working Group Member</role><person>
      <name><completename>GH</completename></name>
      </person></contributor><contributor><role type="editor">Working Group Member</role><person>
      <name><completename>IJ</completename></name>
      </person></contributor><contributor><role type="editor">Balloting Group Member</role><person>
      <name><completename>KL</completename></name>
      </person></contributor><contributor><role type="editor">Balloting Group Member</role><person>
      <name><completename>MN</completename></name>
      </person></contributor><contributor><role type="editor">Standards Board Chair</role><person>
      <name><completename>OP</completename></name>
      </person></contributor><contributor><role type="editor">Standards Board Vice-Chair</role><person>
      <name><completename>QR</completename></name>
      </person></contributor><contributor><role type="editor">Standards Board Past Chair</role><person>
      <name><completename>ST</completename></name>
      </person></contributor><contributor><role type="editor">Standards Board Secretary</role><person>
      <name><completename>UV</completename></name>
      </person></contributor><contributor><role type="editor">Standards Board Member</role><person>
      <name><completename>KL</completename></name>
      </person></contributor><contributor><role type="editor">Standards Board Member</role><person>
      <name><completename>MN</completename></name>
      </person></contributor><contributor><role type="publisher"/><organization>
      <name>Institute of Electrical and Electronic Engineers</name>
      <abbreviation>IEEE</abbreviation></organization></contributor><edition>2</edition><version><revision-date>2000-01-01</revision-date><draft>0.3.4</draft></version><language>en</language><script>Latn</script><status><stage>20</stage><substage>20</substage><iteration>3</iteration></status><copyright><from>2000</from><owner><organization>
      <name>Institute of Electrical and Electronic Engineers</name>
      <abbreviation>IEEE</abbreviation></organization></owner></copyright><ext><doctype>standard</doctype><editorialgroup><society>SECRETARIAT</society><balloting-group>SC</balloting-group><working-group>WG</working-group><working-group>WG1</working-group><committee>TC</committee><committee>TC1</committee></editorialgroup><ics><code>1</code></ics><ics><code>2</code></ics><ics><code>3</code></ics></ext></bibdata>
      <boilerplate>
        <copyright-statement>
          <clause>
            <p id="copyright" align="left">Copyright © 2000 by The Institute of Electrical and Electronics Engineers, Inc.<br/>Three Park Avenue<br/>New York, New York 10016-5997, USA</p>
            <p id="_aa4d99e2-4d2a-9ba9-0873-15c134ef3e9b">All rights reserved.</p>
          </clause>
        </copyright-statement>
        <license-statement>
          <clause>
            <p id="_0e840a39-4799-feca-e27e-add3c1608ecc">This document is an unapproved draft of a proposed IEEE Standard. As such, this document is subject to change. USE AT YOUR OWN RISK! IEEE copyright statements SHALL NOT BE REMOVED from draft or approved IEEE standards, or modified in any way. Because this is an unapproved draft, this document must not be utilized for any conformance/compliance purposes. Permission is hereby granted for officers from each IEEE Standards Working Group or Committee to reproduce the draft document developed by that Working Group for purposes of international standardization consideration.  IEEE Standards Department must be informed of the submission for consideration prior to any reproduction for international standardization consideration (<link target="mailto:stds-ipr@ieee.org"/>). Prior to adoption of this document, in whole or in part, by another standards development organization, permission must first be obtained from the IEEE Standards Department (<link target="mailto:stds-ipr@ieee.org"/>). When requesting permission, IEEE Standards Department will require a copy of the standard development organization’s document highlighting the use of IEEE content. Other entities seeking permission to reproduce this document, in whole or in part, must also obtain permission from the IEEE Standards Department.</p>
            <p align="left" id="_bcfab096-63cf-0228-ac1e-345847c182b9">IEEE Standards Department<br/> 445 Hoes Lane<br/> Piscataway, NJ 08854, USA</p>
          </clause>
        </license-statement>
        <legal-statement>
          <clause id="boilerplate-disclaimers">
            <title>Important Notices and Disclaimers Concerning IEEE Standards Documents</title>

            <p id="_DV_M4">IEEE Standards
            documents are made available for use subject to important notices and legal
            disclaimers. These notices and disclaimers, or a reference to this page (<link target="https://standards.ieee.org/ipr/disclaimers.html"/>),
            appear in all standards and may be found under the heading “Important Notices
              and Disclaimers Concerning IEEE Standards Documents.”</p>

            <clause>
              <title>Notice
                and Disclaimer of Liability Concerning the Use of IEEE Standards Documents</title>

              <p id="_69eb5ada-bedb-ac75-a8dc-bdb1e050fd5c">IEEE Standards documents are
              developed within the IEEE Societies and the Standards Coordinating Committees
              of the IEEE Standards Association (IEEE SA) Standards Board. IEEE develops its
              standards through an accredited consensus development process, which brings
              together volunteers representing varied viewpoints and interests to achieve the
              final product. IEEE Standards are documents developed by volunteers with
              scientific, academic, and industry-based expertise in technical working groups.
              Volunteers are not necessarily members of IEEE or IEEE SA, and participate
              without compensation from IEEE. While IEEE administers the process and
              establishes rules to promote fairness in the consensus development process,
              IEEE does not independently evaluate, test, or verify the accuracy of any of
                the information or the soundness of any judgments contained in its standards.</p>

              <p id="_f4b91770-37a6-3693-28b1-ab2d3576ac74">IEEE makes no warranties or
              representations concerning its standards, and expressly disclaims all
              warranties, express or implied, concerning this standard, including but not
              limited to the warranties of merchantability, fitness for a particular purpose
              and non-infringement. In addition, IEEE
              does not warrant or represent that the use of the material contained in its
              standards is free from patent infringement. IEEE standards documents are
                supplied “AS IS” and “WITH ALL FAULTS.”</p>

              <p id="_46c7aa12-ea59-4526-fba7-ad4fce940c54">Use of an IEEE standard is wholly
              voluntary. The existence of an IEEE Standard does not imply that there are no
              other ways to produce, test, measure, purchase, market, or provide other goods
              and services related to the scope of the IEEE standard. Furthermore, the
              viewpoint expressed at the time a standard is approved and issued is subject to
              change brought about through developments in the state of the art and comments
                received from users of the standard.</p>

              <p id="_8f8a7806-7d82-ee66-061f-02a19ec99d1e">In publishing and
              making its standards available, IEEE is not suggesting or rendering
              professional or other services for, or on behalf of, any person or entity, nor
              is IEEE undertaking to perform any duty owed by any other person or entity to
              another. Any person utilizing any IEEE Standards document, should rely upon his
              or her own independent judgment in the exercise of reasonable care in any given
              circumstances or, as appropriate, seek the advice of a competent professional
                in determining the appropriateness of a given IEEE standard.</p>

              <p id="_55dd802a-f63a-0469-366f-b0ff22ccc86f">IN NO EVENT SHALL IEEE
              BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
              CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO: THE NEED TO PROCURE
              SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
              INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
              CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
              IN ANY WAY OUT OF THE PUBLICATION, USE OF, OR RELIANCE UPON ANY STANDARD, EVEN
              IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE AND REGARDLESS OF WHETHER SUCH
                DAMAGE WAS FORESEEABLE.</p>

            </clause>
            <clause><title>Translations</title>

              <p id="_a911590b-2110-6281-346f-c74c928f3d9f">The IEEE consensus
              development process involves the review of documents in English only. In the
              event that an IEEE standard is translated, only the English version published
                by IEEE is the approved IEEE standard.</p>
            </clause>

            <clause><title>Official statements</title>

              <p id="_67fa69dd-43f1-1dbb-33b3-56c6b487a592">A statement, written
              or oral, that is not processed in accordance with the IEEE SA Standards Board
              Operations Manual shall not be considered or inferred to be the official
              position of IEEE or any of its committees and shall not be considered to be,
              nor be relied upon as, a formal position of IEEE. At lectures, symposia,
              seminars, or educational courses, an individual presenting information on IEEE
              standards shall make it clear that the presenter’s views should be considered
              the personal views of that individual rather than the formal position of IEEE,
                IEEE SA, the Standards Committee, or the Working Group.</p>
            </clause>

            <clause><title>Comments on standards</title>

              <p id="_5e37882d-40b2-dc67-c9aa-9ae6b00dbd11">Comments for revision of IEEE
              Standards documents are welcome from any interested party, regardless of membership
                affiliation with IEEE or IEEE SA. However, <strong>IEEE does not provide interpretations, consulting information, or advice pertaining to IEEE Standards documents</strong>.</p>

              <p id="_321bc489-75ad-f89e-3e0e-021ea289688a">Suggestions for changes in
              documents should be in the form of a proposed change of text, together with
              appropriate supporting comments. Since IEEE standards represent a consensus of
              concerned interests, it is important that any responses to comments and
              questions also receive the concurrence of a balance of interests. For this
              reason, IEEE and the members of its Societies and Standards Coordinating
              Committees are not able to provide an instant response to comments, or
              questions except in those cases where the matter has previously been addressed.
              For the same reason, IEEE does not respond to interpretation requests. Any
              person who would like to participate in evaluating comments or in revisions to
              an IEEE standard is welcome to join the relevant IEEE working group. You can
              indicate interest in a working group using the Interests tab in the Manage
              Profile &amp; Interests area of the <link target="https://development.standards.ieee.org/myproject-web/public/view.html#landing">IEEE
                SA myProject system</link>.<fn><p id="_85877103-c5e7-c208-ac2c-fcc6187624ec">Available at: <link target="https://development.standards.ieee.org/myproject-web/public/view.html#landing"/>.</p></fn>
                An IEEE Account is needed to access the application.</p>

              <p id="_c455e6e2-76b8-d43c-3792-2c22fae0d2cf">Comments on standards should be submitted using the <link target="https://standards.ieee.org/content/ieee-standards/en/about/contact/index.html">Contact Us</link> form.<fn><p id="_dfdb1b60-39fe-7a76-9979-acec6418b2a6">Available at: <link target="https://standards.ieee.org/content/ieee-standards/en/about/contact/index.html"/>.</p></fn></p>
            </clause>

            <clause><title>Laws and regulations</title>

              <p id="_4a31df54-1604-bf8b-489a-54e8c1bd7ab9">Users of IEEE
              Standards documents should consult all applicable laws and regulations.
              Compliance with the provisions of any IEEE Standards document does not
              constitute compliance to any applicable regulatory requirements. Implementers
              of the standard are responsible for observing or referring to the applicable
              regulatory requirements. IEEE does not, by the publication of its standards,
              intend to urge action that is not in compliance with applicable laws, and these
                documents may not be construed as doing so.</p>
            </clause>

            <clause><title>Data privacy</title>

              <p id="_dca40c9c-2337-ae9b-1296-325a45d35631">Users of IEEE Standards documents
              should evaluate the standards for considerations of data privacy and data
              ownership in the context of assessing and using the standards in compliance
                with applicable laws and regulations.</p>
            </clause>

            <clause><title>Copyrights</title>

              <p id="_9f9a6684-5448-0b57-0966-766b30ac99d9">IEEE draft and
              approved standards are copyrighted by IEEE under US and international copyright
              laws. They are made available by IEEE and are adopted for a wide variety of
              both public and private uses. These include both use, by reference, in laws and
              regulations, and use in private self-regulation, standardization, and the
              promotion of engineering practices and methods. By making these documents
              available for use and adoption by public authorities and private users, IEEE
                does not waive any rights in copyright to the documents.</p>
            </clause>

            <clause><title>Photocopies</title>

              <p id="_b70596da-132b-304b-051e-7c0e21d0a849">Subject to payment of
              the appropriate licensing fees, IEEE will grant users a limited, non-exclusive
              license to photocopy portions of any individual standard for company or
              organizational internal use or individual, non-commercial use only. To arrange
              for payment of licensing fees, please contact Copyright Clearance Center,
              Customer Service, 222 Rosewood Drive, Danvers, MA 01923 USA; +1 978 750 8400;
              https://www.copyright.com/. Permission to photocopy portions of any individual
              standard for educational classroom use can also be obtained through the
                Copyright Clearance Center.</p>
            </clause>

            <clause><title>Updating of IEEE Standards documents</title>

              <p id="_a659eee9-6f68-1262-2d2c-42b8c6b3480b">Users
              of IEEE Standards documents should be aware that these documents may be
              superseded at any time by the issuance of new editions or may be amended from
              time to time through the issuance of amendments, corrigenda, or errata. An
              official IEEE document at any point in time consists of the current edition of
              the document together with any amendments, corrigenda, or errata then in
                effect.</p>

              <p id="_c0ef0165-1ecb-42e2-6442-73bb494f78e3">Every
              IEEE standard is subjected to review at least every 10 years. When a document
              is more than 10 years old and has not undergone a revision process, it is
              reasonable to conclude that its contents, although still of some value, do not
              wholly reflect the present state of the art. Users are cautioned to check to
                determine that they have the latest edition of any IEEE standard.</p>

              <p id="_881f03c4-f8a3-3cb3-405f-19358c487c10">In
              order to determine whether a given document is the current edition and whether
              it has been amended through the issuance of amendments, corrigenda, or errata,
              visit <link target="https://ieeexplore.ieee.org/browse/standards/collection/ieee/">IEEE
                Xplore</link> or <link target="https://standards.ieee.org/content/ieee-standards/en/about/contact/index.html">contact IEEE</link>.<fn><p id="_92b51ca4-bffc-eca9-d270-5b7240d42939">Available at <link target="https://ieeexplore.ieee.org/browse/standards/collection/ieee"/>.</p></fn>
                For more information about the IEEE SA or IEEE’s standards development process,
                visit the IEEE SA Website.</p>
            </clause>

            <clause>
              <title>Errata</title>

              <p id="_05a6b84f-e605-5238-ffc2-904ba0520742">Errata, if any, for all IEEE standards can be accessed on the <link target="https://standards.ieee.org/standard/index.html">IEEE SA Website</link>.<fn><p id="_7ac5e2ff-3624-9f91-8798-aca5768f7f41">Available at: <link target="https://standards.ieee.org/standard/index.html"/>.</p></fn> Search for standard number and year of approval to access the web page of the published standard. Errata links are located under the Additional Resources Details section. Errata are also available in <link target="https://ieeexplore.ieee.org/browse/standards/collection/ieee/">IEEE Xplore</link>. Users are encouraged to periodically check for errata.</p>
            </clause>

            <clause><title>Patents</title>

              <p id="_63718157-819f-a4c0-b7c8-74c1d2f0944a">IEEE Standards are developed in compliance with the <link target="https://standards.ieee.org/about/sasb/patcom/materials.html">IEEE SA Patent Policy</link>.<fn><p id="_faf141af-ee0f-4653-c729-50c21675015f">Available at: <link target="https://standards.ieee.org/about/sasb/patcom/materials.html"/>.</p></fn></p>
              <p id="_7b4497a2-91e0-efe8-0837-55d7dda3adfa">Attention is called to
              the possibility that implementation of this standard may require use of subject
              matter covered by patent rights. By publication of this standard, no position
              is taken by the IEEE with respect to the existence or validity of any patent
              rights in connection therewith. If a patent holder or patent applicant has
              filed a statement of assurance via an Accepted Letter of Assurance, then the
              statement is listed on the IEEE SA Website at <link target="https://standards.ieee.org/about/sasb/patcom/patents.html"/>. Letters of Assurance may
              indicate whether the Submitter is willing or unwilling to grant licenses under
              patent rights without compensation or under reasonable rates, with reasonable
              terms and conditions that are demonstrably free of any unfair discrimination to
                applicants desiring to obtain such licenses.</p>

              <p id="_d0d47ec9-06e7-d425-6f34-e475bb628d1d">Essential Patent
              Claims may exist for which a Letter of Assurance has not been received. The
              IEEE is not responsible for identifying Essential Patent Claims for which a
              license may be required, for conducting inquiries into the legal validity or
              scope of Patents Claims, or determining whether any licensing terms or
              conditions provided in connection with submission of a Letter of Assurance, if
              any, or in any licensing agreements are reasonable or non-discriminatory. Users
              of this standard are expressly advised that determination of the validity of
              any patent rights, and the risk of infringement of such rights, is entirely
              their own responsibility. Further information may be obtained from the IEEE
                Standards Association.</p>
            </clause>

            <clause><title>IMPORTANT NOTICE</title>

              <p id="_ee588d90-d9cc-0b08-c42d-7b1ea7190a7e">IEEE Standards do not
              guarantee or ensure safety, security, health, or environmental protection, or
              ensure against interference with or from other devices or networks. IEEE
              Standards development activities consider research and information presented to
              the standards development group in developing any safety recommendations. Other
              information about safety practices, changes in technology or technology implementation,
              or impact by peripheral systems also may be pertinent to safety considerations
              during implementation of the standard. Implementers and users of IEEE Standards
              documents are responsible for determining and complying with all appropriate
              safety, security, environmental, health, and interference protection practices
                and all applicable laws and regulations.</p>
            </clause>
          </clause>
          <clause id="boilerplate-participants">
            <title>Participants</title>
              <p id="_6c151db1-c395-acf1-1fa2-c8db0131136b">At the time this draft Standard was completed, the WG Working Group had the following membership:</p>
              <p align="center" type="officeholder" id="_08d02fae-f1d9-e550-fbdd-4645fe7d095f"><strong>AB</strong>, <em>Chair</em></p>
              <p align="center" type="officeholder" id="_31eadeb4-3307-4629-948d-2cb3c6412966"><strong>CD</strong>, <em>Vice Chair</em></p>
              <p type="officemember" id="_67b33631-2fbb-f564-e9f0-82282edefdef">E, F, Jr.</p>
              <p type="officemember" id="_0e9e363e-d5c0-b780-8cec-621969a23c4b">GH</p>
              <p type="officemember" id="_876f6c07-835a-7987-3116-f58991fa75b2">IJ</p>
              <p id="_46f7565b-0bef-19ea-ec10-9cbb61112146">The following members of the SC Standards Association balloting group voted on this Standard. Balloters may have voted for approval, disapproval, or abstention.</p>
              <p type="officemember" id="_4bb301e0-e632-db01-7a13-a25dc1d19245">KL</p>
              <p type="officemember" id="_6d22f033-4acc-bb26-cdbc-17c15081ac6f">MN</p>
              <p id="_44e9013d-e106-6625-4bd8-23ccd243ada0">When the IEEE SA Standards Board approved this Standard on , it had the following membership:</p>
              <p align="center" type="officeholder" id="_996af77c-8f97-8120-2122-160468d38421"><strong>OP</strong>, <em>Chair</em></p>
              <p align="center" type="officeholder" id="_788af112-e13f-9cb6-8d24-abf8696f77c9"><strong>QR</strong>, <em>Vice Chair</em></p>
              <p align="center" type="officeholder" id="_da7481f4-39f9-6c55-6d46-1b8884b61b9d"><strong>ST</strong>, <em>Past Chair</em></p>
              <p align="center" type="officeholder" id="_1aeba399-1582-a62f-8b2b-69d7c8b4af2d"><strong>UV</strong>, <em>Secretary</em></p>
              <p type="officemember" id="_433b1929-28dc-9529-4780-b8adbc2abef5">KL</p>
              <p type="officemember" id="_57925a1f-9722-e750-d098-a02dfb15d545">MN</p>
              <p type="emeritus_sign" id="_49166d58-0938-7cc1-a872-016042bb1c33">*Member Emeritus</p>
          </clause>
        </legal-statement>
        <feedback-statement>
          <clause>
            <p align="left" id="_e934c824-e425-4780-49ab-b5b213d3ad03">The Institute of Electrical and Electronics Engineers, Inc.<br/> 3 Park Avenue, New York, NY 10016-5997, USA</p>
          </clause>

          <clause>
            <p id="_7c8abde4-b041-07c0-6748-0cf04bff9724">Copyright © 2000 by The Institute of Electrical and Electronics Engineers, Inc.</p>
            <p id="_c254dc66-2cc9-5a51-1956-7e591b1e96dc">All rights reserved. Published . Printed in the United States of America.</p>
          </clause>

          <clause>
            <p id="_3db6f550-190c-379c-93b3-c26e27566acd">IEEE is a registered trademark in the U.S. Patent &amp; Trademark Office, owned by The Institute of Electrical and Electronics Engineers, Incorporated.</p>
          </clause>

          <clause>
            <table unnumbered="true">
              <tbody>
                <tr><td>PDF:</td>	<td>ISBN 978-0-XXXX-XXXX-X</td>	<td>STDXXXXX</td></tr>
                <tr><td>Print:</td>	<td>ISBN 978-0-XXXX-XXXX-X</td>	<td>STDPDXXXXX</td></tr>
              </tbody>
            </table>
          </clause>

          <clause>
            <p id="_c46d91eb-fa3d-4310-9757-5dfad377d35c">IEEE prohibits discrimination, harassment, and bullying.</p>
            <p id="_41116375-3164-0b50-5b78-07ca1a84051f">For more information, visit <link target="https://www.ieee.org/about/corporate/governance/p9-26.html"/>.</p>
            <p id="_45b2ec47-59fb-6b29-c7ac-95d64eecd2e6">No part of this publication may be reproduced in any form, in an electronic retrieval system or otherwise, without the prior written permission of the publisher.</p>
          </clause>
        </feedback-statement>
      </boilerplate>

      <sections><clause id="_clause" inline-header="false" obligation="normative">
      <title>Clause</title>
      <p id="_2e901de4-4c14-e534-d135-862a24df22ee">Hello</p>
      </clause>
      </sections>
      </ieee-standard>
    INPUT
    word = <<~OUTPUT
          <body lang='EN-US' xml:lang='EN-US' link='blue' vlink='#954F72'>
        <div class='WordSection1'>
          <p class='IEEEStdsTitle' style='margin-top:50.0pt;margin-right:0cm;margin-bottom:36.0pt;margin-left:0cm'>
            <span lang='EN-US' xml:lang='EN-US'>P1000&#x2122;/D0.3.4</span>
            <br/>
            <span lang='EN-US' xml:lang='EN-US'>Draft Standard for Empty</span>
          </p>
          <p class='IEEEStdsTitleParaSans'>
            <span lang='EN-US' xml:lang='EN-US'>Developed by the</span>
          </p>
          <p class='IEEEStdsTitleParaSans'>
            <span lang='EN-US' xml:lang='EN-US'>
              <p>&#xa0;</p>
            </span>
          </p>
          <p class='IEEEStdsTitleParaSansBold'>
            <span lang='EN-US' xml:lang='EN-US'>TC</span>
          </p>
          <p class='IEEEStdsTitleParaSans'>
            <span lang='EN-US' xml:lang='EN-US'>of the</span>
          </p>
          <p class='IEEEStdsTitleParaSansBold'>
            <span lang='EN-US' xml:lang='EN-US'>IEEE SECRETARIAT</span>
          </p>
          <p class='IEEEStdsTitleParaSans'>
            <span lang='EN-US' xml:lang='EN-US'>
              <p>&#xa0;</p>
            </span>
          </p>
          <p class='IEEEStdsTitleParaSans'>
            <span lang='EN-US' xml:lang='EN-US'>
              <p>&#xa0;</p>
            </span>
          </p>
          <p class='IEEEStdsTitleParaSans'>
            <span lang='EN-US' xml:lang='EN-US'>Approved 01 Dec 1001</span>
          </p>
          <p class='IEEEStdsTitleParaSans'>
            <span lang='EN-US' xml:lang='EN-US'>
              <p>&#xa0;</p>
            </span>
          </p>
          <p class='IEEEStdsTitleParaSansBold'>
            <span lang='EN-US' xml:lang='EN-US'>IEEE SA Standards Board</span>
          </p>
          <p class='IEEEStdsCopyrightaddrs'>
            <span lang='EN-US' xml:lang='EN-US'>
              <p>&#xa0;</p>
            </span>
          </p>
          <div class='boilerplate-copyright'>
            <div>
              <p style='text-align:left;' align='left' class='IEEEStdsTitleDraftCRaddr'>
                <a name='copyright' id='copyright'/>
                Copyright &#xa9; 2000 by The Institute of Electrical and Electronics
                Engineers, Inc.
                <br/>
                Three Park Avenue
                <br/>
                New York, New York 10016-5997, USA
              </p>
              <p class='IEEEStdsTitleDraftCRBody'>
                <a name="_" id="_"/>
                All rights reserved.
              </p>
            </div>
          </div>
          <div class='boilerplate-license'>
            <div>
              <p class='IEEEStdsTitleDraftCRaddr'>
                <a name="_" id="_"/>
                This document is an unapproved draft of a proposed IEEE Standard. As
                such, this document is subject to change. USE AT YOUR OWN RISK! IEEE
                copyright statements SHALL NOT BE REMOVED from draft or approved IEEE
                standards, or modified in any way. Because this is an unapproved
                draft, this document must not be utilized for any
                conformance/compliance purposes. Permission is hereby granted for
                officers from each IEEE Standards Working Group or Committee to
                reproduce the draft document developed by that Working Group for
                purposes of international standardization consideration. IEEE
                Standards Department must be informed of the submission for
                consideration prior to any reproduction for international
                standardization consideration (
                <a href='mailto:stds-ipr@ieee.org'>stds-ipr@ieee.org</a>
                ). Prior to adoption of this document, in whole or in part, by another
                standards development organization, permission must first be obtained
                from the IEEE Standards Department (
                <a href='mailto:stds-ipr@ieee.org'>stds-ipr@ieee.org</a>
                ). When requesting permission, IEEE Standards Department will require
                a copy of the standard development organization&#x2019;s document
                highlighting the use of IEEE content. Other entities seeking
                permission to reproduce this document, in whole or in part, must also
                obtain permission from the IEEE Standards Department.
              </p>
              <p style='text-align:left;' align='left' class='IEEEStdsTitleDraftCRBody'>
                <a name="_" id="_"/>
                IEEE Standards Department
                <br/>
                 445 Hoes Lane
                <br/>
                 Piscataway, NJ 08854, USA
              </p>
            </div>
          </div>
          <p class='IEEEStdsParagraph'>&#xa0;</p>
        </div>
        <p class='IEEEStdsParagraph'>
          <br clear='all' class='section'/>
        </p>
        <div class='WordSection2'>
          <div>
            <a name='abstract-destination' id='abstract-destination'/>
          </div>
          <p class='IEEEStdsKeywords'>
            <a name="_" id="_">
              <span class='IEEEStdsKeywordsHeader'>
                <span lang='EN-US' xml:lang='EN-US'>
                  <p>&#xa0;</p>
                </span>
              </span>
            </a>
          </p>
          <p class='IEEEStdsKeywords'>
            <span style='mso-bookmark:_Ref'>
              <span class='IEEEStdsKeywordsHeader'>
                <span lang='EN-US' xml:lang='EN-US'>Keywords:</span>
              </span>
              <span lang='EN-US' xml:lang='EN-US'/>
            </span>
          </p>
          <p class='IEEEStdsParagraph'>
            <span lang='EN-US' xml:lang='EN-US'>
              <p>&#xa0;</p>
            </span>
          </p>
          <p class='IEEEStdsCRFootnote'>
            <a class='FootnoteRef' href='#_ftn1' type='footnote' style='mso-footnote-id:ftn1' name="_" title='' id="_">
              <span class='MsoFootnoteReference'>
                <span style='mso-special-character:footnote'/>
              </span>
            </a>
          </p>
        </div>
        <span lang='EN-US' xml:lang='EN-US' style='font-size:10.0pt;font-family:&#x22;Times New Roman&#x22;,serif; mso-fareast-font-family:&#x22;Times New Roman&#x22;;color:white;mso-ansi-language:EN-US; mso-fareast-language:JA;mso-bidi-language:AR-SA'>
          <br clear='all' style='page-break-before:always;mso-break-type:section-break'/>
        </span>
        <!-- points to feedback statement as footnote -->
        <div class='WordSection3'>
          <div>
            <a name='boilerplate-disclaimers' id='boilerplate-disclaimers'/>
            <p class='IEEEStdsLevel1frontmatter'>Important Notices and Disclaimers Concerning IEEE Standards Documents</p>
            <p class='IEEEStdsParagraph'>
              <a name="_" id="_"/>
              IEEE Standards documents are made available for use subject to important
              notices and legal disclaimers. These notices and disclaimers, or a
              reference to this page (
              <a href='https://standards.ieee.org/ipr/disclaimers.html'>https://standards.ieee.org/ipr/disclaimers.html</a>
              ), appear in all standards and may be found under the heading
              &#x201c;Important Notices and Disclaimers Concerning IEEE Standards
              Documents.&#x201d;
            </p>
            <div>
              <p class='IEEEStdsLevel2frontmatter'>
                Notice and Disclaimer of Liability Concerning the Use of IEEE
                Standards Documents
              </p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                IEEE Standards documents are developed within the IEEE Societies and
                the Standards Coordinating Committees of the IEEE Standards
                Association (IEEE SA) Standards Board. IEEE develops its standards
                through an accredited consensus development process, which brings
                together volunteers representing varied viewpoints and interests to
                achieve the final product. IEEE Standards are documents developed by
                volunteers with scientific, academic, and industry-based expertise in
                technical working groups. Volunteers are not necessarily members of
                IEEE or IEEE SA, and participate without compensation from IEEE. While
                IEEE administers the process and establishes rules to promote fairness
                in the consensus development process, IEEE does not independently
                evaluate, test, or verify the accuracy of any of the information or
                the soundness of any judgments contained in its standards.
              </p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                IEEE makes no warranties or representations concerning its standards,
                and expressly disclaims all warranties, express or implied, concerning
                this standard, including but not limited to the warranties of
                merchantability, fitness for a particular purpose and
                non-infringement. In addition, IEEE does not warrant or represent that
                the use of the material contained in its standards is free from patent
                infringement. IEEE standards documents are supplied &#x201c;AS
                IS&#x201d; and &#x201c;WITH ALL FAULTS.&#x201d;
              </p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                Use of an IEEE standard is wholly voluntary. The existence of an IEEE
                Standard does not imply that there are no other ways to produce, test,
                measure, purchase, market, or provide other goods and services related
                to the scope of the IEEE standard. Furthermore, the viewpoint
                expressed at the time a standard is approved and issued is subject to
                change brought about through developments in the state of the art and
                comments received from users of the standard.
              </p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                In publishing and making its standards available, IEEE is not
                suggesting or rendering professional or other services for, or on
                behalf of, any person or entity, nor is IEEE undertaking to perform
                any duty owed by any other person or entity to another. Any person
                utilizing any IEEE Standards document, should rely upon his or her own
                independent judgment in the exercise of reasonable care in any given
                circumstances or, as appropriate, seek the advice of a competent
                professional in determining the appropriateness of a given IEEE
                standard.
              </p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                IN NO EVENT SHALL IEEE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
                SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
                LIMITED TO: THE NEED TO PROCURE SUBSTITUTE GOODS OR SERVICES; LOSS OF
                USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
                ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
                TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
                PUBLICATION, USE OF, OR RELIANCE UPON ANY STANDARD, EVEN IF ADVISED OF
                THE POSSIBILITY OF SUCH DAMAGE AND REGARDLESS OF WHETHER SUCH DAMAGE
                WAS FORESEEABLE.
              </p>
            </div>
            <div>
              <p class='IEEEStdsLevel2frontmatter'>Translations</p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                The IEEE consensus development process involves the review of
                documents in English only. In the event that an IEEE standard is
                translated, only the English version published by IEEE is the approved
                IEEE standard.
              </p>
            </div>
            <div>
              <p class='IEEEStdsLevel2frontmatter'>Official statements</p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                A statement, written or oral, that is not processed in accordance with
                the IEEE SA Standards Board Operations Manual shall not be considered
                or inferred to be the official position of IEEE or any of its
                committees and shall not be considered to be, nor be relied upon as, a
                formal position of IEEE. At lectures, symposia, seminars, or
                educational courses, an individual presenting information on IEEE
                standards shall make it clear that the presenter&#x2019;s views should
                be considered the personal views of that individual rather than the
                formal position of IEEE, IEEE SA, the Standards Committee, or the
                Working Group.
              </p>
            </div>
            <div>
              <p class='IEEEStdsLevel2frontmatter'>Comments on standards</p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                Comments for revision of IEEE Standards documents are welcome from any
                interested party, regardless of membership affiliation with IEEE or
                IEEE SA. However,
                <b>
                  IEEE does not provide interpretations, consulting information, or
                  advice pertaining to IEEE Standards documents
                </b>
                .
              </p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                Suggestions for changes in documents should be in the form of a
                proposed change of text, together with appropriate supporting
                comments. Since IEEE standards represent a consensus of concerned
                interests, it is important that any responses to comments and
                questions also receive the concurrence of a balance of interests. For
                this reason, IEEE and the members of its Societies and Standards
                Coordinating Committees are not able to provide an instant response to
                comments, or questions except in those cases where the matter has
                previously been addressed. For the same reason, IEEE does not respond
                to interpretation requests. Any person who would like to participate
                in evaluating comments or in revisions to an IEEE standard is welcome
                to join the relevant IEEE working group. You can indicate interest in
                a working group using the Interests tab in the Manage Profile
                Interests area of the
                <a href='https://development.standards.ieee.org/myproject-web/public/view.html#landing'>IEEE SA myProject system</a>
                .
                <span style='mso-bookmark:_Ref'>
                  <a class='FootnoteRef' href='#_ftn2' type='footnote' style='mso-footnote-id:ftn2' name="_" title='' id="_">
                    <span class='MsoFootnoteReference'>
                      <span style='mso-special-character:footnote'/>
                    </span>
                  </a>
                </span>
                 An IEEE Account is needed to access the application.
              </p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                Comments on standards should be submitted using the
                <a href='https://standards.ieee.org/content/ieee-standards/en/about/contact/index.html'>Contact Us</a>
                 form.
                <span style='mso-bookmark:_Ref'>
                  <a class='FootnoteRef' href='#_ftn3' type='footnote' style='mso-footnote-id:ftn3' name="_" title='' id="_">
                    <span class='MsoFootnoteReference'>
                      <span style='mso-special-character:footnote'/>
                    </span>
                  </a>
                </span>
              </p>
            </div>
            <div>
              <p class='IEEEStdsLevel2frontmatter'>Laws and regulations</p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                Users of IEEE Standards documents should consult all applicable laws
                and regulations. Compliance with the provisions of any IEEE Standards
                document does not constitute compliance to any applicable regulatory
                requirements. Implementers of the standard are responsible for
                observing or referring to the applicable regulatory requirements. IEEE
                does not, by the publication of its standards, intend to urge action
                that is not in compliance with applicable laws, and these documents
                may not be construed as doing so.
              </p>
            </div>
            <div>
              <p class='IEEEStdsLevel2frontmatter'>Data privacy</p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                Users of IEEE Standards documents should evaluate the standards for
                considerations of data privacy and data ownership in the context of
                assessing and using the standards in compliance with applicable laws
                and regulations.
              </p>
            </div>
            <div>
              <p class='IEEEStdsLevel2frontmatter'>Copyrights</p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                IEEE draft and approved standards are copyrighted by IEEE under US and
                international copyright laws. They are made available by IEEE and are
                adopted for a wide variety of both public and private uses. These
                include both use, by reference, in laws and regulations, and use in
                private self-regulation, standardization, and the promotion of
                engineering practices and methods. By making these documents available
                for use and adoption by public authorities and private users, IEEE
                does not waive any rights in copyright to the documents.
              </p>
            </div>
            <div>
              <p class='IEEEStdsLevel2frontmatter'>Photocopies</p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                Subject to payment of the appropriate licensing fees, IEEE will grant
                users a limited, non-exclusive license to photocopy portions of any
                individual standard for company or organizational internal use or
                individual, non-commercial use only. To arrange for payment of
                licensing fees, please contact Copyright Clearance Center, Customer
                Service, 222 Rosewood Drive, Danvers, MA 01923 USA; +1 978 750 8400;
                https://www.copyright.com/. Permission to photocopy portions of any
                individual standard for educational classroom use can also be obtained
                through the Copyright Clearance Center.
              </p>
            </div>
            <div>
              <p class='IEEEStdsLevel2frontmatter'>Updating of IEEE Standards documents</p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                Users of IEEE Standards documents should be aware that these documents
                may be superseded at any time by the issuance of new editions or may
                be amended from time to time through the issuance of amendments,
                corrigenda, or errata. An official IEEE document at any point in time
                consists of the current edition of the document together with any
                amendments, corrigenda, or errata then in effect.
              </p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                Every IEEE standard is subjected to review at least every 10 years.
                When a document is more than 10 years old and has not undergone a
                revision process, it is reasonable to conclude that its contents,
                although still of some value, do not wholly reflect the present state
                of the art. Users are cautioned to check to determine that they have
                the latest edition of any IEEE standard.
              </p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                In order to determine whether a given document is the current edition
                and whether it has been amended through the issuance of amendments,
                corrigenda, or errata, visit
                <a href='https://ieeexplore.ieee.org/browse/standards/collection/ieee/'>IEEE Xplore</a>
                 or
                <a href='https://standards.ieee.org/content/ieee-standards/en/about/contact/index.html'>contact IEEE</a>
                .
                <span style='mso-bookmark:_Ref'>
                  <a class='FootnoteRef' href='#_ftn4' type='footnote' style='mso-footnote-id:ftn4' name="_" title='' id="_">
                    <span class='MsoFootnoteReference'>
                      <span style='mso-special-character:footnote'/>
                    </span>
                  </a>
                </span>
                 For more information about the IEEE SA or IEEE&#x2019;s standards
                development process, visit the IEEE SA Website.
              </p>
            </div>
            <div>
              <p class='IEEEStdsLevel2frontmatter'>Errata</p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                Errata, if any, for all IEEE standards can be accessed on the
                <a href='https://standards.ieee.org/standard/index.html'>IEEE SA Website</a>
                .
                <span style='mso-bookmark:_Ref'>
                  <a class='FootnoteRef' href='#_ftn5' type='footnote' style='mso-footnote-id:ftn5' name="_" title='' id="_">
                    <span class='MsoFootnoteReference'>
                      <span style='mso-special-character:footnote'/>
                    </span>
                  </a>
                </span>
                 Search for standard number and year of approval to access the web
                page of the published standard. Errata links are located under the
                Additional Resources Details section. Errata are also available in
                <a href='https://ieeexplore.ieee.org/browse/standards/collection/ieee/'>IEEE Xplore</a>
                . Users are encouraged to periodically check for errata.
              </p>
            </div>
            <div>
              <p class='IEEEStdsLevel2frontmatter'>Patents</p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                IEEE Standards are developed in compliance with the
                <a href='https://standards.ieee.org/about/sasb/patcom/materials.html'>IEEE SA Patent Policy</a>
                .
                <span style='mso-bookmark:_Ref'>
                  <a class='FootnoteRef' href='#_ftn6' type='footnote' style='mso-footnote-id:ftn6' name="_" title='' id="_">
                    <span class='MsoFootnoteReference'>
                      <span style='mso-special-character:footnote'/>
                    </span>
                  </a>
                </span>
              </p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                Attention is called to the possibility that implementation of this
                standard may require use of subject matter covered by patent rights.
                By publication of this standard, no position is taken by the IEEE with
                respect to the existence or validity of any patent rights in
                connection therewith. If a patent holder or patent applicant has filed
                a statement of assurance via an Accepted Letter of Assurance, then the
                statement is listed on the IEEE SA Website at
                <a href='https://standards.ieee.org/about/sasb/patcom/patents.html'>https://standards.ieee.org/about/sasb/patcom/patents.html</a>
                . Letters of Assurance may indicate whether the Submitter is willing
                or unwilling to grant licenses under patent rights without
                compensation or under reasonable rates, with reasonable terms and
                conditions that are demonstrably free of any unfair discrimination to
                applicants desiring to obtain such licenses.
              </p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                Essential Patent Claims may exist for which a Letter of Assurance has
                not been received. The IEEE is not responsible for identifying
                Essential Patent Claims for which a license may be required, for
                conducting inquiries into the legal validity or scope of Patents
                Claims, or determining whether any licensing terms or conditions
                provided in connection with submission of a Letter of Assurance, if
                any, or in any licensing agreements are reasonable or
                non-discriminatory. Users of this standard are expressly advised that
                determination of the validity of any patent rights, and the risk of
                infringement of such rights, is entirely their own responsibility.
                Further information may be obtained from the IEEE Standards
                Association.
              </p>
            </div>
            <div>
              <p class='IEEEStdsLevel2frontmatter'>IMPORTANT NOTICE</p>
              <p class='IEEEStdsParagraph'>
                <a name="_" id="_"/>
                IEEE Standards do not guarantee or ensure safety, security, health, or
                environmental protection, or ensure against interference with or from
                other devices or networks. IEEE Standards development activities
                consider research and information presented to the standards
                development group in developing any safety recommendations. Other
                information about safety practices, changes in technology or
                technology implementation, or impact by peripheral systems also may be
                pertinent to safety considerations during implementation of the
                standard. Implementers and users of IEEE Standards documents are
                responsible for determining and complying with all appropriate safety,
                security, environmental, health, and interference protection practices
                and all applicable laws and regulations.
              </p>
            </div>
          </div>
        </div>
        <span lang='EN-US' xml:lang='EN-US' style='font-size:12.0pt;mso-bidi-font-size:10.0pt;font-family: &#x22;Times New Roman&#x22;,serif;mso-fareast-font-family:&#x22;Times New Roman&#x22;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'>
          <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
        </span>
                 <div>
           <a name='boilerplate-participants' id='boilerplate-participants'/>
           <p class='IEEEStdsLevel1frontmatter'>Participants</p>
           <p class='IEEEStdsParagraph'>
             <a name="_" id="_"/>
             At the time this draft Standard was completed, the WG Working Group had
             the following membership:
           </p>
           <p style='text-align:center;' align='center' class='IEEEStdsNamesCtrCxSpFirst'>
             <a name="_" id="_"/>
             <b>AB</b>
             ,
             <i>Chair</i>
           </p>
           <p style='text-align:center;' align='center' class='IEEEStdsNamesCtrCxSpLast'>
             <a name="_" id="_"/>
             <b>CD</b>
             ,
             <i>Vice Chair</i>
           </p>
         </div>
         <span lang='EN-US' xml:lang='EN-US' style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &#x22;Times New Roman&#x22;,serif;mso-fareast-font-family:&#x22;Times New Roman&#x22;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'>
           <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
           <div class='WordSection4'>
             <p class='IEEEStdsNamesList'>
               <a name="_" id="_"/>
               E, F, Jr.
             </p>
             <p class='IEEEStdsNamesList'>
               <a name="_" id="_"/>
               GH
             </p>
             <p class='IEEEStdsNamesList'>
               <a name="_" id="_"/>
               IJ
             </p>
           </div>
           <span lang='EN-US' xml:lang='EN-US' style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &#x22;Times New Roman&#x22;,serif;mso-fareast-font-family:&#x22;Times New Roman&#x22;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'>
             <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
             <div class='WordSection5'>
               <p class='IEEEStdsParagraph'>&#xa0;</p>
               <p class='IEEEStdsParagraph'>
                 <a name="_" id="_"/>
                 The following members of the SC Standards Association balloting group
                 voted on this Standard. Balloters may have voted for approval,
                 disapproval, or abstention.
               </p>
             </div>
             <span lang='EN-US' xml:lang='EN-US' style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &#x22;Times New Roman&#x22;,serif;mso-fareast-font-family:&#x22;Times New Roman&#x22;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'>
               <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
               <div class='WordSection6'>
                 <p class='IEEEStdsNamesList'>
                   <a name="_" id="_"/>
                   KL
                 </p>
                 <p class='IEEEStdsNamesList'>
                   <a name="_" id="_"/>
                   MN
                 </p>
               </div>
               <span lang='EN-US' xml:lang='EN-US' style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &#x22;Times New Roman&#x22;,serif;mso-fareast-font-family:&#x22;Times New Roman&#x22;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'>
                 <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
                 <div class='WordSection7'>
                   <p class='IEEEStdsParagraph'>&#xa0;</p>
                   <p class='IEEEStdsParagraph'>
                     <a name="_" id="_"/>
                     When the IEEE SA Standards Board approved this Standard on , it
                     had the following membership:
                   </p>
                   <p style='text-align:center;' align='center' class='IEEEStdsNamesCtrCxSpFirst'>
                     <a name="_" id="_"/>
                     <b>OP</b>
                     ,
                     <i>Chair</i>
                   </p>
                   <p style='text-align:center;' align='center' class='IEEEStdsNamesCtrCxSpMiddle'>
                     <a name="_" id="_"/>
                     <b>QR</b>
                     ,
                     <i>Vice Chair</i>
                   </p>
                   <p style='text-align:center;' align='center' class='IEEEStdsNamesCtrCxSpMiddle'>
                     <a name="_" id="_"/>
                     <b>ST</b>
                     ,
                     <i>Past Chair</i>
                   </p>
                   <p style='text-align:center;' align='center' class='IEEEStdsNamesCtrCxSpLast'>
                     <a name="_" id="_"/>
                     <b>UV</b>
                     ,
                     <i>Secretary</i>
                   </p>
                 </div>
                 <span lang='EN-US' xml:lang='EN-US' style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &#x22;Times New Roman&#x22;,serif;mso-fareast-font-family:&#x22;Times New Roman&#x22;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'>
                   <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
                   <div class='WordSection8'>
                     <p class='IEEEStdsNamesList'>
                       <a name="_" id="_"/>
                       KL
                     </p>
                     <p class='IEEEStdsNamesList'>
                       <a name="_" id="_"/>
                       MN
                     </p>
                   </div>
                   <span lang='EN-US' xml:lang='EN-US' style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &#x22;Times New Roman&#x22;,serif;mso-fareast-font-family:&#x22;Times New Roman&#x22;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'>
                     <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
                     <div class='WordSection9'>
                       <p class='IEEEStdsParaMemEmeritus'>
                         <a name="_" id="_"/>
                         *Member Emeritus
                       </p>
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
        <div class='WordSectionMiddleTitle'>
          <p class='IEEEStdsTitle' style='margin-top:70.0pt'>Draft Standard for Empty</p>
        </div>
        <p class='IEEEStdsParagraph'>
          <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
        </p>
        <div class='WordSectionMain'>
          <div>
            <a name="_" id="_"/>
            <p class='IEEEStdsLevel1Header'>Clause</p>
            <p class='IEEEStdsParagraph'>
              <a name="_" id="_"/>
              Hello
            </p>
          </div>
        </div>
        <div style='mso-element:footnote-list'>
          <div style='mso-element:footnote' id='ftn1'>
            <p style='text-align:left;' align='left' class='IEEEStdsCRTextReg'>
              <a name="_" id="_"/>
              <a style='mso-footnote-id:ftn1' href='#_ftn1' name="_" title='' id="_"/>
              <a style='mso-footnote-id:ftn0' href='#_ftnref0' name="_" title='' id="_"/>
              The Institute of Electrical and Electronics Engineers, Inc.
              <br/>
               3 Park Avenue, New York, NY 10016-5997, USA
            </p>
            <p class='IEEEStdsCRTextReg'>&#xa0;</p>
            <p class='IEEEStdsCRTextReg'>
              <a name="_" id="_"/>
              Copyright &#xa9; 2000 by The Institute of Electrical and Electronics
              Engineers, Inc.
            </p>
            <p class='IEEEStdsCRTextReg'>
              <a name="_" id="_"/>
              All rights reserved. Published . Printed in the United States of
              America.
            </p>
            <p class='IEEEStdsCRTextReg'>&#xa0;</p>
            <p class='IEEEStdsCRTextReg'>
              <a name="_" id="_"/>
              IEEE is a registered trademark in the U.S. Patent Trademark Office,
              owned by The Institute of Electrical and Electronics Engineers,
              Incorporated.
            </p>
            <p class='IEEEStdsCRTextReg'>&#xa0;</p>
            <p class='IEEEStdsCRTextReg'>
              PDF:
              <span style='mso-tab-count:1'> </span>
              ISBN 978-0-XXXX-XXXX-X
              <span style='mso-tab-count:1'> </span>
              STDXXXXX
            </p>
            <p class='IEEEStdsCRTextReg'>
              Print:
              <span style='mso-tab-count:1'> </span>
              ISBN 978-0-XXXX-XXXX-X
              <span style='mso-tab-count:1'> </span>
              STDPDXXXXX
            </p>
            <p class='IEEEStdsCRTextItal'>&#xa0;</p>
            <p class='IEEEStdsCRTextItal'>
              <a name="_" id="_"/>
              IEEE prohibits discrimination, harassment, and bullying.
            </p>
            <p class='IEEEStdsCRTextItal'>
              <a name="_" id="_"/>
              For more information, visit
              <a href='https://www.ieee.org/about/corporate/governance/p9-26.html'>https://www.ieee.org/about/corporate/governance/p9-26.html</a>
              .
            </p>
            <p class='IEEEStdsCRTextItal'>
              <a name="_" id="_"/>
              No part of this publication may be reproduced in any form, in an
              electronic retrieval system or otherwise, without the prior written
              permission of the publisher.
            </p>
          </div>
          <div style='mso-element:footnote' id='ftn2'>
            <p class='IEEEStdsFootnote'>
              <a name="_" id="_"/>
              <a style='mso-footnote-id:ftn2' href='#_ftn2' name="_" title='' id="_">
                <span class='MsoFootnoteReference'>
                  <span style='mso-special-character:footnote'/>
                </span>
              </a>
              Available at:
              <a href='https://development.standards.ieee.org/myproject-web/public/view.html#landing'>https://development.standards.ieee.org/myproject-web/public/view.html#landing</a>
              .
            </p>
          </div>
          <div style='mso-element:footnote' id='ftn3'>
            <p class='IEEEStdsFootnote'>
              <a name="_" id="_"/>
              <a style='mso-footnote-id:ftn3' href='#_ftn3' name="_" title='' id="_">
                <span class='MsoFootnoteReference'>
                  <span style='mso-special-character:footnote'/>
                </span>
              </a>
              Available at:
              <a href='https://standards.ieee.org/content/ieee-standards/en/about/contact/index.html'>https://standards.ieee.org/content/ieee-standards/en/about/contact/index.html</a>
              .
            </p>
          </div>
          <div style='mso-element:footnote' id='ftn4'>
            <p class='IEEEStdsFootnote'>
              <a name="_" id="_"/>
              <a style='mso-footnote-id:ftn4' href='#_ftn4' name="_" title='' id="_">
                <span class='MsoFootnoteReference'>
                  <span style='mso-special-character:footnote'/>
                </span>
              </a>
              Available at
              <a href='https://ieeexplore.ieee.org/browse/standards/collection/ieee'>https://ieeexplore.ieee.org/browse/standards/collection/ieee</a>
              .
            </p>
          </div>
          <div style='mso-element:footnote' id='ftn5'>
            <p class='IEEEStdsFootnote'>
              <a name="_" id="_"/>
              <a style='mso-footnote-id:ftn5' href='#_ftn5' name="_" title='' id="_">
                <span class='MsoFootnoteReference'>
                  <span style='mso-special-character:footnote'/>
                </span>
              </a>
              Available at:
              <a href='https://standards.ieee.org/standard/index.html'>https://standards.ieee.org/standard/index.html</a>
              .
            </p>
          </div>
          <div style='mso-element:footnote' id='ftn6'>
            <p class='IEEEStdsFootnote'>
              <a name="_" id="_"/>
              <a style='mso-footnote-id:ftn6' href='#_ftn6' name="_" title='' id="_">
                <span class='MsoFootnoteReference'>
                  <span style='mso-special-character:footnote'/>
                </span>
              </a>
              Available at:
              <a href='https://standards.ieee.org/about/sasb/patcom/materials.html'>https://standards.ieee.org/about/sasb/patcom/materials.html</a>
              .
            </p>
          </div>
        </div>
      </body>
    OUTPUT
    IsoDoc::IEEE::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:body")
    doc.at("//xmlns:div[@class = 'WordSectionContents']")&.remove
    expect(strip_guid(xmlpp(doc.to_xml)))
      .to be_equivalent_to xmlpp(word)
  end

  it "process admonitions" do
    input = <<~INPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml" type='presentation'>
         <sections><clause id="a">
          <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" type="caution" keep-with-next="true" keep-lines-together="true">
          <name>CAUTION</name>
        <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </admonition>
          <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6b" type="caution" keep-with-next="true" keep-lines-together="true" notag="true">
        <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </admonition>
          </clause></sections>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
          <div>
        <a name='a' id='a'/>
        <p class='IEEEStdsLevel1Header'/>
        <div class='IEEEStdsWarning' style='page-break-after: avoid;page-break-inside: avoid;'>
          <a name="_" id="_"/>
          <p class='IEEEStdsWarning' style='text-align:center;'>
            <b>CAUTION</b>
          </p>
          <p class='IEEEStdsParagraph'>
            <a name="_" id="_"/>
            Only use paddy or parboiled rice for the determination of husked rice
            yield.
          </p>
        </div>
        <div class='IEEEStdsWarning' style='page-break-after: avoid;page-break-inside: avoid;'>
          <a name="_" id="_"/>
          <p class='IEEEStdsParagraph'>
            <a name="_" id="_"/>
            Only use paddy or parboiled rice for the determination of husked rice
            yield.
          </p>
        </div>
      </div>
    OUTPUT
    IsoDoc::IEEE::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'a']]")
    expect(strip_guid(xmlpp(doc.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "process editorial notes" do
    input = <<~INPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml" type='presentation'>
         <sections><clause id="a">
          <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" type="editorial" keep-with-next="true" keep-lines-together="true">
          <name>EDITORIAL</name>
        <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </admonition>
          </clause></sections>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
          <div>
        <a name='a' id='a'/>
        <p class='IEEEStdsLevel1Header'/>
        <div class='zzHelp' style='page-break-after: avoid;page-break-inside: avoid;'>
          <a name="_" id="_"/>
          <p class='zzHelp' style='text-align:center;'>
            <b>EDITORIAL</b>
          </p>
          <p class='zzHelp'>
            <a name="_" id="_"/>
            Only use paddy or parboiled rice for the determination of husked rice
            yield.
          </p>
        </div>
      </div>
    OUTPUT
    IsoDoc::IEEE::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'a']]")
    expect(strip_guid(xmlpp(doc.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "process sourcecode" do
    input = <<~INPUT
          <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
        <sections>
          <clause id="a" displayorder="1">
            <sourcecode lang='ruby' id='samplecode'>
              <name>
                Figure 1&#xA0;&#x2014; Ruby
                <em>code</em>
              </name>
               puts x
            </sourcecode>
            <sourcecode unnumbered='true'> Que? </sourcecode>
          </clause>
        </sections>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
      <div>
        <a name='a' id='a'/>
        <p class='IEEEStdsLevel1Header'/>
        <p class='IEEEStdsComputerCode' style='page-break-after:avoid;'>
          <a name='samplecode' id='samplecode'/>
        </p>
        <p class='IEEEStdsComputerCode'>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; </p>
        <p class='IEEEStdsComputerCode'>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; puts x</p>
        <p class='IEEEStdsComputerCode'>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; </p>
        <p class='SourceTitle' style='text-align:center;'>
           Figure 1&#xa0;&#x2014; Ruby
          <i>code</i>
        </p>
        <p class='IEEEStdsComputerCode'> Que? </p>
      </div>
    OUTPUT
    IsoDoc::IEEE::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'a']]")
    expect(strip_guid(xmlpp(doc.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end
end
