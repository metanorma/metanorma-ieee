require "spec_helper"
require "relaton_iso"

RSpec.describe Metanorma::Ieee, type: :validation do
  before(:all) do
    FileUtils.rm_f "test.err.html"
  end

  it "Warns of illegal doctype" do
    errors = convert_and_capture_errors(<<~INPUT)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      text
    INPUT
    expect(errors).to include("pizza is not a recognised document type")
  end

  it "Warns of illegal docsubtype" do
    errors = convert_and_capture_errors(<<~INPUT)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :docsubtype: pizza

      text
    INPUT
    expect(errors).to include("pizza is not a recognised document subtype")
  end

  it "Warns of illegal docstage" do
    errors = convert_and_capture_errors(<<~INPUT)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :docstage: pizza

      text
    INPUT
    expect(errors).to include("pizza is not a recognised stage")
  end

  context "Capitalisation validation" do
    let(:uncapitalised_title) do
      convert_and_capture_errors(<<~INPUT)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        text
      INPUT
    end

    let(:capitalised_title) do
      convert_and_capture_errors(<<~INPUT)
        = Document save for the Title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        text
      INPUT
    end

    it "Warns of uncapitalised word in title other than preposition (or article)" do
      expect(uncapitalised_title).to include("Title contains uncapitalised word other than preposition")
      expect(capitalised_title).not_to include("Title contains uncapitalised word other than preposition")
    end
  end

  context "Figure and table heading capitalisation" do
    let(:uncapitalised_figure) do
      convert_and_capture_errors(<<~INPUT)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        .uncapitalised caption
        image::spec/assets/rice_image1.png[]
      INPUT
    end

    let(:capitalised_figure) do
      convert_and_capture_errors(<<~INPUT)
        = Document save for the Title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        .Capitalised caption
        image::spec/assets/rice_image1.png[]
      INPUT
    end

    let(:uncapitalised_table_caption) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    let(:capitalised_table_caption) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    let(:uncapitalised_table_cell) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    let(:uncapitalised_table_header_cell) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    let(:capitalised_table_no_header) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    it "Warns of uncapitalised title of figure" do
      expect(uncapitalised_figure).to include("figure heading should be capitalised")
      expect(capitalised_figure).not_to include("figure heading should be capitalised")
    end

    it "Warns of uncapitalised title of table" do
      expect(uncapitalised_table_caption).to include("table heading should be capitalised")
      expect(capitalised_table_caption).not_to include("table heading should be capitalised")
    end

    it "Warns of uncapitalised heading of table" do
      expect(uncapitalised_table_cell).to include("table heading should be capitalised")
      expect(uncapitalised_table_header_cell).to include("table heading should be capitalised")
      expect(capitalised_table_no_header).not_to include("table heading should be capitalised")
    end
  end

  context "Reference validation" do
    let(:undated_reference) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Scope
        <<iso123,clause=1>>

        [bibliography]
        == Normative References
        * [[[iso123,ISO 123]]] _Standard_
      INPUT
    end

    let(:dated_reference) do
      convert_and_capture_errors(<<~INPUT)
        #{VALIDATING_BLANK_HDR}

        == Scope
        <<iso123,clause=1>>

        [bibliography]
        == Normative References
        * [[[iso123,ISO 123:1985]]] _Standard_
      INPUT
    end

    let(:dated_references_with_parts) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Scope
        <<iso123,clause=1>>

        [bibliography]
        == Normative References
        * [[[iso123,ISO 123-2000]]] _Standard_
        * [[[iso124,ISO 123-2000-12]]] _Standard_
      INPUT
    end

    it "warns of undated reference in normative references" do
      expect(undated_reference).to include("Normative reference iso123 is not dated")
      expect(dated_reference).not_to include("Normative reference iso123 is not dated")
    end

    it "warns that undated reference has locality" do
      expect(undated_reference).to include("Undated reference ISO 123 should not contain specific elements")
    end

    it "does not warn for dated references with parts" do
      expect(dated_references_with_parts).not_to include("Undated reference ISO 123-2000 should not contain specific elements")
      expect(dated_references_with_parts).not_to include("Undated reference ISO 123-2000-12 should not contain specific elements")
    end
  end

  context "List depth validation" do
    let(:unordered_3_levels) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause

        * List
        ** List
        *** List
      INPUT
    end

    let(:unordered_2_levels) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause

        * List
        ** List
      INPUT
    end

    let(:ordered_6_levels) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause

        . List
        .. List
        ... List
        .... List
        ..... List
        ...... List
      INPUT
    end

    let(:ordered_5_levels) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause

        . List
        .. List
        ... List
        .... List
        ..... List
      INPUT
    end

    let(:subclause_6_levels) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause

        === Clause

        ==== Clause

        ===== Clause

        ====== Clause

        [level=6]
        ====== Clause

      INPUT
    end

    let(:subclause_5_levels) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause

        === Clause

        ==== Clause

        ===== Clause

        ====== Clause

      INPUT
    end

    let(:only_child_subclause) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}
        == Clause

        === Subclause

      INPUT
    end

    let(:multiple_ordered_lists) do
      convert_and_capture_errors(<<~"INPUT")
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
    end

    let(:multiple_ordered_lists_in_subclauses) do
      convert_and_capture_errors(<<~"INPUT")
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
    end

    it "Warn if unordered list more than 2 levels deep" do
      expect(unordered_3_levels).to include("Use ordered lists for lists more than two levels deep")
      expect(unordered_2_levels).not_to include("Use ordered lists for lists more than two levels deep")
    end

    it "Warn if ordered list more than 5 levels deep" do
      expect(ordered_6_levels).to include("Ordered lists should not be more than five levels deep")
      expect(ordered_5_levels).not_to include("Ordered lists should not be more than five levels deep")
    end

    it "Warn if more than 5 levels of subclause" do
      expect(subclause_6_levels).to include("Exceeds the maximum clause depth of 5")
      expect(subclause_5_levels).not_to include("exceeds the maximum clause depth of 5")
    end

    it "Warning if subclause is only child of its parent, or none" do
      expect(only_child_subclause).to include("subclause is only child")
    end

    it "Warn if more than one ordered lists in a clause" do
      expect(multiple_ordered_lists).to include("More than 1 ordered list in a numbered clause")
      expect(multiple_ordered_lists_in_subclauses).not_to include("More than 1 ordered list in a numbered clause")
    end
  end

  context "Crossreference validation" do
    let(:xref_with_dash_range) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    let(:xref_with_to_range) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    let(:xref_without_range) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    it "Warns of ranges in crossreferences" do
      expect(xref_with_dash_range).to include("Cross-reference contains range, should be separate cross-references")
      expect(xref_with_to_range).to include("Cross-reference contains range, should be separate cross-references")
      expect(xref_without_range).not_to include("Cross-reference contains range, should be separate cross-references")
    end
  end

  context "Warns of missing overview" do
    let(:missing_overview) do
      convert_and_capture_errors(<<~INPUT)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        text
      INPUT
    end

    let(:overview_supplied) do
      convert_and_capture_errors(<<~INPUT)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        == Overview
      INPUT
    end

    let(:full_overview_structure) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    let(:amendment_no_overview) do
      convert_and_capture_errors(<<~INPUT)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: amendment

        text
      INPUT
    end

    it "Overview clause missing" do
      expect(missing_overview).to include("Overview clause missing")
      expect(missing_overview).to include("Scope subclause missing")
      expect(missing_overview).to include("Word Usage subclause missing")
    end

    it "Overview clause not missing if supplied" do
      expect(overview_supplied).not_to include("Overview clause missing")
      expect(overview_supplied).to include("Scope subclause missing")
      expect(overview_supplied).to include("Word Usage subclause missing")
    end

    it "Scope and Word usage clause not missing if supplied" do
      expect(full_overview_structure).not_to include("Overview clause missing")
      expect(full_overview_structure).not_to include("Scope subclause missing")
      expect(full_overview_structure).not_to include("Word Usage subclause missing")
    end

    it "Overview clause not missing in amendments" do
      expect(amendment_no_overview).not_to include("Overview clause missing")
      expect(amendment_no_overview).not_to include("Scope subclause missing")
      expect(amendment_no_overview).not_to include("Word Usage subclause missing")
    end
  end

  context "Title matching" do
    let(:mismatched_title) do
      convert_and_capture_errors(<<~INPUT)
        = Fred
        :docfile: test.adoc
        :doctype: recommended-practice
        :draft: 1.1
        :docsubtype: amendment
        :trial-use: true
        :no-pdf:

      INPUT
    end

    it "warns that title should match doctype" do
      expect(mismatched_title).to include("Expected title to start as: Draft Trial-Use Recommended Practice")
    end
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
        .to include("Editorial instruction is missing from change")

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
        .not_to include("Editorial instruction is missing from change")
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
        .to include("'Add' change description should start with _Insert_")

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
        .to include("'Delete' change description should start with _Delete_")

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
        .to include("'Modify' change description should start with _Change_ " \
                    "or _Replace_")

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
        .to include("'Modify' change description for change not involving " \
                    "figure or equation should start with _Change_")

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
        .to include("'Modify' change description for change involving figure " \
                    "or equation should start with _Replace_")

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
        .not_to include("'Modify' change description for change involving " \
                        "figure or equation should start with _Replace_")
      expect(File.read("test.err.html"))
        .not_to include("'Modify' change description for change not involving " \
                        "figure or equation should start with _Change_")
      expect(File.read("test.err.html"))
        .not_to include("'Modify' change description should start with " \
                        "_Change_ or _Replace_")
    end
  end

  context "Warns of missing normative references" do
    let(:missing_normative_refs) do
      convert_and_capture_errors(<<~INPUT)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        text
      INPUT
    end

    let(:normative_refs_supplied) do
      convert_and_capture_errors(<<~INPUT)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        [bibliography]
        == Normative references
      INPUT
    end

    let(:amendment_no_normative_refs) do
      convert_and_capture_errors(<<~INPUT)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: amendment

        text
      INPUT
    end

    it "Normative references missing" do
      expect(missing_normative_refs).to include("Normative references missing")
    end

    it "Normative references not missing if supplied" do
      expect(normative_refs_supplied).not_to include("Normative references missing")
    end

    it "Normative references not missing in amendments" do
      expect(amendment_no_normative_refs).not_to include("Normative references missing")
    end
  end

  context "Warns of missing terms & definitions" do
    let(:missing_definitions) do
      convert_and_capture_errors(<<~INPUT)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        text
      INPUT
    end

    let(:definitions_supplied) do
      convert_and_capture_errors(<<~INPUT)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: pizza

        == Terms and definitions
        === Term 1
      INPUT
    end

    let(:amendment_no_definitions) do
      convert_and_capture_errors(<<~INPUT)
        = Document title
        Author
        :docfile: test.adoc
        :nodoc:
        :no-isobib:
        :doctype: amendment

        text
      INPUT
    end

    it "Terms & definitions missing" do
      expect(missing_definitions).to include("Definitions missing")
    end

    it "Terms & definitions not missing if supplied" do
      expect(definitions_supplied).not_to include("Definitions missing")
    end

    it "Terms & definitions not missing in amendment" do
      expect(amendment_no_definitions).not_to include("Definitions missing")
    end
  end

  context "Section ordering" do
    let(:missing_abstract) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Symbols and Abbreviated Terms

        Paragraph
      INPUT
    end

    let(:amendment_with_abstract) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    let(:missing_overview) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        [abstract]
        == Abstract
        Abstract

        == Symbols and Abbreviated Terms

        Paragraph
      INPUT
    end

    let(:amendment_without_overview) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    let(:normrefs_not_followed_by_definitions) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        [abstract]
        == Abstract

        == Overview

        [bibliography]
        == Normative References

        == Symbols and Abbreviated Terms

        Paragraph
      INPUT
    end

    let(:amendment_normrefs_ordering) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    let(:bibliography_not_annex) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Overview

        [bibliography]
        == Bibiliography

      INPUT
    end

    let(:bibliography_middle_of_annexes) do
      convert_and_capture_errors(<<~"INPUT")
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
    end

    let(:bibliography_last_annex) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Overview

        [appendix]
        == Appendix

        [appendix]
        == Bibliography
        [bibliography]
        === Bibiliography

      INPUT
    end

    let(:bibliography_first_annex) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Overview

        [appendix]
        == Bibliography
        [bibliography]
        === Bibiliography

        [appendix]
        == Appendix
      INPUT
    end

    it "Warning if missing abstract" do
      expect(missing_abstract).to include("Initial section must be (content) Abstract")
      expect(amendment_with_abstract).not_to include("Initial section must be (content) Abstract")
    end

    it "Warning if do not start with overview" do
      expect(missing_overview).to include("Prefatory material must be followed by (clause) Overview")
      expect(amendment_without_overview).not_to include("Prefatory material must be followed by (clause) Overview")
    end

    it "Warning if normative references not followed by terms and definitions" do
      expect(normrefs_not_followed_by_definitions).to include("Normative References must be followed by Definitions")
      expect(amendment_normrefs_ordering).not_to include("Normative References must be followed by Definitions")
    end

    it "Warning if bibliography out of place" do
      expect(bibliography_not_annex).to include("Bibliography must be either the first or the last document annex")
      expect(bibliography_middle_of_annexes).to include("Bibliography must be either the first or the last document annex")
      expect(bibliography_last_annex).not_to include("Bibliography must be either the first or the last document annex")
      expect(bibliography_first_annex).not_to include("Bibliography must be either the first or the last document annex")
    end
  end

  context "Number validation" do
    let(:decimal_comma) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause
        8,1
      INPUT
    end

    let(:leading_decimal_without_zero) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause
        Number: .1
      INPUT
    end

    let(:percent_without_space) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause
        9%
      INPUT
    end

    let(:number_unit_no_space) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause
        7km
      INPUT
    end

    let(:tolerance_missing_unit) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause
        7 ± 2 km
      INPUT
    end

    let(:table_4digit_ok) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause
        98765 0.98765

        |===
        | 9876 | 0.9876
        | 9876.9876 | 9
        |===

      INPUT
    end

    let(:table_5digit_integer) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause
        |===
        | 98765 | 0
        |===
      INPUT
    end

    let(:table_5digit_decimal) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause
        |===
        | 10.98765 | 0
        |===
      INPUT
    end

    let(:table_4digit_no_breaks) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause
        |===
        | 9876 | 0.9876
        | 987  | 0.987
        |===

      INPUT
    end

    let(:table_4digit_with_breaks_integer) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause
        |===
        | 9876
        | 987 6
        |===

      INPUT
    end

    let(:table_4digit_with_breaks_decimal) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Clause
        |===
        | 0.9876
        | 0.987 6
        |===

      INPUT
    end

    it "Style warning if decimal point" do
      expect(decimal_comma).to include("possible decimal comma")
    end

    it "Style warning if leading decimal point without zero" do
      expect(leading_decimal_without_zero).to include("decimal without initial zero")
    end

    it "Style warning if percent sign without space" do
      expect(percent_without_space).to include("no space before percent sign")
    end

    it "Style warning if no space between number and unit" do
      expect(number_unit_no_space).to include("no space between number and SI unit")
    end

    it "Style warning if no unit on both unit and tolerance" do
      expect(tolerance_missing_unit).to include("unit is needed on both value and tolerance")
    end

    it "Style warning if 5-digit numeral in table" do
      expect(table_4digit_ok).not_to include("number in table not broken up in threes")
      expect(table_5digit_integer).to include("number in table not broken up in threes")
      expect(table_5digit_decimal).to include("number in table not broken up in threes")
    end

    it "Style warning if 4-digit numeral in table column with 5-digit numerals" do
      expect(table_4digit_no_breaks).not_to include(" is a 4-digit number in a table column with numbers broken up in threes")
      expect(table_4digit_with_breaks_integer).to include(" is a 4-digit number in a table column with numbers broken up in threes")
      expect(table_4digit_with_breaks_decimal).to include(" is a 4-digit number in a table column with numbers broken up in threes")
    end
  end

  context "Image name validation" do
    let(:wrong_image_names) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    let(:wrong_image_names_in_tables) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    let(:two_images_in_cell) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    let(:single_image_in_cell) do
      convert_and_capture_errors(<<~INPUT)
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
    end

    let(:term_with_related) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Terms and definitions

        === Term
        related:contrast[que]
      INPUT
    end

    let(:term_with_missing_symbol) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Terms and definitions

        === Term
        symbol:[que]
      INPUT
    end

    let(:term_with_all_refs) do
      convert_and_capture_errors(<<~"INPUT")
        #{VALIDATING_BLANK_HDR}

        == Terms and definitions

        === Term
        related:contrast[que]
        symbol:[que1]

        === que

        == Symbols

        que1:: X
      INPUT
    end

    let(:invalid_xml_schema) do
      convert_and_capture_errors(<<~"INPUT")
        = A
        X
        :docfile: test.adoc
        :no-pdf:

        [align=mid-air]
        Para
      INPUT
    end

    it "warn on wrong image names" do
      expect(wrong_image_names).to include("Image name document-2000_​fig1 is expected to be 1000-2000_​fig1")
      expect(wrong_image_names).not_to include("Image name document-2000_​fig2 is expected to be 1000-2000_​fig2")
      expect(wrong_image_names).to include("Image name 1000-2000_​fig4 is expected to be 1000-2000_​fig3")
    end

    it "warn on wrong image names within tables" do
      expect(wrong_image_names_in_tables).not_to include("Image name Tab2Row1Col2.png is expected to be Tab2Row1Col2")
      expect(wrong_image_names_in_tables).to include("Image name 1000-fig2.png is expected to be Tab2Row2Col2")
      expect(wrong_image_names_in_tables).to include("Image name 1000-fig4.png is expected to be Tab2Row3Col1")
    end

    it "warn on two images in a table cell" do
      expect(two_images_in_cell).to include("More than one image in the table cell")
      expect(single_image_in_cell).not_to include("More than one image in the table cell")
    end

    it "warn on missing related terms" do
      expect(term_with_related).not_to include("Error: Term reference to <code>que</code> missing:`")
      expect(term_with_missing_symbol).to include("Symbol reference in <code>symbol​[que]</code> missing:")
      expect(term_with_all_refs).not_to include("Error: Term reference to <code>que</code> missing:")
      expect(term_with_all_refs).not_to include("Symbol reference in <code>symbol​[que1]</code> missing:")
    end

    it "validates document against Metanorma XML schema" do
      expect(invalid_xml_schema).to include('value of attribute "align" is invalid; must be equal to')
    end
  end
end
