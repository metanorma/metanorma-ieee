require "spec_helper"

RSpec.describe Metanorma::IEEE do
  before(:all) do
    FileUtils.rm_f "test.err.html"
  end

  it "Warns of illegal doctype" do
    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      text
    INPUT
    expect(File.read("test.err.html"))
      .to include "pizza is not a recognised document type"
  end

  it "Warns of illegal docsubtype" do
    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :docsubtype: pizza

      text
    INPUT
    expect(File.read("test.err.html"))
      .to include "pizza is not a recognised document subtype"
  end

  it "Warns of illegal docstage" do
    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :docstage: pizza

      text
    INPUT
    expect(File.read("test.err.html"))
      .to include "pizza is not a recognised stage"
  end

  it "Warns of uncapitalised word in title other than preposition (or article)" do
    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      text
    INPUT
    expect(File.read("test.err.html"))
      .to include "Title contains uncapitalised word other than preposition"

    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Document save for the Title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      text
    INPUT
    expect(File.read("test.err.html"))
      .not_to include "Title contains uncapitalised word other than preposition"
  end

  it "Warns of uncapitalised title of figure" do
    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      .uncapitalised caption
      image::spec/assets/rice_image1.png[]
    INPUT
    expect(File.read("test.err.html"))
      .to include "figure heading should be capitalised"

    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Document save for the Title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      .Capitalised caption
      image::spec/assets/rice_image1.png[]
    INPUT
    expect(File.read("test.err.html"))
      .not_to include "figure heading should be capitalised"
  end

  it "Warns of uncapitalised title of table" do
    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      .uncapitalised caption
      |===
      |A |B
      |===
    INPUT
    expect(File.read("test.err.html"))
      .to include "table heading should be capitalised"

    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Document save for the Title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      .Capitalised caption
      |===
      |A |B
      |===
    INPUT
    expect(File.read("test.err.html"))
      .not_to include "table heading should be capitalised"
  end

  it "Warns of uncapitalised heading of table" do
    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      |===
      |a |B

      |C |D
      |===
    INPUT
    expect(File.read("test.err.html"))
      .to include "table heading should be capitalised"

    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      |===
      |A |B

      h|c |D
      |===
    INPUT
    expect(File.read("test.err.html"))
      .to include "table heading should be capitalised"

    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Document save for the Title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      |===
      |A |B

      |c |D
      |===
    INPUT
    expect(File.read("test.err.html"))
      .not_to include "table heading should be capitalised"
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
    expect(File.read("test.err.html"))
      .to include "Normative reference iso123 is not dated"

    VCR.use_cassette "iso123" do
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
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
      expect(File.read("test.err.html"))
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
    expect(File.read("test.err.html"))
      .to include "Undated reference ISO 123 should not contain " \
                  "specific elements"

    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      #{VALIDATING_BLANK_HDR}

      == Scope
      <<iso123,clause=1>>

      [bibliography]
      == Normative References
      * [[[iso123,ISO 123-2000]]] _Standard_
    INPUT
    expect(File.read("test.err.html"))
      .not_to include "Undated reference ISO 123-2000 should not contain " \
                      "specific elements"
  end

  it "Warn if unordered list more than 2 levels deep" do
    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      #{VALIDATING_BLANK_HDR}

      == Clause

      * List
      ** List
      *** List
    INPUT
    expect(File.read("test.err.html"))
      .to include "Use ordered lists for lists more than two levels deep"

    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      #{VALIDATING_BLANK_HDR}

      == Clause

      * List
      ** List
    INPUT
    expect(File.read("test.err.html"))
      .not_to include "Use ordered lists for lists more than two levels deep"
  end

  it "Warn if ordered list more than 5 levels deep" do
    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      #{VALIDATING_BLANK_HDR}

      == Clause

      . List
      .. List
      ... List
      .... List
      ..... List
      ...... List
    INPUT
    expect(File.read("test.err.html"))
      .to include "Ordered lists should not be more than five levels deep"

    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      #{VALIDATING_BLANK_HDR}

      == Clause

      . List
      .. List
      ... List
      .... List
      ..... List
    INPUT
    expect(File.read("test.err.html"))
      .not_to include "Ordered lists should not be more than five levels deep"
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
    expect(File.read("test.err.html"))
      .to include "Exceeds the maximum clause depth of 5"

    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      #{VALIDATING_BLANK_HDR}

      == Clause

      === Clause

      ==== Clause

      ===== Clause

      ====== Clause

    INPUT
    expect(File.read("test.err.html"))
      .not_to include "exceeds the maximum clause depth of 5"
  end

  it "Warning if subclause is only child of its parent, or none" do
    Asciidoctor.convert(<<~"INPUT", *OPTIONS)
      #{VALIDATING_BLANK_HDR}
      == Clause

      === Subclause

    INPUT
    expect(File.read("test.err.html")).to include "subclause is only child"
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
    expect(File.read("test.err.html"))
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
    expect(File.read("test.err.html"))
      .not_to include "More than 1 ordered list in a numbered clause"
  end

  it "Warns of ranges in crossreferences" do
    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      <<ref1,clause=3-5>>

      [bibliography]
      == Bibliography

      * [[[ref1,XYZ]]] _Standard_
    INPUT

    expect(File.read("test.err.html")).to include "Cross-reference contains range, should be separate cross-references"

    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      <<ref1,clause=3;to!clause=5>>

      [bibliography]
      == Bibliography

      * [[[ref1,XYZ]]] _Standard_
    INPUT

    expect(File.read("test.err.html")).to include "Cross-reference contains range, should be separate cross-references"

    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      <<ref1,clause=3>>

      [bibliography]
      == Bibliography

      * [[[ref1,XYZ]]] _Standard_
    INPUT

    expect(File.read("test.err.html")).not_to include "Cross-reference contains range, should be separate cross-references"
  end

  context "Warns of missing overview" do
    it "Overview clause missing" do
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        text
      INPUT

      expect(File.read("test.err.html")).to include "Overview clause missing"
      expect(File.read("test.err.html")).to include "Scope subclause missing"
      expect(File.read("test.err.html")).to include "Word Usage subclause missing"
    end

    it "Overview clause not missing if supplied" do
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        == Overview
      INPUT
      expect(File.read("test.err.html")).not_to include "Overview clause missing"
      expect(File.read("test.err.html")).to include "Scope subclause missing"
      expect(File.read("test.err.html")).to include "Word Usage subclause missing"
    end

    it "Scope and Word usage clause not missing if supplied" do
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
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
      expect(File.read("test.err.html")).not_to include "Overview clause missing"
      expect(File.read("test.err.html")).not_to include "Scope subclause missing"
      expect(File.read("test.err.html")).not_to include "Word Usage subclause missing"
    end

    it "Overview clause not missing in amendments" do
      FileUtils.rm_f "test.err.html"
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: amendment

        text
      INPUT
      expect(File.read("test.err.html")).not_to include "Overview clause missing"
      expect(File.read("test.err.html")).not_to include "Scope subclause missing"
      expect(File.read("test.err.html")).not_to include "Word Usage subclause missing"
    end
  end

  it "warns that title should match doctype" do
    Asciidoctor.convert(<<~INPUT, *OPTIONS)
      = Fred
      :docfile: test.adoc
      :doctype: recommended-practice
      :draft: 1.1
      :docsubtype: amendment
      :trial-use: true
      :no-pdf:

    INPUT
    expect(File.exist?("test.err.html")).to be true
    expect(File.read("test.err.html"))
      .to include "Expected title to start as: " \
                  "Draft Trial-Use Recommended Practice"
  end

  context "Amends" do
    it "warns that editorial instruction is missing" do
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Fred
        :docfile: test.adoc
        :doctype: recommended-practice
        :docsubtype: amendment
        :no-pdf:

        [change="add",locality="page=27",path="//table[2]",path_end="//table[2]/following-sibling:example[1]",title="Change"]
        == Change Clause

      INPUT
      expect(File.exist?("test.err.html")).to be true
      expect(File.read("test.err.html"))
        .to include "Editorial instruction is missing from change"

      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Fred
        :docfile: test.adoc
        :doctype: recommended-practice
        :docsubtype: amendment
        :no-pdf:

        [change="add",locality="page=27",path="//table[2]",path_end="//table[2]/following-sibling:example[1]",title="Change"]
        == Change Clause

        _This table contains information on polygon cells which are not included in ISO 10303-52. Remove table 2 completely and replace with:_
      INPUT
      expect(File.exist?("test.err.html")).to be true
      expect(File.read("test.err.html"))
        .not_to include "Editorial instruction is missing from change"
    end

    it "warns that editorial instruction should match amend type" do
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Fred
        :docfile: test.adoc
        :doctype: recommended-practice
        :docsubtype: amendment
        :no-pdf:

        [change="add",locality="page=27",path="//table[2]",path_end="//table[2]/following-sibling:example[1]",title="Change"]
        == Change Clause
        _This table contains information on polygon cells which are not included in ISO 10303-52. Remove table 2 completely and replace with:_

      INPUT
      expect(File.exist?("test.err.html")).to be true
      expect(File.read("test.err.html"))
        .to include "'Add' change description should start with _Insert_"

      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Fred
        :docfile: test.adoc
        :doctype: recommended-practice
        :docsubtype: amendment
        :no-pdf:

        [change="delete",locality="page=27",path="//table[2]",path_end="//table[2]/following-sibling:example[1]",title="Change"]
        == Change Clause
        _This table contains information on polygon cells which are not included in ISO 10303-52. Remove table 2 completely and replace with:_

      INPUT
      expect(File.exist?("test.err.html")).to be true
      expect(File.read("test.err.html"))
        .to include "'Delete' change description should start with _Delete_"

      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Fred
        :docfile: test.adoc
        :doctype: recommended-practice
        :docsubtype: amendment
        :no-pdf:

        [change="modify",locality="page=27",path="//table[2]",path_end="//table[2]/following-sibling:example[1]",title="Change"]
        == Change Clause
        _This table contains information on polygon cells which are not included in ISO 10303-52. Remove table 2 completely and replace with:_

      INPUT
      expect(File.exist?("test.err.html")).to be true
      expect(File.read("test.err.html"))
        .to include "'Modify' change description should start with _Change_ " \
                    "or _Replace_"

      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Fred
        :docfile: test.adoc
        :doctype: recommended-practice
        :docsubtype: amendment
        :no-pdf:

        [change="modify",locality="page=27",path="//table[2]",path_end="//table[2]/following-sibling:example[1]",title="Change"]
        == Change Clause

        _Replace this text_

        ____
        Hello
        ____

      INPUT
      expect(File.exist?("test.err.html")).to be true
      expect(File.read("test.err.html"))
        .to include "'Modify' change description for change not involving " \
                    "figure or equation should start with _Change_"

      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Fred
        :docfile: test.adoc
        :doctype: recommended-practice
        :docsubtype: amendment
        :no-pdf:

        [change="modify",locality="page=27",path="//table[2]",path_end="//table[2]/following-sibling:example[1]",title="Change"]
        == Change Clause

        _Change this text_

        ____
        [stem]
        ++++
        ABC
        ++++
        ____

      INPUT
      expect(File.exist?("test.err.html")).to be true
      expect(File.read("test.err.html"))
        .to include "'Modify' change description for change involving figure " \
                    "or equation should start with _Replace_"

      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Fred
        :docfile: test.adoc
        :doctype: recommended-practice
        :docsubtype: amendment
        :no-pdf:

        [change="modify",locality="page=27",path="//table[2]",path_end="//table[2]/following-sibling:example[1]",title="Change"]
        == Change Clause

        _Replace this text_

        ____
        [stem]
        ++++
        ABC
        ++++
        ____

      INPUT
      expect(File.exist?("test.err.html")).to be true
      expect(File.read("test.err.html"))
        .not_to include "'Modify' change description for change involving " \
                        "figure or equation should start with _Replace_"
      expect(File.read("test.err.html"))
        .not_to include "'Modify' change description for change not involving " \
                        "figure or equation should start with _Change_"
      expect(File.read("test.err.html"))
        .not_to include "'Modify' change description should start with " \
                        "_Change_ or _Replace_"
    end
  end

  context "Warns of missing normative references" do
    it "Normative references missing" do
      FileUtils.rm_f "test.err.html"
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        text
      INPUT
      expect(File.read("test.err.html")).to include "Normative references missing"
    end

    it "Normative references not missing if supplied" do
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        [bibliography]
        == Normative references
      INPUT
      expect(File.read("test.err.html"))
        .not_to include "Normative references missing"
    end

    it "Normative references not missing in amendments" do
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: amendment

        text
      INPUT
      expect(File.read("test.err.html"))
        .not_to include "Normative references missing"
    end
  end

  context "Warns of missing terms & definitions" do
    it "Terms & definitions missing" do
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        text
      INPUT
      expect(File.read("test.err.html")).to include "Definitions missing"
    end

    it "Terms & definitions not missing if supplied" do
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        == Terms and definitions
        === Term 1
      INPUT
      expect(File.read("test.err.html")).not_to include "Definitions missing"
    end

    it "Terms & definitions not missing in amendment" do
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: amendment

        text
      INPUT
      expect(File.read("test.err.html")).not_to include "Definitions missing"
    end
  end

  context "Section ordering" do
    it "Warning if missing abstract" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Symbols and Abbreviated Terms

        Paragraph
      INPUT
      expect(File.read("test.err.html"))
        .to include "Initial section must be (content) Abstract"

      Asciidoctor.convert(<<~INPUT, *OPTIONS)
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
      expect(File.read("test.err.html"))
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
      expect(File.read("test.err.html"))
        .to include "Prefatory material must be followed by (clause) Overview"

      Asciidoctor.convert(<<~INPUT, *OPTIONS)
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
      expect(File.read("test.err.html"))
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
      expect(File.read("test.err.html"))
        .to include "Normative References must be followed by " \
                    "Definitions"

      Asciidoctor.convert(<<~INPUT, *OPTIONS)
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
      expect(File.read("test.err.html"))
        .not_to include "Normative References must be followed by " \
                        "Definitions"
    end

    it "Warning if bibliography out of place" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Overview

        [bibliography]
        == Bibiliography

      INPUT
      expect(File.read("test.err.html"))
        .to include "Bibliography must be either the first or the last " \
                    "document annex"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Overview

        [appendix]
        == Appendix

        [appendix]
        == Bibliography
        [bibliography]
        === Bibiliography

        [appendix]
        == Appendix
      INPUT
      expect(File.read("test.err.html"))
        .to include "Bibliography must be either the first or the last " \
                    "document annex"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Overview

        [appendix]
        == Appendix

        [appendix]
        == Bibliography
        [bibliography]
        === Bibiliography

      INPUT
      expect(File.read("test.err.html"))
        .not_to include "Bibliography must be either the first or the last " \
                        "document annex"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Overview

        [appendix]
        == Bibliography
        [bibliography]
        === Bibiliography

        [appendix]
        == Appendix
      INPUT
      expect(File.read("test.err.html"))
        .not_to include "Bibliography must be either the first or the last " \
                        "document annex"
    end
  end

  context "Number validation" do
    it "Style warning if decimal point" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        8,1
      INPUT
      expect(File.read("test.err.html")).to include "possible decimal comma"
    end

    it "Style warning if leading decimal point without zero" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        Number: .1
      INPUT
      expect(File.read("test.err.html")).to include "decimal without initial zero"
    end

    it "Style warning if percent sign without space" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        9%
      INPUT
      expect(File.read("test.err.html")).to include "no space before percent sign"
    end

    it "Style warning if no space between number and unit" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        7km
      INPUT
      expect(File.read("test.err.html")).to include "no space between number and SI unit"
    end

    it "Style warning if no unit on both unit and tolerance" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        7 ± 2 km
      INPUT
      expect(File.read("test.err.html")).to include "unit is needed on both value and tolerance"
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
      expect(File.read("test.err.html")).not_to include "number in table not broken up in threes"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        |===
        | 98765 | 0
        |===
      INPUT
      expect(File.read("test.err.html")).to include "number in table not broken up in threes"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        |===
        | 10.98765 | 0
        |===
      INPUT
      expect(File.read("test.err.html")).to include "number in table not broken up in threes"
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
      expect(File.read("test.err.html")).not_to include " is a 4-digit number in a table column with numbers broken up in threes"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        |===
        | 9876
        | 987 6
        |===

      INPUT
      expect(File.read("test.err.html")).to include " is a 4-digit number in a table column with numbers broken up in threes"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Clause
        |===
        | 0.9876
        | 0.987 6
        |===

      INPUT
      expect(File.read("test.err.html")).to include " is a 4-digit number in a table column with numbers broken up in threes"
    end
  end

  context "Image name validation" do
    it "warn on wrong image names" do
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :docnumber: 1000
        :copyright-year: 2000
        :data-uri-image: false

        == Clause
        image::spec/assets/document-2000_fig1.png[]

        image::spec/assets/1000-2000_fig2.png[]

        image::spec/assets/1000-2000_fig4.png[]
      INPUT
      expect(File.read("test.err.html"))
        .to include "Image name document-2000_​fig1 is expected to be 1000-2000_​fig1"
      expect(File.read("test.err.html"))
        .not_to include "Image name document-2000_​fig2 is expected to be 1000-2000_​fig2"
      expect(File.read("test.err.html"))
        .to include "Image name 1000-2000_​fig4 is expected to be 1000-2000_​fig3"
    end

    it "warn on wrong image names within tables" do
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :docnumber: 1000
        :data-uri-image: false

        == Clause

        |===
        |A |B
        |===

        |===
        a| image::spec/assets/Tab2Row1Col2.png[] | A

        | C a| image::spec/assets/1000-fig2.png[]

        a| image::spec/assets/1000-fig4.png[] | D
        |===
      INPUT
      expect(File.read("test.err.html"))
        .not_to include "Image name Tab2Row1Col2.png is expected to be Tab2Row1Col2"
      expect(File.read("test.err.html"))
        .to include "Image name 1000-fig2.png is expected to be Tab2Row2Col2"
      expect(File.read("test.err.html"))
        .to include "Image name 1000-fig4.png is expected to be Tab2Row3Col1"
    end

    it "warn on two images in a table cell" do
      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :docnumber: 1000

        == Clause

        |===
        a| image::spec/assets/rice_image1.png[]
        image::spec/assets/rice_image2.png[] | B
        |===
      INPUT
      expect(File.read("test.err.html"))
        .to include "More than one image in the table cell"

      Asciidoctor.convert(<<~INPUT, *OPTIONS)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :docnumber: 1000

        == Clause

        |===
        a| image::spec/assets/rice_image1.png[] | B
        |===
      INPUT
      expect(File.read("test.err.html"))
        .not_to include "More than one image in the table cell"
    end

    it "warn on missing related terms" do
      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Terms and definitions

        === Term
        related:contrast[que]
      INPUT
      expect(File.read("test.err.html"))
        .not_to include "Error: Term reference to <code>que</code> missing:`"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Terms and definitions

        === Term
        symbol:[que]
      INPUT
      expect(File.read("test.err.html"))
        .to include "Symbol reference in <code>symbol​[que]</code> missing:"

      Asciidoctor.convert(<<~"INPUT", *OPTIONS)
        #{VALIDATING_BLANK_HDR}

        == Terms and definitions

        === Term
        related:contrast[que]
        symbol:[que1]

        === que

        == Symbols

        que1:: X
      INPUT
      expect(File.read("test.err.html"))
        .not_to include "Error: Term reference to <code>que</code> missing:"
      expect(File.read("test.err.html"))
        .not_to include "Symbol reference in <code>symbol​[que1]</code> missing:"
    end
  end
end
