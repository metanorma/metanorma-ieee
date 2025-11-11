# encoding: utf-8

require "spec_helper"

RSpec.describe Relaton::Render::Ieee do
  it "renders book, five editors" do
    input = <<~INPUT
      <bibitem type="book">
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
    INPUT
    output = <<~OUTPUT
      <formattedref>Aluffi, P., D. Anderson, M. Hering, M. Mustaţă, and S. Payne, <em>Facets of Algebraic Geometry: A Collection in Honor of William Fulton's 80th Birthday</em>, first edition, Cambridge, UK: Cambridge University Press, 2022, DOI: https://doi.org/10.1017/9781108877831.</formattedref>
    OUTPUT
    expect(renderer.render(input))
      .to be_equivalent_to output
  end

  it "renders book, eleven editors" do
    input = <<~INPUT
      <bibitem type="book">
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
        <contributor>
          <role type="editor"/>
          <person>
            <name><surname>Dopey</surname><forename>Paolo</forename></name>
          </person>
        </contributor>
                <contributor>
          <role type="editor"/>
          <person>
            <name><surname>Grumpy</surname><forename>David</forename></name>
          </person>
        </contributor>
        <contributor>
          <role type="editor"/>
          <person>
            <name><surname>Sneezy</surname><forename>Milena</forename></name>
          </person>
        </contributor>
        <contributor>
          <role type="editor"/>
          <person>
            <name><surname>Happy</surname><forename>Mircea</forename></name>
          </person>
        </contributor>
        <contributor>
          <role type="editor"/>
          <person>
            <name><surname>Doc</surname><forename>Sam</forename></name>
          </person>
        </contributor>
        <contributor>
          <role type="editor"/>
          <person>
            <name><surname>Sleepy</surname><forename>Sam</forename></name>
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
    INPUT
    output = <<~OUTPUT
      <formattedref>Aluffi, P., D. Anderson, M. Hering <em>et al.</em>, <em>Facets of Algebraic Geometry: A Collection in Honor of William Fulton's 80th Birthday</em>, first edition, Cambridge, UK: Cambridge University Press, 2022, DOI: https://doi.org/10.1017/9781108877831.</formattedref>
    OUTPUT
    expect(renderer.render(input))
      .to be_equivalent_to output
  end

  it "renders incollection, two authors" do
    input = <<~INPUT
      <bibitem type="incollection">
        <title>Object play in great apes: Studies in nature and captivity</title>
        <date type="published"><on>2005</on></date>
        <date type="accessed"><on>2019-09-03</on></date>
        <contributor>
          <role type="author"/>
          <person>
            <name>
              <surname>Ramsey</surname>
              <formatted-initials>J. K.</formatted-initials>
            </name>
          </person>
        </contributor>
        <contributor>
          <role type="author"/>
          <person>
            <name>
              <surname>McGrew</surname>
              <formatted-initials>W. C.</formatted-initials>
            </name>
          </person>
        </contributor>
        <relation type="includedIn">
          <bibitem>
            <title>The nature of play: Great apes and humans</title>
            <contributor>
              <role type="editor"/>
              <person>
                <name>
                  <surname>Pellegrini</surname>
                  <forename>Anthony</forename>
                  <forename>D.</forename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="editor"/>
              <person>
                <name>
                  <surname>Smith</surname>
                  <forename>Peter</forename>
                  <forename>K.</forename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="publisher"/>
              <organization>
                <name>Guilford Press</name>
              </organization>
            </contributor>
            <edition>3</edition>
            <medium>
              <form>electronic resource</form>
              <size>8vo</size>
            </medium>
            <place>New York, NY</place>
          </bibitem>
        </relation>
        <extent>
          <locality type="page">
          <referenceFrom>89</referenceFrom>
          <referenceTo>112</referenceTo>
          </locality>
        </extent>
      </bibitem>
    INPUT
    output = <<~OUTPUT
      <formattedref>Ramsey, J. K., and W. C. McGrew, “Object play in great apes: Studies in nature and captivity,” in Pellegrini, A. D., and P. K. Smith (eds.): <em>The nature of play: Great apes and humans</em>, New York, NY: Guilford Press, 2005, pp. 89–112, accessed September 3, 2019.</formattedref>
    OUTPUT
    expect(renderer.render(input))
      .to be_equivalent_to output
  end

  it "renders journal" do
    input = <<~INPUT
      <bibitem type="journal">
        <title>Nature</title>
        <date type="published"><from>2005</from><to>2009</to></date>
      </bibitem>
    INPUT
    output = <<~OUTPUT
      <formattedref><em>Nature</em>, 2005&#x2013;2009.</formattedref>
    OUTPUT
    expect(renderer.render(input))
      .to be_equivalent_to output
  end

  it "renders article" do
    input = <<~INPUT
      <bibitem type="article">
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
        <partnumber>472</partnumber>
        <run>N.S.</run>
        </series>
            <contributor>
              <role type="publisher"/>
              <organization>
                <name>Cambridge University Press</name>
              </organization>
            </contributor>
            <place>Cambridge, UK</place>
            <extent>
                <localityStack>
                  <locality type="volume"><referenceFrom>1</referenceFrom></locality>
                  <locality type="issue"><referenceFrom>7</referenceFrom></locality>
        <locality type="page">
          <referenceFrom>89</referenceFrom>
          <referenceTo>112</referenceTo>
        </locality>
                </localityStack>
            </extent>
      </bibitem>
    INPUT
    output = <<~OUTPUT
      <formattedref>Aluffi, P., D. Anderson, M. Hering, M. Mustaţă, and S. Payne, “Facets of Algebraic Geometry: A Collection in Honor of William Fulton's 80th Birthday,” <em><em>London Mathematical Society Lecture Note Series</em> (N.S.)</em>, vol. 1 no. 7, pp. 89–112, 2022, DOI: https://doi.org/10.1017/9781108877831.</formattedref>
    OUTPUT
    expect(renderer.render(input))
      .to be_equivalent_to output
  end

  it "renders software" do
      input = <<~INPUT
        <bibitem type="software">
          <title>metanorma-standoc</title>
          <uri>https://github.com/metanorma/metanorma-standoc</uri>
          <date type="published"><on>2019-09-04</on></date>
          <date type="accessed"><on>2023-09-06</on></date>
          <contributor>
            <role type="author"/>
            <organization>
              <name>Ribose Inc.</name>
            </organization>
          </contributor>
          <contributor>
            <role type="distributor"/>
            <organization>
              <name>GitHub</name>
            </organization>
          </contributor>
          <edition>1.3.1</edition>
        </bibitem>
      INPUT
      output = <<~OUTPUT
        <formattedref>Ribose Inc., “metanorma-standoc,” 2019, accessed September 6, 2023, <fmt-link target='https://github.com/metanorma/metanorma-standoc'>https://github.com/metanorma/metanorma-standoc</fmt-link>.</formattedref>
      OUTPUT
      expect(renderer.render(input))
        .to be_equivalent_to output
  end

  it "renders home standard" do
    input = <<~INPUT
         <bibitem type="standard" schema-version="v1.2.1">
              <fetched>2022-12-22</fetched>
        <title type="title-intro" format="text/plain" language="en" script="Latn">Latex, rubber</title>
        <title type="title-main" format="text/plain" language="en" script="Latn">Determination of total solids content</title>
        <title type="main" format="text/plain" language="en" script="Latn">Latex, rubber - Determination of total solids content</title>
        <title type="title-intro" format="text/plain" language="fr" script="Latn">Latex de caoutchouc</title>
        <title type="title-main" format="text/plain" language="fr" script="Latn">Détermination des matières solides totales</title>
        <title type="main" format="text/plain" language="fr" script="Latn">Latex de caoutchouc - Détermination des matières solides totales</title>
        <uri type="src">https://www.iso.org/standard/61884.html</uri>
        <uri type="obp">https://www.iso.org/obp/ui/#!iso:std:61884:en</uri>
        <uri type="rss">https://www.iso.org/contents/data/standard/06/18/61884.detail.rss</uri>
        <docidentifier type="ISO" primary="true">ISO 124</docidentifier>
        <docidentifier type="URN">urn:iso:std:iso:124:ed-7</docidentifier>
        <docnumber>124</docnumber>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Organization for Standardization</name>
            <abbreviation>ISO</abbreviation>
            <uri>www.iso.org</uri>
          </organization>
        </contributor>
        <edition>7</edition>
        <language>en</language>
        <language>fr</language>
        <script>Latn</script>
        <status>
          <stage>90</stage>
          <substage>93</substage>
        </status>
        <copyright>
          <from>2014</from>
          <owner>
            <organization>
              <name>ISO</name>
            </organization>
          </owner>
        </copyright>
        <relation type="obsoletes">
          <bibitem type="standard">
            <formattedref format="text/plain">ISO 124:2011</formattedref>
            <docidentifier type="ISO" primary="true">ISO 124:2011</docidentifier>
          </bibitem>
        </relation>
        <place>Geneva</place>
        <ext schema-version="v1.0.0">
          <doctype>international-standard</doctype>
          <editorialgroup>
            <technical-committee number="45" type="TC">Raw materials (including latex) for use in the rubber industry</technical-committee>
          </editorialgroup>
          <ics>
            <code>83.040.10</code>
            <text>Latex and raw rubber</text>
          </ics>
          <structuredidentifier type="ISO">
            <project-number>ISO 124</project-number>
          </structuredidentifier>
        </ext>
      </bibitem>
    INPUT
    output = <<~OUTPUT
      <formattedref>Latex, rubber - Determination of total solids content.</formattedref>
    OUTPUT
    expect(renderer.render(input))
      .to be_equivalent_to output
  end

  it "renders external standard" do
    input = <<~INPUT
      <bibitem type="standard">
        <fetched>2022-12-22</fetched>
        <title type="main" format="text/plain">Intellectual Property Rights in IETF Technology</title>
        <uri type="src">https://www.rfc-editor.org/info/rfc3979</uri>
        <docidentifier type="IETF" primary="true">RFC 3979</docidentifier>
        <docidentifier type="DOI">10.17487/RFC3979</docidentifier>
        <docnumber>RFC3979</docnumber>
        <date type="published">
          <on>2005-03</on>
        </date>
        <contributor>
          <role type="editor"/>
          <person>
            <name>
              <completename language="en" script="Latn">S. Bradner</completename>
            </name>
          </person>
        </contributor>
        <contributor>
          <role type="authorizer"/>
          <organization>
            <name>RFC Series</name>
          </organization>
        </contributor>
        <language>en</language>
        <script>Latn</script>
        <abstract format="text/html" language="en" script="Latn">
          <p>The IETF policies about Intellectual Property Rights (IPR), such as patent rights, relative to technologies developed in the IETF are designed to ensure that IETF working groups and participants have as much information about any IPR constraints on a technical proposal as possible.  The policies are also intended to benefit the Internet community and the public at large, while respecting the legitimate rights of IPR holders.  This memo details the IETF policies concerning IPR related to technology worked on within the IETF.  It also describes the objectives that the policies are designed to meet.  This memo updates RFC 2026 and, with RFC 3978, replaces Section 10 of RFC 2026.  This memo also updates paragraph 4 of Section 3.2 of RFC 2028, for all purposes, including reference [2] in RFC 2418.  This document specifies an Internet Best Current Practices for the Internet Community, and requests discussion and suggestions for improvements.</p>
        </abstract>
        <relation type="obsoletedBy">
          <bibitem>
            <formattedref format="text/plain">RFC8179</formattedref>
            <docidentifier type="IETF" primary="true">RFC8179</docidentifier>
          </bibitem>
        </relation>
        <relation type="updates">
          <bibitem>
            <formattedref format="text/plain">RFC2026</formattedref>
            <docidentifier type="IETF" primary="true">RFC2026</docidentifier>
          </bibitem>
        </relation>
        <relation type="updates">
          <bibitem>
            <formattedref format="text/plain">RFC2028</formattedref>
            <docidentifier type="IETF" primary="true">RFC2028</docidentifier>
          </bibitem>
        </relation>
        <series>
          <title format="text/plain">RFC</title>
          <number>3979</number>
        </series>
        <keyword>ipr</keyword>
        <keyword>copyright</keyword>
        <ext schema-version="v1.0.0">
          <editorialgroup>
            <committee>ipr</committee>
          </editorialgroup>
        </ext>
      </bibitem>
    INPUT
    output = <<~OUTPUT
    <formattedref>Intellectual Property Rights in IETF Technology, <fmt-link target='https://www.rfc-editor.org/info/rfc3979'>https://www.rfc-editor.org/info/rfc3979</fmt-link>.</formattedref>
    OUTPUT
    expect(renderer.render(input))
      .to be_equivalent_to output
  end

  it "renders dataset" do
    input = <<~INPUT
      <bibitem type="dataset">
        <title>Children of Immigrants. Longitudinal Sudy (CILS) 1991–2006 ICPSR20520</title>
        <uri>https://doi.org/10.3886/ICPSR20520.v2</uri>
        <date type="published"><on>2012-01-23</on></date>
        <date type="accessed"><on>2018-05-06</on></date>
        <contributor>
          <role type="author"/>
          <person>
            <name><surname>Portes</surname><forename>Alejandro</forename></name>
          </person>
        </contributor>
        <contributor>
          <role type="author"/>
          <person>
            <name><surname>Rumbaut</surname><forename>Rubén</forename><forename>G.</forename></name>
          </person>
        </contributor>
        <contributor>
          <role type="distributor"/>
          <organization>
            <name>Inter-University Consortium for Political and Social Research</name>
          </organization>
        </contributor>
        <edition>2</edition>
        <medium>
          <genre>dataset</genre>
        </medium>
          <size>
            <value type="data">501 GB</value>
          </size>
      </bibitem>
    INPUT
    output = <<~OUTPUT
    <formattedref>Portes, A., and R. G. Rumbaut, “Children of Immigrants. Longitudinal Sudy (CILS) 1991–2006 ICPSR20520,” Dataset, 2012, accessed May 6, 2018, <fmt-link target='https://doi.org/10.3886/ICPSR20520.v2'>https://doi.org/10.3886/ICPSR20520.v2</fmt-link>.</formattedref>
    OUTPUT
    expect(renderer.render(input))
      .to be_equivalent_to output
  end

  it "renders website" do
    input = <<~INPUT
      <bibitem type="website">
        <title>Language Log</title>
        <uri>https://languagelog.ldc.upenn.edu/nll/</uri>
        <date type="published"><from>2003</from></date>
        <date type="accessed"><on>2019-09-03</on></date>
        <contributor>
          <role type="author"/>
          <person>
            <name><surname>Liberman</surname><forename>Mark</forename></name>
          </person>
        </contributor>
        <contributor>
          <role type="author"/>
          <person>
            <name><surname>Pullum</surname><forename>Geoffrey</forename></name>
          </person>
        </contributor>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>University of Pennsylvania</name>
          </organization>
        </contributor>
      </bibitem>
    INPUT
    output = <<~OUTPUT
    <formattedref>Liberman, M., and G. Pullum, “Language Log,” University of Pennsylvania, 2003–, accessed September 3, 2019, <fmt-link target='https://languagelog.ldc.upenn.edu/nll/'>https://languagelog.ldc.upenn.edu/nll/</fmt-link>.</formattedref>
    OUTPUT
    expect(renderer.render(input))
      .to be_equivalent_to output
  end

  it "renders unpublished" do
    input = <<~INPUT
      <bibitem type="unpublished">
        <title>Controlled manipulation of light by cooperativeresponse of atoms in an optical lattice</title>
        <uri>https://eprints.soton.ac.uk/338797/</uri>
        <date type="created"><on>2012</on></date>
        <date type="accessed"><on>2020-06-24</on></date>
        <contributor>
          <role type="author"/>
          <person>
            <name><surname>Jenkins</surname><formatted-initials>S.</formatted-initials></name>
          </person>
        </contributor>
        <contributor>
          <role type="author"/>
          <person>
            <name><surname>Ruostekoski</surname><forename>Janne</forename></name>
          </person>
        </contributor>
        <medium>
          <genre>preprint</genre>
        </medium>
      </bibitem>
    INPUT
    output = <<~OUTPUT
    <formattedref>Jenkins, S., and J. Ruostekoski, “Controlled manipulation of light by cooperativeresponse of atoms in an optical lattice,” Preprint, 2012, accessed June 24, 2020, <fmt-link target='https://eprints.soton.ac.uk/338797/'>https://eprints.soton.ac.uk/338797/</fmt-link>.</formattedref>
    OUTPUT
    expect(renderer.render(input))
      .to be_equivalent_to output
  end

  it "renders untyped" do
    input = <<~INPUT
      <bibitem>
        <title>Controlled manipulation of light by cooperativeresponse of atoms in an optical lattice</title>
        <uri>https://eprints.soton.ac.uk/338797/</uri>
        <date type="created"><on>2012</on></date>
        <date type="accessed"><on>2020-06-24</on></date>
        <contributor>
          <role type="author"/>
          <person>
            <name><surname>Jenkins</surname><formatted-initials>S.</formatted-initials></name>
          </person>
        </contributor>
        <contributor>
          <role type="author"/>
          <person>
            <name><surname>Ruostekoski</surname><forename>Janne</forename></name>
          </person>
        </contributor>
        <medium>
          <genre>preprint</genre>
        </medium>
      </bibitem>
    INPUT
    output = <<~OUTPUT
      <formattedref>Jenkins, S., and J. Ruostekoski, “Controlled manipulation of light by cooperativeresponse of atoms in an optical lattice,” Preprint, 2012, accessed June 24, 2020, <fmt-link target='https://eprints.soton.ac.uk/338797/'>https://eprints.soton.ac.uk/338797/</fmt-link>.</formattedref>
    OUTPUT
    expect(renderer.render(input))
      .to be_equivalent_to output
  end

  private

  def renderer
    i = IsoDoc::Ieee::PresentationXMLConvert.new({})
    i.i18n_init("en", "Latn", nil)
    Relaton::Render::Ieee::General.new(i18nhash: i.i18n.get)
  end
end
