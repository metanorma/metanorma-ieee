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
        dest = docxml.at("div[@id = 'abstract-destination']")
        if f = docxml.at("//div[@class = 'abstract']")
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

      def word_cleanup(docxml)
        super
        div_cleanup(docxml)
        style_cleanup(docxml)
        para_type_cleanup(docxml)
        docxml
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
        html.xpath("//strong").each do |s|
          s.name = "span"
          s["class"] = "IEEEStdsParaBold"
        end
        html.xpath("//em").each do |s|
          s.name = "span"
          s["class"] = "IEEEStdsAddItal"
        end
      end

      STYLESMAP = {
        MsoFootnoteText: "IEEEStdsFootnote",
        MsoNormal: "IEEEStdsParagraph",
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
