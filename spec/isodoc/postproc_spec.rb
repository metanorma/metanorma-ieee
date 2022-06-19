require "spec_helper"

RSpec.describe IsoDoc::IEEE do
  it "moves abstract in Word" do
    mock_populate_template
    input = <<~INPUT
      <html>
      <head/>
      <body>
      <div class="WordSection1"><p/></div>
      <div class="WordSection2"><p/></div>
      <div class="main-section">
      <div id="x"> <h1 class="AbstractTitle">Abstract</h1>
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
          <div class='WordSection1'>
            <p/>
          </div>
          <div class='WordSection2'>
            <p/>
          </div>
          <div class='main-section'>
            <hr/>
            <div id='abstract-destination'>
              <p class='IEEEStdsAbstractBody'>
                <span class='IEEEStdsAbstractHeader'>
                  <span lang='EN-US'>Abstract:</span>
                </span>
                 Abstract text
              </p>
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
          <div class='WordSection1'>
            <p/>
          </div>
          <div class='WordSection2'>
            <p/>
          </div>
          <div class='main-section'>
            <div id='x' type='overview'>
              <h1>Overview</h1>
              <div id='x1' type='scope'>
                <h2>Overview</h2>
                <p>Abstract text</p>
              </div>
              <hr/>
              <div id='abstract-destination'>
                <p class='IEEEStdsAbstractBody'>
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

  private

  def mock_populate_template
    allow_any_instance_of(::IsoDoc::WordFunction::Postprocess)
      .to receive(:populate_template)
      .with(anything, anything)
      .and_return nil
  end
end
