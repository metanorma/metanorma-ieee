require "spec_helper"
require "fileutils"

logoloc = File.expand_path(
  File.join(File.dirname(__FILE__), "..", "..", "lib", "isodoc", "ieee",
            "html"),
)

RSpec.describe Metanorma::IEEE do
  it "processes default metadata" do
    csdc = IsoDoc::IEEE::HtmlConvert.new({})
    docxml, = csdc.convert_init(<<~"INPUT", "test", true)
      <ieee-standard xmlns="https://www.calconnect.org/standards/ieee">
        <bibdata type="standard">
        <title language="en" format="text/plain" type="main">Main Title<br/>in multiple lines</title>
        <title language="en" format="text/plain" type="annex">Annex Title</title>
        <title language="fr" format="text/plain" type="main">Titre Principal</title>
        <title language='en' format='text/plain' type='subtitle'>Subtitle</title>
      <title language='fr' format='text/plain' type='subtitle'>Soustitre</title>
      <title language='en' format='text/plain' type='amendment'>Amendment Title</title>
      <title language='fr' format='text/plain' type='amendment'>Titre de Amendment</title>
      <title language='en' format='text/plain' type='corrigendum'>Corrigendum Title</title>
      <title language='fr' format='text/plain' type='corrigendum'>Titre de Corrigendum</title>
        <docidentifier type="IEEE" scope="PDF">ABC</docidentifier>
        <docidentifier type="IEEE" scope="print">DEF</docidentifier>
        <docidentifier type="ISBN" scope="PDF">GHI</docidentifier>
        <docidentifier type="ISBN" scope="print">JKL</docidentifier>
        <docnumber>1000</docnumber>
        <date type='published'>2018-09-01</date>
        <date type='confirmed'>2018-07-01</date>
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
              <role type='editor'>Working Group Secretary</role>
              <person>
                <name>
                  <completename>CD1</completename>
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
        <draft>3.4</draft>
      </version>
        <language>en</language>
        <script>Latn</script>
        <status>
          <stage>final-draft</stage>
          <iteration>3</iteration>
        </status>
        <copyright>
          <from>2001</from>
          <owner>
            <organization>
            <name>International Telecommunication Union</name>
            <abbreviation>ITU</abbreviation>
            </organization>
          </owner>
        </copyright>
        <series type="main">
        <title>A3</title>
      </series>
      <series type="secondary">
        <title>B3</title>
      </series>
      <series type="tertiary">
        <title>C3</title>
      </series>
           <keyword>word2</keyword>
       <keyword>word1</keyword>
        <ext>
        <doctype>recommended-practice</doctype>
        <docsubtype>trial-use</docsubtype>
          <editorialgroup>
            <society>Society</society>
            <balloting-group>BG</balloting-group>
            <working-group>WG</working-group>
            <technical-committee>Tech Committee</technical-committee>
          </editorialgroup>
       <recommendationstatus>
        <from>D3</from>
        <to>E3</to>
        <approvalstage process="F3">G3</approvalstage>
      </recommendationstatus>
      <ip-notice-received>false</ip-notice-received>
      <structuredidentifier>
      <bureau>R</bureau>
      <docnumber>1000</docnumber>
      <annexid>F1</annexid>
      <amendment>2</amendment>
      <corrigendum>3</corrigendum>
      </structuredidentifier>
        </ext>
      </bibdata>
      <preface/><sections/>
      <annex obligation="informative"/>
      </ieee-standard>
    INPUT
    expect(htmlencode(metadata(csdc.info(docxml, nil)).to_s
      .gsub(/, :/, ",\n:"))).to be_equivalent_to <<~"OUTPUT"
        {:accesseddate=>"XXX",
        :agency=>"IEEE",
        :authors=>["AB", "CD", "CD1", "E, F, Jr.", "GH", "IJ", "KL", "MN", "OP", "QR", "ST", "UV", "KL", "MN"],
        :authors_affiliations=>{""=>["AB", "CD", "CD1", "E, F, Jr.", "GH", "IJ", "KL", "MN", "OP", "QR", "ST", "UV", "KL", "MN"]},
        :balloting_group=>"BG",
        :balloting_group_members=>["KL", "MN"],
        :circulateddate=>"XXX",
        :confirmeddate=>"2018-07-01",
        :copieddate=>"XXX",
        :createddate=>"XXX",
        :docnumber=>"ABC",
        :docnumeric=>"1000",
        :docsubtype=>"Trial Use",
        :doctitle=>"Main Titlein multiple lines",
        :doctype=>"Recommended Practice",
        :doctype_abbrev=>"Rec. Prac.",
        :docyear=>"2001",
        :draft=>"3.4",
        :draft_month=>"January",
        :draft_year=>"2000",
        :draftinfo=>" (draft 3.4, 2000-01-01)",
        :edition=>"2",
        :full_doctitle=>"Draft Rec. Prac. for Main Titlein multiple lines",
        :implementeddate=>"XXX",
        :isbn_pdf=>"GHI",
        :isbn_print=>"JKL",
        :issueddate=>"XXX",
        :iteration=>"3",
        :keywords=>["word2", "word1"],
        :lang=>"en",
        :obsoleteddate=>"XXX",
        :publisheddate=>"2018-09-01",
        :publisher=>"Institute of Electrical and Electronic Engineers",
        :receiveddate=>"XXX",
        :revdate=>"2000-01-01",
        :revdate_monthyear=>"January 2000",
        :script=>"Latn",
        :society=>"Society",
        :stage=>"Final Draft",
        :stage_display=>"Final Draft",
        :stageabbr=>"FD",
        :std_board=>{"chair"=>"OP", "vice-chair"=>"QR", "past-chair"=>"ST", "secretary"=>"UV", "members"=>["KL", "MN"]},
        :stdid_pdf=>"ABC",
        :stdid_print=>"DEF",
        :technical_committee=>"Tech Committee",
        :transmitteddate=>"XXX",
        :unchangeddate=>"XXX",
        :unpublished=>true,
        :updateddate=>"XXX",
        :vote_endeddate=>"XXX",
        :vote_starteddate=>"XXX",
        :wg_members=>{"chair"=>"AB", "vice-chair"=>"CD", "secretary"=>"CD1", "members"=>["E, F, Jr.", "GH", "IJ"]},
        :working_group=>"WG"}
      OUTPUT
  end

  it "processes metadata with no nominated contributors or scoped identifiers" do
    csdc = IsoDoc::IEEE::HtmlConvert.new({})
    docxml, = csdc.convert_init(<<~"INPUT", "test", true)
      <ieee-standard xmlns="https://www.calconnect.org/standards/ieee">
        <bibdata type="standard">
        <title language="en" format="text/plain" type="main">Main Title<br/>in multiple lines</title>
        <title language="en" format="text/plain" type="annex">Annex Title</title>
        <title language="fr" format="text/plain" type="main">Titre Principal</title>
        <title language='en' format='text/plain' type='subtitle'>Subtitle</title>
      <title language='fr' format='text/plain' type='subtitle'>Soustitre</title>
      <title language='en' format='text/plain' type='amendment'>Amendment Title</title>
      <title language='fr' format='text/plain' type='amendment'>Titre de Amendment</title>
      <title language='en' format='text/plain' type='corrigendum'>Corrigendum Title</title>
      <title language='fr' format='text/plain' type='corrigendum'>Titre de Corrigendum</title>
        <docnumber>1000</docnumber>
        <date type='published'>2018-09-01</date>
        <edition>2</edition>
      <version>
        <revision-date>2000-01-01</revision-date>
        <draft>3.4</draft>
      </version>
        <language>en</language>
        <script>Latn</script>
        <status>
          <stage>final-draft</stage>
          <iteration>3</iteration>
        </status>
        <copyright>
          <from>2001</from>
          <owner>
            <organization>
            <name>International Telecommunication Union</name>
            <abbreviation>ITU</abbreviation>
            </organization>
          </owner>
        </copyright>
        <series type="main">
        <title>A3</title>
      </series>
      <series type="secondary">
        <title>B3</title>
      </series>
      <series type="tertiary">
        <title>C3</title>
      </series>
           <keyword>word2</keyword>
       <keyword>word1</keyword>
        <ext>
        <doctype>recommended-practice</doctype>
        <docsubtype>trial-use</docsubtype>
          <editorialgroup>
            <society>Society</society>
            <balloting-group>BG</balloting-group>
            <working-group>WG</working-group>
            <technical-committee>Tech Committee</technical-committee>
          </editorialgroup>
       <recommendationstatus>
        <from>D3</from>
        <to>E3</to>
        <approvalstage process="F3">G3</approvalstage>
      </recommendationstatus>
      <ip-notice-received>false</ip-notice-received>
      <structuredidentifier>
      <bureau>R</bureau>
      <docnumber>1000</docnumber>
      <annexid>F1</annexid>
      <amendment>2</amendment>
      <corrigendum>3</corrigendum>
      </structuredidentifier>
        </ext>
      </bibdata>
      <preface/><sections/>
      <annex obligation="informative"/>
      </ieee-standard>
    INPUT
    expect(htmlencode(metadata(csdc.info(docxml, nil)).to_s
      .gsub(/, :/, ",\n:"))).to be_equivalent_to <<~"OUTPUT"
        {:accesseddate=>"XXX",
        :balloting_group=>"BG",
        :balloting_group_members=>["Balloter1", "Balloter2", "Balloter3", "Balloter4", "Balloter5", "Balloter6", "Balloter7", "Balloter8", "Balloter9"],
        :circulateddate=>"XXX",
        :confirmeddate=>"&lt;Date Approved&gt;",
        :copieddate=>"XXX",
        :createddate=>"XXX",
        :docnumeric=>"1000",
        :docsubtype=>"Trial Use",
        :doctitle=>"Main Titlein multiple lines",
        :doctype=>"Recommended Practice",
        :doctype_abbrev=>"Rec. Prac.",
        :docyear=>"2001",
        :draft=>"3.4",
        :draft_month=>"January",
        :draft_year=>"2000",
        :draftinfo=>" (draft 3.4, 2000-01-01)",
        :edition=>"2",
        :full_doctitle=>"Draft Rec. Prac. for Main Titlein multiple lines",
        :implementeddate=>"XXX",
        :isbn_pdf=>"978-0-XXXX-XXXX-X",
        :isbn_print=>"978-0-XXXX-XXXX-X",
        :issueddate=>"XXX",
        :iteration=>"3",
        :keywords=>["word2", "word1"],
        :lang=>"en",
        :obsoleteddate=>"XXX",
        :publisheddate=>"2018-09-01",
        :receiveddate=>"XXX",
        :revdate=>"2000-01-01",
        :revdate_monthyear=>"January 2000",
        :script=>"Latn",
        :society=>"Society",
        :stage=>"Final Draft",
        :stage_display=>"Final Draft",
        :stageabbr=>"FD",
        :std_board=>{"chair"=>"&lt;Name&gt;", "vice-chair"=>"&lt;Name&gt;", "past-chair"=>"&lt;Name&gt;", "secretary"=>"&lt;Name&gt;", "members"=>["SBMember1", "SBMember2", "SBMember3", "SBMember4", "SBMember5", "SBMember6", "SBMember7", "SBMember8", "SBMember9"]},
        :stdid_pdf=>"STDXXXXX",
        :stdid_print=>"STDPDXXXXX",
        :technical_committee=>"Tech Committee",
        :transmitteddate=>"XXX",
        :unchangeddate=>"XXX",
        :unpublished=>true,
        :updateddate=>"XXX",
        :vote_endeddate=>"XXX",
        :vote_starteddate=>"XXX",
        :wg_members=>{"members"=>["Participant1", "Participant2", "Participant3", "Participant4", "Participant5", "Participant6", "Participant7", "Participant8", "Participant9"]},
        :working_group=>"WG"}
      OUTPUT
  end
end
