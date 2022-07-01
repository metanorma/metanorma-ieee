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

      def admonition_cleanup(docxml)
        super
        docxml.xpath("//div[@class = 'zzHelp']").each do |d|
          d.xpath(".//p").each do |p|
            %w(IEEEStdsWarning IEEEStdsParagraph).include?(p["class"]) ||
              !p["class"] or next

            p["class"] = "zzHelp"
          end
        end
        docxml
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
        if cell.name == "th" then "IEEEStdsTableLineHead"
        elsif cell["align"] == "center" || /text-align:center/.match?(cell["style"])
          "IEEEStdsTableData-Center"
        else "IEEEStdsTableData-Left"
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
        elsif hdr.at("./ancestor::div[@class = 'Section3']")
          hdr.name = "p"
          hdr["class"] = "IEEEStdsLevel#{idx}frontmatter"
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
        table_caption(docxml)
        figure_caption(docxml)
        example_caption(docxml)
      end

      def table_caption(docxml)
        docxml.xpath("//p[@class = 'TableTitle']").each do |s|
          s.children = s.children.to_xml
            .sub(/^#{@i18n.table}(\s+[A-Z0-9.]+)?/, "")
        end
      end

      def figure_caption(docxml)
        docxml.xpath("//p[@class = 'FigureTitle']").each do |s|
          s.children = s.children.to_xml
            .sub(/^#{@i18n.figure}(\s+[A-Z0-9.]+)?/, "")
        end
      end

      def example_caption(docxml)
        docxml.xpath("//p[@class = 'example-title']").each do |s|
          s.children = "<em>#{s.children.to_xml}</em>"
          s["class"] = "IEEEStdsParagraph"
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

      def note_style_cleanup(docxml)
        docxml.xpath("//span[@class = 'note_label']").each do |s|
          multi = /^#{@i18n.note}\s+[A-Z0-9.]+/.match?(s.text)
          div = s.at("./ancestor::div[@class = 'Note']")
          if multi
            s.remove
            seq = notesequence(div)
          else seq = nil
          end
          note_style_cleanup1(multi, div, seq)
        end
      end

      def notesequence(div)
        @notesequences ||= { max: 0, lookup: {} }
        unless id = @notesequences[:lookup][@xrefs.anchor(div["id"], :sequence)]
          @notesequences[:max] += 1
          id = @notesequences[:max]
          @notesequences[:lookup][@xrefs.anchor(div["id"], :sequence)] = id
        end
        id
      end

      # hardcoded list style for notes
      def note_style_cleanup1(multi, div, seq)
        div.xpath(".//p[@class = 'Note' or not(@class)]")
          .each_with_index do |p, i|
          p["class"] =
            i.zero? && multi ? "IEEEStdsMultipleNotes" : "IEEEStdsSingleNote"
          if multi
            p["style"] ||= ""
            p["style"] += "mso-list:l17 level1 lfo#{seq};"
          end
        end
      end

      STYLESMAP = {
        example: "IEEEStdsParagraph",
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
