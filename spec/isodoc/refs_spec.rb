require "spec_helper"

RSpec.describe IsoDoc do
  it "processes biblio citations" do
    VCR.use_cassette "isodoc" do
      input = <<~INPUT
                  <iso-standard xmlns="http://riboseinc.com/isoxml">
                  <sections>
                  <clause id='A' inline-header='false' obligation='normative'>
                  <title>Clause</title>
                  <p id='_'>
                    <eref type='inline' bibitemid='ref1' citeas='ISO 639:1967'/>
                    <eref type='inline' bibitemid='ref7' citeas='ISO 639-2:1998'/>
                    <eref type='inline' bibitemid='ref2' citeas='Aluffi'/>
                    <eref type='inline' bibitemid='ref3' citeas='REF4'/>
                    <eref type='inline' bibitemid='ref4' citeas='ISO 639:1967'/>
                    <eref type='inline' bibitemid='ref5' citeas='[B2]'/>
                    <eref type='inline' bibitemid='ref6' citeas='[B1]'/>
                  </p>
                </clause>
              </sections>
              <bibliography>
                   <references id='_' normative='true' obligation='informative'>
                     <title>Normative References</title>
                     <bibitem id="IETF_6281" type="standard" schema-version="v1.2.1">  <fetched>2022-12-23</fetched>
        <title type="title-main" format="text/plain" language="en" script="Latn">Code for the representation of names of languages</title>

        <title type="main" format="text/plain" language="en" script="Latn">Code for the representation of names of languages</title>
          <uri type="src">https://www.iso.org/standard/4766.html</uri>  <uri type="rss">https://www.iso.org/contents/data/standard/00/47/4766.detail.rss</uri>  <docidentifier type="ISO" primary="true">ISO 639</docidentifier>  <docidentifier type="URN">urn:iso:std:iso:639:ed-1</docidentifier>  <docnumber>639</docnumber>  <contributor>    <role type="publisher"/>    <organization>
        <name>International Organization for Standardization</name>
              <abbreviation>ISO</abbreviation>      <uri>www.iso.org</uri>    </organization>  </contributor>  <edition>1</edition>  <language>en</language>  <script>Latn</script>  <status>    <stage>95</stage>    <substage>99</substage>  </status>  <copyright>    <from>1988</from>    <owner>      <organization>
        <name>ISO</name>
              </organization>    </owner>  </copyright>  <relation type="updates">    <bibitem type="standard">      <formattedref format="text/plain">ISO 639-1:2002</formattedref>      <docidentifier type="ISO" primary="true">ISO 639-1:2002</docidentifier>      <date type="circulated">        <on>2002-07-18</on>      </date>    </bibitem>
          </relation>  <relation type="instance">    <bibitem type="standard">      <fetched>2022-12-23</fetched>
        <title type="title-main" format="text/plain" language="en" script="Latn">Code for the representation of names of languages</title>

        <title type="main" format="text/plain" language="en" script="Latn">Code for the representation of names of languages</title>
              <uri type="src">https://www.iso.org/standard/4766.html</uri>      <uri type="rss">https://www.iso.org/contents/data/standard/00/47/4766.detail.rss</uri>      <docidentifier type="ISO" primary="true">ISO 639:1988</docidentifier>      <docidentifier type="URN">urn:iso:std:iso:639:ed-1</docidentifier>      <docnumber>639</docnumber>      <date type="published">        <on>1988-03</on>      </date>      <contributor>        <role type="publisher"/>        <organization>
        <name>International Organization for Standardization</name>
                  <abbreviation>ISO</abbreviation>          <uri>www.iso.org</uri>        </organization>      </contributor>      <edition>1</edition>      <language>en</language>      <script>Latn</script>      <abstract format="text/plain" language="en" script="Latn">Gives a two-letter lower-case code. The symbols were devised primarily for use in terminology, lexicography and linguistic, but they may be used for any application. It also includes guidance on the use of language symbols in some of these applications. The annex includes a classified list of languages and their symbols arranged by families.</abstract>      <status>        <stage>95</stage>        <substage>99</substage>      </status>      <copyright>        <from>1988</from>        <owner>          <organization>
        <name>ISO</name>
                  </organization>        </owner>      </copyright>      <relation type="updates">        <bibitem type="standard">          <formattedref format="text/plain">ISO 639-1:2002</formattedref>          <docidentifier type="ISO" primary="true">ISO 639-1:2002</docidentifier>          <date type="circulated">            <on>2002-07-18</on>          </date>        </bibitem>
              </relation>      <place>Geneva</place>    </bibitem>
          </relation>  <place>Geneva</place></bibitem>
          <bibitem id="ref7">
            <title type="title-main" format="text/plain" language="en" script="Latn">Codes for the representation of names of languages</title>
            <title type="title-part" format="text/plain" language="en" script="Latn">Part 2: Alpha-3 code</title>
            <title type="main" format="text/plain" language="en" script="Latn">Codes for the representation of names of languages - Part 2: Alpha-3 code</title>
            <title type="title-main" format="text/plain" language="fr" script="Latn">Codes pour la représentation des noms de langue</title>
            <title type="title-part" format="text/plain" language="fr" script="Latn">Partie 2: Code alpha-3</title>
            <title type="main" format="text/plain" language="fr" script="Latn">Codes pour la représentation des noms de langue - Partie 2: Code alpha-3</title>
            <uri type="src">https://www.iso.org/standard/4767.html</uri>
            <uri type="rss">https://www.iso.org/contents/data/standard/00/47/4767.detail.rss</uri>
            <docidentifier type="ISO" primary="true">ISO 639-2</docidentifier>
            <docidentifier type="iso-reference">ISO 639-2(E)</docidentifier>
            <docidentifier type="URN">urn:iso:std:iso:639:-2:stage-95.99:ed-1</docidentifier>
            <docnumber>639</docnumber>
            <contributor>
              <role type="publisher"/>
              <organization>
                <name>International Organization for Standardization</name>
                <abbreviation>ISO</abbreviation>
                <uri>www.iso.org</uri>
              </organization>
            </contributor>
            <edition>1</edition>
            <language>en</language>
            <language>fr</language>
            <script>Latn</script>
            <status>
              <stage>95</stage>
              <substage>99</substage>
            </status>
            <copyright>
              <from>1998</from>
              <owner>
                <organization>
                  <name>ISO</name>
                </organization>
              </owner>
            </copyright>
          </bibitem>
                     <bibitem id='ref3'>
                       <formattedref format='application/x-isodoc+xml'>REF4</formattedref>
                       <docidentifier>REF4</docidentifier>
                       <docidentifier type='metanorma-ordinal'>[B1]</docidentifier>
                       <docnumber>4</docnumber>
                     </bibitem>
                     <bibitem type="book" id="ref2">
                <title>Facets of Algebraic Geometry: A Collection in Honor of William Fulton's 80th Birthday</title>
                <docidentifier type="DOI">https://doi.org/10.1017/9781108877831</docidentifier>
                <docidentifier type="ISBN">9781108877831</docidentifier>
                <date type="published"><on>2022</on></date>
                <contributor>
                  <role type="editor"/>
                  <person>
                    <name><surname>Aluffi</surname><forename>Paolo</forename></name>
                  </person>
                </contributor>
                        <contributor>
                  <role type="editor"/>
                  <person>
                    <name><surname>Anderson</surname><forename>David</forename></name>
                  </person>
                </contributor>
                <contributor>
                  <role type="editor"/>
                  <person>
                    <name><surname>Hering</surname><forename>Milena</forename></name>
                  </person>
                </contributor>
                <contributor>
                  <role type="editor"/>
                  <person>
                    <name><surname>Mustaţă</surname><forename>Mircea</forename></name>
                  </person>
                </contributor>
                <contributor>
                  <role type="editor"/>
                  <person>
                    <name><surname>Payne</surname><forename>Sam</forename></name>
                  </person>
                </contributor>
               <note type="Availability">
                 <p id="_">IEEE 194-1977 has been withdrawn; however, copies can be obtained from Global Engineering, 15 Inverness Way East, Englewood, CO 80112-5704, USA, tel. (303) 792-2181 (http://global.ihs.com/).
         </p>
               </note>
                <edition>1</edition>
                <series>
                <title>London Mathematical Society Lecture Note Series</title>
                <number>472</number>
                </series>
                    <contributor>
                      <role type="publisher"/>
                      <organization>
                        <name>Cambridge University Press</name>
                      </organization>
                    </contributor>
                    <place>Cambridge, UK</place>
                  <size><value type="volume">1</value></size>
              </bibitem>
                     <bibitem type='standard' id='ref1'>
                       <fetched>2022-07-02</fetched>
                       <title type='main' format='text/plain'>Indiana Jones and the Last Crusade</title>
                       <title type='title-main' format='text/plain'>Indiana Jones and the Last Crusade</title>
                       <title type='main' format='text/plain'>Indiana Jones and the Last Crusade</title>
                       <docidentifier type="ISO">ISO 639:1967</docidentifier>
                       <docidentifier type='metanorma-ordinal'>[B3]</docidentifier>
                       <contributor>
                         <role type='publisher'/>
                         <organization>
                           <name>International Organization for Standardization</name>
                           <abbreviation>ISO</abbreviation>
                         </organization>
                       </contributor>
                       <contributor>
                         <role type='author'/>
                         <person>
                           <name>
                             <forename>Indiana</forename>
                             <surname>Jones</surname>
                           </name>
                         </person>
                       </contributor>
                     </bibitem>
                   </references>
                   <references id='_' normative='false' obligation='informative'>
                     <title>Bibliography</title>
                     <bibitem id='ref6'>
                       <formattedref format='application/x-isodoc+xml'>REF4</formattedref>
                       <docidentifier>REF4</docidentifier>
                       <docidentifier type='metanorma-ordinal'>[B1]</docidentifier>
                       <docnumber>4</docnumber>
                     </bibitem>
                           <bibitem type="book" id="ref5">
                <title>Facets of Algebraic Geometry: A Collection in Honor of William Fulton's 80th Birthday</title>
                <docidentifier type="DOI">https://doi.org/10.1017/9781108877831</docidentifier>
                <docidentifier type="ISBN">9781108877831</docidentifier>
                       <docidentifier type='metanorma-ordinal'>[B2]</docidentifier>
                <date type="published"><on>2022</on></date>
                <contributor>
                  <role type="editor"/>
                  <person>
                    <name><surname>Aluffi</surname><forename>Paolo</forename></name>
                  </person>
                </contributor>
                        <contributor>
                  <role type="editor"/>
                  <person>
                    <name><surname>Anderson</surname><forename>David</forename></name>
                  </person>
                </contributor>
                <contributor>
                  <role type="editor"/>
                  <person>
                    <name><surname>Hering</surname><forename>Milena</forename></name>
                  </person>
                </contributor>
                <contributor>
                  <role type="editor"/>
                  <person>
                    <name><surname>Mustaţă</surname><forename>Mircea</forename></name>
                  </person>
                </contributor>
                <contributor>
                  <role type="editor"/>
                  <person>
                    <name><surname>Payne</surname><forename>Sam</forename></name>
                  </person>
                </contributor>
                <edition>1</edition>
                <series>
                <title>London Mathematical Society Lecture Note Series</title>
                <number>472</number>
                </series>
                    <contributor>
                      <role type="publisher"/>
                      <organization>
                        <name>Cambridge University Press</name>
                      </organization>
                    </contributor>
                    <place>Cambridge, UK</place>
                  <size><value type="volume">1</value></size>
              </bibitem>
                     <bibitem type='standard' id='ref4'>
                       <fetched>2022-07-02</fetched>
                       <title type='main' format='text/plain'>Indiana Jones and the Last Crusade</title>
                       <title type='title-main' format='text/plain'>Indiana Jones and the Last Crusade</title>
                       <title type='main' format='text/plain'>Indiana Jones and the Last Crusade</title>
                       <docidentifier type="ISO">ISO 639:1967</docidentifier>
                       <docidentifier type='metanorma-ordinal'>[B3]</docidentifier>
                       <contributor>
                         <role type='publisher'/>
                         <organization>
                           <name>International Organization for Standardization</name>
                           <abbreviation>ISO</abbreviation>
                         </organization>
                       </contributor>
                       <contributor>
                         <role type='author'/>
                         <person>
                           <name>
                             <forename>Indiana</forename>
                             <surname>Jones</surname>
                           </name>
                         </person>
                       </contributor>
                     </bibitem>
                   </references>
                 </bibliography>
               </ieee-standard>
              </iso-standard>
      INPUT

      presxml = <<~PRESXML
        <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
               <preface> <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause> </preface>
                        <sections>
             <p class="zzSTDTitle1" displayorder="3">??? for ???</p>
             <clause id="A" inline-header="false" obligation="normative" displayorder="4">
               <title depth="1">2.<tab/>Clause</title>
               <p id="_">
                 <xref type="inline" target="ref1"><span class="std_publisher">ISO </span><span class="std_docNumber">639</span>:<span class="std_year">1967</span></xref>
                 <xref type="inline" target="ref7"><span class="std_publisher">ISO </span><span class="std_docNumber">639-2</span>:<span class="std_year">1998</span></xref>
                 <xref type="inline" target="ref2">Aluffi</xref>
                 <xref type="inline" target="ref3">REF4</xref>
                 <xref type="inline" target="ref4">ISO 639:1967 [B3]</xref>
                 <xref type="inline" target="ref5">Aluffi, Anderson, Hering, Mustaţă and Payne [B2]</xref>
                 <xref type="inline" target="ref6">REF4 [B1]</xref>
               </p>
             </clause>
             <references id="_" normative="true" obligation="informative" displayorder="2">
               <title depth="1">Normative References</title>
               <bibitem id="IETF_6281" type="standard">
                 <formattedref>Code for the representation of names of languages.</formattedref>
                 <title type="title-main" format="text/plain" language="en" script="Latn">Code for the representation of names of languages</title>
                 <title type="main" format="text/plain" language="en" script="Latn">Code for the representation of names of languages</title>
                 <uri type="src">https://www.iso.org/standard/4766.html</uri>
                 <uri type="rss">https://www.iso.org/contents/data/standard/00/47/4766.detail.rss</uri>
                 <docidentifier type="ISO" primary="true">ISO 639</docidentifier>
                 <docidentifier type="URN">URN urn:iso:std:iso:639:ed-1</docidentifier>
                 <docidentifier scope="biblio-tag">ISO 639</docidentifier>
                 <biblio-tag>ISO 639, </biblio-tag>
               </bibitem>
               <bibitem id="ref7">
                 <formattedref>Codes for the representation of names of languages - Part 2: Alpha-3 code.</formattedref>
                 <title type="title-main" format="text/plain" language="en" script="Latn">Codes for the representation of names of languages</title>
                 <title type="title-part" format="text/plain" language="en" script="Latn">Part 2: Alpha-3 code</title>
                 <title type="main" format="text/plain" language="en" script="Latn">Codes for the representation of names of languages - Part 2: Alpha-3 code</title>
                 <title type="title-main" format="text/plain" language="fr" script="Latn">Codes pour la représentation des noms de langue</title>
                 <title type="title-part" format="text/plain" language="fr" script="Latn">Partie 2: Code alpha-3</title>
                 <title type="main" format="text/plain" language="fr" script="Latn">Codes pour la représentation des noms de langue - Partie 2: Code alpha-3</title>
                 <uri type="src">https://www.iso.org/standard/4767.html</uri>
                 <uri type="rss">https://www.iso.org/contents/data/standard/00/47/4767.detail.rss</uri>
                 <docidentifier type="ISO" primary="true">ISO 639-2</docidentifier>
                 <docidentifier type="iso-reference">iso-reference ISO 639-2(E)</docidentifier>
                 <docidentifier type="URN">URN urn:iso:std:iso:639:-2:stage-95.99:ed-1</docidentifier>
                 <docidentifier scope="biblio-tag">ISO 639-2</docidentifier>
                 <biblio-tag>ISO 639-2, </biblio-tag>
               </bibitem>
               <bibitem id="ref3">
                 <formattedref format="application/x-isodoc+xml">REF4</formattedref>
                 <docidentifier>REF4</docidentifier>
                 <docidentifier type="metanorma-ordinal">[B1]</docidentifier>
                 <docidentifier scope="biblio-tag">REF4</docidentifier>
                 <docnumber>4</docnumber>
                 <biblio-tag>[B1], REF4, </biblio-tag>
               </bibitem>
               <bibitem type="book" id="ref2">
                 <formattedref>Aluffi, P., D. Anderson, M. Hering, M. Mustaţă, and S. Payne, <em>Facets of Algebraic Geometry: A Collection in Honor of William Fulton's 80th Birthday</em>, first edition, Cambridge, UK: Cambridge University Press, 2022a, DOI: https://doi.org/10.1017/9781108877831.<fn reference="_"><p>
                  IEEE 194-1977 has been withdrawn; however, copies can be obtained from Global Engineering, 15 Inverness Way East, Englewood, CO 80112-5704, USA, tel. (303) 792-2181 (http://global.ihs.com/).

                </p></fn></formattedref>
                 <title>Facets of Algebraic Geometry: A Collection in Honor of William Fulton's 80th Birthday</title>
                 <docidentifier type="DOI">https://doi.org/10.1017/9781108877831</docidentifier>
                 <docidentifier type="ISBN">ISBN 9781108877831</docidentifier>
                 <note type="Availability">
                   <p id="_">IEEE 194-1977 has been withdrawn; however, copies can be obtained from Global Engineering, 15 Inverness Way East, Englewood, CO 80112-5704, USA, tel. (303) 792-2181 (http://global.ihs.com/).
          </p>
                 </note>
                 <biblio-tag/>
               </bibitem>
               <bibitem type="standard" id="ref1">
                 <formattedref>Indiana Jones and the Last Crusade.</formattedref>
                 <title type="main" format="text/plain">Indiana Jones and the Last Crusade</title>
                 <title type="title-main" format="text/plain">Indiana Jones and the Last Crusade</title>
                 <title type="main" format="text/plain">Indiana Jones and the Last Crusade</title>
                 <docidentifier type="ISO">ISO 639:1967</docidentifier>
                 <docidentifier type="metanorma-ordinal">[B3]</docidentifier>
                 <docidentifier scope="biblio-tag">ISO 639:1967</docidentifier>
                 <biblio-tag>[B3], ISO 639:1967, </biblio-tag>
               </bibitem>
             </references>
           </sections>
           <bibliography>
             <references id="_" normative="false" obligation="informative" displayorder="5">
               <title depth="1">Bibliography</title>
               <bibitem id="ref6">
                 <formattedref format="application/x-isodoc+xml">REF4</formattedref>
                 <docidentifier type="metanorma-ordinal">[B1]</docidentifier>
                 <docidentifier>REF4</docidentifier>
                 <docidentifier scope="biblio-tag">REF4</docidentifier>
                 <docnumber>4</docnumber>
                 <biblio-tag>[B1]<tab/>REF4, </biblio-tag>
               </bibitem>
               <bibitem type="book" id="ref5">
                 <formattedref>Aluffi, P., D. Anderson, M. Hering, M. Mustaţă, and S. Payne, <em>Facets of Algebraic Geometry: A Collection in Honor of William Fulton's 80th Birthday</em>, first edition, Cambridge, UK: Cambridge University Press, 2022b, DOI: https://doi.org/10.1017/9781108877831.</formattedref>
                 <title>Facets of Algebraic Geometry: A Collection in Honor of William Fulton's 80th Birthday</title>
                 <docidentifier type="metanorma-ordinal">[B2]</docidentifier>
                 <docidentifier type="DOI">https://doi.org/10.1017/9781108877831</docidentifier>
                 <docidentifier type="ISBN">ISBN 9781108877831</docidentifier>
                 <biblio-tag>[B2]<tab/></biblio-tag>
               </bibitem>
               <bibitem type="standard" id="ref4">
                 <formattedref>Indiana Jones and the Last Crusade.</formattedref>
                 <title type="main" format="text/plain">Indiana Jones and the Last Crusade</title>
                 <title type="title-main" format="text/plain">Indiana Jones and the Last Crusade</title>
                 <title type="main" format="text/plain">Indiana Jones and the Last Crusade</title>
                 <docidentifier type="metanorma-ordinal">[B3]</docidentifier>
                 <docidentifier type="ISO">ISO 639:1967</docidentifier>
                 <docidentifier scope="biblio-tag">ISO 639:1967</docidentifier>
                 <biblio-tag>[B3]<tab/>ISO 639:1967, </biblio-tag>
               </bibitem>
             </references>
           </bibliography>
         </iso-standard>
      PRESXML
      out = Nokogiri::XML(
        IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
        .convert("test", input, true),
      )
      expect(xmlpp(strip_guid(out.to_xml)))
        .to be_equivalent_to xmlpp(presxml)
    end
  end

  it "re-sorts biblio citations" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <sections/>
      <bibliography>
       <references id='_' normative='false' obligation='informative'>
         <title>Normative References</title>
         <bibitem id="IETF_6281" type="standard" schema-version="v1.2.1">
         <title>Title 1</title>
         <docidentifier>ABC</docidentifier>
         </bibitem>
         <bibitem id="IETF_6282" type="standard" schema-version="v1.2.1">
         <title>Title 1</title>
         <docidentifier>DEF</docidentifier>
         <docidentifier type="metanorma-ordinal">[B1]</docidentifier>
         </bibitem>
         <bibitem id="IETF_6283" type="standard" schema-version="v1.2.1">
         <title>Title 2</title>
         <docidentifier>GHI</docidentifier>
         <docidentifier type="metanorma">[1]</docidentifier>
         </bibitem>
         </references>
         </bibliography>
         </iso-standard>
    INPUT
    presxml = <<~PRESXML
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
        <preface>
          <clause type="toc" id="_" displayorder="1">
            <title depth="1">Contents</title>
          </clause>
        </preface>
        <sections/>
        <bibliography>
          <references id="_" normative="false" obligation="informative" displayorder="2">
            <title depth="1">Normative References</title>
            <bibitem id="IETF_6281" type="standard">
              <formattedref>“Title 1,”.</formattedref>
              <title>Title 1</title>
              <docidentifier type="metanorma-ordinal">[B1]</docidentifier>
              <docidentifier>ABC</docidentifier>
              <docidentifier scope="biblio-tag">ABC</docidentifier>
              <biblio-tag>[B1]<tab/>ABC, </biblio-tag>
            </bibitem>
            <bibitem id="IETF_6282" type="standard">
              <formattedref>“Title 1,”.</formattedref>
              <title>Title 1</title>
              <docidentifier type="metanorma-ordinal">[B2]</docidentifier>
              <docidentifier>DEF</docidentifier>
              <docidentifier scope="biblio-tag">DEF</docidentifier>
              <biblio-tag>[B2]<tab/>DEF, </biblio-tag>
            </bibitem>
            <bibitem id="IETF_6283" type="standard">
              <formattedref>“Title 2,”.</formattedref>
              <title>Title 2</title>
              <docidentifier type="metanorma-ordinal">[B3]</docidentifier>
              <docidentifier>GHI</docidentifier>
              <docidentifier scope="biblio-tag">GHI</docidentifier>
              <biblio-tag>[B3]<tab/>GHI, </biblio-tag>
            </bibitem>
          </references>
        </bibliography>
      </iso-standard>
    PRESXML
    out = Nokogiri::XML(
      IsoDoc::IEEE::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true),
    )
    expect(xmlpp(strip_guid(out.to_xml)))
      .to be_equivalent_to xmlpp(presxml)
  end
end
