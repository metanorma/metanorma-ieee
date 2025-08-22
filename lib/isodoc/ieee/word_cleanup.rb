module IsoDoc
  module Ieee
    class WordConvert < IsoDoc::WordConvert
      def toWord(result, filename, dir, header)
        ::Html2Doc::Ieee.new(
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
        else
          hdr.name = "p"
          front = hdr.at("./ancestor::div[@class = 'Section3' or @class = 'WordSectionContents']")
          type = front ? "frontmatter" : "header"
          hdr["class"] = stylesmap["level#{idx}#{type}".to_sym]
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
          TOCTitle: "IEEEStdsLevel1frontmatter",
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
          surname: "au_surname",
          forename: "au_fname",
        }
      end

      def table_toc_class
        ["IEEEStds Regular Table Caption", "TableTitle", "tabletitle"]
      end

      def figure_toc_class
        ["IEEEStds Regular Figure Caption", "FigureTitle", "figuretitle"]
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

      def abstract_cleanup(docxml)
        dest = docxml.at("div[@id = 'abstract-destination']") or return
        if f = docxml.at("//div[@class = 'abstract']")
          f.previous_element.remove
          abstract_cleanup1(f, dest)
          abstract_header(dest)
          f.remove
        elsif f = docxml.at("//div[@type = 'scope']")
          abstract_cleanup1(f, dest)
          abstract_header(dest)
        end
      end

      def abstract_cleanup1(source, dest)
        source.elements.reject { |e| %w(h1 h2).include?(e.name) }.each do |e|
          e1 = e.dup
          e1.xpath("self::p | .//p").each do |p|
            p["class"] = stylesmap[:abstract]
            p["style"] ||= ""
            p["style"] = "font-family: 'Arial', sans-serif;#{p['style']}"
          end
          dest and dest << e1
        end
      end

      def abstract_header(dest)
        dest.elements.first.add_first_child <<~XML
          <span class='IEEEStdsAbstractHeader'><span lang='EN-US'>Abstract:</span></span>
        XML
      end

      def introduction_cleanup(docxml)
        dest = docxml.at("div[@id = 'introduction-destination']") or return
        unless i = docxml.at("//h1[@class = 'IntroTitle']")&.parent
          dest.parent.remove
          return
        end
        introduction_cleanup1(i, dest)
      end

      def introduction_cleanup1(intro, dest)
        introduction_to_frontispiece(intro, dest)
        introduction_para_style(intro.document)
      end

      def introduction_to_frontispiece(intro, dest)
        docxml = intro.document
        intro.previous_element.remove
        introcontent = docxml.xpath("//h1[@class = 'IntroTitle']")
          .map(&:parent).uniq.map(&:remove)
        introcontent.each do |node|
          dest.add_previous_sibling(node)
        end
        dest.remove
      end

      def introduction_para_style(docxml)
        docxml.xpath("//h1[@class = 'IntroTitle']").each do |i|
          i.next_element or next
          if i.next_element.name == "div" &&
              i.next_element["class"] == stylesmap[:intro]
            i.next_element.name = "p"
          end
        end
      end
    end
  end
end
