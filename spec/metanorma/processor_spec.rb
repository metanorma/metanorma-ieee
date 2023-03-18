require "spec_helper"
require "metanorma"

RSpec.describe Metanorma::IEEE::Processor do
  registry = Metanorma::Registry.instance
  registry.register(Metanorma::IEEE::Processor)
  processor = registry.find_processor(:ieee)

  inputxml = <<~INPUT
      <ieee-standard xmlns="http://riboseinc.com/isoxml">
      <sections>
        <terms id="H" obligation="normative"><title>Terms</title>
          <term id="J">
            <name>1.1.</name>
            <preferred>Term2</preferred>
          </term>
        </terms>
        <preface/>
      </sections>
    </ieee-standard>
  INPUT

  it "registers against metanorma" do
    expect(processor).not_to be nil
  end

  it "registers output formats against metanorma" do
    expect(processor.output_formats.sort.to_s).to be_equivalent_to <<~"OUTPUT"
      [[:doc, "doc"], [:html, "html"], [:ieee, "ieee.xml"], [:pdf, "pdf"], [:presentation, "presentation.xml"], [:rxl, "rxl"], [:xml, "xml"]]
    OUTPUT
  end

  it "registers version against metanorma" do
    expect(processor.version.to_s).to match(%r{^Metanorma::IEEE })
  end

  it "generates IsoDoc XML from a blank document" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}
    INPUT
    output = <<~OUTPUT
        #{blank_hdr_gen}
        <sections/>
      </ieee-standard>
    OUTPUT
    expect(xmlpp(strip_guid(processor.input_to_isodoc(input, nil))))
      .to be_equivalent_to xmlpp(output)
  end

  it "generates HTML from IsoDoc XML" do
    FileUtils.rm_f "test.xml"
    processor.output(inputxml, "test.xml", "test.html", :html)
    expect(xmlpp(strip_guid(File.read("test.html", encoding: "utf-8")
      .gsub(%r{^.*<main}m, "<main")
      .gsub(%r{</main>.*}m, "</main>"))))
      .to be_equivalent_to xmlpp(<<~"OUTPUT")
        <main class='main-section'>
          <button onclick='topFunction()' id='myBtn' title='Go to top'>Top</button>
          <p class='zzSTDTitle1'/>
          <div id='H'>
            <h1 id='_'>Terms</h1>
            <h2 class='TermNum' id='J'>1.1.</h2>
            <p class='Terms' style='text-align:left;'>Term2</p>
          </div>
        </main>
      OUTPUT
  end

  it "generates IEEE XML from Metanorma XML" do
    FileUtils.rm_f "test.xml"
    FileUtils.rm_f "test.ieee.xml"
    File.write("test.xml", inputxml)
    processor.output(inputxml, "test.xml", "test.ieee.xml", :ieee)
    expect(File.exist?("test.ieee.xml")).to be true
    FileUtils.rm_f "test.ieee.xml"
    begin
    expect do
      processor.output(inputxml, "test.xml", "test.ieee.xml", :ieee,
                       { ieeedtd: "XXX" })
    end.to raise_error StandardError
    rescue StandardError
    end
  end
end
