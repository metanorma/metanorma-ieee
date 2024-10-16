require "spec_helper"

RSpec.describe IsoDoc do
  it "processes tables" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword id="A">
          <table id="tableD-1" alt="tool tip" summary="long desc">
          <name>Hello</name>
        <thead>
          <tr>
            <td rowspan="2" align="left">Description</td>
            <td colspan="4" align="center">Rice sample</td>
          </tr>
          <tr>
            <td align="left">Arborio</td>
            <td align="center">Drago<fn reference="a">
        <p id="_0fe65e9a-5531-408e-8295-eeff35f41a55">Parboiled rice.</p>
      </fn></td>
            <td align="center">Balilla<fn reference="a">
        <p id="_0fe65e9a-5531-408e-8295-eeff35f41a55">Parboiled rice.</p>
      </fn></td>
            <td align="center">Thaibonnet</td>
          </tr>
          </thead>
          <tbody>
          <tr>
            <th align="left"><p>Number of laboratories retained after eliminating outliers<br/>
            Laboratory count</p></th>
            <td align="center">13</td>
            <td align="center">11</td>
            <td align="center">13</td>
            <td align="center">13</td>
          </tr>
          <tr>
            <td align="left">Mean value, g/100 g</td>
            <td align="center">81,2</td>
            <td align="center">82,0</td>
            <td align="center">81,8</td>
            <td align="center">77,7</td>
          </tr>
          </tbody>
          <tfoot>
          <tr>
            <td align="left">Reproducibility limit, <stem type="AsciiMath">R</stem> (= 2,83 <stem type="AsciiMath">s_R</stem>)</td>
            <td align="center">2,89</td>
            <td align="center">0,57</td>
            <td align="center">2,26</td>
            <td align="center">6,06</td>
          </tr>
        </tfoot>
        <dl>
        <dt>Drago</dt>
      <dd>A type of rice</dd>
      </dl>
      <note><p>This is a table about rice</p></note>
      </table>
          </foreword></preface>
          </iso-standard>
    INPUT

    presxml = <<~PRESXML
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
         <preface>
             <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause>
           <foreword displayorder='2' id="A">
             <table id='tableD-1' alt='tool tip' summary='long desc'>
               <name>Table 1&#x2014;Hello</name>
               <thead>
                 <tr>
                   <td rowspan='2' align='left'>Description</td>
                   <td colspan='4' align='center'>Rice sample</td>
                 </tr>
                 <tr>
                   <td align='left'>Arborio</td>
                   <td align='center'>
                     Drago
                     <fn reference='a'>
                       <p id='_'>Parboiled rice.</p>
                     </fn>
                   </td>
                   <td align='center'>
                     Balilla
                     <fn reference='a'>
                       <p id='_'>Parboiled rice.</p>
                     </fn>
                   </td>
                   <td align='center'>Thaibonnet</td>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <th align='left'>
                      <p>Number of laboratories retained after eliminating outliers<br/>
                      Laboratory count</p>
                    </th>
                   <td align='center'>13</td>
                   <td align='center'>11</td>
                   <td align='center'>13</td>
                   <td align='center'>13</td>
                 </tr>
                 <tr>
                   <td align='left'>Mean value, g/100 g</td>
                   <td align='center'>81,2</td>
                   <td align='center'>82,0</td>
                   <td align='center'>81,8</td>
                   <td align='center'>77,7</td>
                 </tr>
               </tbody>
               <tfoot>
                 <tr>
                   <td align='left'>
                     Reproducibility limit,
                     <stem type='AsciiMath'>R</stem>
                      (= 2,83
                     <stem type='AsciiMath'>s_R</stem>
                     )
                   </td>
                   <td align='center'>2,89</td>
                   <td align='center'>0,57</td>
                   <td align='center'>2,26</td>
                   <td align='center'>6,06</td>
                 </tr>
               </tfoot>
               <dl>
                 <dt>Drago</dt>
                 <dd>A type of rice</dd>
               </dl>
               <note>
                 <name>NOTE</name>
                 <p>This is a table about rice</p>
               </note>
             </table>
           </foreword>
         </preface>
       </iso-standard>
    PRESXML

    html = <<~"OUTPUT"
      #{HTML_HDR}
           <br/>
           <div id="A">
             <h1 class='ForewordTitle'>Foreword</h1>
             <p class='TableTitle' style='text-align:center;'>Table 1&#x2014;Hello</p>
             <table id='tableD-1' class='MsoISOTable' style='border-width:1px;border-spacing:0;' title='tool tip'>
               <caption>
                 <span style='display:none'>long desc</span>
               </caption>
               <thead>
                 <tr>
                   <td rowspan='2' style='text-align:left;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;' scope='col'>Description</td>
                   <td colspan='4' style='text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;' scope='colgroup'>Rice sample</td>
                 </tr>
                 <tr>
                   <td style='text-align:left;border-top:none;border-bottom:solid windowtext 1.5pt;' scope='col'>Arborio</td>
                   <td style='text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;' scope='col'>
                      Drago
                     <a href='#tableD-1a' class='TableFootnoteRef'>a</a>
                     <aside class='footnote'>
                       <div id='fn:tableD-1a'>
                         <span>
                           <span id='tableD-1a' class='TableFootnoteRef'>a</span>
                           &#xa0;
                         </span>
                         <p id='_'>Parboiled rice.</p>
                       </div>
                     </aside>
                   </td>
                   <td style='text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;' scope='col'>
                      Balilla
                     <a href='#tableD-1a' class='TableFootnoteRef'>a</a>
                   </td>
                   <td style='text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;' scope='col'>Thaibonnet</td>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <th style='font-weight:bold;text-align:left;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;' scope='row'>
                     <p>Number of laboratories retained after eliminating outliers<br/>
                     Laboratory count</p>
                   </th>
                   <td style='text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;'>13</td>
                   <td style='text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;'>11</td>
                   <td style='text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;'>13</td>
                   <td style='text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;'>13</td>
                 </tr>
                 <tr>
                   <td style='text-align:left;border-top:none;border-bottom:solid windowtext 1.5pt;'>Mean value, g/100 g</td>
                   <td style='text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;'>81,2</td>
                   <td style='text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;'>82,0</td>
                   <td style='text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;'>81,8</td>
                   <td style='text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;'>77,7</td>
                 </tr>
               </tbody>
               <tfoot>
                 <tr>
                   <td style='text-align:left;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;'>
                      Reproducibility limit,
                     <span class='stem'>(#(R)#)</span>
                      (= 2,83
                     <span class='stem'>(#(s_R)#)</span>
                      )
                   </td>
                   <td style='text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;'>2,89</td>
                   <td style='text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;'>0,57</td>
                   <td style='text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;'>2,26</td>
                   <td style='text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;'>6,06</td>
                 </tr>
               </tfoot>
               <div class="figdl">
               <dl>
                 <dt>
                   <p>Drago</p>
                 </dt>
                 <dd>A type of rice</dd>
               </dl>
               </div>
               <div class='Note'>
                 <p>
                 <span class='note_label'>NOTE&#x2014;</span>This is a table about rice
                 </p>
               </div>
             </table>
           </div>
         </div>
       </body>
    OUTPUT

    word = <<~WORD
          <div>
        <a name="A" id="A"/>
        <p class="IEEEStdsLevel1Header">Foreword</p>
        <p class="IEEEStdsRegularTableCaption" style="text-align:center;">—Hello</p>
        <div align="center" class="table_container">
          <table class="MsoISOTable" style="mso-table-anchor-horizontal:column;mso-table-overlap:never;border-spacing:0;border-width:1px;" title="tool tip" summary="long desc">
            <a name="tableD-1" id="tableD-1"/>
            <thead>
              <tr>
                <td rowspan="2" align="left" style="border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:avoid;">
                  <p class="IEEEStdsTableColumnHead" style="text-align: left;page-break-after:avoid">Description</p>
                </td>
                <td colspan="4" align="center" style="border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">
                  <p class="IEEEStdsTableColumnHead" style="text-align: center;page-break-after:avoid">Rice sample</p>
                </td>
              </tr>
              <tr>
                <td align="left" style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:avoid;">
                  <p class="IEEEStdsTableColumnHead" style="text-align: left;page-break-after:avoid">Arborio</p>
                </td>
                <td align="center" style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:avoid;">
                  <p class="IEEEStdsTableColumnHead" style="text-align: center;page-break-after:avoid">
                     Drago
                     <a href="#tableD-1a" class="TableFootnoteRef">a</a><aside><div style="page-break-after:avoid"><a name="ftntableD-1a" id="ftntableD-1a"/><span><span class="TableFootnoteRef"><a name="tableD-1a" id="tableD-1a"/>a</span><span style="mso-tab-count:1">  </span></span><p style="page-break-after:avoid" class="IEEEStdsParagraph"><a name="_" id="_"/>Parboiled rice.</p></div></aside></p>
                </td>
                <td align="center" style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:avoid;">
                  <p class="IEEEStdsTableColumnHead" style="text-align: center;page-break-after:avoid">
                     Balilla
                     <a href="#tableD-1a" class="TableFootnoteRef">a</a></p>
                </td>
                <td align="center" style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:avoid;">
                  <p class="IEEEStdsTableColumnHead" style="text-align: center;page-break-after:avoid">Thaibonnet</p>
                </td>
              </tr>
            </thead>
            <tbody>
              <tr>
                <th align="left" style="font-weight:bold;border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">
                  <p class="IEEEStdsTableLineHead" style="text-align: left;page-break-after:avoid">Number of laboratories retained after eliminating outliers</p>
                  <p class="IEEEStdsTableLineSubhead" style="text-align: left;page-break-after:avoid">
                      Laboratory count</p>
                </th>
                <td align="center" style="border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">
                  <p class="IEEEStdsTableData-Center" style="text-align: center;page-break-after:avoid">13</p>
                </td>
                <td align="center" style="border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">
                  <p class="IEEEStdsTableData-Center" style="text-align: center;page-break-after:avoid">11</p>
                </td>
                <td align="center" style="border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">
                  <p class="IEEEStdsTableData-Center" style="text-align: center;page-break-after:avoid">13</p>
                </td>
                <td align="center" style="border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">
                  <p class="IEEEStdsTableData-Center" style="text-align: center;page-break-after:avoid">13</p>
                </td>
              </tr>
              <tr>
                <td align="left" style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:auto;">
                  <p class="IEEEStdsTableData-Left" style="text-align: left;page-break-after:auto">Mean value, g/100 g</p>
                </td>
                <td align="center" style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:auto;">
                  <p class="IEEEStdsTableData-Center" style="text-align: center;page-break-after:auto">81,2</p>
                </td>
                <td align="center" style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:auto;">
                  <p class="IEEEStdsTableData-Center" style="text-align: center;page-break-after:auto">82,0</p>
                </td>
                <td align="center" style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:auto;">
                  <p class="IEEEStdsTableData-Center" style="text-align: center;page-break-after:auto">81,8</p>
                </td>
                <td align="center" style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:auto;">
                  <p class="IEEEStdsTableData-Center" style="text-align: center;page-break-after:auto">77,7</p>
                </td>
              </tr>
            </tbody>
            <tfoot>
              <tr>
                <td align="left" style="border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:auto;">
                  <p class="IEEEStdsTableData-Left" style="text-align: left;page-break-after:auto">
                     Reproducibility limit,
                     <span class="stem">(#(R)#)</span>
                      (= 2,83
                      <span class="stem">(#(s_R)#)</span>
                     )
                   </p>
                </td>
                <td align="center" style="border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:auto;">
                  <p class="IEEEStdsTableData-Center" style="text-align: center;page-break-after:auto">2,89</p>
                </td>
                <td align="center" style="border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:auto;">
                  <p class="IEEEStdsTableData-Center" style="text-align: center;page-break-after:auto">0,57</p>
                </td>
                <td align="center" style="border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:auto;">
                  <p class="IEEEStdsTableData-Center" style="text-align: center;page-break-after:auto">2,26</p>
                </td>
                <td align="center" style="border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:auto;">
                  <p class="IEEEStdsTableData-Center" style="text-align: center;page-break-after:auto">6,06</p>
                </td>
              </tr>
            </tfoot>
            <div class="figdl">
            <p style="text-indent: -2.0cm; margin-left: 2.0cm; tab-stops: 2.0cm;" class="IEEEStdsParagraph">Drago<span style="mso-tab-count:1">  </span>A type of rice</p>
            </div>
            <div>
              <p class="IEEEStdsSingleNote"><span class="note_label">NOTE—</span>This is a table about rice</p>
            </div>
          </table>
        </div>
      </div>
    WORD
    expect(Xml::C14n.format(strip_guid(IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)))).to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(Nokogiri::XML(IsoDoc::Ieee::HtmlConvert.new({})
      .convert("test", presxml, true))
      .at("//body").to_xml)).to be_equivalent_to Xml::C14n.format(html)
    IsoDoc::Ieee::WordConvert.new({}).convert("test", presxml, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'A']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml
      .gsub("<m:", "<").gsub("</m:", "</"))))
      .to be_equivalent_to Xml::C14n.format(word)
    expect(Nokogiri::XML(IsoDoc::Ieee::PresentationXMLConvert
      .new({ hierarchicalassets: true })
      .convert("test", input, true))
      .at("//xmlns:table/xmlns:name").to_xml)
      .to be_equivalent_to "<name>Table Preface.1&#x2014;Hello</name>"
  end

  it "processes figures" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword id="A">
          <figure id="figureA-1" keep-with-next="true" keep-lines-together="true">
        <name>Split-it-right <em>sample</em> divider<fn reference="1"><p>X</p></fn></name>
        <image src="data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7" height="20" width="auto" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f2" mimetype="image/png"/>
        <image src="data:application/xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+Cjw/eG1sLXN0eWxlc2hlZXQgdHlwZT0idGV4dC94c2wiIGhyZWY9Ii4uLy4uLy4uL3hzbC9yZXNfZG9jL2ltZ2ZpbGUueHNsIj8+CjwhRE9DVFlQRSBpbWdmaWxlLmNvbnRlbnQgU1lTVEVNICIuLi8uLi8uLi9kdGQvdGV4dC5lbnQiPgo8aW1nZmlsZS5jb250ZW50IG1vZHVsZT0iZnVuZGFtZW50YWxzX29mX3Byb2R1Y3RfZGVzY3JpcHRpb25fYW5kX3N1cHBvcnQiIGZpbGU9ImFjdGlvbl9zY2hlbWFleHBnMS54bWwiPgo8aW1nIHNyYz0iYWN0aW9uX3NjaGVtYWV4cGcxLmdpZiI+CjxpbWcuYXJlYSBzaGFwZT0icmVjdCIgY29vcmRzPSIyMTAsMTg2LDM0MywyMjciIGhyZWY9Ii4uLy4uL3Jlc291cmNlcy9iYXNpY19hdHRyaWJ1dGVfc2NoZW1hL2Jhc2ljX2F0dHJpYnV0ZV9zY2hlbWEueG1sIiAvPgo8aW1nLmFyZWEgc2hhcGU9InJlY3QiIGNvb3Jkcz0iMTAsMTAsOTYsNTEiIGhyZWY9Ii4uLy4uL3Jlc291cmNlcy9hY3Rpb25fc2NoZW1hL2FjdGlvbl9zY2hlbWEueG1sIiAvPgo8aW1nLmFyZWEgc2hhcGU9InJlY3QiIGNvb3Jkcz0iMjEwLDI2NCwzNTgsMzA1IiBocmVmPSIuLi8uLi9yZXNvdXJjZXMvc3VwcG9ydF9yZXNvdXJjZV9zY2hlbWEvc3VwcG9ydF9yZXNvdXJjZV9zY2hlbWEueG1sIiAvPgo8L2ltZz4KPC9pbWdmaWxlLmNvbnRlbnQ+Cg==" height="20" width="auto" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f2" mimetype="application/xml"/>
        <fn reference="a">
        <p id="_ef2c85b8-5a5a-4ecd-a1e6-92acefaaa852">The time <stem type="AsciiMath">t_90</stem> was estimated to be 18,2 min for this example.</p>
      </fn>
        <dl>
        <dt>A</dt>
        <dd><p>B</p></dd>
        </dl>
      </figure>
      <figure id="figure-B">
      <pre alt="A B">A &#x3c;
      B</pre>
      </figure>
      <figure id="figure-C" unnumbered="true">
      <pre>A &#x3c;
      B</pre>
      </figure>
          </foreword></preface>
          </iso-standard>
    INPUT
    presxml = <<~OUTPUT
          <?xml version='1.0'?>
           <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <preface>
              <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause>
          <foreword displayorder="2" id="A">
          <figure id="figureA-1" keep-with-next="true" keep-lines-together="true">
        <name>Figure 1&#x2014;Split-it-right <em>sample</em> divider<fn reference="1"><p>X</p></fn></name>
        <image src="data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7" height="20" width="auto" id="_" mimetype="image/png"/>
        <image src='data:application/xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+Cjw/eG1sLXN0eWxlc2hlZXQgdHlwZT0idGV4dC94c2wiIGhyZWY9Ii4uLy4uLy4uL3hzbC9yZXNfZG9jL2ltZ2ZpbGUueHNsIj8+CjwhRE9DVFlQRSBpbWdmaWxlLmNvbnRlbnQgU1lTVEVNICIuLi8uLi8uLi9kdGQvdGV4dC5lbnQiPgo8aW1nZmlsZS5jb250ZW50IG1vZHVsZT0iZnVuZGFtZW50YWxzX29mX3Byb2R1Y3RfZGVzY3JpcHRpb25fYW5kX3N1cHBvcnQiIGZpbGU9ImFjdGlvbl9zY2hlbWFleHBnMS54bWwiPgo8aW1nIHNyYz0iYWN0aW9uX3NjaGVtYWV4cGcxLmdpZiI+CjxpbWcuYXJlYSBzaGFwZT0icmVjdCIgY29vcmRzPSIyMTAsMTg2LDM0MywyMjciIGhyZWY9Ii4uLy4uL3Jlc291cmNlcy9iYXNpY19hdHRyaWJ1dGVfc2NoZW1hL2Jhc2ljX2F0dHJpYnV0ZV9zY2hlbWEueG1sIiAvPgo8aW1nLmFyZWEgc2hhcGU9InJlY3QiIGNvb3Jkcz0iMTAsMTAsOTYsNTEiIGhyZWY9Ii4uLy4uL3Jlc291cmNlcy9hY3Rpb25fc2NoZW1hL2FjdGlvbl9zY2hlbWEueG1sIiAvPgo8aW1nLmFyZWEgc2hhcGU9InJlY3QiIGNvb3Jkcz0iMjEwLDI2NCwzNTgsMzA1IiBocmVmPSIuLi8uLi9yZXNvdXJjZXMvc3VwcG9ydF9yZXNvdXJjZV9zY2hlbWEvc3VwcG9ydF9yZXNvdXJjZV9zY2hlbWEueG1sIiAvPgo8L2ltZz4KPC9pbWdmaWxlLmNvbnRlbnQ+Cg==' height='20' width='auto' id='_' mimetype='application/xml'/>
        <fn reference="a">
        <p id="_">The time <stem type="AsciiMath">t_90</stem> was estimated to be 18,2 min for this example.</p>
      </fn>
        <dl>
        <dt>A</dt>
        <dd><p>B</p></dd>
        </dl>
      </figure>
      <figure id="figure-B">
      <name>Figure 2</name>
      <pre alt="A B">A &#x3c;
      B</pre>
      </figure>
      <figure id="figure-C" unnumbered="true">
      <pre>A &#x3c;
      B</pre>
      </figure>
          </foreword></preface>
          </iso-standard>
    OUTPUT
    html = <<~OUTPUT
      #{HTML_HDR}
                               <br/>
                               <div id="A">
                                 <h1 class="ForewordTitle">Foreword</h1>
                                 <div id="figureA-1" class="figure" style='page-break-after: avoid;page-break-inside: avoid;'>
                         <img src="data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7" height="20" width="auto"/>
                         <img src='data:application/xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+Cjw/eG1sLXN0eWxlc2hlZXQgdHlwZT0idGV4dC94c2wiIGhyZWY9Ii4uLy4uLy4uL3hzbC9yZXNfZG9jL2ltZ2ZpbGUueHNsIj8+CjwhRE9DVFlQRSBpbWdmaWxlLmNvbnRlbnQgU1lTVEVNICIuLi8uLi8uLi9kdGQvdGV4dC5lbnQiPgo8aW1nZmlsZS5jb250ZW50IG1vZHVsZT0iZnVuZGFtZW50YWxzX29mX3Byb2R1Y3RfZGVzY3JpcHRpb25fYW5kX3N1cHBvcnQiIGZpbGU9ImFjdGlvbl9zY2hlbWFleHBnMS54bWwiPgo8aW1nIHNyYz0iYWN0aW9uX3NjaGVtYWV4cGcxLmdpZiI+CjxpbWcuYXJlYSBzaGFwZT0icmVjdCIgY29vcmRzPSIyMTAsMTg2LDM0MywyMjciIGhyZWY9Ii4uLy4uL3Jlc291cmNlcy9iYXNpY19hdHRyaWJ1dGVfc2NoZW1hL2Jhc2ljX2F0dHJpYnV0ZV9zY2hlbWEueG1sIiAvPgo8aW1nLmFyZWEgc2hhcGU9InJlY3QiIGNvb3Jkcz0iMTAsMTAsOTYsNTEiIGhyZWY9Ii4uLy4uL3Jlc291cmNlcy9hY3Rpb25fc2NoZW1hL2FjdGlvbl9zY2hlbWEueG1sIiAvPgo8aW1nLmFyZWEgc2hhcGU9InJlY3QiIGNvb3Jkcz0iMjEwLDI2NCwzNTgsMzA1IiBocmVmPSIuLi8uLi9yZXNvdXJjZXMvc3VwcG9ydF9yZXNvdXJjZV9zY2hlbWEvc3VwcG9ydF9yZXNvdXJjZV9zY2hlbWEueG1sIiAvPgo8L2ltZz4KPC9pbWdmaWxlLmNvbnRlbnQ+Cg==' height='20' width='auto'/>
                         <a href="#_" class="TableFootnoteRef">a</a><aside class="footnote"><div id="fn:_"><span><span id="_" class="TableFootnoteRef">a</span>&#160; </span>
                         <p id="_">The time <span class="stem">(#(t_90)#)</span> was estimated to be 18,2 min for this example.</p>
                       </div></aside>
                         <p  style='page-break-after:avoid;'><b>Key</b></p>
                         <div class="figdl">
                      <dl><dt><p>A</p></dt><dd><p>B</p></dd></dl>
                      </div>
                       <p class="FigureTitle" style="text-align:center;">Figure 1&#8212;Split-it-right <i>sample</i> divider
                       <a class='FootnoteRef' href='#fn:1'>
                  <sup>1</sup>
                </a>
                        </p></div>
                               <div class="figure" id="figure-B">
                <pre>A &#x3c;
                B</pre>
                <p class="FigureTitle" style="text-align:center;">Figure 2</p>
                </div>
                               <div class="figure" id="figure-C">
                <pre>A &#x3c;
                B</pre>
                </div>
                               </div>
                               <aside id='fn:1' class='footnote'>
                  <p>X</p>
                </aside>
                             </div>
                           </body>
    OUTPUT
    word = <<~OUTPUT
      <div>
        <a name="A" id="A"/>
        <p class="IEEEStdsLevel1Header">Foreword</p>
        <div class="IEEEStdsImage" style="page-break-after: avoid;page-break-inside: avoid;">
          <a name="figureA-1" id="figureA-1"/>
          <img src="_.gif" height="20" width="20"/>
          <img src="_.xml" height="20" width="0"/>
          <aside>
            <div>
              <a name="ftn_" id="ftn_"/>
            </div>
          </aside>
          <p style="page-break-after:avoid;" class="IEEEStdsParagraph">
            <b>Key</b>
          </p>
          <table class="dl" style="page-break-after:avoid;">
            <tr>
              <td valign="top" align="left">
                <p align="left" style="margin-left:0pt;text-align:left;" class="IEEEStdsParagraph">A</p>
              </td>
              <td valign="top">
                <p class="IEEEStdsParagraph">B</p>
              </td>
            </tr>
            <tr>
              <td valign="top" align="left">
                <span>
                  <span class="TableFootnoteRef"><a name="_" id="_"/>a</span>
                  <span style="mso-tab-count:1">  </span>
                </span>
              </td>
              <td valign="top">
                <p class="IEEEStdsParagraph"><a name="_" id="_"/>The time <span class="stem">(#(t_90)#)</span> was estimated to be 18,2 min for this example.</p>
              </td>
            </tr>
          </table>
          <p class="IEEEStdsRegularFigureCaption" style="text-align:center;">—Split-it-right <i>sample</i> divider<span style="mso-bookmark:_Ref"><a class="FootnoteRef" href="#_ftn1" type="footnote" style="mso-footnote-id:ftn1" name="_" title="" id="_"><span class="MsoFootnoteReference"><span style="mso-special-character:footnote"/></span></a></span></p>
        </div>
        <div class="IEEEStdsImage">
          <a name="figure-B" id="figure-B"/>
          <pre style="page-break-after:avoid;">A
      B</pre>
          <p class="IEEEStdsRegularFigureCaption" style="text-align:center;"/>
        </div>
        <div class="IEEEStdsImage">
          <a name="figure-C" id="figure-C"/>
          <pre>A
      B</pre>
        </div>
      </div>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true).gsub("&lt;", "&#x3c;"))))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(IsoDoc::Ieee::HtmlConvert.new({})
      .convert("test", presxml, true))
      .at("//body").to_xml))).to be_equivalent_to Xml::C14n.format(html)
    FileUtils.rm_rf "spec/assets/odf1.emf"
    IsoDoc::Ieee::WordConvert.new({}).convert("test", presxml, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'A']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml
      .gsub("<m:", "<").gsub("</m:", "</")
      .gsub(/['"][^'".]+\.(gif|xml)['"]/, "'_.\\1'")
      .gsub("epub:", "")
      .gsub(/mso-bookmark:_Ref\d+/, "mso-bookmark:_Ref"))))
      .to be_equivalent_to Xml::C14n.format(word)
    expect(Xml::C14n.format(Nokogiri::XML(IsoDoc::Ieee::PresentationXMLConvert
     .new({ hierarchicalassets: true })
     .convert("test", input, true))
     .at("//xmlns:figure/xmlns:name").to_xml))
      .to be_equivalent_to Xml::C14n.format(<<~OUTPUT)
        <name>
          Figure Preface.1&#x2014;Split-it-right
          <em>sample</em>
           divider
          <fn reference='1'>
            <p>X</p>
          </fn>
        </name>
      OUTPUT
  end

  it "processes sequences of notes" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <clause id="a"><title>First</title>
          <note id="note1">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">First note.</p>
      </note>
          <note id="note2">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83a">Second note.</p>
      </note>
          </clause>
          <clause id="b"><title>First</title>
          <note id="note3">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83b">Third note.</p>
      </note>
      </clause>
        </sections>
          </iso-standard>
    INPUT
    presxml = <<~OUTPUT
          <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
          <preface>
              <clause type="toc" id="_" displayorder="1">
          <title depth="1">Contents</title>
        </clause>
        </preface>
        <sections>
          <p class="zzSTDTitle1" displayorder="2">??? for ???</p>
          <clause id='a' displayorder='3'>
            <title depth='1'>
              1.
              <tab/>
              First
            </title>
            <note id='note1'>
              <name>NOTE 1</name>
              <p id='_'>First note.</p>
            </note>
            <note id='note2'>
              <name>NOTE 2</name>
              <p id='_'>Second note.</p>
            </note>
          </clause>
          <clause id='b' displayorder='4'>
            <title depth='1'>
              2.
              <tab/>
              First
            </title>
            <note id='note3'>
              <name>NOTE</name>
              <p id='_'>Third note.</p>
            </note>
          </clause>
        </sections>
      </iso-standard>
    OUTPUT
    html = <<~"OUTPUT"
      #{HTML_HDR}
          <p class="zzSTDTitle1">??? for ???</p>
          <div id='a'>
            <h1> 1. &#xa0; First </h1>
            <div id='note1' class='Note'>
              <p>
                <span class='note_label'>NOTE 1&#x2014;</span>
                First note.
              </p>
            </div>
            <div id='note2' class='Note'>
              <p>
                <span class='note_label'>NOTE 2&#x2014;</span>
                Second note.
              </p>
            </div>
          </div>
          <div id='b'>
            <h1> 2. &#xa0; First </h1>
            <div id='note3' class='Note'>
              <p>
                <span class='note_label'>NOTE&#x2014;</span>
                Third note.
              </p>
            </div>
          </div>
        </div>
      </body>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
       .convert("test", input, true).gsub("&lt;", "&#x3c;"))))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(Nokogiri::XML(IsoDoc::Ieee::HtmlConvert.new({})
      .convert("test", presxml, true))
      .at("//body").to_xml)).to be_equivalent_to Xml::C14n.format(html)
  end

  it "processes admonitions" do
    presxml = <<~INPUT
            <iso-standard xmlns="http://riboseinc.com/isoxml" type='presentation'>
            <preface>
                <clause type="toc" id="_" displayorder="1">
        <title depth="1">Contents</title>
      </clause>
            <foreword displayorder="2">
            <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" type="caution" keep-with-next="true" keep-lines-together="true">
            <name>CAUTION</name>
          <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
        </admonition>
            <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6b" type="caution" keep-with-next="true" keep-lines-together="true" notag="true">
          <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
        </admonition>
            </foreword></preface>
            </iso-standard>
    INPUT
    html = <<~OUTPUT
      #{HTML_HDR}
      <br/>
        <div>
                    <h1 class='ForewordTitle'>Foreword</h1>
                          <div id="_" class='Admonition' style='page-break-after: avoid;page-break-inside: avoid;'>
        <p class='AdmonitionTitle' style='text-align:center;'>CAUTION</p>
        <p id="_">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </div>
      <div id="_" class='Admonition' style='page-break-after: avoid;page-break-inside: avoid;'>
        <p id="_">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
             </div>
           </div>
         </div>
       </body>
    OUTPUT
    word = <<~OUTPUT
      <div class='WordSection2'>
            <div class="WordSectionContents">
          <h1 class="IEEEStdsLevel1frontmatter">Contents</h1>
        </div>
        <p class="page-break">
          <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
        </p>
        <div>
          <h1 class='ForewordTitle'>Foreword</h1>
          <div id="_" class='IEEEStdsWarning' style='page-break-after: avoid;page-break-inside: avoid;'>
            <p class='IEEEStdsWarning' style='text-align:center;'>
              <b>CAUTION</b>
            </p>
            <p id="_">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
          </div>
          <div id="_" class='IEEEStdsWarning' style='page-break-after: avoid;page-break-inside: avoid;'>
            <p id="_">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
          </div>
        </div>
        <p>&#xa0;</p>
      </div>
    OUTPUT
    expect(strip_guid(Xml::C14n.format(Nokogiri::XML(IsoDoc::Ieee::HtmlConvert.new({})
      .convert("test", presxml, true))
      .at("//body").to_xml))).to be_equivalent_to Xml::C14n.format(html)
    expect(strip_guid(Xml::C14n.format(Nokogiri::XML(IsoDoc::Ieee::WordConvert.new({})
      .convert("test", presxml, true))
                .at("//div[@class = 'WordSection2']").to_xml)))
      .to be_equivalent_to Xml::C14n.format(word)
  end

  it "processes examples" do
    presxml = <<~INPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
        <preface>
            <clause type="toc" id="_" displayorder="1">
         <title depth="1">Contents</title>
        </clause>
          <foreword displayorder="2" id="A">
            <example id='samplecode' keep-with-next='true' keep-lines-together='true'>
              <name>Example 1</name>
              <p>Hello</p>
              <sourcecode id='X'>
                <name>Sample</name>
              </sourcecode>
            </example>
          </foreword>
        </preface>
      </iso-standard>
    INPUT
    html = <<~OUTPUT
      #{HTML_HDR}
      <br/>
        <div id="A">
                    <h1 class='ForewordTitle'>Foreword</h1>
                                 <div id='samplecode' class='example' style='page-break-after: avoid;page-break-inside: avoid;'>
               <p class='example-title'>Example 1:</p>
               <p>Hello</p>
               <pre id='X' class='sourcecode'>
                 <br/>
                 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
                 <br/>
                 &#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;
               </pre>
               <p class='SourceTitle' style='text-align:center;'>Sample</p>
             </div>
           </div>
        </div>
        </body>
    OUTPUT
    word = <<~OUTPUT
      <div>
         <a name='A' id='A'/>
         <p class='IEEEStdsLevel1Header'>Foreword</p>
         <div class='IEEEStdsParagraph' style='page-break-after: avoid;page-break-inside: avoid;'>
           <a name='samplecode' id='samplecode'/>
           <p class='IEEEStdsParagraph'>
             <em>Example 1:</em>
           </p>
           <p class='IEEEStdsParagraph'>Hello</p>
           <p class='IEEEStdsComputerCode' style='page-break-after:avoid;'>
             <a name='X' id='X'/>
           </p>
           <p class='IEEEStdsComputerCode'>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; </p>
           <p class='IEEEStdsComputerCode'>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0; </p>
           <p class='SourceTitle' style='text-align:center;'>Sample</p>
         </div>
       </div>
    OUTPUT
    expect(strip_guid(Xml::C14n.format(Nokogiri::XML(IsoDoc::Ieee::HtmlConvert.new({})
      .convert("test", presxml, true))
      .at("//body").to_xml))).to be_equivalent_to Xml::C14n.format(html)
    IsoDoc::Ieee::WordConvert.new({}).convert("test", presxml, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'A']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml
      .gsub("<m:", "<").gsub("</m:", "</"))))
      .to be_equivalent_to Xml::C14n.format(word)
  end

  it "process formulae" do
    input = <<~INPUT
             <iso-standard xmlns="http://riboseinc.com/isoxml"  type='presentation'>
          <preface><foreword id="A" displayorder="1">
          <formula id="_be9158af-7e93-4ee2-90c5-26d31c181934" unnumbered="true"  keep-with-next="true" keep-lines-together="true">
        <stem type="AsciiMath">r = 1 %</stem>
      <dl id="_e4fe94fe-1cde-49d9-b1ad-743293b7e21d">
        <dt>
          <stem type="AsciiMath">r</stem>
        </dt>
        <dd>
          <p id="_1b99995d-ff03-40f5-8f2e-ab9665a69b77">is the repeatability limit.</p>
        </dd>
      </dl>
          <note id="_83083c7a-6c85-43db-a9fa-4d8edd0c9fc0">
        <p id="_511aaa98-4116-42af-8e5b-c87cdf5bfdc8">[durationUnits] is essentially a duration statement without the "P" prefix. "P" is unnecessary because between "G" and "U" duration is always expressed.</p>
      </note>
          </formula>
          <formula id="_be9158af-7e93-4ee2-90c5-26d31c181935">
        <stem type="AsciiMath">r = 1 %</stem>
        </formula>
          </foreword></preface>
          </iso-standard>
    INPUT
    presxml = <<~INPUT
               <iso-standard xmlns="http://riboseinc.com/isoxml"  type='presentation'>
            <preface>
                <clause type="toc" id="_" displayorder="1">
        <title depth="1">Contents</title>
      </clause>
          <foreword id="A" displayorder="2">
            <formula id="_" unnumbered="true"  keep-with-next="true" keep-lines-together="true">
          <stem type="AsciiMath">r = 1 %</stem>
        <dl id="_" class="formula_dl">
          <dt>
            <stem type="AsciiMath">r</stem>
          </dt>
          <dd>
            <p id="_">is the repeatability limit.</p>
          </dd>
        </dl>
            <note id="_">
            <name>NOTE</name>
          <p id="_">[durationUnits] is essentially a duration statement without the "P" prefix. "P" is unnecessary because between "G" and "U" duration is always expressed.</p>
        </note>
            </formula>
            <formula id="_"><name>1</name>
          <stem type="AsciiMath">r = 1 %</stem>
          </formula>
            </foreword></preface>
            </iso-standard>
    INPUT
    html = <<~OUTPUT
          #{HTML_HDR}
          <br/>
          <div id="A">
            <h1 class='ForewordTitle'>Foreword</h1>
            <div id="_" style='page-break-after: avoid;page-break-inside: avoid;'>
              <div class='formula'>
                <p>
                  <span class='stem'>(#(r = 1 %)#)</span>
                </p>
              </div>
              <div class="figdl">
              <dl id="_" class='formula_dl'>
                <dt>
                  <span class='stem'>(#(r)#)</span>
                </dt>
                <dd>
                  <p id="_">is the repeatability limit.</p>
                </dd>
              </dl>
              </div>
              <div id="_" class='Note'>
                <p>
                  <span class='note_label'>NOTE&#x2014;</span>
                  [durationUnits] is essentially a duration statement without the "P"
                  prefix. "P" is unnecessary because between "G" and "U" duration is
                  always expressed.
                </p>
              </div>
            </div>
            <div id="_">
              <div class='formula'>
                <p>
                  <span class='stem'>(#(r = 1 %)#)</span>
                  &#xa0; (1)
                </p>
              </div>
            </div>
          </div>
        </div>
      </body>
    OUTPUT
    word = <<~OUTPUT
      <div>
         <a name="A" id="A"/>
         <p class="IEEEStdsLevel1Header">Foreword</p>
         <div style="page-break-after: avoid;page-break-inside: avoid;">
           <a name="_" id="_"/>
           <div class="IEEEStdsEquation">
             <p class="IEEEStdsEquation">
               <span class="stem">(#(r = 1 %)#)</span>
               <span style="mso-tab-count:1">  </span>
             </p>
           </div>
           <p class="IEEEStdsEquationVariableList"><span class="stem">(#(r)#)</span><span style="mso-tab-count:1">  </span>is the repeatability limit.</p>
           <div>
             <a name="_" id="_"/>
             <p class="IEEEStdsSingleNote"><span class="note_label">NOTE—</span>[durationUnits] is essentially a duration statement without the "P" prefix. "P" is unnecessary because between "G" and "U" duration is always expressed.</p>
           </div>
         </div>
         <div>
           <a name="_" id="_"/>
           <div class="IEEEStdsEquation">
             <p class="IEEEStdsEquation"><span class="stem">(#(r = 1 %)#)</span><span style="mso-tab-count:1">  </span>(1)</p>
           </div>
         </div>
       </div>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
       .convert("test", input, true))))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(strip_guid(Xml::C14n.format(Nokogiri::XML(IsoDoc::Ieee::HtmlConvert.new({})
  .convert("test", presxml, true))
  .at("//body").to_xml))).to be_equivalent_to Xml::C14n.format(html)
    IsoDoc::Ieee::WordConvert.new({}).convert("test", presxml, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:div[xmlns:a[@id = 'A']]")
    expect(strip_guid(Xml::C14n.format(doc.to_xml
      .gsub("<m:", "<").gsub("</m:", "</"))))
      .to be_equivalent_to Xml::C14n.format(word)
  end

  it "processes amend blocks" do
    input = <<~INPUT
      <standard-document xmlns='https://www.metanorma.org/ns/standoc'>
           <bibdata type='standard'>
             <title language='en' format='text/plain'>Document title</title>
             <language>en</language>
             <script>Latn</script>
             <status>
               <stage>published</stage>
             </status>
             <copyright>
               <from>2020</from>
             </copyright>
             <ext>
               <doctype>article</doctype>
             </ext>
           </bibdata>
           <sections>
             <clause id='A' inline-header='false' obligation='normative'>
               <title>Change Clause</title>
               <amend id='B' change='modify' path='//table[2]' path_end='//table[2]/following-sibling:example[1]' title='Change'>
                 <autonumber type='table'>2</autonumber>
                 <autonumber type='example'>A.7</autonumber>
                 <description>
                   <p id='C'>
                     <em>
                       This table contains information on polygon cells which are not
                       included in ISO 10303-52. Remove table 2 completely and replace
                       with:
                     </em>
                   </p>
                 </description>
                                  <newcontent id='D'>
                   <table id='E'>
                     <name>Edges of triangle and quadrilateral cells</name>
                     <tbody>
                       <tr>
                         <th colspan='2' valign='middle' align='center'>triangle</th>
                         <th colspan='2' valign='middle' align='center'>quadrilateral</th>
                       </tr>
                       <tr>
                         <td valign='middle' align='center'>edge</td>
                         <td valign='middle' align='center'>vertices</td>
                         <td valign='middle' align='center'>edge</td>
                         <td valign='middle' align='center'>vertices</td>
                       </tr>
                       <tr>
                         <td valign='middle' align='center'>1</td>
                         <td valign='middle' align='center'>1, 2</td>
                         <td valign='middle' align='center'>1</td>
                         <td valign='middle' align='center'>1, 2</td>
                       </tr>
                       <tr>
                         <td valign='middle' align='center'>2</td>
                         <td valign='middle' align='center'>2, 3</td>
                         <td valign='middle' align='center'>2</td>
                         <td valign='middle' align='center'>2, 3</td>
                       </tr>
                       <tr>
                         <td valign='middle' align='center'>3</td>
                         <td valign='middle' align='center'>3, 1</td>
                         <td valign='middle' align='center'>3</td>
                         <td valign='middle' align='center'>3, 4</td>
                       </tr>
                       <tr>
                         <td valign='top' align='left'/>
                         <td valign='top' align='left'/>
                         <td valign='middle' align='center'>4</td>
                         <td valign='middle' align='center'>4, 1</td>
                       </tr>
                     </tbody>
                   </table>
                   <figure id="H"><name>Figure</name></figure>
                   <example id='F'>
                     <p id='G'>This is not generalised further.</p>
                   </example>
                 </newcontent>
               </amend>
             </clause>
           </sections>
         </standard-document>
    INPUT
    presxml = <<~OUTPUT
          <clause id='A' inline-header='false' obligation='normative' displayorder='3'>
        <title depth='1'>
          1.
          <tab/>
          Change Clause
        </title>
        <p id='C'>
          <strong>
            <em>
               This table contains information on polygon cells which are not included
              in ISO 10303-52. Remove table 2 completely and replace with:
            </em>
          </strong>
        </p>
        <quote id='D'>
          <table id='E' number='2'>
            <name>Table 2&#x2014;Edges of triangle and quadrilateral cells</name>
            <tbody>
              <tr>
                <th colspan='2' valign='middle' align='center'>triangle</th>
                <th colspan='2' valign='middle' align='center'>quadrilateral</th>
              </tr>
              <tr>
                <td valign='middle' align='center'>edge</td>
                <td valign='middle' align='center'>vertices</td>
                <td valign='middle' align='center'>edge</td>
                <td valign='middle' align='center'>vertices</td>
              </tr>
              <tr>
                <td valign='middle' align='center'>1</td>
                <td valign='middle' align='center'>1, 2</td>
                <td valign='middle' align='center'>1</td>
                <td valign='middle' align='center'>1, 2</td>
              </tr>
              <tr>
                <td valign='middle' align='center'>2</td>
                <td valign='middle' align='center'>2, 3</td>
                <td valign='middle' align='center'>2</td>
                <td valign='middle' align='center'>2, 3</td>
              </tr>
              <tr>
                <td valign='middle' align='center'>3</td>
                <td valign='middle' align='center'>3, 1</td>
                <td valign='middle' align='center'>3</td>
                <td valign='middle' align='center'>3, 4</td>
              </tr>
              <tr>
                <td valign='top' align='left'/>
                <td valign='top' align='left'/>
                <td valign='middle' align='center'>4</td>
                <td valign='middle' align='center'>4, 1</td>
              </tr>
            </tbody>
          </table>
          <figure id='H' unnumbered='true'>
            <name>Figure</name>
          </figure>
          <example id='F' number='A.7'>
            <name>Example A.7</name>
            <p id='G'>This is not generalised further.</p>
          </example>
        </quote>
      </clause>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri::XML(
      IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true),
    ).at("//xmlns:clause[@id = 'A']").to_xml))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end
end
