require "spec_helper"

RSpec.describe IsoDoc do
  it "processes tables" do
    input = <<~"INPUT"
      <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword>
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
            <th align="left">Number of laboratories retained after eliminating outliers</td>
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

    presxml = <<~"PRESXML"
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
         <preface>
           <foreword displayorder='1'>
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
                       <p id='_0fe65e9a-5531-408e-8295-eeff35f41a55'>Parboiled rice.</p>
                     </fn>
                   </td>
                   <td align='center'>
                     Balilla
                     <fn reference='a'>
                       <p id='_0fe65e9a-5531-408e-8295-eeff35f41a55'>Parboiled rice.</p>
                     </fn>
                   </td>
                   <td align='center'>Thaibonnet</td>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <th align='left'>Number of laboratories retained after eliminating outliers</th>
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
           <div>
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
                         <p id='_0fe65e9a-5531-408e-8295-eeff35f41a55'>Parboiled rice.</p>
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
                   <th style='font-weight:bold;text-align:left;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;' scope='row'>Number of laboratories retained after eliminating outliers</th>
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
               <dl>
                 <dt>
                   <p>Drago</p>
                 </dt>
                 <dd>A type of rice</dd>
               </dl>
               <div class='Note'>
                 <p>
                   <span class='note_label'>NOTE</span>
                   &#xa0; This is a table about rice
                 </p>
               </div>
             </table>
           </div>
           <p class='zzSTDTitle1'/>
         </div>
       </body>
    OUTPUT

    word = <<~"WORD"
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
          <div>
            <h1 class='ForewordTitle'>Foreword</h1>
            <p class='TableTitle' style='text-align:center;'>Table 1&#x2014;Hello</p>
            <div align='center' class='table_container'>
              <table id='tableD-1' class='MsoISOTable' style='mso-table-anchor-horizontal:column;mso-table-overlap:never;border-spacing:0;border-width:1px;' title='tool tip' summary='long desc'>
                <thead>
                  <tr>
                    <td rowspan='2' align='left' style='border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;'>Description</td>
                    <td colspan='4' align='center' style='border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;'>Rice sample</td>
                  </tr>
                  <tr>
                    <td align='left' style='border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;'>Arborio</td>
                    <td align='center' style='border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;'>
                       Drago
                      <a href='#tableD-1a' class='TableFootnoteRef'>a</a>
                      <aside>
                        <div id='ftntableD-1a'>
                          <span>
                            <span id='tableD-1a' class='TableFootnoteRef'>a</span>
                            <span style='mso-tab-count:1'>&#xa0; </span>
                          </span>
                          <p id='_0fe65e9a-5531-408e-8295-eeff35f41a55'>Parboiled rice.</p>
                        </div>
                      </aside>
                    </td>
                    <td align='center' style='border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;'>
                       Balilla
                      <a href='#tableD-1a' class='TableFootnoteRef'>a</a>
                    </td>
                    <td align='center' style='border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;'>Thaibonnet</td>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <th align='left' style='font-weight:bold;border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;'>Number of laboratories retained after eliminating outliers</th>
                    <td align='center' style='border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;'>13</td>
                    <td align='center' style='border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;'>11</td>
                    <td align='center' style='border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;'>13</td>
                    <td align='center' style='border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;'>13</td>
                  </tr>
                  <tr>
                    <td align='left' style='border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;'>Mean value, g/100 g</td>
                    <td align='center' style='border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;'>81,2</td>
                    <td align='center' style='border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;'>82,0</td>
                    <td align='center' style='border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;'>81,8</td>
                    <td align='center' style='border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;'>77,7</td>
                  </tr>
                </tbody>
                <tfoot>
                  <tr>
                    <td align='left' style='border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;'>
                       Reproducibility limit,
                      <span class='stem'>(#(R)#)</span>
                       (= 2,83
                      <span class='stem'>(#(s_R)#)</span>
                       )
                    </td>
                    <td align='center' style='border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;'>2,89</td>
                    <td align='center' style='border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;'>0,57</td>
                    <td align='center' style='border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;'>2,26</td>
                    <td align='center' style='border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;'>6,06</td>
                  </tr>
                </tfoot>
                <dl>
                  <dt>
                    <p align='left' style='margin-left:0pt;text-align:left;'>Drago</p>
                  </dt>
                  <dd>A type of rice</dd>
                </dl>
                <div class='Note'>
                  <p class='Note'>
                    <span class='note_label'>NOTE</span>
                    <span style='mso-tab-count:1'>&#xa0; </span>
                    This is a table about rice
                  </p>
                </div>
              </table>
            </div>
          </div>
          <p>&#xa0;</p>
        </div>
        <p>
          <br clear='all' class='section'/>
        </p>
                <div class='WordSection13'>
          <p class='IEEEStdsTitle' style='margin-top:70.0pt'>??? for ???</p>
        </div>
        <p>
          <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
        </p>
        <div class='WordSection14'/>
      </body>
    WORD
    expect(xmlpp(IsoDoc::IEEE::PresentationXMLConvert.new({})
      .convert("test", input, true))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(Nokogiri::XML(IsoDoc::IEEE::HtmlConvert.new({})
      .convert("test", presxml, true))
      .at("//body").to_xml)).to be_equivalent_to xmlpp(html)
    expect(xmlpp(Nokogiri::XML(IsoDoc::IEEE::WordConvert.new({})
      .convert("test", presxml, true))
                .at("//body").to_xml)).to be_equivalent_to xmlpp(word)
    expect(xmlpp(Nokogiri::XML(IsoDoc::IEEE::PresentationXMLConvert
      .new({ hierarchical_assets: true })
      .convert("test", input, true))
      .at("//xmlns:table/xmlns:name").to_xml))
      .to be_equivalent_to "<name>Table Preface.1&#x2014;Hello</name>"
  end

  it "processes figures" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword>
          <figure id="figureA-1" keep-with-next="true" keep-lines-together="true">
        <name>Split-it-right <em>sample</em> divider<fn reference="1"><p>X</p></fn></name>
        <image src="rice_images/rice_image1.png" height="20" width="30" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png" alt="alttext" title="titletxt"/>
        <image src="rice_images/rice_image1.png" height="20" width="auto" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f1" mimetype="image/png"/>
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
          <preface><foreword displayorder="1">
          <figure id="figureA-1" keep-with-next="true" keep-lines-together="true">
        <name>Figure 1&#x2014;Split-it-right <em>sample</em> divider<fn reference="1"><p>X</p></fn></name>
        <image src="rice_images/rice_image1.png" height="20" width="30" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png" alt="alttext" title="titletxt"/>
        <image src="rice_images/rice_image1.png" height="20" width="auto" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f1" mimetype="image/png"/>
        <image src="data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7" height="20" width="auto" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f2" mimetype="image/png"/>
        <image src='data:application/xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+Cjw/eG1sLXN0eWxlc2hlZXQgdHlwZT0idGV4dC94c2wiIGhyZWY9Ii4uLy4uLy4uL3hzbC9yZXNfZG9jL2ltZ2ZpbGUueHNsIj8+CjwhRE9DVFlQRSBpbWdmaWxlLmNvbnRlbnQgU1lTVEVNICIuLi8uLi8uLi9kdGQvdGV4dC5lbnQiPgo8aW1nZmlsZS5jb250ZW50IG1vZHVsZT0iZnVuZGFtZW50YWxzX29mX3Byb2R1Y3RfZGVzY3JpcHRpb25fYW5kX3N1cHBvcnQiIGZpbGU9ImFjdGlvbl9zY2hlbWFleHBnMS54bWwiPgo8aW1nIHNyYz0iYWN0aW9uX3NjaGVtYWV4cGcxLmdpZiI+CjxpbWcuYXJlYSBzaGFwZT0icmVjdCIgY29vcmRzPSIyMTAsMTg2LDM0MywyMjciIGhyZWY9Ii4uLy4uL3Jlc291cmNlcy9iYXNpY19hdHRyaWJ1dGVfc2NoZW1hL2Jhc2ljX2F0dHJpYnV0ZV9zY2hlbWEueG1sIiAvPgo8aW1nLmFyZWEgc2hhcGU9InJlY3QiIGNvb3Jkcz0iMTAsMTAsOTYsNTEiIGhyZWY9Ii4uLy4uL3Jlc291cmNlcy9hY3Rpb25fc2NoZW1hL2FjdGlvbl9zY2hlbWEueG1sIiAvPgo8aW1nLmFyZWEgc2hhcGU9InJlY3QiIGNvb3Jkcz0iMjEwLDI2NCwzNTgsMzA1IiBocmVmPSIuLi8uLi9yZXNvdXJjZXMvc3VwcG9ydF9yZXNvdXJjZV9zY2hlbWEvc3VwcG9ydF9yZXNvdXJjZV9zY2hlbWEueG1sIiAvPgo8L2ltZz4KPC9pbWdmaWxlLmNvbnRlbnQ+Cg==' height='20' width='auto' id='_8357ede4-6d44-4672-bac4-9a85e82ab7f2' mimetype='application/xml'/>
        <fn reference="a">
        <p id="_ef2c85b8-5a5a-4ecd-a1e6-92acefaaa852">The time <stem type="AsciiMath">t_90</stem> was estimated to be 18,2 min for this example.</p>
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
                               <div>
                                 <h1 class="ForewordTitle">Foreword</h1>
                                 <div id="figureA-1" class="figure" style='page-break-after: avoid;page-break-inside: avoid;'>
                         <img src="rice_images/rice_image1.png" height="20" width="30" alt="alttext" title="titletxt"/>
                         <img src="rice_images/rice_image1.png" height="20" width="auto"/>
                         <img src="data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7" height="20" width="auto"/>
                         <img src='data:application/xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+Cjw/eG1sLXN0eWxlc2hlZXQgdHlwZT0idGV4dC94c2wiIGhyZWY9Ii4uLy4uLy4uL3hzbC9yZXNfZG9jL2ltZ2ZpbGUueHNsIj8+CjwhRE9DVFlQRSBpbWdmaWxlLmNvbnRlbnQgU1lTVEVNICIuLi8uLi8uLi9kdGQvdGV4dC5lbnQiPgo8aW1nZmlsZS5jb250ZW50IG1vZHVsZT0iZnVuZGFtZW50YWxzX29mX3Byb2R1Y3RfZGVzY3JpcHRpb25fYW5kX3N1cHBvcnQiIGZpbGU9ImFjdGlvbl9zY2hlbWFleHBnMS54bWwiPgo8aW1nIHNyYz0iYWN0aW9uX3NjaGVtYWV4cGcxLmdpZiI+CjxpbWcuYXJlYSBzaGFwZT0icmVjdCIgY29vcmRzPSIyMTAsMTg2LDM0MywyMjciIGhyZWY9Ii4uLy4uL3Jlc291cmNlcy9iYXNpY19hdHRyaWJ1dGVfc2NoZW1hL2Jhc2ljX2F0dHJpYnV0ZV9zY2hlbWEueG1sIiAvPgo8aW1nLmFyZWEgc2hhcGU9InJlY3QiIGNvb3Jkcz0iMTAsMTAsOTYsNTEiIGhyZWY9Ii4uLy4uL3Jlc291cmNlcy9hY3Rpb25fc2NoZW1hL2FjdGlvbl9zY2hlbWEueG1sIiAvPgo8aW1nLmFyZWEgc2hhcGU9InJlY3QiIGNvb3Jkcz0iMjEwLDI2NCwzNTgsMzA1IiBocmVmPSIuLi8uLi9yZXNvdXJjZXMvc3VwcG9ydF9yZXNvdXJjZV9zY2hlbWEvc3VwcG9ydF9yZXNvdXJjZV9zY2hlbWEueG1sIiAvPgo8L2ltZz4KPC9pbWdmaWxlLmNvbnRlbnQ+Cg==' height='20' width='auto'/>
                         <a href="#_" class="TableFootnoteRef">a</a><aside class="footnote"><div id="fn:_"><span><span id="_" class="TableFootnoteRef">a</span>&#160; </span>
                         <p id="_">The time <span class="stem">(#(t_90)#)</span> was estimated to be 18,2 min for this example.</p>
                       </div></aside>
                         <p  style='page-break-after:avoid;'><b>Key</b></p><dl><dt><p>A</p></dt><dd><p>B</p></dd></dl>
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
                               <p class="zzSTDTitle1"/>
                               <aside id='fn:1' class='footnote'>
                  <p>X</p>
                </aside>
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
          <div>
            <h1 class='ForewordTitle'>Foreword</h1>
            <div id='figureA-1' class='figure' style='page-break-after: avoid;page-break-inside: avoid;'>
              <img src='rice_images/rice_image1.png' height='20' alt='alttext' title='titletxt' width='30'/>
              <img src='rice_images/rice_image1.png' height='20' width='auto'/>
              <img src='_.gif' height='20' width='auto'/>
              <img src='_.xml' height='20' width='auto'/>
              <a href='#_' class='TableFootnoteRef'>a</a>
              <aside>
                <div id='ftn_'>
                  <span>
                    <span id='_' class='TableFootnoteRef'>a</span>
                    <span style='mso-tab-count:1'>&#xa0; </span>
                  </span>
                  <p id='_'>
                    The time#{' '}
                    <span class='stem'>(#(t_90)#)</span>
                     was estimated to be 18,2 min for this example.
                  </p>
                </div>
              </aside>
              <p style='page-break-after:avoid;'>
                <b>Key</b>
              </p>
              <table class='dl'>
                <tr>
                  <td valign='top' align='left'>
                    <p align='left' style='margin-left:0pt;text-align:left;'>A</p>
                  </td>
                  <td valign='top'>
                    <p>B</p>
                  </td>
                </tr>
              </table>
              <p class='FigureTitle' style='text-align:center;'>
                Figure 1&#x2014;Split-it-right#{' '}
                <i>sample</i>
                 divider
                <span style='mso-bookmark:_Ref'>
                  <a class='FootnoteRef' href='#ftn1' type='footnote'>
                    <sup>1</sup>
                  </a>
                </span>
              </p>
            </div>
            <div id='figure-B' class='figure'>
              <pre>A &#x3c; B</pre>
              <p class='FigureTitle' style='text-align:center;'>Figure 2</p>
            </div>
            <div id='figure-C' class='figure'>
              <pre>A &#x3c; B</pre>
            </div>
          </div>
          <p>&#xa0;</p>
        </div>
        <p>
          <br clear='all' class='section'/>
        </p>
        <div class='WordSection13'>
          <p class='IEEEStdsTitle' style='margin-top:70.0pt'>??? for ???</p>
        </div>
        <p>
          <br clear='all' style='page-break-before:auto;mso-break-type:section-break'/>
        </p>
        <div class='WordSection14'>
          <aside id='ftn1'>
            <p>X</p>
          </aside>
        </div>
      </body>
    OUTPUT
    expect(xmlpp(IsoDoc::IEEE::PresentationXMLConvert.new({})
      .convert("test", input, true).gsub(/&lt;/, "&#x3c;")))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(strip_guid(Nokogiri::XML(IsoDoc::IEEE::HtmlConvert.new({})
      .convert("test", presxml, true))
      .at("//body").to_xml))).to be_equivalent_to xmlpp(html)
    FileUtils.rm_rf "spec/assets/odf1.emf"
    expect(xmlpp(strip_guid(Nokogiri::XML(IsoDoc::IEEE::WordConvert.new({})
      .convert("test", presxml, true)
      .gsub(/['"][^'".]+\.(gif|xml)['"]/, "'_.\\1'")
      .gsub(/epub:/, "")
      .gsub(/mso-bookmark:_Ref\d+/, "mso-bookmark:_Ref"))
                           .at("//body").to_xml)))
      .to be_equivalent_to xmlpp(word)
    expect(xmlpp(Nokogiri::XML(IsoDoc::IEEE::PresentationXMLConvert
     .new({ hierarchical_assets: true })
     .convert("test", input, true))
     .at("//xmlns:figure/xmlns:name").to_xml))
      .to be_equivalent_to <<~OUTPUT
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
end
