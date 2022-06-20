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

      def authority_cleanup(docxml)
        feedback_footnote(docxml)
        %w(copyright license disclaimers participants).each do |t|
          authority_cleanup1(docxml, t)
        end
        coverpage_note_cleanup(docxml)
        abstract_cleanup(docxml)
        authority_style(docxml)
      end

      def feedback_footnote(docxml)
        feedback_style(docxml)
        feedback_table(docxml)
        f = docxml.at("//div[@class = 'boilerplate-feedback']")
        docxml.at("//aside").previous = <<~FN
          <aside id="ftn0">#{f.remove.to_xml}</aside>
        FN
      end

      def authority_style(docxml)
        copyright_style(docxml)
        license_style(docxml)
        officer_style(docxml)
      end

      def copyright_style(docxml)
        docxml.at("//div[@class = 'boilerplate-copyright']").xpath(".//p")
          .reverse.each_with_index do |p, i|
          p["class"] =
            i.zero? ? "IEEEStdsTitleDraftCRBody" : "IEEEStdsTitleDraftCRaddr"
        end
      end

      def license_style(docxml)
        docxml.at("//div[@class = 'boilerplate-license']").xpath(".//p")
          .reverse.each_with_index do |p, i|
          p["class"] =
            i.zero? ? "IEEEStdsTitleDraftCRBody" : "IEEEStdsTitleDraftCRaddr"
        end
      end

      def officer_style(docxml)
        docxml.xpath("//p[@type = 'officeholder']").each do |p|
          officeholder_style(p)
        end
        docxml.xpath("//p[@type = 'officemember']").each do |p|
          officemember_style(p)
        end
      end

      def officeholder_style(para)
        n = para.next_element
        p = para.previous_element
        n && n.name == "p" && n["type"] == "officeholder" and
          klass = "IEEEStdsNamesCtrCxSpLast"
        p && p.name == "p" && p["type"] == "officeholder" and
          klass = "IEEEStdsNamesCtrCxSpFirst"
        para["class"] = klass || "IEEEStdsNamesCtrCxSpMiddle"
      end

      SECTIONBREAK = <<~BREAK.freeze
        </div>
        <span lang="EN-US" style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family:
        "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-ansi-language:
        EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'><br clear="all"
        style='page-break-before:auto;mso-break-type:section-break'></span>
        <div class="WordSection">
      BREAK

      def officemember_style(para)
        para["class"] = "IEEEStdsNamesList"
        n = para.next_element
        p = para.previous_element
        (n && n.name == "p" && n["type"] == "officemember") or
          para.previous = SECTIONBREAK
        (p && p.name == "p" && p["type"] == "officemember") or
          para.next = SECTIONBREAK
      end

      def feedback_table(docxml)
        docxml.at("//div[@class = 'boilerplate-feedback']").xpath(".//table")
          .each do |t|
          t.xpath(".//tr").each do |tr|
            feedback_table1(tr)
          end
          t.replace(t.at(".//tbody").elements)
        end
      end

      def feedback_table1(trow)
        trow.name = "p"
        trow["class"] = "IEEEStdsCRTextReg"
        trow.xpath("./td").each do |td|
          td.next_element and td << "<span style='mso-tab-count:1'> </span>"
          td.replace(td.children)
        end
      end

      def feedback_style(docxml)
        docxml.at("//div[@class = 'boilerplate-feedback']").xpath("./div")
          .each_with_index do |div, i|
          i.zero? or div.elements.first.previous = "<p>&#xa0;</p>"
          div.xpath(".//p").each_with_index do |p, j|
            p["class"] = i == 4 ? "IEEEStdsCRTextItal" : "IEEEStdsCRTextReg"
            j.zero? && i.zero? and
              p.children.first.previous =
                '<a style="mso-footnote-id:ftn0" href="#_ftnref0" name="_ftn0" title=""/>'
          end
        end
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

      def authority_cleanup1(docxml, klass)
        dest = docxml.at("//div[@id = 'boilerplate-#{klass}-destination']")
        auth = docxml.at("//div[@id = 'boilerplate-#{klass}' "\
                         "or @class = 'boilerplate-#{klass}']")
        auth&.xpath(".//h1[not(text())] | .//h2[not(text())]")&.each(&:remove)
        authority_cleanup_hdr(auth)
        dest and auth and dest.replace(auth.remove)
      end

      def authority_cleanup_hdr(auth)
        (1..2).each do |i|
          auth&.xpath(".//h#{i}")&.each do |h|
            h.name = "p"
            h["class"] = "IEEEStdsLevel#{i}frontmatter"
          end
        end
      end

      def word_cleanup(docxml)
        super
        div_cleanup(docxml)
        style_cleanup(docxml)
        para_type_cleanup(docxml)
        docxml
      end

      def div_cleanup(docxml)
        d = docxml.at("//div[@class = 'WordSection2']/"\
                      "div[@class = 'WordSection2']") and
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
