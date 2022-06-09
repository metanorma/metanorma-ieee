require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::IEEE do
  before(:all) do
    @blank_hdr = blank_hdr_gen
  end

  it "has a version number" do
    expect(Metanorma::IEEE::VERSION).not_to be nil
  end

  it "processes a blank document" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}
    INPUT
    output = <<~OUTPUT
      #{@blank_hdr}
      <sections/>
      </ieee-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "converts a blank document" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
      :legacy-do-not-insert-missing-sections:
    INPUT
    output = <<~OUTPUT
        #{@blank_hdr}
        <sections/>
      </ieee-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
    expect(File.exist?("test.html")).to be true
  end

  it "processes default metadata" do
    output = Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :no-isobib:
      :docnumber: 1000
      :partnumber: 1
      :edition: 2
      :revdate: 2000-01-01
      :draft: 0.3.4
      :committee: TC
      :technical-committee-number: 1
      :technical-committee-type: A
      :balloting-group: SC
      :subcommittee-number: 2
      :subcommittee-type: B
      :working-group: WG
      :workgroup-number: 3
      :workgroup-type: C
      :committee_2: TC1
      :technical-committee-number_2: 11
      :technical-committee-type_2: A1
      :subcommittee_2: SC1
      :subcommittee-number_2: 21
      :subcommittee-type_2: B1
      :working-group_2: WG1
      :workgroup-number_2: 31
      :workgroup-type_2: C1
      :society: SECRETARIAT
      :docstage: 20
      :docsubstage: 20
      :iteration: 3
      :language: en
      :title-intro-en: Introduction
      :title-main-en: Main Title -- Title
      :title-part-en: Title Part
      :title-intro-fr: Introduction Française
      :title-main-fr: Titre Principal
      :title-part-fr: Part du Titre
      :library-ics: 1,2,3
      :copyright-year: 2000
      :horizontal: true
      :confirmed-date: 1000-12-01
      :issued-date: 1001-12-01
      :wg_chair: AB
      :wg_vicechair: CD
      :wg_members: E, F, Jr.; GH; IJ
      :balloting_group_members: KL; MN
      :std_board_chair: OP
      :std_board_vicechair: QR
      :std_board_pastchair: ST
      :std_board_secretary: UV
      :std_board_members: WX; YZ
    INPUT
    expect(xmlpp(output.sub(%r{<boilerplate>.*</boilerplate>}m, "")))
      .to be_equivalent_to xmlpp(<<~"OUTPUT")
    OUTPUT
  end
end
