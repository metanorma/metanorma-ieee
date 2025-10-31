require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "debug"
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
require "canon"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  #   config.around do |example|
  #     Dir.mktmpdir("rspec-") do |dir|
  #       ["spec/assets/", "spec/examples/", "spec/fixtures/"].each do |assets|
  #         tmp_assets = File.join(dir, assets)
  #         FileUtils.mkdir_p tmp_assets
  #         FileUtils.cp_r Dir.glob("#{assets}*"), tmp_assets
  #       end
  #       Dir.chdir(dir) { example.run }
  #     end
  #   end
end

OPTIONS = [backend: :ieee, header_footer: true].freeze

def presxml_options
  { semanticxmlinsert: "false" }
end

def metadata(xml)
  xml.sort.to_h.delete_if do |_k, v|
    v.nil? || (v.respond_to?(:empty?) && v.empty?)
  end
end

def htmlencode(xml)
  HTMLEntities.new.encode(xml, :hexadecimal)
    .gsub("&#x3e;", ">").gsub("&#xa;", "\n")
    .gsub("&#x22;", '"').gsub("&#x3c;", "<")
    .gsub("&#x26;", "&").gsub("&#x27;", "'")
    .gsub(/\\u(....)/) do |_s|
    "&#x#{$1.downcase};"
  end
end

def strip_guid(xml)
  xml.gsub(%r{ id=['"]_[^"']+['"]}, ' id="_"')
    .gsub(%r{ semx-id="[^"]+"}, "")
    .gsub(%r{ original-id=['"]_[^"']+['"]}, ' original-id="_"')
    .gsub(%r{ target=['"]_[^"']+['"]}, ' target="_"')
    .gsub(%r{ source=['"]_[^"']+['"]}, ' source="_"')
    .gsub(%r{ original-reference=['"][^"']{3,}+['"]}, ' original-reference="_"')
    .gsub(%r{ name=['"]_[^"']+['"]}, ' name="_"')
    .gsub(%r( href=['"]#_?[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{13}['"]), ' href="#_"')
    .gsub(%r( href=['"]#(fn:)_?[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12,13}['"]), ' href="#fn:_"')
    .gsub(%r( name=['"][0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{13}['"]), ' name="_"')
    .gsub(%r( name=['"]ftn_?[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12,13}['"]), ' name="ftn_"')
    .gsub(%r( id=['"][0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{13}['"]), ' id="_"')
    .gsub(%r( id=['"]ftn_?[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12,13}['"]), ' id="ftn_"')
    .gsub(%r( id=['"]fn:_?[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12,13}['"]), ' id="fn:_"')
    .gsub(%r[ src="([^/]+)/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\.], ' src="\\1/_.')
    .gsub(%r[ src='([^/]+)/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\.], " src='\\1/_.")
    .gsub(%r[ reference=['"]_[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}_], ' reference="__')
    .gsub(%r[ reference=['"][0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}.], ' reference="_"')
    .gsub(%r[ bibitemid=['"]_[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}.], ' bibitemid="_"')
    .gsub(%r[ NOTEREF _Ref\d+], ' NOTEREF _Ref')
    .gsub(%r[mso-bookmark:_Ref\d+], "mso-bookmark:_Ref")
    .gsub(%r{<fetched>[^<]+</fetched>}, "<fetched/>")
    .gsub(%r{ schema-version="[^"]+"}, "")
end

ASCIIDOC_BLANK_HDR = <<~HDR.freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :novalid:

HDR

VALIDATING_BLANK_HDR = <<~HDR.freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :no-isobib:

HDR

LOCAL_CACHED_ISOBIB_BLANK_HDR = <<~HDR.freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :novalid:
  :local-cache-only: spec/relatondb

HDR

def boilerplate_read(file, xmldoc)
  conv = Metanorma::Ieee::Converter.new(:ieee, {})
  conv.init(Asciidoctor::Document.new([]))
  file.gsub!(/(?<!\{)(\{\{[^{}]+\}\})(?!\})/, "pass:[\\1]")
  isodoc = conv.boilerplate_isodoc(xmldoc)
  # conv.boilerplate_isodoc_values(isodoc)
  x = isodoc.populate_template(file, nil)
  ret = conv.boilerplate_file_restructure(x)
  conv.footnote_boilerplate_renumber(ret)
  ret.to_xml(encoding: "UTF-8", indent: 2,
             save_with: Nokogiri::XML::Node::SaveOptions::AS_XML)
    .gsub(/<(\/)?sections>/, "<\\1boilerplate>")
    .gsub(/ id="_[^"]+"/, " id='_'")
end

def boilerplate(xmldoc)
  file = File.join(File.dirname(__FILE__), "..", "lib", "metanorma", "ieee",
                   "boilerplate.adoc")
  ret = Nokogiri::XML(boilerplate_read(
                        File.read(file, encoding: "utf-8")
                        .gsub(/<\/?membership>/, ""), xmldoc
                      ))
  ret.at("//p[@type='emeritus_sign']")&.remove
  ret.at("//clause[@anchor='boilerplate_word_usage']")&.remove
  ret.xpath("//passthrough").each(&:remove)
  ret.xpath("//li").each { |x| x["id"] = "_" }
  strip_guid(ret.root.to_xml(encoding: "UTF-8", indent: 2,
                             save_with: Nokogiri::XML::Node::SaveOptions::AS_XML))
    .gsub("&amp;lt;", "&lt;")
    .gsub("&amp;gt;", "&gt;")
  # .gsub("&lt;Date Approved&gt;", "&lt;‌Date Approved&gt;‌")
end

def ieeedoc(lang)
  script = case lang
           when "zh" then "Hans"
           else
             "Latn"
           end
  <<~"INPUT"
             <metanorma xmlns="http://riboseinc.com/isoxml">
             <bibdata type="standard">
             <title language="en" type="main">An ITU Standard</title>
             <title language="fr" type="main">Un Standard ITU</title>
             <docidentifier type="IEEE">12345</docidentifier>
             <language>#{lang}</language>
             <script>#{script}</script>
             <keyword>A</keyword>
             <keyword>B</keyword>
             <ext>
             <doctype>recommendation</doctype>
             <flavor>ieee</flavor>
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
     </metanorma>
  INPUT
end

BLANK_HDR = <<~"HDR".freeze
  <?xml version="1.0" encoding="UTF-8"?>
  <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Ieee::VERSION}" flavor="ieee">
         <bibdata type="standard">
         <title type="title-abbrev" language="en">IEEE Std. for Document title</title>
      <title type="main" language="en">IEEE Standard for Document title</title>
      <title language="en" type="title-main">Document title</title>
                  <contributor>
             <role type="author"/>
             <organization>
               <name>Institute of Electrical and Electronic Engineers</name>
               <abbreviation>IEEE</abbreviation>
             </organization>
           </contributor>
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
           <flavor>ieee</flavor>
   </ext>
  </bibdata>
                    <metanorma-extension>
      <semantic-metadata>
         <stage-published>true</stage-published>
      </semantic-metadata>
            <presentation-metadata>
              <name>TOC Heading Levels</name>
              <value>2</value>
            </presentation-metadata>
            <presentation-metadata>
              <name>HTML TOC Heading Levels</name>
              <value>2</value>
            </presentation-metadata>
            <presentation-metadata>
              <name>DOC TOC Heading Levels</name>
              <value>2</value>
            </presentation-metadata>
            <presentation-metadata>
              <name>PDF TOC Heading Levels</name>
              <value>2</value>
            </presentation-metadata>
          </metanorma-extension>
HDR

def blank_hdr_gen
  <<~"HDR"
    #{BLANK_HDR}
    #{boilerplate(Nokogiri::XML("#{BLANK_HDR}</metanorma>"))}
  HDR
end

HTML_HDR = <<~HDR.freeze
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
      <br/>
    <div class="TOC" id="_">
      <h1 class="IntroTitle">Contents</h1>
    </div>
HDR

def word2xml(filename)
  File.read(filename, encoding: "UTF-8")
    .sub(/^.*<html/m, "<html")
    .sub(/<\/html>.*$/m, "</html>")
    .gsub("</o:", "</").gsub("<o:", "<")
    .gsub("epub:type", "type")
end

def mock_pdf
  allow(Mn2pdf).to receive(:convert) do |url, output, _c, _d|
    FileUtils.cp(url.gsub('"', ""), output.gsub('"', ""))
  end
end
