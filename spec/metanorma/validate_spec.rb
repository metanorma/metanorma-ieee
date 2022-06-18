require "spec_helper"

RSpec.describe Metanorma::IEEE do
  before(:all) do
    FileUtils.rm_f "test.err"
  end

  it "Warns of illegal doctype" do
    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      text
    INPUT
    expect(File.read("test.err"))
      .to include "pizza is not a recognised document type"
  end

  it "Warns of uncapitalised word in title other than preposition (or article)" do
    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      text
    INPUT
    expect(File.read("test.err"))
      .to include "Title contains uncapitalised word other than preposition"

    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      = Document save for the Title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      text
    INPUT
    expect(File.read("test.err"))
      .not_to include "Title contains uncapitalised word other than preposition"
  end

  it "warns of undated reference in normative references" do
    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      #{VALIDATING_BLANK_HDR}

      == Scope
      <<iso123,clause=1>>

      [bibliography]
      == Normative References
      * [[[iso123,ISO 123]]] _Standard_
    INPUT
    expect(File.read("test.err"))
      .to include "Normative reference iso123 is not dated"

    VCR.use_cassette "iso123" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:

        == Scope
        <<iso123,clause=1>>

        [bibliography]
        == Normative References
        * [[[iso123,ISO 123]]] _Standard_
      INPUT
      expect(File.read("test.err"))
        .not_to include "Normative reference iso123 is not dated"
    end
  end

  it "warns that undated reference has locality" do
    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      #{VALIDATING_BLANK_HDR}

      == Scope
      <<iso123,clause=1>>

      [bibliography]
      == Normative References
      * [[[iso123,ISO 123]]] _Standard_
    INPUT
    expect(File.read("test.err"))
      .to include "undated reference ISO 123 should not contain "\
                  "specific elements"

    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      #{VALIDATING_BLANK_HDR}

      == Scope
      <<iso123,clause=1>>

      [bibliography]
      == Normative References
      * [[[iso123,ISO 123-2000]]] _Standard_
    INPUT
    expect(File.read("test.err"))
      .not_to include "undated reference ISO 123-2000 should not contain "\
                      "specific elements"
  end

  it "Warn if more than 5 levels of subclause" do
    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      #{VALIDATING_BLANK_HDR}

      == Clause

      === Clause

      ==== Clause

      ===== Clause

      ====== Clause

      [level=6]
      ====== Clause

    INPUT
    expect(File.read("test.err"))
      .to include "Exceeds the maximum clause depth of 5"

    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      #{VALIDATING_BLANK_HDR}

      == Clause

      === Clause

      ==== Clause

      ===== Clause

      ====== Clause

    INPUT
    expect(File.read("test.err"))
      .not_to include "exceeds the maximum clause depth of 5"
  end

  it "Warning if subclause is only child of its parent, or none" do
    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      #{VALIDATING_BLANK_HDR}
      == Clause

      === Subclause

    INPUT
    expect(File.read("test.err")).to include "subclause is only child"
  end

  it "Warn if more than one ordered lists in a clause" do
    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      #{VALIDATING_BLANK_HDR}

      == Clause

      . A
      .. B
      ... C

      a

      . A
      .. B

      a

      . B

    INPUT
    expect(File.read("test.err"))
      .to include "More than 1 ordered list in a numbered clause"

    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      #{VALIDATING_BLANK_HDR}

      == Clause

      . A
      .. B
      ... C

      === Clause
      a

      . A
      .. B

      a

    INPUT
    expect(File.read("test.err"))
      .not_to include "More than 1 ordered list in a numbered clause"
  end

  context "Warns of missing overview" do
    it "Overview clause missing" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        text
      INPUT

      expect(File.read("test.err")).to include "Overview clause missing"
      expect(File.read("test.err")).to include "Scope subclause missing"
      expect(File.read("test.err")).to include "Word Usage subclause missing"
    end

    it "Overview clause not missing if supplied" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        == Overview
      INPUT
      expect(File.read("test.err")).not_to include "Overview clause missing"
      expect(File.read("test.err")).to include "Scope subclause missing"
      expect(File.read("test.err")).to include "Word Usage subclause missing"
    end

    it "Scope and Word usage clause not missing if supplied" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        == Overview

        === Scope

        === Word Usage
      INPUT
      expect(File.read("test.err")).not_to include "Overview clause missing"
      expect(File.read("test.err")).not_to include "Scope subclause missing"
      expect(File.read("test.err")).not_to include "Word Usage subclause missing"
    end

    it "Overview clause not missing in amendments" do
      FileUtils.rm_f "test.err"
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: amendment

        text
      INPUT
      expect(File.read("test.err")).not_to include "Overview clause missing"
      expect(File.read("test.err")).not_to include "Scope subclause missing"
      expect(File.read("test.err")).not_to include "Word Usage subclause missing"
    end
  end

  it "warns that title should match doctype" do
    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      = Fred
      :docfile: test.adoc
      :doctype: recommended-practice
      :draft: 1.1
      :docsubtype: trial-use
      :no-pdf:

    INPUT
    expect(File.exist?("test.err")).to be true
    expect(File.read("test.err")).to include "Expected title to start as: "\
                                             "Draft Trial-Use Recommended Practice"
  end

  context "Warns of missing normative references" do
    it "Normative references missing" do
      FileUtils.rm_f "test.err"
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        text
      INPUT
      expect(File.read("test.err")).to include "Normative references missing"
    end

    it "Normative references not missing if supplied" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        [bibliography]
        == Normative references
      INPUT
      expect(File.read("test.err"))
        .not_to include "Normative references missing"
    end

    it "Normative references not missing in amendments" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: amendment

        text
      INPUT
      expect(File.read("test.err"))
        .not_to include "Normative references missing"
    end
  end

  context "Warns of missing terms & definitions" do
    it "Terms & definitions missing" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        text
      INPUT
      expect(File.read("test.err")).to include "Definitions missing"
    end

    it "Terms & definitions not missing if supplied" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        == Terms and definitions
        === Term 1
      INPUT
      expect(File.read("test.err")).not_to include "Definitions missing"
    end

    it "Terms & definitions not missing in amendment" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: amendment

        text
      INPUT
      expect(File.read("test.err")).not_to include "Definitions missing"
    end
  end

  context "Section ordering" do
    it "Warning if missing abstract" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Symbols and Abbreviated Terms

        Paragraph
      INPUT
      expect(File.read("test.err"))
        .to include "Initial section must be (content) Abstract"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: amendment

        [abstract]
        == Abstract

        == Symbols and Abbreviated Terms

        Paragraph
      INPUT
      expect(File.read("test.err"))
        .not_to include "Initial section must be (content) Abstract"
    end

    it "Warning if do not start with overview" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}
        [abstract]
        == Abstract

        == Symbols and Abbreviated Terms

        Paragraph
      INPUT
      expect(File.read("test.err"))
        .to include "Prefatory material must be followed by (clause) Overview"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: amendment

        [abstract]
        == Abstract

        == Symbols and Abbreviated Terms

        Paragraph
      INPUT
      expect(File.read("test.err"))
        .not_to include "Prefatory material must be followed by (clause) Overview"
    end

    it "Warning if normative references not followed by terms and definitions" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        [abstract]
        == Abstract

        == Overview

        [bibliography]
        == Normative References

        == Symbols and Abbreviated Terms

        Paragraph
      INPUT
      expect(File.read("test.err"))
        .to include "Normative References must be followed by "\
                    "Definitions"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: amendment

        [abstract]
        == Abstract

        == Overview

        [bibliography]
        == Normative References

        == Symbols and Abbreviated Terms

        Paragraph
      INPUT
      expect(File.read("test.err"))
        .not_to include "Normative References must be followed by "\
                        "Definitions"
    end
  end

  context "Number validation" do
    it "Style warning if decimal point" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        8,1
      INPUT
      expect(File.read("test.err")).to include "possible decimal comma"
    end

    it "Style warning if leading decimal point without zero" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        Number: .1
      INPUT
      expect(File.read("test.err")).to include "decimal without initial zero"
    end

    it "Style warning if percent sign without space" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        9%
      INPUT
      expect(File.read("test.err")).to include "no space before percent sign"
    end

    it "Style warning if no space between number and unit" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        7km
      INPUT
      expect(File.read("test.err")).to include "no space between number and SI unit"
    end

    it "Style warning if no unit on both unit and tolerance" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        7 ± 2 km
      INPUT
      expect(File.read("test.err")).to include "unit is needed on both value and tolerance"
    end

    it "Style warning if 5-digit numeral in table" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        98765 0.98765

        |===
        | 9876 | 0.9876
        | 9876.9876 | 9
        |===

      INPUT
      expect(File.read("test.err")).not_to include "number in table not broken up in threes"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        |===
        | 98765 | 0
        |===
      INPUT
      expect(File.read("test.err")).to include "number in table not broken up in threes"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        |===
        | 10.98765 | 0
        |===
      INPUT
      expect(File.read("test.err")).to include "number in table not broken up in threes"
    end

    it "Style warning if 4-digit numeral in table column with 5-digit numerals" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        |===
        | 9876 | 0.9876
        | 987  | 0.987
        |===

      INPUT
      expect(File.read("test.err")).not_to include " is a 4-digit number in a table column with numbers broken up in threes"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        |===
        | 9876
        | 987 6
        |===

      INPUT
      expect(File.read("test.err")).to include " is a 4-digit number in a table column with numbers broken up in threes"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        |===
        | 0.9876
        | 0.987 6
        |===

      INPUT
      expect(File.read("test.err")).to include " is a 4-digit number in a table column with numbers broken up in threes"
    end
  end

  context "Image name validation" do
    it "warn on wrong image names" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :docnumber: 1000
        :copyright-year: 2000

        == Clause
        image::document-2000_fig1.png[]

        image::1000-2000_fig2.png[]

        image::1000-2000_fig4.png[]
      INPUT
      expect(File.read("test.err"))
        .to include "image name document-2000_fig1.png is expected to be 1000-2000_fig1"
      expect(File.read("test.err"))
        .not_to include "image name 1000-2000_fig2.png is expected to be 1000-2000_fig2"
      expect(File.read("test.err"))
        .to include "image name 1000-2000_fig4.png is expected to be 1000-2000_fig3"
    end

    it "warn on wrong image names within tables" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :docnumber: 1000

        == Clause

        |===
        |A |B
        |===

        |===
        a| image::Tab2Row1Col2.png[] | A

        | C a| image::1000-fig2.png[]

        a| image::1000-fig4.png[] | D
        |===
      INPUT
      expect(File.read("test.err"))
        .not_to include "image name Tab2Row1Col2.png is expected to be Tab2Row1Col2"
      expect(File.read("test.err"))
        .to include "image name 1000-fig2.png is expected to be Tab2Row2Col2"
      expect(File.read("test.err"))
        .to include "image name 1000-fig4.png is expected to be Tab2Row3Col1"
    end

    it "warn on two images in a table cell" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :docnumber: 1000

        == Clause

        |===
        a| image::document-fig1.png[]
        image::1000-fig2.png[] | B
        |===
      INPUT
      expect(File.read("test.err")).to include "More than one image in the table cell"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :docnumber: 1000

        == Clause

        |===
        a| image::document-fig1.png[] | B
        |===
      INPUT
      expect(File.read("test.err")).not_to include "More than one image in the table cell"
    end
  end
end