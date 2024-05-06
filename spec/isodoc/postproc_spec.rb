require "spec_helper"

RSpec.describe IsoDoc::IEEE do
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
    expect(xmlpp(IsoDoc::IEEE::HtmlConvert
      .new(htmlcoverpage: nil,
           htmlintropage: nil,
           bare: true,
           filename: "test")
       .html_cleanup(Nokogiri::XML(input)).to_xml)
       .sub(/^.*<main/m, "<main").sub(%r{</main>.*$}m, "</main>"))
      .to be_equivalent_to xmlpp(doc)
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
               <p class='IEEEStdsAbstractBody' style="font-family: 'Arial', sans-serif;">Abstract text</p>
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
    expect(xmlpp(IsoDoc::IEEE::WordConvert
      .new(wordcoverpage: nil,
           wordintropage: nil,
           filename: "test")
       .word_cleanup(Nokogiri::XML(input)).to_xml)
       .sub(/^.*<main/m, "<main").sub(%r{</main>.*$}m, "</main>"))
      .to be_equivalent_to xmlpp(doc)
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
    expect(xmlpp(IsoDoc::IEEE::WordConvert
      .new(wordcoverpage: nil,
           wordintropage: nil,
           filename: "test")
   .word_cleanup(Nokogiri::XML(input)).to_xml)
   .sub(/^.*<main/m, "<main").sub(%r{</main>.*$}m, "</main>"))
      .to be_equivalent_to xmlpp(doc)
  end

  it "moves introduction in Word" do
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
          <div class='main-section'>
            <hr/>
            <div id='x'>
              <p class='IEEEStdsLevel1Header'>Introduction</p>
              <div class='Admonition'>Introduction Admonition</div>
              <p class='IEEEStdsParagraph'>Introduction text</p>
            </div>
          </div>
        </body>
      </html>
    OUTPUT
    expect(xmlpp(IsoDoc::IEEE::WordConvert
      .new(wordcoverpage: nil,
           wordintropage: nil,
           filename: "test")
       .word_cleanup(Nokogiri::XML(input)).to_xml)
       .sub(/^.*<main/m, "<main").sub(%r{</main>.*$}m, "</main>"))
      .to be_equivalent_to xmlpp(doc)
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
    expect(xmlpp(IsoDoc::IEEE::WordConvert
       .new(wordcoverpage: nil,
            wordintropage: nil,
            filename: "test")
        .word_cleanup(Nokogiri::XML(input)).to_xml)
        .sub(/^.*<main/m, "<main").sub(%r{</main>.*$}m, "</main>"))
      .to be_equivalent_to xmlpp(doc)
  end

  private

  def mock_populate_template
    allow_any_instance_of(::IsoDoc::WordFunction::Postprocess)
      .to receive(:populate_template)
      .with(anything, anything)
      .and_return nil
  end
end
