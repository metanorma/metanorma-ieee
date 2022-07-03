require "spec_helper"

RSpec.describe IsoDoc do
  it "processes biblio citations" do
    input = <<~"INPUT"
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <clause id='A' inline-header='false' obligation='normative'>
          <title>Clause</title>
          <p id='_'>
            <eref type='inline' bibitemid='ref1' citeas='ISO 639:1967'/>
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

    presxml = <<~"PRESXML"
      <clause id='A' inline-header='false' obligation='normative' displayorder='2'>
        <title depth='1'>
          2.
          <tab/>
          Clause
        </title>
        <p id='_'>
          <eref type='inline' bibitemid='ref1' citeas='ISO 639:1967'>ISO 639:1967</eref>
          <eref type='inline' bibitemid='ref2' citeas='Aluffi'>Aluffi</eref>
          <eref type='inline' bibitemid='ref3' citeas='REF4'>REF4</eref>
          <eref type='inline' bibitemid='ref4' citeas='ISO 639:1967'>ISO 639:1967 [B3]</eref>
          <eref type='inline' bibitemid='ref5' citeas='[B2]'>
            Facets of Algebraic Geometry: A Collection in Honor of William Fulton's
            80th Birthday [B2]
          </eref>
          <eref type='inline' bibitemid='ref6' citeas='[B1]'>REF4 [REF4] [B1]</eref>
        </p>
      </clause>
    PRESXML
    expect(xmlpp(Nokogiri::XML(
      IsoDoc::IEEE::PresentationXMLConvert.new({})
      .convert("test", input, true),
    )
      .at("//xmlns:clause[@id = 'A']").to_xml))
      .to be_equivalent_to xmlpp(presxml)
  end
end
