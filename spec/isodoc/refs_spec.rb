require "spec_helper"

RSpec.describe IsoDoc do
  it "processes biblio citations" do
      input = <<~INPUT
                  <iso-standard xmlns="http://riboseinc.com/isoxml">
                  <sections>
                  <clause id='A' inline-header='false' obligation='normative'>
                  <title>Clause</title>
                  <p id='_'>
                    <eref bibitemid="ISO16634"/>
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
            <bibitem id="ISO16634" type="standard">
              <title format="text/plain" language="x">Cereals, pulses, milled cereal products, xxxx, oilseeds and animal feeding stuffs</title>
              <title format="text/plain" language="en">Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</title>
              <docidentifier type="ISO">ISO 16634:-- (all parts)</docidentifier>
              <date type="published">
                <on>--</on>
              </date>
              <contributor>
                <role type="publisher"/>
                <organization>
                  <name>ISO</name>
                </organization>
              </contributor>
              <note format="text/plain" reference="1" type="Unpublished-Status">Under preparation. (Stage at the time of publication ISO/DIS 16634)</note>
              <extent type="part">
                <referenceFrom>all</referenceFrom>
              </extent>
            </bibitem>
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
            <docidentifier type="ISO" primary="true">ISO 639-2:1998</docidentifier>
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
                       <formattedref format='application/x-isodoc+xml'>Title</formattedref>
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
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title id="_" depth="1">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <p class="zzSTDTitle1" displayorder="3"/>
             <clause id="A" inline-header="false" obligation="normative" displayorder="4">
                <title id="_">Clause</title>
                <fmt-title id="_" depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">2</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Clause</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="A">2</semx>
                </fmt-xref-label>
                <p id="_">
                   <eref bibitemid="ISO16634" id="_"/>
                   <semx element="eref" source="_">
                      <fmt-xref target="ISO16634">ISO 16634:--</fmt-xref>
                   </semx>
                   <eref type="inline" bibitemid="ref1" citeas="ISO 639:1967" id="_"/>
                   <semx element="eref" source="_">
                      <fmt-xref type="inline" target="ref1">
                         <span class="std_publisher">ISO </span>
                         <span class="std_docNumber">639</span>
                         :
                         <span class="std_year">1967</span>
                      </fmt-xref>
                   </semx>
                   <eref type="inline" bibitemid="ref7" citeas="ISO 639-2:1998" id="_"/>
                   <semx element="eref" source="_">
                      <fmt-xref type="inline" target="ref7">
                         <span class="std_publisher">ISO </span>
                         <span class="std_docNumber">639-2</span>
                         :
                         <span class="std_year">1998</span>
                      </fmt-xref>
                   </semx>
                   <eref type="inline" bibitemid="ref2" citeas="Aluffi" id="_"/>
                   <semx element="eref" source="_">
                      <fmt-xref type="inline" target="ref2">Aluffi, Anderson, Hering, Mustaţă and Payne 2022a</fmt-xref>
                   </semx>
                   <eref type="inline" bibitemid="ref3" citeas="REF4" id="_"/>
                   <semx element="eref" source="_">
                      <fmt-xref type="inline" target="ref3">REF4</fmt-xref>
                   </semx>
                   <eref type="inline" bibitemid="ref4" citeas="ISO 639:1967" id="_"/>
                   <semx element="eref" source="_">
                      <fmt-xref type="inline" target="ref4">ISO 639:1967 [B3]</fmt-xref>
                   </semx>
                   <eref type="inline" bibitemid="ref5" citeas="[B2]" id="_"/>
                   <semx element="eref" source="_">
                      <fmt-xref type="inline" target="ref5">Aluffi, Anderson, Hering, Mustaţă and Payne [B2]</fmt-xref>
                   </semx>
                   <eref type="inline" bibitemid="ref6" citeas="[B1]" id="_"/>
                   <semx element="eref" source="_">
                      <fmt-xref type="inline" target="ref6">Title REF4</fmt-xref>
                   </semx>
                </p>
             </clause>
             <references id="_" normative="true" obligation="informative" displayorder="2">
                <title id="_">Normative References</title>
                <fmt-title id="_" depth="1">
                   <semx element="title" source="_">Normative References</semx>
                </fmt-title>
                <bibitem id="ISO16634" type="standard">
                   <formattedref>Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs.</formattedref>
                   <title format="text/plain" language="x">Cereals, pulses, milled cereal products, xxxx, oilseeds and animal feeding stuffs</title>
                   <title format="text/plain" language="en">Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</title>
                   <docidentifier type="ISO">ISO 16634:-- (all parts)</docidentifier>
                   <docidentifier scope="biblio-tag">ISO 16634:-- (all parts)</docidentifier>
                   <date type="published">
                      <on>--</on>
                   </date>
                   <contributor>
                      <role type="publisher"/>
                      <organization>
                         <name>ISO</name>
                      </organization>
                   </contributor>
                   <note format="text/plain" reference="1" type="Unpublished-Status">Under preparation. (Stage at the time of publication ISO/DIS 16634)</note>
                   <extent type="part">
                      <referenceFrom>all</referenceFrom>
                   </extent>
                   <biblio-tag>
                      ISO 16634:-- (all parts)
                      <fn id="_" reference="1" original-reference="_" target="_">
                         <p>Under preparation. (Stage at the time of publication ISO/DIS 16634)</p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <semx element="autonum" source="_">1</semx>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                      ,
                   </biblio-tag>
                </bibitem>
                <bibitem id="IETF_6281" type="standard">
                   <formattedref>Code for the representation of names of languages.</formattedref>
                   <fetched/>
                   <title type="title-main" format="text/plain" language="en" script="Latn">Code for the representation of names of languages</title>
                   <title type="main" format="text/plain" language="en" script="Latn">Code for the representation of names of languages</title>
                   <uri type="src">https://www.iso.org/standard/4766.html</uri>
                   <uri type="rss">https://www.iso.org/contents/data/standard/00/47/4766.detail.rss</uri>
                   <docidentifier type="ISO" primary="true">ISO 639</docidentifier>
                   <docidentifier type="URN">URN urn:iso:std:iso:639:ed-1</docidentifier>
                   <docidentifier scope="biblio-tag">ISO 639</docidentifier>
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
                   <script>Latn</script>
                   <status>
                      <stage>95</stage>
                      <substage>99</substage>
                   </status>
                   <copyright>
                      <from>1988</from>
                      <owner>
                         <organization>
                            <name>ISO</name>
                         </organization>
                      </owner>
                   </copyright>
                   <relation type="updates">
                      <bibitem type="standard">
                         <formattedref format="text/plain">ISO 639-1:2002</formattedref>
                         <docidentifier type="ISO" primary="true">ISO 639-1:2002</docidentifier>
                         <date type="circulated">
                            <on>2002-07-18</on>
                         </date>
                      </bibitem>
                   </relation>
                   <relation type="instance">
                      <bibitem type="standard">
                         <fetched/>
                         <title type="title-main" format="text/plain" language="en" script="Latn">Code for the representation of names of languages</title>
                         <title type="main" format="text/plain" language="en" script="Latn">Code for the representation of names of languages</title>
                         <uri type="src">https://www.iso.org/standard/4766.html</uri>
                         <uri type="rss">https://www.iso.org/contents/data/standard/00/47/4766.detail.rss</uri>
                         <docidentifier type="ISO" primary="true">ISO 639:1988</docidentifier>
                         <docidentifier type="URN">urn:iso:std:iso:639:ed-1</docidentifier>
                         <docnumber>639</docnumber>
                         <date type="published">
                            <on>1988-03</on>
                         </date>
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
                         <script>Latn</script>
                         <abstract format="text/plain" language="en" script="Latn">Gives a two-letter lower-case code. The symbols were devised primarily for use in terminology, lexicography and linguistic, but they may be used for any application. It also includes guidance on the use of language symbols in some of these applications. The annex includes a classified list of languages and their symbols arranged by families.</abstract>
                         <status>
                            <stage>95</stage>
                            <substage>99</substage>
                         </status>
                         <copyright>
                            <from>1988</from>
                            <owner>
                               <organization>
                                  <name>ISO</name>
                               </organization>
                            </owner>
                         </copyright>
                         <relation type="updates">
                            <bibitem type="standard">
                               <formattedref format="text/plain">ISO 639-1:2002</formattedref>
                               <docidentifier type="ISO" primary="true">ISO 639-1:2002</docidentifier>
                               <date type="circulated">
                                  <on>2002-07-18</on>
                               </date>
                            </bibitem>
                         </relation>
                         <place>Geneva</place>
                      </bibitem>
                   </relation>
                   <place>Geneva</place>
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
                   <docidentifier type="ISO" primary="true">ISO 639-2:1998</docidentifier>
                   <docidentifier type="iso-reference">iso-reference ISO 639-2(E)</docidentifier>
                   <docidentifier type="URN">URN urn:iso:std:iso:639:-2:stage-95.99:ed-1</docidentifier>
                   <docidentifier scope="biblio-tag">ISO 639-2:1998</docidentifier>
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
                   <biblio-tag>ISO 639-2:1998, </biblio-tag>
                </bibitem>
                <bibitem id="ref3">
                   <formattedref format="application/x-isodoc+xml">REF4</formattedref>
                   <docidentifier>REF4</docidentifier>
                   <docidentifier scope="biblio-tag">REF4</docidentifier>
                   <docnumber>4</docnumber>
                   <biblio-tag>REF4, </biblio-tag>
                </bibitem>
                <bibitem type="book" id="ref2">
                   <formattedref>
                      Aluffi, P., D. Anderson, M. Hering, M. Mustaţă, and S. Payne,
                      <em>Facets of Algebraic Geometry: A Collection in Honor of William Fulton's 80th Birthday</em>
                      , first edition, Cambridge, UK: Cambridge University Press, 2022a, DOI: https://doi.org/10.1017/9781108877831.
                      <fn id="_" reference="2" original-reference="_" target="_">
                         <p>
                IEEE 194-1977 has been withdrawn; however, copies can be obtained from Global Engineering, 15 Inverness Way East, Englewood, CO 80112-5704, USA, tel. (303) 792-2181 (http://global.ihs.com/).
        
              </p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <semx element="autonum" source="_">2</semx>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                   </formattedref>
                   <title>Facets of Algebraic Geometry: A Collection in Honor of William Fulton's 80th Birthday</title>
                   <docidentifier type="DOI">https://doi.org/10.1017/9781108877831</docidentifier>
                   <docidentifier type="ISBN">ISBN 9781108877831</docidentifier>
                   <date type="published">
                      <on>2022</on>
                   </date>
                   <contributor>
                      <role type="editor"/>
                      <person>
                         <name>
                            <surname>Aluffi</surname>
                            <forename>Paolo</forename>
                         </name>
                      </person>
                   </contributor>
                   <contributor>
                      <role type="editor"/>
                      <person>
                         <name>
                            <surname>Anderson</surname>
                            <forename>David</forename>
                         </name>
                      </person>
                   </contributor>
                   <contributor>
                      <role type="editor"/>
                      <person>
                         <name>
                            <surname>Hering</surname>
                            <forename>Milena</forename>
                         </name>
                      </person>
                   </contributor>
                   <contributor>
                      <role type="editor"/>
                      <person>
                         <name>
                            <surname>Mustaţă</surname>
                            <forename>Mircea</forename>
                         </name>
                      </person>
                   </contributor>
                   <contributor>
                      <role type="editor"/>
                      <person>
                         <name>
                            <surname>Payne</surname>
                            <forename>Sam</forename>
                         </name>
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
                   <size>
                      <value type="volume">1</value>
                   </size>
                   <docidentifier type="metanorma">Aluffi, Anderson, Hering, Mustaţă and Payne 2022a</docidentifier>
                   <biblio-tag>Aluffi, Anderson, Hering, Mustaţă and Payne 2022a, </biblio-tag>
                </bibitem>
                <bibitem type="standard" id="ref1">
                   <formattedref>Indiana Jones and the Last Crusade.</formattedref>
                   <fetched/>
                   <title type="main" format="text/plain">Indiana Jones and the Last Crusade</title>
                   <title type="title-main" format="text/plain">Indiana Jones and the Last Crusade</title>
                   <title type="main" format="text/plain">Indiana Jones and the Last Crusade</title>
                   <docidentifier type="ISO">ISO 639:1967</docidentifier>
                   <docidentifier scope="biblio-tag">ISO 639:1967</docidentifier>
                   <contributor>
                      <role type="publisher"/>
                      <organization>
                         <name>International Organization for Standardization</name>
                         <abbreviation>ISO</abbreviation>
                      </organization>
                   </contributor>
                   <contributor>
                      <role type="author"/>
                      <person>
                         <name>
                            <forename>Indiana</forename>
                            <surname>Jones</surname>
                         </name>
                      </person>
                   </contributor>
                   <biblio-tag>ISO 639:1967, </biblio-tag>
                </bibitem>
             </references>
          </sections>
          <bibliography>
             <references id="_" normative="false" obligation="informative" displayorder="5">
                <title id="_">Bibliography</title>
                <fmt-title id="_" depth="1">
                   <semx element="title" source="_">Bibliography</semx>
                </fmt-title>
                <bibitem id="ref6">
                   <formattedref format="application/x-isodoc+xml">Title</formattedref>
                   <docidentifier type="metanorma-ordinal">[B1]</docidentifier>
                   <docidentifier>REF4</docidentifier>
                   <docidentifier scope="biblio-tag">REF4</docidentifier>
                   <docnumber>4</docnumber>
                   <biblio-tag>
                      [B1]
                      <tab/>
                      REF4,
                   </biblio-tag>
                </bibitem>
                <bibitem type="book" id="ref5">
                   <formattedref>
                      Aluffi, P., D. Anderson, M. Hering, M. Mustaţă, and S. Payne,
                      <em>Facets of Algebraic Geometry: A Collection in Honor of William Fulton's 80th Birthday</em>
                      , first edition, Cambridge, UK: Cambridge University Press, 2022b, DOI: https://doi.org/10.1017/9781108877831.
                   </formattedref>
                   <title>Facets of Algebraic Geometry: A Collection in Honor of William Fulton's 80th Birthday</title>
                   <docidentifier type="metanorma-ordinal">[B2]</docidentifier>
                   <docidentifier type="DOI">https://doi.org/10.1017/9781108877831</docidentifier>
                   <docidentifier type="ISBN">ISBN 9781108877831</docidentifier>
                   <date type="published">
                      <on>2022</on>
                   </date>
                   <contributor>
                      <role type="editor"/>
                      <person>
                         <name>
                            <surname>Aluffi</surname>
                            <forename>Paolo</forename>
                         </name>
                      </person>
                   </contributor>
                   <contributor>
                      <role type="editor"/>
                      <person>
                         <name>
                            <surname>Anderson</surname>
                            <forename>David</forename>
                         </name>
                      </person>
                   </contributor>
                   <contributor>
                      <role type="editor"/>
                      <person>
                         <name>
                            <surname>Hering</surname>
                            <forename>Milena</forename>
                         </name>
                      </person>
                   </contributor>
                   <contributor>
                      <role type="editor"/>
                      <person>
                         <name>
                            <surname>Mustaţă</surname>
                            <forename>Mircea</forename>
                         </name>
                      </person>
                   </contributor>
                   <contributor>
                      <role type="editor"/>
                      <person>
                         <name>
                            <surname>Payne</surname>
                            <forename>Sam</forename>
                         </name>
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
                   <size>
                      <value type="volume">1</value>
                   </size>
                   <biblio-tag>
                      [B2]
                      <tab/>
                   </biblio-tag>
                </bibitem>
                <bibitem type="standard" id="ref4">
                   <formattedref>Indiana Jones and the Last Crusade.</formattedref>
                   <fetched/>
                   <title type="main" format="text/plain">Indiana Jones and the Last Crusade</title>
                   <title type="title-main" format="text/plain">Indiana Jones and the Last Crusade</title>
                   <title type="main" format="text/plain">Indiana Jones and the Last Crusade</title>
                   <docidentifier type="metanorma-ordinal">[B3]</docidentifier>
                   <docidentifier type="ISO">ISO 639:1967</docidentifier>
                   <docidentifier scope="biblio-tag">ISO 639:1967</docidentifier>
                   <contributor>
                      <role type="publisher"/>
                      <organization>
                         <name>International Organization for Standardization</name>
                         <abbreviation>ISO</abbreviation>
                      </organization>
                   </contributor>
                   <contributor>
                      <role type="author"/>
                      <person>
                         <name>
                            <forename>Indiana</forename>
                            <surname>Jones</surname>
                         </name>
                      </person>
                   </contributor>
                   <biblio-tag>
                      [B3]
                      <tab/>
                      ISO 639:1967,
                   </biblio-tag>
                </bibitem>
             </references>
          </bibliography>
          <fmt-footnote-container>
             <fmt-fn-body id="_" target="_" reference="1">
                <semx element="fn" source="_">
                   <p>
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
                      Under preparation. (Stage at the time of publication ISO/DIS 16634)
                   </p>
                </semx>
             </fmt-fn-body>
             <fmt-fn-body id="_" target="_" reference="2">
                <semx element="fn" source="_">
                   <p>
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <semx element="autonum" source="_">2</semx>
                            </sup>
                         </span>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      IEEE 194-1977 has been withdrawn; however, copies can be obtained from Global Engineering, 15 Inverness Way East, Englewood, CO 80112-5704, USA, tel. (303) 792-2181 (http://global.ihs.com/).
                   </p>
                </semx>
             </fmt-fn-body>
          </fmt-footnote-container>
       </iso-standard>
      PRESXML
      out = Nokogiri::XML(
        IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
        .convert("test", input, true),
      )
      expect(Canon.format_xml(strip_guid(out.to_xml)))
        .to be_equivalent_to Canon.format_xml(presxml)
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
               <fmt-title id="_" depth="1">Contents</fmt-title>
            </clause>
         </preface>
         <sections/>
         <bibliography>
            <references id="_" normative="false" obligation="informative" displayorder="2">
               <title id="_">Normative References</title>
               <fmt-title id="_" depth="1">
                     <semx element="title" source="_">Normative References</semx>
               </fmt-title>
               <bibitem id="IETF_6281" type="standard">
                  <formattedref>“Title 1,”.</formattedref>
                  <title>Title 1</title>
                  <docidentifier type="metanorma-ordinal">[B1]</docidentifier>
                  <docidentifier>ABC</docidentifier>
                  <docidentifier scope="biblio-tag">ABC</docidentifier>
                  <biblio-tag>
                     [B1]
                     <tab/>
                     ABC,
                  </biblio-tag>
               </bibitem>
               <bibitem id="IETF_6282" type="standard">
                  <formattedref>“Title 1,”.</formattedref>
                  <title>Title 1</title>
                  <docidentifier type="metanorma-ordinal">[B2]</docidentifier>
                  <docidentifier>DEF</docidentifier>
                  <docidentifier scope="biblio-tag">DEF</docidentifier>
                  <biblio-tag>
                     [B2]
                     <tab/>
                     DEF,
                  </biblio-tag>
               </bibitem>
               <bibitem id="IETF_6283" type="standard">
                  <formattedref>“Title 2,”.</formattedref>
                  <title>Title 2</title>
                  <docidentifier type="metanorma-ordinal">[B3]</docidentifier>
                  <docidentifier>GHI</docidentifier>
                  <docidentifier scope="biblio-tag">GHI</docidentifier>
                  <biblio-tag>
                     [B3]
                     <tab/>
                     GHI,
                  </biblio-tag>
               </bibitem>
            </references>
         </bibliography>
      </iso-standard>
    PRESXML
    out = Nokogiri::XML(
      IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true),
    )
    expect(Canon.format_xml(strip_guid(out.to_xml)))
      .to be_equivalent_to Canon.format_xml(presxml)
  end

  it "renders reference without identifier" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <sections/>
          <bibliography>
           <references id="_" normative="true" obligation="informative">
             <title>Normative references</title>
             <p id="_">The following referenced documents are indispensable for the application of this document (i.e., they must be understood and used, so each referenced document is cited in text and its relationship to this document is explained). For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments or corrigenda) applies.</p>
             <bibitem id="ref1">
               <formattedref format="application/x-isodoc+xml">Reference 1</formattedref>
             </bibitem>
             <bibitem id="ref2">
               <formattedref format="application/x-isodoc+xml">Reference 2</formattedref>
               <docidentifier>A</docidentifier>
             </bibitem>
           </references>
           <references id="_" normative="false" obligation="informative">
             <title>Bibliography</title>
             <p id="_">Bibliographical references are resources that provide additional or helpful material but do not need to be understood or used to implement this standard. Reference to these resources is made for informational use only.</p>
             <bibitem id="ref3">
               <formattedref format="application/x-isodoc+xml">Reference 2</formattedref>
               <docidentifier type="metanorma">[B1]</docidentifier>
             </bibitem>
           </references>
         </bibliography>
      </ieee-standard>
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
            <references id="_" normative="true" obligation="informative" displayorder="3">
               <title id="_">Normative references</title>
               <fmt-title id="_" depth="1">
                     <semx element="title" source="_">Normative references</semx>
               </fmt-title>
               <p id="_">The following referenced documents are indispensable for the application of this document (i.e., they must be understood and used, so each referenced document is cited in text and its relationship to this document is explained). For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments or corrigenda) applies.</p>
               <bibitem id="ref1">
                  <formattedref format="application/x-isodoc+xml">Reference 1</formattedref>
                  <biblio-tag/>
               </bibitem>
               <bibitem id="ref2">
                  <formattedref format="application/x-isodoc+xml">Reference 2</formattedref>
                  <docidentifier>A</docidentifier>
                  <docidentifier scope="biblio-tag">A</docidentifier>
                  <biblio-tag>A, </biblio-tag>
               </bibitem>
            </references>
         </sections>
         <bibliography>
            <references id="_" normative="false" obligation="informative" displayorder="4">
               <title id="_">Bibliography</title>
               <fmt-title id="_" depth="1">
                     <semx element="title" source="_">Bibliography</semx>
               </fmt-title>
               <p id="_">Bibliographical references are resources that provide additional or helpful material but do not need to be understood or used to implement this standard. Reference to these resources is made for informational use only.</p>
               <bibitem id="ref3">
                  <formattedref format="application/x-isodoc+xml">Reference 2</formattedref>
                  <docidentifier type="metanorma-ordinal">[B1]</docidentifier>
                  <biblio-tag>
                     [B1]
                     <tab/>
                  </biblio-tag>
               </bibitem>
            </references>
         </bibliography>
      </iso-standard>
    PRESXML
    out = Nokogiri::XML(
      IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true),
    )
    expect(Canon.format_xml(strip_guid(out.to_xml)))
      .to be_equivalent_to Canon.format_xml(presxml)
  end

  it "removes page locality" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
                <sections>
                  <clause id='A' inline-header='false' obligation='normative'>
                  <title>Clause</title>
                  <p id='_'>
                    <eref type='inline' bibitemid='IETF_6281' citeas='ISO 639:1967'>
                    <localityStack><locality type="page"><referenceFrom>4</referenceFrom><referenceTo>9</referenceTo></locality></localityStack>
                    </eref>
                    <eref type='inline' bibitemid='IETF_6281' citeas='ISO 639:1967'>
                    <localityStack><locality type="figure"><referenceFrom>4</referenceFrom><referenceTo>9</referenceTo></locality></localityStack>
                    </eref>
                    <eref type='inline' bibitemid='Johns' citeas='ISO 639-2:1998'>
                    <localityStack><locality type="page"><referenceFrom>4</referenceFrom><referenceTo>9</referenceTo></locality></localityStack>
                    </eref>
                    <eref type='inline' bibitemid='Johns' citeas='ISO 639-2:1998'>
                    <localityStack><locality type="figure"><referenceFrom>4</referenceFrom><referenceTo>9</referenceTo></locality></localityStack>
                    </eref>
                  </p>
                </clause>
              </sections>
      <bibliography>
       <references id='_' normative='true' obligation='informative'>
         <title>Normative References</title>
         <bibitem id="IETF_6281" type="standard" schema-version="v1.2.1">
         <title>Title 1</title>
         <docidentifier>IETF 6281</docidentifier>
         </bibitem>
         <bibitem id="Johns" type="book" schema-version="v1.2.1">
         <title>Title 1</title>
         <docidentifier type="metanorma">Johns 2022</docidentifier>
         </bibitem>
         </references>
         </bibliography>
         </iso-standard>
    INPUT
    presxml = <<~PRESXML
      <clause id="A" inline-header="false" obligation="normative" displayorder="4">
         <title id="_">Clause</title>
         <fmt-title id="_" depth="1">
            <span class="fmt-caption-label">
               <semx element="autonum" source="A">2</semx>
               <span class="fmt-autonum-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Clause</semx>
         </fmt-title>
         <fmt-xref-label>
            <span class="fmt-element-name">Clause</span>
            <semx element="autonum" source="A">2</semx>
         </fmt-xref-label>
         <p id="_">
            <eref type="inline" bibitemid="IETF_6281" citeas="ISO 639:1967" id="_">
               <localityStack>
                  <locality type="page">
                     <referenceFrom>4</referenceFrom>
                     <referenceTo>9</referenceTo>
                  </locality>
               </localityStack>
            </eref>
            <semx element="eref" source="_">
               <fmt-xref type="inline" target="IETF_6281">
                  <span class="std_publisher">IETF </span>
                  <span class="std_docNumber">6281</span>
                  , 4–9
               </fmt-xref>
            </semx>
            <eref type="inline" bibitemid="IETF_6281" citeas="ISO 639:1967" id="_">
               <localityStack>
                  <locality type="figure">
                     <referenceFrom>4</referenceFrom>
                     <referenceTo>9</referenceTo>
                  </locality>
               </localityStack>
            </eref>
            <semx element="eref" source="_">
               <fmt-xref type="inline" target="IETF_6281">
                  <span class="std_publisher">IETF </span>
                  <span class="std_docNumber">6281</span>
                  , Figure 4–9
               </fmt-xref>
            </semx>
            <eref type="inline" bibitemid="Johns" citeas="ISO 639-2:1998" id="_">
               <localityStack>
                  <locality type="page">
                     <referenceFrom>4</referenceFrom>
                     <referenceTo>9</referenceTo>
                  </locality>
               </localityStack>
            </eref>
            <semx element="eref" source="_">
               <fmt-xref type="inline" target="Johns">Johns 2022, 4–9</fmt-xref>
            </semx>
            <eref type="inline" bibitemid="Johns" citeas="ISO 639-2:1998" id="_">
               <localityStack>
                  <locality type="figure">
                     <referenceFrom>4</referenceFrom>
                     <referenceTo>9</referenceTo>
                  </locality>
               </localityStack>
            </eref>
            <semx element="eref" source="_">
               <fmt-xref type="inline" target="Johns">Johns 2022, Figure 4–9</fmt-xref>
            </semx>
         </p>
      </clause>
    PRESXML
    out = Nokogiri::XML(
      IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true),
    )
    out = out.at("//xmlns:clause[@id = 'A']")
    expect(Canon.format_xml(strip_guid(out.to_xml)))
      .to be_equivalent_to Canon.format_xml(presxml)
  end
end
