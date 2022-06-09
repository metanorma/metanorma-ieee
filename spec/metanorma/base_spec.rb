require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::IEEE do
  before(:all) do
    @blank_hdr = blank_hdr_gen
  end

  it "has a version number" do
    expect(Metanorma::IEEE::VERSION).not_to be nil
  end

  it "processes a blank document" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}
    INPUT
    output = <<~OUTPUT
      #{@blank_hdr}
      <sections/>
      </ieee-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "converts a blank document" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
      :legacy-do-not-insert-missing-sections:
    INPUT
    output = <<~OUTPUT
        #{@blank_hdr}
        <sections/>
      </ieee-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
    expect(File.exist?("test.html")).to be true
  end

  it "processes default metadata" do
    output = Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :no-isobib:
      :docnumber: 1000
      :partnumber: 1
      :edition: 2
      :revdate: 2000-01-01
      :draft: 0.3.4
      :committee: TC
      :technical-committee-number: 1
      :technical-committee-type: A
      :balloting-group: SC
      :subcommittee-number: 2
      :subcommittee-type: B
      :working-group: WG
      :workgroup-number: 3
      :workgroup-type: C
      :committee_2: TC1
      :technical-committee-number_2: 11
      :technical-committee-type_2: A1
      :subcommittee_2: SC1
      :subcommittee-number_2: 21
      :subcommittee-type_2: B1
      :working-group_2: WG1
      :workgroup-number_2: 31
      :workgroup-type_2: C1
      :society: SECRETARIAT
      :docstage: 20
      :docsubstage: 20
      :iteration: 3
      :language: en
      :title-intro-en: Introduction
      :title-main-en: Main Title -- Title
      :title-part-en: Title Part
      :title-intro-fr: Introduction Française
      :title-main-fr: Titre Principal
      :title-part-fr: Part du Titre
      :library-ics: 1,2,3
      :copyright-year: 2000
      :horizontal: true
      :confirmed-date: 1000-12-01
      :issued-date: 1001-12-01
      :wg_chair: AB
      :wg_vicechair: CD
      :wg_members: E, F, Jr.; GH; IJ
      :balloting_group_members: KL; MN
      :std_board_chair: OP
      :std_board_vicechair: QR
      :std_board_pastchair: ST
      :std_board_secretary: UV
      :std_board_members: WX; YZ
    INPUT
    expect(xmlpp(output.sub(%r{<boilerplate>.*</boilerplate>}m, "")))
      .to be_equivalent_to xmlpp(<<~"OUTPUT")
           <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='0.0.1'>
         <bibdata type='standard'>
           <title language='en' format='text/plain'>Document title</title>
           <title language='intro-en' format='text/plain'>Introduction</title>
           <title language='main-en' format='text/plain'>Main Title -- Title</title>
           <title language='part-en' format='text/plain'>Title Part</title>
           <title language='intro-fr' format='text/plain'>Introduction Française</title>
           <title language='main-fr' format='text/plain'>Titre Principal</title>
           <title language='part-fr' format='text/plain'>Part du Titre</title>
           <docidentifier type='IEEE'>1000</docidentifier>
           <docnumber>1000</docnumber>
           <date type='confirmed'>
             <on>1000-12-01</on>
           </date>
           <date type='issued'>
             <on>1001-12-01</on>
           </date>
           <contributor>
             <role type='editor'>Working Group Chair</role>
             <person>
               <name>
                 <completename>AB</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='editor'>Working Group Vice-Chair</role>
             <person>
               <name>
                 <completename>CD</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='editor'>Working Group Member</role>
             <person>
               <name>
                 <completename>E, F, Jr.</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='editor'>Working Group Member</role>
             <person>
               <name>
                 <completename>GH</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='editor'>Working Group Member</role>
             <person>
               <name>
                 <completename>IJ</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='editor'>Balloting Group Member</role>
             <person>
               <name>
                 <completename>KL</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='editor'>Balloting Group Member</role>
             <person>
               <name>
                 <completename>MN</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='editor'>Standards Board Chair</role>
             <person>
               <name>
                 <completename>OP</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='editor'>Standards Board Vice-Chair</role>
             <person>
               <name>
                 <completename>QR</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='editor'>Standards Board Past Chair</role>
             <person>
               <name>
                 <completename>ST</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='editor'>Standards Board Secretary</role>
             <person>
               <name>
                 <completename>UV</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='editor'>Standards Board Member</role>
             <person>
               <name>
                 <completename>KL</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='editor'>Standards Board Member</role>
             <person>
               <name>
                 <completename>MN</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='publisher'/>
             <organization>
               <name>Institute of Electrical and Electronic Engineers</name>
               <abbreviation>IEEE</abbreviation>
             </organization>
           </contributor>
           <edition>2</edition>
           <version>
             <revision-date>2000-01-01</revision-date>
             <draft>0.3.4</draft>
           </version>
           <language>en</language>
           <script>Latn</script>
           <status>
             <stage>20</stage>
             <substage>20</substage>
             <iteration>3</iteration>
           </status>
           <copyright>
             <from>2000</from>
             <owner>
               <organization>
                 <name>Institute of Electrical and Electronic Engineers</name>
                 <abbreviation>IEEE</abbreviation>
               </organization>
             </owner>
           </copyright>
           <ext>
             <doctype>standard</doctype>
             <editorialgroup>
               <society>SECRETARIAT</society>
               <balloting-group>SC</balloting-group>
               <working-group>WG</working-group>
               <working-group>WG1</working-group>
               <committee>TC</committee>
               <committee>TC1</committee>
             </editorialgroup>
             <ics>
               <code>1</code>
             </ics>
             <ics>
               <code>2</code>
             </ics>
             <ics>
               <code>3</code>
             </ics>
           </ext>
         </bibdata>
         <sections> </sections>
       </ieee-standard>
    OUTPUT
  end
end
