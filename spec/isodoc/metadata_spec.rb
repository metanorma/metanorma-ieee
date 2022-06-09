require "spec_helper"
require "fileutils"

logoloc = File.expand_path(
  File.join(File.dirname(__FILE__), "..", "..", "lib", "isodoc", "ieee", "html"),
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
                 <date type='published' format='ddMMMyyyy'>1.IX.2018</date>
        <contributor>
          <role type="author"/>
          <organization>
            <name>International Telecommunication Union</name>
            <abbreviation>ITU</abbreviation>
          </organization>
        </contributor>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Telecommunication Union</name>
            <abbreviation>ITU</abbreviation>
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
       :agency=>"ITU",
       :circulateddate=>"XXX",
       :confirmeddate=>"XXX",
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
       :implementeddate=>"XXX",
       :issueddate=>"XXX",
       :iteration=>"3",
       :keywords=>["word2", "word1"],
       :lang=>"en",
       :obsoleteddate=>"XXX",
       :publisheddate=>"XXX",
       :publisher=>"International Telecommunication Union",
       :receiveddate=>"XXX",
       :revdate=>"2000-01-01",
       :revdate_monthyear=>"January 2000",
       :script=>"Latn",
       :stage=>"Final Draft",
       :stage_display=>"Final Draft",
       :stageabbr=>"FD",
       :transmitteddate=>"XXX",
       :unchangeddate=>"XXX",
       :unpublished=>true,
       :updateddate=>"XXX",
       :vote_endeddate=>"XXX",
       :vote_starteddate=>"XXX"}
      OUTPUT
  end
end
