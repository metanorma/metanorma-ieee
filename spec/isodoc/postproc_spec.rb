require "spec_helper"

RSpec.describe IsoDoc::Ieee do
  it "removes paragraph types in HTML" do
    mock_populate_template
    input = <<~INPUT
      <html>
      <head/>
      <body>
      <div class="title-section"><p/></div>
      <div class="WordSection2"><p/></div>
      <div class="main-section">
      <br/>
      <div id="x" class="abstract">
      <h1 class="AbstractTitle">Abstract</h1>
      <p type="sometype">Abstract text</p>
      </div>
      <hr/>
      <div id="abstract-destination"/>
      </div>
      </body>
      </html>
    INPUT
    doc = <<~OUTPUT
      <main class='main-section'>
        <br/>
        <div id='x' class='abstract'>
          <h1 class='AbstractTitle'><a class="anchor" href="#x"/><a class="header" href="#x">Abstract</a></h1>
          <p>Abstract text</p>
        </div>
        <hr/>
        <div id='abstract-destination'/>
      </main>
    OUTPUT
    expect(Canon.format_xml(IsoDoc::Ieee::HtmlConvert
      .new(htmlcoverpage: nil,
           htmlintropage: nil,
           bare: true,
           filename: "test")
       .html_cleanup(Nokogiri::XML(input)).to_xml)
       .sub(/^.*<main/m, "<main").sub(%r{</main>.*$}m, "</main>"))
      .to be_equivalent_to Canon.format_xml(doc)
  end

  it "moves abstract in Word, and style abstracts" do
    mock_populate_template
    input = <<~INPUT
      <html>
      <head/>
      <body>
      <div class="WordSection1"><p/></div>
      <div class="WordSection2"><p/></div>
      <div class="main-section">
      <br/>
      <div id="x" class="abstract">
      <h1 class="AbstractTitle">Abstract</h1>
      <p>Abstract text</p>A
      <ul><li><p>X</p></li></ul>
      </div>
      <hr/>
      <div id="abstract-destination"/>
      </div>
      </body>
      </html>
    INPUT
    doc = <<~OUTPUT
      <html>
        <head/>
        <body>
          <div class='main-section'>
            <hr/>
            <div id='abstract-destination'>
               <p class='IEEEStdsAbstractBody' style="font-family: 'Arial', sans-serif;"><span class="IEEEStdsAbstractHeader"><span lang="EN-US">Abstract:</span></span> Abstract text</p>
               <ul>
                 <li>
                   <p style="font-family: 'Arial', sans-serif;" class='IEEEStdsAbstractBody'>X</p>
                 </li>
               </ul>
            </div>
          </div>
        </body>
      </html>
    OUTPUT
    expect(Canon.format_xml(IsoDoc::Ieee::WordConvert
      .new(wordcoverpage: nil,
           wordintropage: nil,
           filename: "test")
       .word_cleanup(Nokogiri::XML(input)).to_xml)
       .sub(/^.*<main/m, "<main").sub(%r{</main>.*$}m, "</main>"))
      .to be_equivalent_to Canon.format_xml(doc)

    input = <<~INPUT
      <html>
      <head/>
      <body>
      <div class="WordSection1"><p/></div>
      <div class="WordSection2"><p/></div>
      <div class="main-section">
      <br/>
      <div id="x" class="abstract"/>
      <hr/>
      <div id="abstract-destination"/>
      </div>
      </body>
      </html>
    INPUT
    doc = <<~OUTPUT
      <html>
        <head/>
        <body>
          <div class='main-section'>
            <hr/>
            <div id='abstract-destination'/>
          </div>
        </body>
      </html>
    OUTPUT
    expect(Canon.format_xml(IsoDoc::Ieee::WordConvert
      .new(wordcoverpage: nil,
           wordintropage: nil,
           filename: "test")
       .word_cleanup(Nokogiri::XML(input)).to_xml)
       .sub(/^.*<main/m, "<main").sub(%r{</main>.*$}m, "</main>"))
      .to be_equivalent_to Canon.format_xml(doc)
  end

  it "copies scope in Word in the absence of abstract" do
    mock_populate_template
    input = <<~INPUT
      <html>
      <head/>
      <body>
      <div class="WordSection1"><p/></div>
      <div class="WordSection2"><p/></div>
      <div class="main-section">
      <div id="x" type="overview"> <h1>Overview</h1>
      <div id="x1" type="scope"> <h2>Overview</h2>
      <p>Abstract text</p>
      </div>
      <hr/>
      <div id="abstract-destination"/>
      </div>
      </body>
      </html>
    INPUT
    doc = <<~OUTPUT
          <html>
        <head/>
        <body>
          <div class='main-section'>
            <div id='x' type='overview'>
              <p class='IEEEStdsLevel1Header'>Overview</p>
              <div id='x1' type='scope'>
                <p class='IEEEStdsLevel2Header'>Overview</p>
                <p class='IEEEStdsParagraph'>Abstract text</p>
              </div>
              <hr/>
              <div id='abstract-destination'>
                <p class='IEEEStdsAbstractBody' style="font-family: 'Arial', sans-serif;">
                  <span class='IEEEStdsAbstractHeader'>
                    <span lang='EN-US'>Abstract:</span>
                  </span>
                   Abstract text
                </p>
              </div>
            </div>
          </div>
        </body>
      </html>
    OUTPUT
    expect(Canon.format_xml(IsoDoc::Ieee::WordConvert
      .new(wordcoverpage: nil,
           wordintropage: nil,
           filename: "test")
   .word_cleanup(Nokogiri::XML(input)).to_xml)
   .sub(/^.*<main/m, "<main").sub(%r{</main>.*$}m, "</main>"))
      .to be_equivalent_to Canon.format_xml(doc)
  end

  it "moves introductory material in Word" do
    mock_populate_template
    input = <<~INPUT
      <html>
      <head/>
      <body>
      <div class="WordSection1"><p/></div>
      <div class="WordSection2"><p/></div>
      <div class="main-section">
      <br/>
      <div id="x">
      <h1 class="IntroTitle">Introduction</h1>
      <div class="Admonition">Introduction Admonition</div>
      <p>Introduction text</p>
      <h1 class="IntroTitle">Introduction 2</h1>
      </div>
      <div id="y">
      <h1 class="IntroTitle">Acknowledgements</h1>
      <p>As given</p>
      </div>
      <hr/>
      <div id="introduction-destination"/>
      </div>
      </body>
      </html>
    INPUT
    doc = <<~OUTPUT
      <html>
          <head/>
          <body>
             <div class="main-section">
                <hr/>
                <div id="x">
                   <p class="IEEEStdsLevel1Header">Introduction</p>
                   <div class="Admonition">Introduction Admonition</div>
                   <p class="IEEEStdsParagraph">Introduction text</p>
                   <p class="IEEEStdsLevel1Header">Introduction 2</p>
                </div>
                <div id="y">
                   <p class="IEEEStdsLevel1Header">Acknowledgements</p>
                   <p class="IEEEStdsParagraph">As given</p>
                </div>
             </div>
          </body>
       </html>
    OUTPUT
    expect(Canon.format_xml(IsoDoc::Ieee::WordConvert
      .new(wordcoverpage: nil,
           wordintropage: nil,
           filename: "test")
       .word_cleanup(Nokogiri::XML(input)).to_xml)
       .sub(/^.*<main/m, "<main").sub(%r{</main>.*$}m, "</main>"))
      .to be_equivalent_to Canon.format_xml(doc)
  end

  it "renders headings in Word" do
    mock_populate_template
    input = <<~INPUT
      <html>
      <head/>
      <body>
          <div class="WordSection1"><p/></div>
          <div class="WordSection2"><p/></div>
         <div class='WordSection14'>
           <div id='D'>
             <h1>1. <span style='mso-tab-count:1'>&#xa0; </span>Overview
             </h1>
             <p id='E'>Text</p>
             <div id='D1' type='scope'>
               <h2>1.1. <span style='mso-tab-count:1'>&#xa0; </span>Scope
               </h2>
             </div>
             <div id='D2' type='purpose'>
               <h3>
                 1.2. <span style='mso-tab-count:1'>&#xa0; </span>Purpose
               </h3>
               <h4>
                 1.3. <span style='mso-tab-count:1'>&#xa0; </span>Purpose #1
               </h4>
             </div>
           </div>
           </body></html>
    INPUT
    doc = <<~OUTPUT
      <html>
         <head/>
         <body>
           <div class='WordSection1'>
             <div id='D'>
               <p class='IEEEStdsLevel1Header'>Overview </p>
               <p id='E' class='IEEEStdsParagraph'>Text</p>
               <div id='D1' type='scope'>
                 <p class='IEEEStdsLevel2Header'>Scope </p>
               </div>
               <div id='D2' type='purpose'>
                 <p class='IEEEStdsLevel3Header'>Purpose </p>
                 <p class='IEEEStdsLevel4Header'>Purpose #1 </p>
               </div>
             </div>
           </div>
         </body>
       </html>
    OUTPUT
    expect(Canon.format_xml(IsoDoc::Ieee::WordConvert
       .new(wordcoverpage: nil,
            wordintropage: nil,
            filename: "test")
        .word_cleanup(Nokogiri::XML(input)).to_xml)
        .sub(/^.*<main/m, "<main").sub(%r{</main>.*$}m, "</main>"))
      .to be_equivalent_to Canon.format_xml(doc)
  end

  it "populates Word ToC" do
    FileUtils.rm_rf "test.doc"
    IsoDoc::Ieee::WordConvert
      .new(wordcoverpage: nil,
           wordintropage: "spec/assets/wordintro.html",
           filename: "test")
      .convert("test", <<~INPUT, false)
        <iso-standard xmlns="http://riboseinc.com/isoxml">
          <metanorma-extension>
            <presentation-metadata>
            <toc-heading-levels>2</toc-heading-levels>
         <html-toc-heading-levels>2</html-toc-heading-levels>
         <doc-toc-heading-levels>3</doc-toc-heading-levels>
         <pdf-toc-heading-levels>2</pdf-toc-heading-levels>
            </presentation-metadata>
          </metanorma-extension>
          <preface><clause type="toc" id="_13d7055e-30fc-845a-c60e-8972faf092d9" displayorder="1"><fmt-title depth="1" id="_b7371af6-75a1-52fa-2891-5c5f9a06aa7c">Contents</fmt-title></clause></preface>
                  <sections>
                    <clause id="A" inline-header="false" obligation="normative" displayorder="1">
                      <fmt-title id="_">1
                        <tab/>
                        Clause 4</fmt-title>
                      <clause id="N" inline-header="false" obligation="normative">
                        <fmt-title id="_">1.1
                          <tab/>
                          Introduction
                          <bookmark id="Q"/>
                          to this
                          <fn reference="1" id="F1">
                            <p id="_ff27c067-2785-4551-96cf-0a73530ff1e6">Formerly denoted as 15 % (m/m).</p><fmt-fn-label><semx source="F1">1</semx></fmt-fn-label></fn>
                        </fmt-title>
                      </clause>
                      <clause id="O" inline-header="false" obligation="normative">
                        <fmt-title id="_">1.2
                          <tab/>
                          Clause 4.2</fmt-title>
                        <p>A
                          <fn reference="1" id="F2">
                            <p id="_ff27c067-2785-4551-96cf-0a73530ff1e6">Formerly denoted as 15 % (m/m).</p><fmt-fn-label><semx source="F2">1</semx></fmt-fn-label></fn>
                        </p>
                      </clause>
                    </clause>
                  </sections>
                  <annex id="AA" displayorder="2"><fmt-title id="_">Annex First</fmt-title></annex>
                </iso-standard>
    INPUT

    word = File.read("test.doc", encoding: "UTF-8")
      .sub(/^.*An empty word intro page\./m, "")
      .sub(%r{</div>.*$}m, "</div>")
      .gsub(/<o:p>&#xA0;<\/o:p>/, "")

    expect(Canon.format_xml("<div>#{word.gsub(/_Toc\d\d+/, '_Toc')}"))
      .to be_equivalent_to Canon.format_xml(<<~'OUTPUT')
        <div>
           WORDTOC
           <div class="WordSectionContents">
              <p class="IEEEStdsLevel1frontmatter">Contents</p>
              <p class="MsoToc1">
                 <span lang="EN-GB" xml:lang="EN-GB">
                    <span style="mso-element:field-begin"/>
                    <span style="mso-spacerun:yes"> </span>
                    TOC \o "1-3" \h \z \u
                    <span style="mso-element:field-separator"/>
                 </span>
                 <span class="MsoHyperlink">
                    <span lang="EN-GB" style="mso-no-proof:yes" xml:lang="EN-GB">
                       <a href="#_Toc">
                          1 Clause 4
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-tab-count:1 dotted">. </span>
                          </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-element:field-begin"/>
                          </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"> PAGEREF _Toc \h </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-element:field-separator"/>
                          </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">1</span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"/>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-element:field-end"/>
                          </span>
                       </a>
                    </span>
                 </span>
              </p>
              <p class="MsoToc2">
                 <span class="MsoHyperlink">
                    <span lang="EN-GB" style="mso-no-proof:yes" xml:lang="EN-GB">
                       <a href="#_Toc">
                          1.1 Introduction to this
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-tab-count:1 dotted">. </span>
                          </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-element:field-begin"/>
                          </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"> PAGEREF _Toc \h </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-element:field-separator"/>
                          </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">1</span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"/>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-element:field-end"/>
                          </span>
                       </a>
                    </span>
                 </span>
              </p>
              <p class="MsoToc2">
                 <span class="MsoHyperlink">
                    <span lang="EN-GB" style="mso-no-proof:yes" xml:lang="EN-GB">
                       <a href="#_Toc">
                          1.2 Clause 4.2
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-tab-count:1 dotted">. </span>
                          </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-element:field-begin"/>
                          </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"> PAGEREF _Toc \h </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-element:field-separator"/>
                          </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">1</span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"/>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-element:field-end"/>
                          </span>
                       </a>
                    </span>
                 </span>
              </p>
              <p class="MsoToc1">
                 <span class="MsoHyperlink">
                    <span lang="EN-GB" style="mso-no-proof:yes" xml:lang="EN-GB">
                       <a href="#_Toc">
                          Annex A Annex First
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-tab-count:1 dotted">. </span>
                          </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-element:field-begin"/>
                          </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"> PAGEREF _Toc \h </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-element:field-separator"/>
                          </span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">1</span>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"/>
                          <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                             <span style="mso-element:field-end"/>
                          </span>
                       </a>
                    </span>
                 </span>
              </p>
              <p class="MsoToc1">
                 <span lang="EN-GB" xml:lang="EN-GB">
                    <span style="mso-element:field-end"/>
                 </span>
                 <span lang="EN-GB" xml:lang="EN-GB">
                    <o:p class="MsoNormal"> </o:p>
                 </span>
              </p>
           </div>
        </div>
      OUTPUT
  end

  private

  def mock_populate_template
    allow_any_instance_of(::IsoDoc::WordFunction::Postprocess)
      .to receive(:populate_template)
      .with(anything, anything)
      .and_return nil
  end
end
