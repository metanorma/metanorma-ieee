module IsoDoc
  module IEEE
    class WordConvert < IsoDoc::WordConvert
      def toWord(result, filename, dir, header)
        result = from_xhtml(word_cleanup(to_xhtml(result)))
          .gsub(/-DOUBLE_HYPHEN_ESCAPE-/, "--")
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

      def abstract_cleanup(docxml)
        dest = docxml.at("div[@id = 'abstract-destination']") or return
        if f = docxml.at("//div[@class = 'abstract']")
          f.previous_element.remove
          abstract_cleanup1(f, dest)
          f.remove
        elsif f = docxml.at("//div[@type = 'scope']")
          abstract_cleanup1(f, dest)
        end
      end

      def abstract_cleanup1(source, dest)
        source.elements.each do |e|
          next if %w(h1 h2).include?(e.name)

          dest << e.dup
          dest.elements.last["class"] = "IEEEStdsAbstractBody"
        end
        dest.elements.first.children.first.previous =
          "<span class='IEEEStdsAbstractHeader'><span lang='EN-US'>"\
          "Abstract:</span></span> "
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
        docxml = intro.document
        intro.previous_element.remove
        dest.replace(intro.remove)
        i = docxml.at("//h1[@class = 'IntroTitle']")
        if i.next_element.name == "div" &&
            i.next_element["class"] == "IEEEStdsIntroduction"
          i.next_element.name = "p"
        end
      end

      def word_cleanup(docxml)
        super
        abstract_cleanup(docxml)
        introduction_cleanup(docxml)
        sourcecode_cleanup(docxml)
        div_cleanup(docxml)
        biblio_cleanup(docxml)
        headings_cleanup(docxml)
        span_style_cleanup(docxml)
        caption_cleanup(docxml)
        table_cleanup(docxml)
        style_cleanup(docxml)
        para_type_cleanup(docxml)
        docxml
      end

      def biblio_cleanup(docxml)
        docxml.xpath("//p[@class = 'Biblio']").each do |p|
          headings_strip(p)
        end
      end

      def table_cleanup(docxml)
        thead_cleanup(docxml)
        tbody_cleanup(docxml)
      end

      def thead_cleanup(docxml)
        docxml.xpath("//thead").each do |h|
          h.xpath(".//td | .//th").each do |t|
            if t.at("./p")
              t.xpath("./p").each { |p| p["class"] = "IEEEStdsTableColumnHead" }
            else
              t.children =
                "<p class='IEEEStdsTableColumnHead'>#{t.children.to_xml}</p>"
            end
          end
        end
      end

      def tbody_cleanup(docxml)
        docxml.xpath("//tbody | //tfoot").each do |h|
          next if h.at("./ancestor::div[@class = 'boilerplate-feedback']")

          h.xpath(".//td | .//th").each do |t|
            style = td_style(t)
            if t.at("./p")
              t.xpath("./p").each { |p| p["class"] = style }
            else
              t.children = "<p class='#{style}'>#{t.children.to_xml}</p>"
            end
          end
        end
      end

      def td_style(cell)
        if cell.name == "th"
          "IEEEStdsTableLineHead"
        elsif cell["align"] == "center" || /text-align:center/.match?(cell["style"])
          "IEEEStdsTableData-Center"
        else
          "IEEEStdsTableData-Left"
        end
      end

      def headings_cleanup(docxml)
        (1..9).each do |i|
          headings_cleanup1(docxml, i)
        end
        docxml.xpath("//div[@class = 'Annex']").each do |a|
          a.delete("class")
        end
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
        elsif hdr.at("./ancestor::div[@class = 'Section3']") && idx == 1
          hdr.name = "p"
          hdr["class"] = "IEEEStdsLevel1frontmatter"
        else
          hdr.name = "p"
          hdr["class"] = "IEEEStdsLevel#{idx}Header"
        end
      end

      def headings_strip(hdr)
        if hdr.children.size > 1 && hdr.children[1].name == "span" &&
            hdr.children[1]["style"] == "mso-tab-count:1"
          2.times { hdr.children.first.remove }
        end
      end

      def caption_cleanup(docxml)
        docxml.xpath("//p[@class = 'TableTitle']").each do |s|
          s.children = s.children.to_xml
            .sub(/^#{@i18n.table}(\s+[A-Z0-9.]+)?/, "")
        end
        docxml.xpath("//p[@class = 'FigureTitle']").each do |s|
          s.children = s.children.to_xml
            .sub(/^#{@i18n.figure}(\s+[A-Z0-9.]+)?/, "")
        end
      end

      def div_cleanup(docxml)
        d = docxml.at("//div[@class = 'WordSection2']"\
                      "[div[@class = 'WordSection2']]") and
          d.replace(d.children)
        i = 0
        docxml.xpath("//div[@class]").each do |div|
          next unless /^WordSection/.match?(div["class"])

          i += 1
          div["class"] = "WordSection#{i}"
        end
      end

      def sourcecode_cleanup(docxml)
        docxml.xpath("//p[@class = 'Sourcecode']").each do |s|
          s.replace(s.to_xml.gsub(%r{<br/>}, "</p><p class='Sourcecode'>"))
        end
      end

      def para_type_cleanup(html)
        html.xpath("//p[@type]").each { |p| p.delete("type") }
      end

      def span_style_cleanup(html)
        html.xpath("//strong").each do |s|
          s.name = "span"
          s["class"] = "IEEEStdsParaBold"
        end
      end

      def note_style_cleanup(docxml)
        docxml.xpath("//span[@class = 'note_label']").each do |s|
          multi = /^#{@i18n.note}\s+[A-Z0-9.]+/.match?(s.text)
          div = s.at("./ancestor::div[@class = 'Note']")
          s.remove if multi
          div.xpath(".//p[@class = 'Note' or not(@class)]")
            .each_with_index do |p, i|
            p["class"] =
              i.zero? && multi ? "IEEEStdsMultipleNotes" : "IEEEStdsSingleNote"
          end
        end
      end

      STYLESMAP = {
        MsoNormal: "IEEEStdsParagraph",
        NormRef: "IEEEStdsParagraph",
        Biblio: "IEEEStdsBibliographicEntry",
        figure: "IEEEStdsImage",
        formula: "IEEEStdsEquation",
        Sourcecode: "IEEEStdsComputerCode",
        TableTitle: "IEEEStdsRegularTableCaption",
        FigureTitle: "IEEEStdsRegularFigureCaption",
      }.freeze

      def style_cleanup(docxml)
        note_style_cleanup(docxml)
        docxml.xpath("//div[@class = 'formula']/p").each do |p|
          p["class"] = "IEEEStdsEquation"
        end
        STYLESMAP.each do |k, v|
          docxml.xpath("//*[@class = '#{k}']").each { |s| s["class"] = v }
        end
        docxml.xpath("//p[not(@class)]").each do |p|
          p["class"] = "IEEEStdsParagraph"
        end
      end
    end
  end
end
