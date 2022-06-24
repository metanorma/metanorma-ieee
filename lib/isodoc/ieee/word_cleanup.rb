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
        i.next_element == "div" && i.next_element["class"] == "Admonition" and
          i.next_element["class"] = "IEEEStdsIntroduction"
      end

      def word_cleanup(docxml)
        super
        abstract_cleanup(docxml)
        introduction_cleanup(docxml)
        div_cleanup(docxml)
        headings_cleanup(docxml)
        span_style_cleanup(docxml)
        style_cleanup(docxml)
        para_type_cleanup(docxml)
        docxml
      end

      def headings_cleanup(docxml)
        (1..4).each do |i|
          docxml.xpath("//h#{i}").each do |h|
            headings_cleanup1(h)
            h.name = "p"
            h["class"] = "IEEEStdsLevel#{i}Header"
          end
        end
      end

      def headings_cleanup1(hdr)
        if hdr.children.size > 1 && hdr.children[1].name == "span" &&
            hdr.children[1]["style"] == "mso-tab-count:1"
          2.times { hdr.children.first.remove }
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

      def para_type_cleanup(html)
        html.xpath("//p[@type]").each { |p| p.delete("type") }
      end

      def span_style_cleanup(html)
        html.xpath("//strong").each do |s|
          s.name = "span"
          s["class"] = "IEEEStdsParaBold"
        end
      end

      STYLESMAP = {
        MsoNormal: "IEEEStdsParagraph",
        NormRef: "IEEEStdsParagraph",
        Biblio: "IEEEStdsBibliographicEntry",
        figure: "IEEEStdsImage",
      }.freeze

      def style_cleanup(docxml)
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
