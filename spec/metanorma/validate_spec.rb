require "spec_helper"

RSpec.describe Metanorma::IEEE do
  before(:all) do
    FileUtils.rm_f "test.err"
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
end
