require "spec_helper"
require "fileutils"

RSpec.describe IsoDoc::IEEE::WordConvert do
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
      <li><ul>
      <li>G</li>
      <li>H</li>
      <li><ul>
      <li>I</li>
      <li>J</li>
      <li><ul>
      <li>K</li>
      <li>L</li>
      <li>M</li>
      </ul></li>
      <li>N</li>
      </ul></li>
      <li>O</li>
      </ul></li>
      <li>P</li>
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
         <a name='A' id='A'/>
         <p class='IEEEStdsLevel1Header'/>
         <p class='IEEEStdsParagraph'>
           <p style='mso-list:l2 level1 lfo2;' class='IEEEStdsNumberedListLevel1CxSpFirst'>A</p>
           <p style='mso-list:l2 level1 lfo2;' class='IEEEStdsNumberedListLevel1CxSpMiddle'>B</p>
           <p style='mso-list:l2 level1 lfo2;' class='IEEEStdsNumberedListLevel1CxSpMiddle'>
             <p style='mso-list:l2 level2 lfo2;' class='IEEEStdsNumberedListLevel1CxSpFirst'>C</p>
             <p style='mso-list:l2 level2 lfo2;' class='IEEEStdsNumberedListLevel1CxSpMiddle'>D</p>
             <p style='mso-list:l2 level2 lfo2;' class='IEEEStdsNumberedListLevel1CxSpMiddle'>
               <p style='mso-list:l2 level3 lfo2;' class='IEEEStdsNumberedListLevel1CxSpFirst'>E</p>
               <p style='mso-list:l2 level3 lfo2;' class='IEEEStdsNumberedListLevel1CxSpMiddle'>F</p>
               <p style='mso-list:l2 level3 lfo2;' class='IEEEStdsNumberedListLevel1CxSpMiddle'>
                 <p style='mso-list:l2 level4 lfo2;' class='IEEEStdsNumberedListLevel1CxSpFirst'>G</p>
                 <p style='mso-list:l2 level4 lfo2;' class='IEEEStdsNumberedListLevel1CxSpMiddle'>H</p>
                 <p style='mso-list:l2 level4 lfo2;' class='IEEEStdsNumberedListLevel1CxSpMiddle'>
                   <p style='mso-list:l2 level5 lfo2;' class='IEEEStdsNumberedListLevel1CxSpFirst'>I</p>
                   <p style='mso-list:l2 level5 lfo2;' class='IEEEStdsNumberedListLevel1CxSpMiddle'>J</p>
                   <p style='mso-list:l2 level5 lfo2;' class='IEEEStdsNumberedListLevel1CxSpMiddle'>
                     <p style='mso-list:l2 level6 lfo2;' class='IEEEStdsNumberedListLevel1CxSpFirst'>K</p>
                     <p style='mso-list:l2 level6 lfo2;' class='IEEEStdsNumberedListLevel1CxSpMiddle'>L</p>
                     <p style='mso-list:l2 level6 lfo2;' class='IEEEStdsNumberedListLevel1CxSpLast'>M</p>
                   </p>
                   <p style='mso-list:l2 level5 lfo2;' class='IEEEStdsNumberedListLevel1CxSpLast'>N</p>
                 </p>
                 <p style='mso-list:l2 level4 lfo2;' class='IEEEStdsNumberedListLevel1CxSpLast'>O</p>
               </p>
               <p style='mso-list:l2 level3 lfo2;' class='IEEEStdsNumberedListLevel1CxSpLast'>P</p>
             </p>
             <p style='mso-list:l2 level2 lfo2;' class='IEEEStdsNumberedListLevel1CxSpLast'>Q</p>
           </p>
           <p style='mso-list:l2 level1 lfo2;' class='IEEEStdsNumberedListLevel1CxSpLast'>R</p>
           <p style='mso-list:l3 level1 lfo1;' class='IEEEStdsUnorderedListCxSpFirst'>A</p>
           <p style='mso-list:l3 level1 lfo1;' class='IEEEStdsUnorderedListCxSpMiddle'>B</p>
           <p style='mso-list:l3 level1 lfo1;' class='IEEEStdsUnorderedListCxSpMiddle'>
             B1
             <p style='mso-list:l3 level2 lfo1;' class='IEEEStdsUnorderedListCxSpFirst'>C</p>
             <p style='mso-list:l3 level2 lfo1;' class='IEEEStdsUnorderedListCxSpMiddle'>D</p>
             <p style='mso-list:l3 level2 lfo1;' class='IEEEStdsUnorderedListCxSpMiddle'>
               <p style='mso-list:l3 level3 lfo1;' class='IEEEStdsUnorderedListCxSpFirst'>E</p>
               <p style='mso-list:l3 level3 lfo1;' class='IEEEStdsUnorderedListCxSpMiddle'>F</p>
               <p style='mso-list:l3 level3 lfo1;' class='IEEEStdsUnorderedListCxSpMiddle'>
                 <p style='mso-list:l3 level4 lfo1;' class='IEEEStdsUnorderedListCxSpFirst'>G</p>
                 <p style='mso-list:l3 level4 lfo1;' class='IEEEStdsUnorderedListCxSpMiddle'>H</p>
                 <p style='mso-list:l3 level4 lfo1;' class='IEEEStdsUnorderedListCxSpMiddle'>
                   <p style='mso-list:l3 level5 lfo1;' class='IEEEStdsUnorderedListCxSpFirst'>I</p>
                   <p style='mso-list:l3 level5 lfo1;' class='IEEEStdsUnorderedListCxSpMiddle'>J</p>
                   <p style='mso-list:l3 level5 lfo1;' class='IEEEStdsUnorderedListCxSpMiddle'>
                     <p style='mso-list:l3 level6 lfo1;' class='IEEEStdsUnorderedListCxSpFirst'>K</p>
                     <p style='mso-list:l3 level6 lfo1;' class='IEEEStdsUnorderedListCxSpMiddle'>L</p>
                     <p style='mso-list:l3 level6 lfo1;' class='IEEEStdsUnorderedListCxSpLast'>M</p>
                   </p>
                   <p style='mso-list:l3 level5 lfo1;' class='IEEEStdsUnorderedListCxSpLast'>N</p>
                 </p>
                 <p style='mso-list:l3 level4 lfo1;' class='IEEEStdsUnorderedListCxSpLast'>O</p>
               </p>
               <p style='mso-list:l3 level3 lfo1;' class='IEEEStdsUnorderedListCxSpLast'>P</p>
             </p>
             <p style='mso-list:l3 level2 lfo1;' class='IEEEStdsUnorderedListCxSpLast'>Q</p>
           </p>
           <p style='mso-list:l3 level1 lfo1;' class='IEEEStdsUnorderedListCxSpLast'>R</p>
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
end
