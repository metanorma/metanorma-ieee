require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
  config.default_cassette_options = {
    clean_outdated_http_interactions: true,
    re_record_interval: 1512000,
    record: :once,
  }
end

require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "bundler/setup"
require "asciidoctor"
require "metanorma-ieee"
require "isodoc/ieee/html_convert"
require "metanorma/standoc/converter"
require "rspec/matchers"
require "equivalent-xml"
require "htmlentities"
require "metanorma"
require "metanorma/ieee"
require "rexml/document"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.around do |example|
    Dir.mktmpdir("rspec-") do |dir|
      ["spec/assets/", "spec/examples/", "spec/fixtures/"].each do |assets|
        tmp_assets = File.join(dir, assets)
        FileUtils.mkdir_p tmp_assets
        FileUtils.cp_r Dir.glob("#{assets}*"), tmp_assets
      end
      Dir.chdir(dir) { example.run }
    end
  end
end

OPTIONS = [backend: :ieee, header_footer: true].freeze

def metadata(xml)
  xml.sort.to_h.delete_if do |_k, v|
    v.nil? || (v.respond_to?(:empty?) && v.empty?)
  end
end

def htmlencode(xml)
  HTMLEntities.new.encode(xml, :hexadecimal)
    .gsub(/&#x3e;/, ">").gsub(/&#xa;/, "\n")
    .gsub(/&#x22;/, '"').gsub(/&#x3c;/, "<")
    .gsub(/&#x26;/, "&").gsub(/&#x27;/, "'")
    .gsub(/\\u(....)/) do |_s|
    "&#x#{$1.downcase};"
  end
end

def strip_guid(xml)
  xml.gsub(%r{ id=['"]_[^"']+['"]}, ' id="_"')
    .gsub(%r{ target=['"]_[^"']+['"]}, ' target="_"')
    .gsub(%r{ name=['"]_[^"']+['"]}, ' name="_"')
    .gsub(%r( href=['"]#[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{13}['"]), ' href="#_"')
    .gsub(%r( name=['"][0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{13}['"]), ' name="_"')
    .gsub(%r( name=['"]ftn[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{13}['"]), ' name="ftn_"')
    .gsub(%r( id=['"][0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{13}['"]), ' id="_"')
    .gsub(%r( id=['"]ftn[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{13}['"]), ' id="ftn_"')
    .gsub(%r( id=['"]fn:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{13}['"]), ' id="fn:_"')
    .gsub(%r[ src="([^/]+)/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\.], ' src="\\1/_.')
    .gsub(%r[ src='([^/]+)/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\.], " src='\\1/_.")
    .gsub(%r[mso-bookmark:_Ref\d+], "mso-bookmark:_Ref")
end

def xmlpp(xml)
  c = HTMLEntities.new
  xml &&= xml.split(/(&\S+?;)/).map do |n|
    if /^&\S+?;$/.match?(n)
      c.encode(c.decode(n), :hexadecimal)
    else n
    end
  end.join
  s = ""
  f = REXML::Formatters::Pretty.new(2)
  f.compact = true
  f.write(REXML::Document.new(xml), s)
  s
end

ASCIIDOC_BLANK_HDR = <<~"HDR".freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :novalid:

HDR

VALIDATING_BLANK_HDR = <<~"HDR".freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :no-isobib:

HDR

def boilerplate(xmldoc)
  file = File.read(
    File.join(File.dirname(__FILE__), "..", "lib", "metanorma", "ieee",
              "boilerplate.xml"), encoding: "utf-8"
  )
  conv = Metanorma::IEEE::Converter.new(nil, backend: :ieee,
                                             header_footer: true)
  conv.init(Asciidoctor::Document.new([]))
  ret = Nokogiri::XML(
    conv.boilerplate_isodoc(xmldoc).populate_template(file, nil)
    .gsub(/<p>/, "<p id='_'>")
    .gsub(/<p (?!id=)/, "<p id='_' ")
    .gsub(/<ol>/, "<ol id='_'>")
    .gsub(/<ul>/, "<ul id='_'>")
    .gsub(/<\/?membership>/, ""),
  )
  ret.at("//clause[@id='boilerplate_word_usage']").remove
  conv.smartquotes_cleanup(ret)
  strip_guid(ret.to_xml)
end

def ieeedoc(lang)
  script = case lang
           when "zh" then "Hans"
           else
             "Latn"
           end
  <<~"INPUT"
             <ieee-standard xmlns="http://riboseinc.com/isoxml">
             <bibdata type="standard">
             <title language="en" format="text/plain" type="main">An ITU Standard</title>
             <title language="fr" format="text/plain" type="main">Un Standard ITU</title>
             <docidentifier type="IEEE">12345</docidentifier>
             <language>#{lang}</language>
             <script>#{script}</script>
             <keyword>A</keyword>
             <keyword>B</keyword>
             <ext>
             <doctype>recommendation</doctype>
             </ext>
             </bibdata>
    <preface>
    <abstract><title>Abstract</title>
    <p>This is an abstract</p>
    </abstract>
    <clause id="A0"><title>History</title>
    <p>history</p>
    </clause>
    <foreword obligation="informative">
       <title>Foreword</title>
       <p id="A">This is a preamble</p>
     </foreword>
      <introduction id="B" obligation="informative"><title>Introduction</title><clause id="C" inline-header="false" obligation="informative">
       <title>Introduction Subsection</title>
     </clause>
     </introduction></preface><sections>
     <clause id="D" obligation="normative" type="scope">
       <title>Scope</title>
       <p id="E">Text</p>
     </clause>

     <terms id="I" obligation="normative">
       <term id="J">
       <preferred>Term2</preferred>
     </term>
     </terms>
     <definitions id="L">
       <dl>
       <dt>Symbol</dt>
       <dd>Definition</dd>
       </dl>
     </definitions>
     <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
       <title>Introduction</title>
     </clause>
     <clause id="O" inline-header="false" obligation="normative">
       <title>Clause 4.2</title>
     </clause></clause>

     </sections><annex id="P" inline-header="false" obligation="normative">
       <title>Annex</title>
       <clause id="Q" inline-header="false" obligation="normative">
       <title>Annex A.1</title>
       <clause id="Q1" inline-header="false" obligation="normative">
       <title>Annex A.1a</title>
       </clause>
     </clause>
     </annex><bibliography><references id="R" obligation="informative" normative="true">
       <title>References</title>
     </references><clause id="S" obligation="informative">
       <title>Bibliography</title>
       <references id="T" obligation="informative" normative="false">
       <title>Bibliography Subsection</title>
     </references>
     </clause>
     </bibliography>
     </ieee-standard>
  INPUT
end

BLANK_HDR = <<~"HDR".freeze
  <?xml version="1.0" encoding="UTF-8"?>
  <ieee-standard xmlns="https://www.metanorma.org/ns/ieee" type="semantic" version="#{Metanorma::IEEE::VERSION}">
         <bibdata type="standard">
       <title language="en" format="text/plain">Document title</title>
       <contributor><role type="publisher"/><organization>
       <name>Institute of Electrical and Electronic Engineers</name>
       <abbreviation>IEEE</abbreviation></organization></contributor>
    <language>en</language>
    <script>Latn</script>
   <status>
           <stage>approved</stage>
   </status>

    <copyright>
      <from>#{Time.new.year}</from>
      <owner>
        <organization>
        <name>Institute of Electrical and Electronic Engineers</name>
       <abbreviation>IEEE</abbreviation>
        </organization>
      </owner>
    </copyright>
    <ext>
           <doctype>standard</doctype>
           <subdoctype>document</subdoctype>
   </ext>
  </bibdata>
HDR

def blank_hdr_gen
  <<~"HDR"
    #{BLANK_HDR}
    #{boilerplate(Nokogiri::XML("#{BLANK_HDR}</ieee-standard>"))}
  HDR
end

HTML_HDR = <<~"HDR".freeze
  <body lang='en'>
  <div class="title-section">
    <p>&#160;</p>
  </div>
  <br/>
  <div class="prefatory-section">
    <p>&#160;</p>
  </div>
  <br/>
  <div class="main-section">
HDR

def word2xml(filename)
  File.read(filename, encoding: "UTF-8")
    .sub(/^.*<html/m, "<html")
    .sub(/<\/html>.*$/m, "</html>")
    .gsub(/<\/o:/, "</").gsub(/<o:/, "<")
    .gsub(/epub:type/, "type")
end

def mock_pdf
  allow(::Mn2pdf).to receive(:convert) do |url, output, _c, _d|
    FileUtils.cp(url.gsub(/"/, ""), output.gsub(/"/, ""))
  end
end
