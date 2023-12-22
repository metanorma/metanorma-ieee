module IsoDoc
  module IEEE
    class WordConvert < IsoDoc::WordConvert
      def toWord(result, filename, dir, header)
        result = from_xhtml(word_cleanup(to_xhtml(result)))
          .gsub("-DOUBLE_HYPHEN_ESCAPE-", "--")
        @wordstylesheet = wordstylesheet_update
        ::Html2Doc::IEEE.new(
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

      def sourcecode_style
        stylesmap[:Sourcecode]
      end

      def word_cleanup(docxml)
        super
        abstract_cleanup(docxml)
        introduction_cleanup(docxml)
        sourcecode_cleanup(docxml)
        div_cleanup(docxml)
        biblio_cleanup(docxml)
        headings_cleanup(docxml)
        caption_cleanup(docxml)
        table_cleanup(docxml)
        style_cleanup(docxml)
        para_type_cleanup(docxml)
        docxml
      end

      def make_WordToC(docxml, level)
        toc = ""
        if source = docxml.at("//div[@class = 'TOC']")
          toc = to_xml(source.children)
        end
        xpath = (1..level).each.map do |i|
          "//h#{i}[not(ancestor::*[@class = 'WordSection2'])]"
        end.join (" | ")
        docxml.xpath(xpath).each do |h|
          toc += word_toc_entry(h.name[1].to_i, header_strip(h))
        end
        toc.sub(/(<p class="MsoToc1">)/,
                %{\\1#{word_toc_preface(level)}}) + WORD_TOC_SUFFIX1
      end

      def biblio_cleanup(docxml)
        docxml.xpath("//p[@class = 'Biblio']").each do |p|
          headings_strip(p)
        end
      end

      def headings_cleanup(docxml)
        (1..9).each { |i| headings_cleanup1(docxml, i) }
        docxml.xpath("//div[@class = 'Annex']").each { |a| a.delete("class") }
      end

      def headings_cleanup1(docxml, idx)
        docxml.xpath("//h#{idx}").each do |h|
          headings_strip(h)
          headings_style(h, idx)
        end
      end

      def headings_style(hdr, idx)
        if hdr.at("./ancestor::div[@class = 'Annex']")
          hdr.delete("class")
          hdr["style"] = "mso-list:l13 level#{idx} lfo33;"
        elsif hdr.at("./ancestor::div[@class = 'Section3' or @class = 'WordSectionContents']")
          hdr.name = "p"
          hdr["class"] = stylesmap["level#{idx}frontmatter".to_sym]
        else
          hdr.name = "p"
          hdr["class"] = stylesmap["level#{idx}header".to_sym]
        end
      end

      def headings_strip(hdr)
        if hdr.children.size > 1 && hdr.children[1].name == "span" &&
            hdr.children[1]["style"] == "mso-tab-count:1"
          2.times { hdr.children.first.remove }
        end
      end

      # STYLE
      def div_cleanup(docxml)
        d = docxml.at("//div[@class = 'WordSection2']" \
                      "[div[@class = 'WordSection2']]") and
          d.replace(d.children)
        i = 0
        docxml.xpath("//div[@class]").each do |div|
          next unless /^WordSection\d*$/.match?(div["class"])

          i += 1
          div["class"] = "WordSection#{i}"
        end
      end

      def stylesmap
        {
          example: "IEEEStdsParagraph",
          MsoNormal: "IEEEStdsParagraph",
          NormRef: "IEEEStdsParagraph",
          Biblio: "IEEEStdsBibliographicEntry",
          figure: "IEEEStdsImage",
          formula: "IEEEStdsEquation",
          Sourcecode: "IEEEStdsComputerCode",
          TableTitle: "IEEEStdsRegularTableCaption",
          FigureTitle: "IEEEStdsRegularFigureCaption",
          admonition: "IEEEStdsWarning",
          abstract: "IEEEStdsAbstractBody",
          AbstractTitle: "AbstractTitle",
          level1frontmatter: "IEEEStdsLevel1frontmatter",
          level2frontmatter: "IEEEStdsLevel2frontmatter",
          level3frontmatter: "IEEEStdsLevel3frontmatter",
          level1header: "IEEEStdsLevel1Header",
          level2header: "IEEEStdsLevel2Header",
          level3header: "IEEEStdsLevel3Header",
          level4header: "IEEEStdsLevel4Header",
          level5header: "IEEEStdsLevel5Header",
          level6header: "IEEEStdsLevel6Header",
          zzSTDTitle1: "IEEEStdsTitle",
          tabledata_center: "IEEEStdsTableData-Center",
          tabledata_left: "IEEEStdsTableData-Left",
          table_head: "IEEEStdsTableLineHead",
          table_subhead: "IEEEStdsTableLineSubhead",
          table_columnhead: "IEEEStdsTableColumnHead",
          nameslist: "IEEEStdsNamesList",
          intro: "IEEEStdsIntroduction",
        }
      end

      def table_toc_class
        [stylesmap[:TableTitle], "TableTitle", "tabletitle"]
      end

      def figure_toc_class
        [stylesmap[:FigureTitle], "FigureTitle", "figuretitle"]
      end

      def style_cleanup(docxml)
        note_style_cleanup(docxml)
        docxml.xpath("//div[@class = 'formula']/p").each do |p|
          p["class"] = stylesmap[:formula]
        end
        stylesmap.each do |k, v|
          docxml.xpath("//*[@class = '#{k}']").each { |s| s["class"] = v }
        end
        docxml.xpath("//p[not(@class)]").each do |p|
          p["class"] = stylesmap[:MsoNormal]
        end
      end

      def insert_toc(intro, docxml, level)
        toc = assemble_toc(docxml, level)
        source = docxml.at("//div[@class = 'WordSectionContents']") and
          source << toc
        intro
      end
    end
  end
end
