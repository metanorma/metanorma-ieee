require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::Ieee do
  logoloc = File.expand_path(File.join(File.dirname(__FILE__), "..", "..",
                                       "lib", "isodoc", "ieee", "html"))

  it "processes default metadata" do
    csdc = IsoDoc::Ieee::HtmlConvert.new({})
    docxml, = csdc.convert_init(<<~INPUT, "test", true)
       <ieee-standard xmlns="https://www.calconnect.org/standards/ieee">
           <bibdata type="standard">
           <title language="en" format="text/plain" type="main">Main Title<br/>in multiple lines</title>
           <title type='provenance' language='en' format='application/xml'>Revision of ABC<br/>Incorporates BCD and EFG</title>
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
           <date type='published' format="ddMMMyyyy">01 Sep 2018</date>
           <date type='issued'>2018-07-01</date>
           <date type='issued' format="ddMMMyyyy">01 Jul 2018</date>
           <date type='feedback-ended'>2018-08-01</date>
           <date type='feedback-ended' format="ddMMMyyyy">01 Aug 2018</date>
           <date type="ieee-sasb-approved"><on>1004-12-01</on></date>
           <date type="ieee-sasb-approved" format="ddMMMyyyy"><on>01 Dec 1004</on></date>
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
                 <role type='editor'>Working Group Member</role>
                 <organization>
                   <name>Alibaba, Inc.</name>
                 </organization>
               </contributor>
               <contributor>
                 <role type='editor'>Working Group Member</role>
                 <organization>
                   <name>Alphabet, Ltd.</name>
                 </organization>
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
                 <contributor>
      <role type="authorizer">
         <description>Society</description>
      </role>
      <organization>
         <name>Institute of Electrical and Electronic Engineers</name>
         <subdivision type="Society">
            <name>Society</name>
         </subdivision>
         <subdivision type="Balloting group" subtype="entity">
            <name>BG</name>
         </subdivision>
         <subdivision type="Working group">
            <name>WG</name>
         </subdivision>
         <subdivision type="Working group">
            <name>WG1</name>
         </subdivision>
         <subdivision type="Committee">
            <name>Tech Committee</name>
         </subdivision>
         <subdivision type="Committee">
            <name>TC1</name>
         </subdivision>
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
              <relation type='merges'>
         <bibitem>
           <title>--</title>
           <docidentifier>BCD</docidentifier>
         </bibitem>
       </relation>
       <relation type='merges'>
         <bibitem>
           <title>--</title>
           <docidentifier>EFG</docidentifier>
         </bibitem>
       </relation>
       <relation type='updates'>
         <bibitem>
           <title>--</title>
           <docidentifier>ABC</docidentifier>
         </bibitem>
       </relation>
           <ext>
           <doctype>recommended-practice</doctype>
           <subdoctype>amendment</subdoctype>
           <trial-use>true</trial-use>
             <editorialgroup>
               <society>Society</society>
               <balloting-group type="entity">BG</balloting-group>
               <working-group>WG</working-group>
               <committee>Tech Committee</committee>
             </editorialgroup>
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
      <program>HIJ</program>
           </ext>
         </bibdata>
         <metanorma-extension>
         <semantic-metadata>
         <stage-published>false</stage-published>
         </semantic-metadata>
         </metanorma-extension>
         <preface/><sections/>
         <annex obligation="informative"/>
         </ieee-standard>
    INPUT
    # expect(htmlencode(metadata(csdc.info(docxml, nil))#.to_s
    # .gsub(", :", ",\n:"))).to be_equivalent_to
    expect(metadata(csdc.info(docxml, nil)))
      .to be_equivalent_to(
        { abbrev_doctitle: "Draft Rec. Prac. for Main Title<br/>in multiple lines",
          accesseddate: "XXX",
          adapteddate: "XXX",
          agency: "IEEE",
          amd: "A1",
          announceddate: "XXX",
          authors: ["AB", "CD", "CD1", "E, F, Jr.", "GH",
                    "IJ", "KL", "MN", "OP", "QR", "ST", "UV", "KL", "MN"],
          authors_affiliations: { "" => ["AB", "CD", "CD1",
                                         "E, F, Jr.", "GH", "IJ", "KL", "MN", "OP", "QR", "ST", "UV", "KL", "MN"] },
          balloting_group: "BG",
          balloting_group_type: "entity",
          circulateddate: "XXX",
          confirmeddate: "XXX",
          copieddate: "XXX",
          corr: "C1",
          correcteddate: "XXX",
          createddate: "XXX",
          docnumber: "ABC",
          docnumeric: "1000",
          docsubtype: "Amendment",
          doctitle: "Main Title<br/>in multiple lines",
          doctype: "Recommended Practice",
          doctype_abbrev: "Rec. Prac.",
          docyear: "2001",
          draft: "3.4",
          draft_month: "July",
          draft_year: "2018",
          draftinfo: " (draft 3.4, 2000-01-01)",
          edition: "2",
          feedback_endeddate: "01 Aug 2018",
          full_doctitle: "Draft Recommended Practice for Main Title<br/>in multiple lines",
          ieee_sasb_approveddate: "01 Dec 1004",
          implementeddate: "XXX",
          isbn_pdf: "GHI",
          isbn_print: "JKL",
          issueddate: "01 Jul 2018",
          iteration: "3",
          keywords: ["word2", "word1"],
          lang: "en",
          obsoleteddate: "XXX",
          program: "HIJ",
          provenance_doctitle: "Revision of ABC<br/>Incorporates BCD and EFG",
          publisheddate: "01 Sep 2018",
          publisher: "Institute of Electrical and Electronic Engineers",
          receiveddate: "XXX",
          revdate: "2000-01-01",
          revdate_monthyear: "January 2000",
          script: "Latn",
          society: "Society",
          stable_untildate: "XXX",
          stage: "Final Draft",
          stage_display: "Final Draft",
          stageabbr: "FD",
          stdid_pdf: "ABC",
          stdid_print: "DEF",
          technical_committee: "Tech Committee",
          transmitteddate: "XXX",
          trial_use: true,
          unchangeddate: "XXX",
          unpublished: true,
          updateddate: "XXX",
          vote_endeddate: "XXX",
          vote_starteddate: "XXX",
          working_group: "WG",
          wp_image001_emz: File.join(logoloc, "wp_image001.emz"),
          wp_image003_emz: File.join(logoloc, "wp_image003.emz"),
          wp_image007_emz: File.join(logoloc, "wp_image007.emz"),
          wp_image008_emz: File.join(logoloc, "wp_image008.emz") },
      )
  end

  it "processes ICAP, ICR metadata" do
    csdc = IsoDoc::Ieee::HtmlConvert.new({})
    input = <<~INPUT
       <ieee-standard xmlns="https://www.calconnect.org/standards/ieee">
           <bibdata type="standard">
           <title language="en" format="text/plain" type="main">Main Title<br/>in multiple lines</title>
           <title type='provenance' language='en' format='application/xml'>Revision of ABC<br/>Incorporates BCD and EFG</title>
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
           <date type='published' format="ddMMMyyyy">01 Sep 2018</date>
           <date type='issued'>2018-07-01</date>
           <date type='issued' format="ddMMMyyyy">01 Jul 2018</date>
           <date type='feedback-ended'>2018-08-01</date>
           <date type='feedback-ended' format="ddMMMyyyy">01 Aug 2018</date>
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
                 <role type='editor'>Working Group Member</role>
                 <organization>
                   <name>Alibaba, Inc.</name>
                 </organization>
               </contributor>
               <contributor>
                 <role type='editor'>Working Group Member</role>
                 <organization>
                   <name>Alphabet, Ltd.</name>
                 </organization>
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
                              <contributor>
      <role type="authorizer">
         <description>Society</description>
      </role>
      <organization>
         <name>Institute of Electrical and Electronic Engineers</name>
         <subdivision type="Society">
            <name>Society</name>
         </subdivision>
         <subdivision type="Balloting group" subtype="entity">
            <name>BG</name>
         </subdivision>
         <subdivision type="Working group">
            <name>WG</name>
         </subdivision>
         <subdivision type="Working group">
            <name>WG1</name>
         </subdivision>
         <subdivision type="Committee">
            <name>Tech Committee</name>
         </subdivision>
         <subdivision type="Committee">
            <name>TC1</name>
         </subdivision>
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
              <relation type='merges'>
         <bibitem>
           <title>--</title>
           <docidentifier>BCD</docidentifier>
         </bibitem>
       </relation>
       <relation type='merges'>
         <bibitem>
           <title>--</title>
           <docidentifier>EFG</docidentifier>
         </bibitem>
       </relation>
       <relation type='updates'>
         <bibitem>
           <title>--</title>
           <docidentifier>ABC</docidentifier>
         </bibitem>
       </relation>
           <ext>
           <doctype>whitepaper</doctype>
           <subdoctype>icap</subdoctype>
           <trial-use>true</trial-use>
             <editorialgroup>
               <society>Society</society>
               <balloting-group type="entity">BG</balloting-group>
               <working-group>WG</working-group>
               <committee>Tech Committee</committee>
             </editorialgroup>
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
      <program>HIJ</program>
           </ext>
         </bibdata>
         <metanorma-extension>
         <semantic-metadata>
         <stage-published>false</stage-published>
         </semantic-metadata>
         </metanorma-extension>
         <preface/><sections/>
         <annex obligation="informative"/>
         </ieee-standard>
    INPUT
    docxml, = csdc.convert_init(input, "test", true)
    # expect(htmlencode(metadata(csdc.info(docxml, nil))#.to_s
    # .gsub(", :", ",\n:"))).to be_equivalent_to <<~"OUTPUT"
    expect(metadata(csdc.info(docxml, nil)))
      .to be_equivalent_to(
        { abbrev_doctitle: "Draft ??? for Main Title<br/>in multiple lines",
          accesseddate: "XXX",
          adapteddate: "XXX",
          agency: "IEEE",
          amd: "A1",
          announceddate: "XXX",
          authors: ["AB", "CD", "CD1", "E, F, Jr.", "GH",
                    "IJ", "KL", "MN", "OP", "QR", "ST", "UV", "KL", "MN"],
          authors_affiliations: { "" => ["AB", "CD", "CD1",
                                         "E, F, Jr.", "GH", "IJ", "KL", "MN",
                                         "OP", "QR", "ST", "UV", "KL", "MN"] },
          balloting_group: "BG",
          balloting_group_type: "entity",
          circulateddate: "XXX",
          confirmeddate: "XXX",
          copieddate: "XXX",
          corr: "C1",
          correcteddate: "XXX",
          createddate: "XXX",
          docnumber: "ABC",
          docnumeric: "1000",
          docsubtype: "ICAP",
          doctitle: "Main Title<br/>in multiple lines",
          doctype: "Whitepaper",
          docyear: "2001",
          draft: "3.4",
          draft_month: "July",
          draft_year: "2018",
          draftinfo: " (draft 3.4, 2000-01-01)",
          edition: "2",
          feedback_endeddate: "01 Aug 2018",
          full_doctitle: "Draft Whitepaper for Main Title<br/>in multiple lines",
          ieee_sasb_approveddate: "&lt;Date Approved&gt;",
          implementeddate: "XXX",
          isbn_pdf: "GHI",
          isbn_print: "JKL",
          issueddate: "01 Jul 2018",
          iteration: "3",
          keywords: ["word2", "word1"],
          lang: "en",
          obsoleteddate: "XXX",
          program: "IEEE CONFORMITY ASSESSMENT PROGRAM (ICAP)",
          provenance_doctitle: "Revision of ABC<br/>Incorporates BCD and EFG",
          publisheddate: "01 Sep 2018",
          publisher: "Institute of Electrical and Electronic Engineers",
          receiveddate: "XXX",
          revdate: "2000-01-01",
          revdate_monthyear: "January 2000",
          script: "Latn",
          society: "Society",
          stable_untildate: "XXX",
          stage: "Final Draft",
          stage_display: "Final Draft",
          stageabbr: "FD",
          stdid_pdf: "ABC",
          stdid_print: "DEF",
          technical_committee: "Tech Committee",
          transmitteddate: "XXX",
          trial_use: true,
          unchangeddate: "XXX",
          unpublished: true,
          updateddate: "XXX",
          vote_endeddate: "XXX",
          vote_starteddate: "XXX",
          working_group: "WG",
          wp_image001_emz: File.join(logoloc, "wp_image001_icap.emz"),
          wp_image003_emz: File.join(logoloc, "wp_image003_icap.emz"),
          wp_image007_emz: File.join(logoloc, "wp_image007_icap.emz"),
          wp_image008_emz: File.join(logoloc, "wp_image008_icap.emz") },
      )
    docxml, = csdc.convert_init(input
      .sub(">icap<", ">industry-connection-report<"), "test", true)
    # expect(htmlencode(metadata(csdc.info(docxml, nil))#.to_s
    # .gsub(", :", ",\n:"))).to be_equivalent_to <<~"OUTPUT"
    expect(metadata(csdc.info(docxml, nil)))
      .to be_equivalent_to(
        { abbrev_doctitle: "Draft ??? for Main Title<br/>in multiple lines",
          accesseddate: "XXX",
          adapteddate: "XXX",
          agency: "IEEE",
          amd: "A1",
          announceddate: "XXX",
          authors: ["AB", "CD", "CD1", "E, F, Jr.", "GH",
                    "IJ", "KL", "MN", "OP", "QR", "ST", "UV", "KL", "MN"],
          authors_affiliations: { "" => ["AB", "CD", "CD1",
                                         "E, F, Jr.", "GH", "IJ", "KL", "MN",
                                         "OP", "QR", "ST", "UV", "KL", "MN"] },
          balloting_group: "BG",
          balloting_group_type: "entity",
          circulateddate: "XXX",
          confirmeddate: "XXX",
          copieddate: "XXX",
          corr: "C1",
          correcteddate: "XXX",
          createddate: "XXX",
          docnumber: "ABC",
          docnumeric: "1000",
          docsubtype: "Industry Connection Report",
          doctitle: "Main Title<br/>in multiple lines",
          doctype: "Whitepaper",
          docyear: "2001",
          draft: "3.4",
          draft_month: "July",
          draft_year: "2018",
          draftinfo: " (draft 3.4, 2000-01-01)",
          edition: "2",
          feedback_endeddate: "01 Aug 2018",
          full_doctitle: "Draft Whitepaper for Main Title<br/>in multiple lines",
          ieee_sasb_approveddate: "&lt;Date Approved&gt;",
          implementeddate: "XXX",
          isbn_pdf: "GHI",
          isbn_print: "JKL",
          issueddate: "01 Jul 2018",
          iteration: "3",
          keywords: ["word2", "word1"],
          lang: "en",
          obsoleteddate: "XXX",
          program: "HIJ",
          provenance_doctitle: "Revision of ABC<br/>Incorporates BCD and EFG",
          publisheddate: "01 Sep 2018",
          publisher: "Institute of Electrical and Electronic Engineers",
          receiveddate: "XXX",
          revdate: "2000-01-01",
          revdate_monthyear: "January 2000",
          script: "Latn",
          society: "Society",
          stable_untildate: "XXX",
          stage: "Final Draft",
          stage_display: "Final Draft",
          stageabbr: "FD",
          stdid_pdf: "ABC",
          stdid_print: "DEF",
          technical_committee: "Tech Committee",
          transmitteddate: "XXX",
          trial_use: true,
          unchangeddate: "XXX",
          unpublished: true,
          updateddate: "XXX",
          vote_endeddate: "XXX",
          vote_starteddate: "XXX",
          working_group: "WG",
          wp_image001_emz: File.join(logoloc, "wp_image001_icr.emz"),
          wp_image003_emz: File.join(logoloc, "wp_image003_icr.emz"),
          wp_image007_emz: File.join(logoloc, "wp_image007_icr.emz"),
          wp_image008_emz: File.join(logoloc, "wp_image008_icr.emz") },
      )
  end

  it "processes metadata with no nominated contributors or scoped identifiers" do
    csdc = IsoDoc::Ieee::HtmlConvert.new({})
    docxml, = csdc.convert_init(<<~INPUT, "test", true)
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
        <date type='published' format="ddMMMyyyy">01 Sep 2018</date>
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
        <subdoctype>document</subdoctype>
          <trial-use>false</trial-use>
          <editorialgroup>
            <society>Society</society>
            <balloting-group type="individual">BG</balloting-group>
            <working-group>WG</working-group>
            <committee>Tech Committee</committee>
          </editorialgroup>
        </ext>
      </bibdata>
         <metanorma-extension>
         <semantic-metadata>
         <stage-published>false</stage-published>
         </semantic-metadata>
         </metanorma-extension>
      <preface/><sections/>
      <annex obligation="informative"/>
      </ieee-standard>
    INPUT
    # expect(htmlencode(metadata(csdc.info(docxml, nil))#.to_s
    # .gsub(", :", ",\n:"))).to be_equivalent_to <<~"OUTPUT"
    expect(metadata(csdc.info(docxml, nil)))
      .to be_equivalent_to(
        { abbrev_doctitle: "Draft Rec. Prac. for Main Title<br/>in multiple lines",
          accesseddate: "XXX",
          adapteddate: "XXX",
          announceddate: "XXX",
          circulateddate: "XXX",
          confirmeddate: "XXX",
          copieddate: "XXX",
          correcteddate: "XXX",
          createddate: "XXX",
          docnumeric: "1000",
          docsubtype: "Document",
          doctitle: "Main Title<br/>in multiple lines",
          doctype: "Recommended Practice",
          doctype_abbrev: "Rec. Prac.",
          docyear: "2001",
          draft: "3.4",
          draft_month: "January",
          draft_year: "2000",
          draftinfo: " (draft 3.4, 2000-01-01)",
          edition: "2",
          full_doctitle: "Draft Recommended Practice for Main Title<br/>in multiple lines",
          ieee_sasb_approveddate: "&lt;Date Approved&gt;",
          implementeddate: "XXX",
          isbn_pdf: "978-0-XXXX-XXXX-X",
          isbn_print: "978-0-XXXX-XXXX-X",
          issueddate: "XXX",
          iteration: "3",
          keywords: ["word2", "word1"],
          lang: "en",
          obsoleteddate: "XXX",
          publisheddate: "01 Sep 2018",
          receiveddate: "XXX",
          revdate: "2000-01-01",
          revdate_monthyear: "January 2000",
          script: "Latn",
          society: "&lt;Society&gt;",
          stable_untildate: "XXX",
          stage: "Final Draft",
          stage_display: "Final Draft",
          stageabbr: "FD",
          stdid_pdf: "STDXXXXX",
          stdid_print: "STDPDXXXXX",
          technical_committee: "&lt;Committee Name&gt;",
          transmitteddate: "XXX",
          unchangeddate: "XXX",
          unpublished: true,
          updateddate: "XXX",
          vote_endeddate: "XXX",
          vote_starteddate: "XXX",
          wp_image001_emz: File.join(logoloc, "wp_image001.emz"),
          wp_image003_emz: File.join(logoloc, "wp_image003.emz"),
          wp_image007_emz: File.join(logoloc, "wp_image007.emz"),
          wp_image008_emz: File.join(logoloc, "wp_image008.emz") },
      )
  end
end
