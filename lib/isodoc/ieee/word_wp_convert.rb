module IsoDoc
  module IEEE
    class WordWPConvert < WordConvert
      def initialize(options)
        @libdir ||= File.dirname(__FILE__) # rubocop:disable Lint/DisjunctiveAssignmentInConstructor
        options.merge!(default_file_locations(options))
        super
      end

      def convert1(docxml, filename, dir)
        super
      end

      def default_file_locations(_options)
        { wordstylesheet: html_doc_path("wordstyle_wp.scss"),
          standardstylesheet: html_doc_path("ieee_wp.scss"),
          header: html_doc_path("header_wp.html"),
          wordcoverpage: html_doc_path("word_ieee_titlepage_wp.html"),
          wordintropage: html_doc_path("word_ieee_intro_wp.html"),
          ulstyle: "l11", olstyle: "l16" }
      end

      def default_fonts(_options)
        { bodyfont: '"Calibri",sans-serif',
          headerfont: '"Arial Black",sans-serif',
          monospacefont: '"Courier New",monospace',
          normalfontsize: "11.0pt",
          footnotefontsize: "7.0pt",
          smallerfontsize: "10.0pt",
          monospacefontsize: "10.0pt" }
      end

      STYLESMAP = {
        example: "IEEEStdsParagraph", # x
        MsoNormal: "MsoBodyText",
        NormRef: "MsoBodyText",
        Biblio: "References",
        figure: "MsoBodyText",
        formula: "IEEEStdsEquation", # x
        Sourcecode: "IEEEStdsComputerCode", # x
        TableTitle: "TableTitles",
        FigureTitle: "FigureHeadings",
        admonition: "IEEEStdsWarning", # x
        abstract: "Abstract",
        AbstractTitle: "Unnumberedheading",
        level1frontmatter: "Unnumberedheading",
        level2frontmatter: "IEEEStdsLevel2frontmatter", # x
        level3frontmatter: "IEEEStdsLevel3frontmatter", # x
        level1header: "IEEESectionHeader",
        level2header: "IEEEStdsLevel2Header", # x
        level3header: "IEEEStdsLevel3Header", # x
        level4header: "IEEEStdsLevel4Header", # x
        level5header: "IEEEStdsLevel5Header", # x
        level6header: "IEEEStdsLevel6Header", # x
        zzSTDTitle1: "Titleofdocument",
        tabledata_center: "IEEEStdsTableData-Center", # x
        tabledata_left: "Tablecelltext",
        table_head: "IEEEStdsTableLineHead", # x
        table_subhead: "IEEEStdsTableLineSubhead", # x
        table_columnhead: "Tablecolumnheader",
        nameslist: "IEEEnames",
        intro: "Intro",
      }.freeze
    end

    APPENDIX_STYLE = %w(Appendix Appendixlevel2 Appendixlevel3).freeze

    def headings_style(hdr, idx)
      if hdr.at("./ancestor::div[@class = 'Annex']")
        hdr["class"] = APPENDIX_STYLE[idx]
        hdr["style"] = "mso-list:l15 level#{idx} lfo33;"
      elsif hdr.at("./ancestor::div[@class = 'Section3' or @class = 'WordSectionContents']")
        hdr.name = "p"
        hdr["class"] = STYLESMAP["level#{idx}frontmatter".to_sym]
      else
        hdr.name = "p"
        hdr["class"] = STYLESMAP["level#{idx}header".to_sym]
      end
    end

    def make_body3(body, docxml)
      body.div class: "WordSection3" do |div3|
        content(div3, docxml, ns(self.class::MAIN_ELEMENTS))
      end
      section_break(body)
      body.div class: "WordSection4" do |div3|
        backcover div3
        footnotes div3
        comments div3
      end
    end

    def backcover(out)
      out << File.read(html_doc_path("word_ieee_intro_colophon.html"))
    end

    def figure_attrs(node)
      attr_code(id: node["id"], class: "figure",
                style: "#{keep_style(node)};text-align:center;")
    end

    def toWord(result, filename, dir, header)
      result = from_xhtml(word_cleanup(to_xhtml(result)))
        .gsub("-DOUBLE_HYPHEN_ESCAPE-", "--")
      @wordstylesheet = wordstylesheet_update
      ::Html2Doc::IEEE_WP.new(
        filename: filename,
        imagedir: @localdir,
        stylesheet: @wordstylesheet&.path,
        header_file: header&.path, dir: dir,
        asciimathdelims: [@openmathdelim, @closemathdelim],
        liststyles: { ul: @ulstyle, ol: @olstyle }
      ).process(result)
      header&.unlink
      @wordstylesheet.unlink if @wordstylesheet.is_a?(Tempfile)
    end

    def table_cleanup(docxml)
      super
      docxml.xpath("//div[@class = 'table_container']//p[@class = 'Note']")
        .each do |n|
        n["class"] = "Tablenotes"
      end
    end
  end
end
