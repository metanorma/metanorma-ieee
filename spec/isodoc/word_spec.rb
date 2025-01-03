require "spec_helper"
require "fileutils"

RSpec.describe IsoDoc::Ieee::WordConvert do
  it "processes middle title" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata>
      <title language="en" type="main">Title</title>
      <ext>
      <doctype>standard</doctype>
      </ext>
      </bibdata>
      <preface><introduction id="_introduction" obligation="informative" displayorder="1" id="A">
      <title>Introduction</title><admonition>This introduction is not part of P1000/D0.3.4, Draft Standard for Empty
      </admonition>
      <p id="_7d8a8a7f-3ded-050d-1da9-978f17519335">This is an introduction</p>
      </introduction></preface>
      <sections>
      <clause/>
      </sections>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
      <div class='WordSectionMiddleTitle'>
      <p class='IEEEStdsTitle' style='margin-left:0cm;margin-top:70.0pt'>Standard for Title</p>
      </div>
    OUTPUT
    presxml = IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    IsoDoc::Ieee::WordConvert.new({}).convert("test", presxml, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[@class = 'WordSectionMiddleTitle']")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)

    FileUtils.rm_f "test.doc"
    output = <<~OUTPUT
      <p class="Titleofdocument" style="margin-left:0cm;margin-top:70.0pt">Whitepaper for Title</p>
    OUTPUT
    presxml = IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input
      .sub("<doctype>standard</doctype>", "<doctype>whitepaper</doctype>"), true)
    IsoDoc::Ieee::WordConvert.new({}).convert("test", presxml, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:p[@class = 'Titleofdocument']")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
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
      <sections>
      <clause/>
      </sections>
       </iso-standard>
    INPUT
    output = <<~OUTPUT
      <div class='WordSectionMiddleTitle'>
      <p class='IEEEStdsTitle' style='margin-left:0cm;margin-top:70.0pt'>Guide for Title<br/>Amendment A1 Corrigenda C1</p>
      </div>
    OUTPUT
    presxml = IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    IsoDoc::Ieee::WordConvert.new({}).convert("test", presxml, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[@class = 'WordSectionMiddleTitle']")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes introduction" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
        <preface><introduction id="_introduction" obligation="informative" displayorder="1" id="A">
      <fmt-title>Introduction</fmt-title><admonition>This introduction is not part of P1000/D0.3.4, Draft Standard for Empty
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
    IsoDoc::Ieee::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//*[@class = 'IEEEStdsIntroduction']/..")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes abstract" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata><ext><doctype>standard</doctype></ext></bibdata>
        <preface><abstract id="_introduction" obligation="informative" displayorder="1" id="A">
      <fmt-title>Introduction</fmt-title><admonition>This introduction is not part of P1000/D0.3.4, Draft Standard for Empty
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
        <div class='IEEEStdsWarning'><span class="IEEEStdsAbstractHeader"><span lang="EN-US" xml:lang="EN-US">Abstract:</span></span> This introduction is not part of P1000/D0.3.4, Draft Standard for Empty </div>
        <p class='IEEEStdsAbstractBody' style="font-family: 'Arial', sans-serif;">Text</p>
        <div class="ul_wrap">
        <p style="mso-list:l11 level1 lfo1-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;font-family: 'Arial', sans-serif;" class="IEEEStdsUnorderedListCxSpFirst">List</p>
        </div>
        <p class='IEEEStdsAbstractBody' style="font-family: 'Arial', sans-serif;">
          <a name="_" id="_"/>
          This is an introduction
        </p>
      </div>
    OUTPUT
    IsoDoc::Ieee::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//*[@name = 'abstract-destination']/..")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)

    output = <<~OUTPUT
      <div class="abstract_div">
        <a name="_" id="_"/>
        <p class="Unnumberedheading" style="margin-top:18.0pt;margin-right:7.2pt;margin-bottom:6.0pt;margin-left:0cm;">Introduction</p>
        <div class="IEEEStdsWarning">This introduction is not part of P1000/D0.3.4, Draft Standard for Empty
      </div>
        <p class="Abstract" style="margin-left:0cm;margin-right:0.25cm;">Text</p>
        <div class="ul_wrap">
        <p style="mso-list:l23 level1 lfo1;margin-left:0cm;margin-right:0.25cm;" class="BulletedList">List</p>
        </div>
        <p class="Abstract" style="margin-left:0cm;margin-right:0.25cm;"><a name="_" id="_"/>This is an introduction</p>
      </div>
    OUTPUT
    IsoDoc::Ieee::WordConvert.new({})
      .convert("test", input
      .sub("<doctype>standard</doctype>", "<doctype>whitepaper</doctype>"), false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[@class = 'abstract_div']")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
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
              <foreword displayorder="1">
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
    IsoDoc::Ieee::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[@style = 'mso-element:footnote-list']")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(footnotes)
    doc = Nokogiri::XML(word2xml("test.doc"))
      .xpath("//xmlns:p[.//xmlns:a[@class = 'FootnoteRef']]")
    expect(strip_guid(Xml::C14n.format("<div>#{doc.to_xml}</div>")))
      .to be_equivalent_to Xml::C14n.format(references)
  end

  it "processes lists" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
        <iso-standard xmlns="http://riboseinc.com/isoxml">
        <bibdata><ext><doctype>standard</doctype></bibdata>
                <sections>
      <clause id="A" displayorder="1"><p>
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
           <div class="ol_wrap">
             <p style="mso-list:l16 level1 lfo2-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsNumberedListLevel1CxSpFirst">A</p>
             <p style="mso-list:l16 level1 lfo2-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsNumberedListLevel1CxSpMiddle">B</p>
             <p style="mso-list:l16 level1 lfo2-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsNumberedListLevel1CxSpMiddle">
               <div class="ol_wrap">
                 <p style="mso-list:l16 level2 lfo2-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsNumberedListLevel2CxSpFirst">C</p>
                 <p style="mso-list:l16 level2 lfo2-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsNumberedListLevel2CxSpMiddle">D</p>
                 <p style="mso-list:l16 level2 lfo2-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsNumberedListLevel2CxSpMiddle">
                   <div class="ol_wrap">
                     <p style="mso-list:l16 level6 lfo2-3;text-indent:-0.79cm; margin-left:2.68cm;" class="IEEEStdsNumberedListLevel3CxSpFirst">E</p>
                     <p style="mso-list:l16 level6 lfo2-3;text-indent:-0.79cm; margin-left:2.68cm;" class="IEEEStdsNumberedListLevel3CxSpMiddle">F</p>
                     <p style="mso-list:l16 level6 lfo2-3;text-indent:-0.79cm; margin-left:2.68cm;" class="IEEEStdsNumberedListLevel3CxSpMiddle">
                       <div class="ol_wrap">
                         <p style="mso-list:l16 level6 lfo2-4;text-indent:-0.79cm; margin-left:3.44cm;" class="IEEEStdsNumberedListLevel4CxSpFirst">G</p>
                         <p style="mso-list:l16 level6 lfo2-4;text-indent:-0.79cm; margin-left:3.44cm;" class="IEEEStdsNumberedListLevel4CxSpMiddle">H</p>
                         <p style="mso-list:l16 level6 lfo2-4;text-indent:-0.79cm; margin-left:3.44cm;" class="IEEEStdsNumberedListLevel4CxSpMiddle">
                           <div class="ol_wrap">
                             <p style="mso-list:l16 level6 lfo2-5;text-indent:-0.79cm; margin-left:4.2cm;" class="IEEEStdsNumberedListLevel5CxSpFirst">I</p>
                             <p style="mso-list:l16 level6 lfo2-5;text-indent:-0.79cm; margin-left:4.2cm;" class="IEEEStdsNumberedListLevel5CxSpMiddle">J</p>
                             <p style="mso-list:l16 level6 lfo2-5;text-indent:-0.79cm; margin-left:4.2cm;" class="IEEEStdsNumberedListLevel5CxSpMiddle">
                               <div class="ol_wrap">
                                 <p style="mso-list:l16 level7 lfo2-6;text-indent:-0.79cm; margin-left:4.960000000000001cm;" class="IEEEStdsNumberedListLevel6CxSpFirst">K</p>
                                 <p style="mso-list:l16 level7 lfo2-6;text-indent:-0.79cm; margin-left:4.960000000000001cm;" class="IEEEStdsNumberedListLevel6CxSpMiddle">L</p>
                                 <p style="mso-list:l16 level7 lfo2-6;text-indent:-0.79cm; margin-left:4.960000000000001cm;" class="IEEEStdsNumberedListLevel6CxSpLast">M</p>
                               </div>
                             </p>
                             <p style="mso-list:l16 level6 lfo2-5;text-indent:-0.79cm; margin-left:4.2cm;" class="IEEEStdsNumberedListLevel5CxSpLast">N</p>
                           </div>
                         </p>
                         <p style="mso-list:l16 level6 lfo2-4;text-indent:-0.79cm; margin-left:3.44cm;" class="IEEEStdsNumberedListLevel4CxSpLast">O</p>
                       </div>
                     </p>
                     <p style="mso-list:l16 level6 lfo2-3;text-indent:-0.79cm; margin-left:2.68cm;" class="IEEEStdsNumberedListLevel3CxSpLast">P</p>
                   </div>
                 </p>
                 <p style="mso-list:l16 level2 lfo2-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsNumberedListLevel2CxSpLast">Q</p>
               </div>
             </p>
             <p style="mso-list:l16 level1 lfo2-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsNumberedListLevel1CxSpLast">R</p>
           </div>
           <div class="ul_wrap">
             <p style="mso-list:l11 level1 lfo1-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsUnorderedListCxSpFirst">A</p>
             <p style="mso-list:l11 level1 lfo1-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsUnorderedListCxSpMiddle">B</p>
             <p style="mso-list:l11 level1 lfo1-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsUnorderedListCxSpMiddle">B1<div class="ListContLevel1"><div class="ul_wrap"><p style="mso-list:l21 level1 lfo1-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsUnorderedListLevel2">C</p><p style="mso-list:l21 level1 lfo1-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsUnorderedListLevel2">D</p><p style="mso-list:l21 level1 lfo1-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsUnorderedListLevel2"><div class="ul_wrap"><p style="mso-list:l21 level2 lfo1-3;text-indent:-0.79cm; margin-left:2.68cm;" class="IEEEStdsUnorderedListLevel2">E</p><p style="mso-list:l21 level2 lfo1-3;text-indent:-0.79cm; margin-left:2.68cm;" class="IEEEStdsUnorderedListLevel2">F</p></div></p><p style="mso-list:l21 level1 lfo1-2;text-indent:-0.79cm; margin-left:1.92cm;" class="IEEEStdsUnorderedListLevel2">Q</p></div></div></p>
             <p style="mso-list:l11 level1 lfo1-1;text-indent:-0.79cm; margin-left:1.1600000000000001cm;" class="IEEEStdsUnorderedListCxSpLast">R</p>
           </div>
         </p>
       </div>
    OUTPUT
    IsoDoc::Ieee::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'A']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(word)

    word = <<~OUTPUT
       <div>
         <a name="A" id="A"/>
         <p class="IEEESectionHeader"/>
         <p class="MsoBodyText">
           <div class="ol_wrap">
             <p style="mso-list:l16 level1 lfo2;" class="MsoListParagraphCxSpFirst">A</p>
             <p style="mso-list:l16 level1 lfo2;" class="MsoListParagraphCxSpMiddle">B</p>
             <p style="mso-list:l16 level1 lfo2;" class="MsoListParagraphCxSpMiddle">
               <div class="ol_wrap">
                 <p style="mso-list:l16 level2 lfo2;" class="MsoListParagraphCxSpFirst">C</p>
                 <p style="mso-list:l16 level2 lfo2;" class="MsoListParagraphCxSpMiddle">D</p>
                 <p style="mso-list:l16 level2 lfo2;" class="MsoListParagraphCxSpMiddle">
                   <div class="ol_wrap">
                     <p style="mso-list:l16 level3 lfo2;" class="MsoListParagraphCxSpFirst">E</p>
                     <p style="mso-list:l16 level3 lfo2;" class="MsoListParagraphCxSpMiddle">F</p>
                     <p style="mso-list:l16 level3 lfo2;" class="MsoListParagraphCxSpMiddle">
                       <div class="ol_wrap">
                         <p style="mso-list:l16 level4 lfo2;" class="MsoListParagraphCxSpFirst">G</p>
                         <p style="mso-list:l16 level4 lfo2;" class="MsoListParagraphCxSpMiddle">H</p>
                         <p style="mso-list:l16 level4 lfo2;" class="MsoListParagraphCxSpMiddle">
                           <div class="ol_wrap">
                             <p style="mso-list:l16 level5 lfo2;" class="MsoListParagraphCxSpFirst">I</p>
                             <p style="mso-list:l16 level5 lfo2;" class="MsoListParagraphCxSpMiddle">J</p>
                             <p style="mso-list:l16 level5 lfo2;" class="MsoListParagraphCxSpMiddle">
                               <div class="ol_wrap">
                                 <p style="mso-list:l16 level6 lfo2;" class="MsoListParagraphCxSpFirst">K</p>
                                 <p style="mso-list:l16 level6 lfo2;" class="MsoListParagraphCxSpMiddle">L</p>
                                 <p style="mso-list:l16 level6 lfo2;" class="MsoListParagraphCxSpLast">M</p>
                               </div>
                             </p>
                             <p style="mso-list:l16 level5 lfo2;" class="MsoListParagraphCxSpLast">N</p>
                           </div>
                         </p>
                         <p style="mso-list:l16 level4 lfo2;" class="MsoListParagraphCxSpLast">O</p>
                       </div>
                     </p>
                     <p style="mso-list:l16 level3 lfo2;" class="MsoListParagraphCxSpLast">P</p>
                   </div>
                 </p>
                 <p style="mso-list:l16 level2 lfo2;" class="MsoListParagraphCxSpLast">Q</p>
               </div>
             </p>
             <p style="mso-list:l16 level1 lfo2;" class="MsoListParagraphCxSpLast">R</p>
           </div>
           <div class="ul_wrap">
             <p style="mso-list:l23 level1 lfo1;" class="BulletedList">A</p>
             <p style="mso-list:l23 level1 lfo1;" class="BulletedList">B</p>
             <p style="mso-list:l23 level1 lfo1;" class="BulletedList">B1<div class="ListContLevel1"><div class="ul_wrap"><p style="mso-list:l23 level2 lfo1;" class="BulletedList">C</p><p style="mso-list:l23 level2 lfo1;" class="BulletedList">D</p><p style="mso-list:l23 level2 lfo1;" class="BulletedList"><div class="ul_wrap"><p style="mso-list:l23 level3 lfo1;" class="BulletedList">E</p><p style="mso-list:l23 level3 lfo1;" class="BulletedList">F</p></div></p><p style="mso-list:l23 level2 lfo1;" class="BulletedList">Q</p></div></div></p>
             <p style="mso-list:l23 level1 lfo1;" class="BulletedList">R</p>
           </div>
         </p>
       </div>
    OUTPUT
    IsoDoc::Ieee::WordConvert.new({}).convert("test", input
    .sub("<doctype>standard</doctype>", "<doctype>whitepaper</doctype>"), false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'A']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(word)
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
    presxml = IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    IsoDoc::Ieee::WordConvert.new({}).convert("test", presxml, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'A']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(word)
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
          <p class="IEEEStdsMultipleNotes" style="mso-list:l17 level1 lfo1;">Second</p><p class="IEEEStdsSingleNote" style="mso-list:l17 level1 lfo1;">Multi-para note</p>
        </div>
        <p class="TermNum">
          <a name="C" id="C"/>
        </p>
        <p class="IEEEStdsParagraph"><b>Beta</b>:   </p>
        <div>
          <a name="n3" id="n3"/>
          <p class="IEEEStdsSingleNote"><span class="note_label">NOTE—</span>Third</p><div class="Quote">Quotation</div>
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
    pres_output = IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    IsoDoc::Ieee::WordConvert.new({}).convert("test", pres_output, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'A']]")
    expect(strip_guid(Xml::C14n.format(doc
      .to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML, indent: 0))))
      .to be_equivalent_to Xml::C14n.format(word)
  end

  it "process admonitions" do
    input = <<~INPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml" type='presentation'>
         <sections><clause id="a" displayorder="1">
          <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" type="caution" keep-with-next="true" keep-lines-together="true">
          <fmt-name>CAUTION</fmt-name>
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
    IsoDoc::Ieee::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'a']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "process editorial notes" do
    input = <<~INPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml" type='presentation'>
         <sections><clause id="a" displayorder="1">
          <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" type="editorial" keep-with-next="true" keep-lines-together="true">
          <fmt-name>EDITORIAL</fmt-name>
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
    IsoDoc::Ieee::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'a']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "process sourcecode" do
    input = <<~INPUT
          <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
        <sections>
          <clause id="a" displayorder="1">
            <sourcecode lang='ruby' id='samplecode'>
              <fmt-name>
                Figure 1&#xA0;&#x2014; Ruby
                <em>code</em>
              </fmt-name>
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
    IsoDoc::Ieee::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'a']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "process figures" do
    input = <<~INPUT
          <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
          <bibdata><ext><doctype>standard</doctype></ext></bibdata>
        <sections>
          <clause id="a" displayorder="1">
          <figure id="figureA-1" keep-with-next="true" keep-lines-together="true">
          <fmt-name><span class="fmt-caption-label"><span class="fmt-element-name">Figure</span> <semx element="autonum" source="figureA-1">1</semx><span class="fmt-caption-delim">—</span><semx element="name" source="_">Split-it-right <em>sample</em> divider<fn reference="1"><p>X</p></fn></semx></span></fmt-name>
        <image height="20" width="30" id="_" mimetype="image/png" alt="alttext" title="titletxt"/>
        </figure>
          </clause>
        </sections>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
      <div>
         <a name="a" id="a"/>
         <p class="IEEEStdsLevel1Header"/>
         <div class="IEEEStdsImage" style="page-break-after: avoid;page-break-inside: avoid;">
           <a name="figureA-1" id="figureA-1"/>
           <p class="IEEEStdsImage" style="page-break-after:avoid;">
             <img height="20" alt="alttext" title="titletxt" width="30"/>
           </p>
           <p class="IEEEStdsRegularFigureCaption" style="text-align:center;">Split-it-right <i>sample</i> divider<span style="mso-bookmark:_Ref"><a class="FootnoteRef" href="#_ftn1" type="footnote" style="mso-footnote-id:ftn1" name="_" title="" id="_"><span class="MsoFootnoteReference"><span style="mso-special-character:footnote"/></span></a></span></p>
         </div>
       </div>
    OUTPUT
    IsoDoc::Ieee::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'a']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)

    output = <<~OUTPUT
      <div>
         <a name="a" id="a"/>
         <p class="IEEESectionHeader"/>
         <div class="MsoBodyText" style="page-break-after: avoid;page-break-inside: avoid;;text-align:center;">
           <a name="figureA-1" id="figureA-1"/>
           <p class="FigureHeadings" style="text-align:center;">Split-it-right <i>sample</i> divider<span style="mso-bookmark:_Ref"><a class="FootnoteRef" href="#_ftn1" type="footnote" style="mso-footnote-id:ftn1" name="_" title="" id="_"><span class="MsoFootnoteReference"><span style="mso-special-character:footnote"/></span></a></span></p>
           <img height="20" alt="alttext" title="titletxt" width="30"/>
         </div>
       </div>
    OUTPUT
    IsoDoc::Ieee::WordConvert.new({})
      .convert("test", input.sub("<doctype>standard</doctype>",
                                 "<doctype>whitepaper</doctype>"), false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'a']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "process tables" do
    input = <<~INPUT
          <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
          <bibdata><ext><doctype>standard</doctype></ext></bibdata>
        <sections>
          <clause id="a" displayorder="1">
          <table id="figureA-1" keep-with-next="true" keep-lines-together="true">
        <fmt-name>Figure 1&#xA0;&#x2014; Split-it-right <em>sample</em> divider<fn reference="1"><p>X</p></fn></fmt-name>
        <thead><tr><th>A</th></tr></thead>
        <tbody><tr><td>B</td></tr></tbody>
        <note id="A"><fmt-name>Note</fmt-name><p>This is a note</p></note>
        </table>
          </clause>
        </sections>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
      <div>
         <a name="a" id="a"/>
         <p class="IEEEStdsLevel1Header"/>
         <p class="IEEEStdsRegularTableCaption" style="text-align:center;">Figure 1 — Split-it-right <i>sample</i> divider<span style="mso-bookmark:_Ref"><a class="FootnoteRef" href="#_ftn1" type="footnote" style="mso-footnote-id:ftn1" name="_" title="" id="_"><span class="MsoFootnoteReference"><span style="mso-special-character:footnote"/></span></a></span></p>
         <div align="center" class="table_container">
           <table class="MsoISOTable" style="mso-table-anchor-horizontal:column;mso-table-overlap:never;border-spacing:0;border-width:1px;page-break-after: avoid;page-break-inside: avoid;">
             <a name="figureA-1" id="figureA-1"/>
             <thead>
               <tr>
                 <th style="font-weight:bold;border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:avoid;">
                   <p class="IEEEStdsTableColumnHead" style="page-break-after:avoid">A</p>
                 </th>
               </tr>
             </thead>
             <tbody>
               <tr>
                 <td style="border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:auto;">
                   <p class="IEEEStdsTableData-Left" style="page-break-after:auto">B</p>
                 </td>
               </tr>
             </tbody>
                   <div>
        <a name="A" id="A"/>
             <p class="IEEEStdsSingleNote">
               <span class="note_label">Note</span>
               This is a note
            </p>
      </div>
           </table>
         </div>
       </div>
    OUTPUT
    IsoDoc::Ieee::WordConvert.new({}).convert("test", input, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'a']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)

    output = <<~OUTPUT
      <div>
         <a name="a" id="a"/>
         <p class="IEEESectionHeader"/>
         <p class="TableTitles" style="text-align:center;">Figure 1 — Split-it-right <i>sample</i> divider<span style="mso-bookmark:_Ref"><a class="FootnoteRef" href="#_ftn1" type="footnote" style="mso-footnote-id:ftn1" name="_" title="" id="_"><span class="MsoFootnoteReference"><span style="mso-special-character:footnote"/></span></a></span></p>
         <div align="center" class="table_container">
           <table class="MsoISOTable" style="mso-table-anchor-horizontal:column;mso-table-overlap:never;border-spacing:0;border-width:1px;page-break-after: avoid;page-break-inside: avoid;">
             <a name="figureA-1" id="figureA-1"/>
             <thead>
               <tr>
                 <th style="font-weight:bold;border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:avoid;">
                   <p class="Tablecolumnheader" style="page-break-after:avoid">A</p>
                 </th>
               </tr>
             </thead>
             <tbody>
               <tr>
                 <td style="border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:auto;">
                   <p class="Tablecelltext" style="page-break-after:auto">B</p>
                 </td>
               </tr>
             </tbody>
             <div class="Note">
               <a name="A" id="A"/>
               <p class="Tablenotes">
               <span class="note_label">Note</span>
               This is a note
            </p>
             </div>
           </table>
         </div>
       </div>
    OUTPUT
    IsoDoc::Ieee::WordConvert.new({})
      .convert("test", input.sub("<doctype>standard</doctype>",
                                 "<doctype>whitepaper</doctype>"), false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'a']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "process clause" do
    input = <<~INPUT
          <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
          <bibdata><ext><doctype>standard</doctype></ext></bibdata>
          <sections>
        <clause id="A"><title>This is the clause title</title>
        <p>body</p>
        <clause id="B"><title>This is a subclause</title>
        <p>body</p>
        </clause>
        </clause>
        </sections>
      </iso-standard>
    INPUT
    presxml = <<~OUTPUT
       <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <bibdata>
             <ext>
                <doctype>standard</doctype>
             </ext>
          </bibdata>
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <p class="zzSTDTitle1" displayorder="2">Standard for ???</p>
             <clause id="A" displayorder="3">
                <title id="_">This is the clause title</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">This is the clause title</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="A">1</semx>
                </fmt-xref-label>
                <p>body</p>
                <clause id="B">
                   <title id="_">This is a subclause</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="B">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         </span>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                         <semx element="title" source="_">This is a subclause</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="B">1</semx>
                   </fmt-xref-label>
                   <p>body</p>
                </clause>
             </clause>
          </sections>
       </iso-standard>
    OUTPUT
    word = <<~OUTPUT
      <div>
         <a name="A" id="A"/>
         <p class="IEEEStdsLevel1Header">This is the clause title</p>
         <p class="IEEEStdsParagraph">body</p>
         <div>
           <a name="B" id="B"/>
           <p class="IEEEStdsLevel2Header">This is a subclause</p>
           <p class="IEEEStdsParagraph">body</p>
         </div>
       </div>
    OUTPUT
    pres_output = IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
    xml = Nokogiri::XML(pres_output)
    xml.at("//xmlns:localized-strings")&.remove
    expect(strip_guid(Xml::C14n.format(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    IsoDoc::Ieee::WordConvert.new({}).convert("test", pres_output, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'A']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(word)

    presxml = <<~OUTPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <bibdata>
             <ext>
                <doctype>whitepaper</doctype>
             </ext>
          </bibdata>
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <p class="zzSTDTitle1" displayorder="2">Whitepaper for ???</p>
             <clause id="A" displayorder="3">
                <title id="_">This is the clause title</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">This is the clause title</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="A">1</semx>
                </fmt-xref-label>
                <p>body</p>
                <clause id="B">
                   <title id="_">This is a subclause</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="B">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         </span>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                         <semx element="title" source="_">This is a subclause</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="B">1</semx>
                   </fmt-xref-label>
                   <p>body</p>
                </clause>
             </clause>
          </sections>
       </iso-standard>
    OUTPUT
    word = <<~OUTPUT
      <div>
         <a name="A" id="A"/>
         <p class="IEEESectionHeader">This is the clause title</p>
         <p class="MsoBodyText">body</p>
         <div>
           <a name="B" id="B"/>
           <h2 style="mso-list:l22 level2 lfo33;">This is a subclause</h2>
           <p class="MsoBodyText">body</p>
         </div>
       </div>
    OUTPUT
    pres_output = IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input.sub("<doctype>standard</doctype>",
                                 "<doctype>whitepaper</doctype>"), true)
    xml = Nokogiri::XML(pres_output)
    xml.at("//xmlns:localized-strings")&.remove
    expect(strip_guid(Xml::C14n.format(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    IsoDoc::Ieee::WordConvert.new({})
      .convert("test", pres_output, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'A']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(word)
  end

  it "process annex" do
    input = <<~INPUT
          <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
          <bibdata><ext><doctype>standard</doctype></ext></bibdata>
        <annex id="A"><title>This is the annex title</title>
        <p>body</p>
        <clause id="B"><title>This is a subclause</title>
        <p>body</p>
        </clause>
        </annex>
      </iso-standard>
    INPUT
    word = <<~OUTPUT
      <div>
        <a name="A" id="A"/>
        <h1 style="mso-list:l13 level1 lfo33;">
          <br/>
          <span style="font-weight:normal;">(informative)</span>
          <br/>
          <b>This is the annex title</b>
        </h1>
        <p class="IEEEStdsParagraph">body</p>
        <div>
          <a name="B" id="B"/>
          <h2 style="mso-list:l13 level2 lfo33;">This is a subclause</h2>
          <p class="IEEEStdsParagraph">body</p>
        </div>
      </div>
    OUTPUT
    pres_output = IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
    IsoDoc::Ieee::WordConvert.new({}).convert("test", pres_output, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'A']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(word)

    word = <<~OUTPUT
      <div>
         <a name="A" id="A"/>
         <h1 style="margin-left:0cm;">Annex A</h1>
         <wrapblock>
           <v:line o:spid="_x0000_s2052" style="visibility:visible;mso-wrap-style:square;mso-left-percent:-10001; mso-top-percent:-10001;mso-position-horizontal:absolute; mso-position-horizontal-relative:char;mso-position-vertical:absolute; mso-position-vertical-relative:line;mso-left-percent:-10001;mso-top-percent:-10001" from="55.05pt,2953.75pt" to="217pt,2953.75pt" o:gfxdata="UEsDBBQABgAIAAAAIQC2gziS/gAAAOEBAAATAAAAW0NvbnRlbnRfVHlwZXNdLnhtbJSRQU7DMBBF 90jcwfIWJU67QAgl6YK0S0CoHGBkTxKLZGx5TGhvj5O2G0SRWNoz/78nu9wcxkFMGNg6quQqL6RA 0s5Y6ir5vt9lD1JwBDIwOMJKHpHlpr69KfdHjyxSmriSfYz+USnWPY7AufNIadK6MEJMx9ApD/oD OlTrorhX2lFEilmcO2RdNtjC5xDF9pCuTyYBB5bi6bQ4syoJ3g9WQ0ymaiLzg5KdCXlKLjvcW893 SUOqXwnz5DrgnHtJTxOsQfEKIT7DmDSUCaxw7Rqn8787ZsmRM9e2VmPeBN4uqYvTtW7jvijg9N/y JsXecLq0q+WD6m8AAAD//wMAUEsDBBQABgAIAAAAIQA4/SH/1gAAAJQBAAALAAAAX3JlbHMvLnJl bHOkkMFqwzAMhu+DvYPRfXGawxijTi+j0GvpHsDYimMaW0Yy2fr2M4PBMnrbUb/Q94l/f/hMi1qR JVI2sOt6UJgd+ZiDgffL8ekFlFSbvV0oo4EbChzGx4f9GRdb25HMsYhqlCwG5lrLq9biZkxWOiqY 22YiTra2kYMu1l1tQD30/bPm3wwYN0x18gb45AdQl1tp5j/sFB2T0FQ7R0nTNEV3j6o9feQzro1i OWA14Fm+Q8a1a8+Bvu/d/dMb2JY5uiPbhG/ktn4cqGU/er3pcvwCAAD//wMAUEsDBBQABgAIAAAA IQA/XJkksgEAAE0DAAAOAAAAZHJzL2Uyb0RvYy54bWysU9tuGyEQfa/Uf0C8x4utJKpWXkdVbPcl bS0l+YAxsF5UlkEM9q7/voAvbdq3KC+IuXBmzplh/jD2lh10IIOu4dOJ4Ew7icq4XcNfX9Y3Xzij CE6BRacbftTEHxafP80HX+sZdmiVDiyBOKoH3/AuRl9XFclO90AT9NqlYIuhh5jMsKtUgCGh97aa CXFfDRiUDyg1UfIuT0G+KPhtq2X82bakI7MNT73FcoZybvNZLeZQ7wL4zshzG/COLnowLhW9Qi0h AtsH8x9Ub2RAwjZOJPYVtq2RunBIbKbiHzbPHXhduCRxyF9loo+DlT8Oj24TcutydM/+CeUvSqJU g6f6GswG+U1g2+E7qjRG2EcsfMc29PlxYsLGIuvxKqseI5PJORN34nZ6x5m8xCqoLw99oPhNY8/y peHWuMwYajg8UcyNQH1JyW6Ha2NtmZp1bEgrJ6b3QpQnhNaoHM6JFHbbRxvYAfLkxdfVap2HneDe pGXsJVB3yiuh004E3DtV6nQa1Op8j2Ds6Z6ArDvrlKXJG0f1FtVxE3KdbKWZlYrn/cpL8bddsv78 gsVvAAAA//8DAFBLAwQUAAYACAAAACEA8DUns+EAAAAQAQAADwAAAGRycy9kb3ducmV2LnhtbExP XUvDQBB8F/wPxwq+2Ys1tCHNpYgfiBTR1oKv29w2Keb2Qu7Sxn/vCoLuw8Lszs7OFMvRtepIfTh4 NnA9SUARV94euDawfX+8ykCFiGyx9UwGvijAsjw/KzC3/sRrOm5irUSEQ44Gmhi7XOtQNeQwTHxH LLu97x1GgX2tbY8nEXetnibJTDs8sHxosKO7hqrPzeAM7J8zXaVP+LHiF/u2nr0O24cVGXN5Md4v pN0uQEUa498F/GQQ/1CKsZ0f2AbVCpYSqoHpPJuDEkZ6k0rE3e9El4X+H6T8BgAA//8DAFBLAQIt ABQABgAIAAAAIQC2gziS/gAAAOEBAAATAAAAAAAAAAAAAAAAAAAAAABbQ29udGVudF9UeXBlc10u eG1sUEsBAi0AFAAGAAgAAAAhADj9If/WAAAAlAEAAAsAAAAAAAAAAAAAAAAALwEAAF9yZWxzLy5y ZWxzUEsBAi0AFAAGAAgAAAAhAD9cmSSyAQAATQMAAA4AAAAAAAAAAAAAAAAALgIAAGRycy9lMm9E b2MueG1sUEsBAi0AFAAGAAgAAAAhAPA1J7PhAAAAEAEAAA8AAAAAAAAAAAAAAAAADAQAAGRycy9k b3ducmV2LnhtbFBLBQYAAAAABAAEAPMAAAAaBQAAAAA= " strokecolor="#00aeef" strokeweight="8pt">
           <a name="Line_x0020_23" id="Line_x0020_23"/>
             <lock v:ext="edit" shapetype="f"/>
             <w:wrap type="topAndBottom" anchorx="page"/>
           </v:line>
         </wrapblock>
         <br style="mso-ignore:vglayout" clear="ALL"/>
         <p class="MsoBodyText"> </p>
        <p class="Unnumberedheading">This is the annex title</p>
         <p class="MsoBodyText">body</p>
         <div>
           <a name="B" id="B"/>
           <h2 class="Unnumberedheading">This is a subclause</h2>
           <p class="MsoBodyText">body</p>
         </div>
       </div>
    OUTPUT
    pres_output = IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input.sub("<doctype>standard</doctype>",
                                 "<doctype>whitepaper</doctype>"), true)
    IsoDoc::Ieee::WordConvert.new({})
      .convert("test", pres_output, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'A']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml)))
      .to be_equivalent_to Xml::C14n.format(word)
  end
end
