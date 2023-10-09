module IsoDoc
  module IEEE
    class WordConvert < IsoDoc::WordConvert
      def authority_cleanup(docxml)
        feedback_footnote(docxml)
        %w(copyright license disclaimers participants).each do |t|
          authority_cleanup1(docxml, t)
        end
        coverpage_note_cleanup(docxml)
        authority_style(docxml)
      end

      def feedback_footnote(docxml)
        feedback_style(docxml)
        feedback_table(docxml)
        f = docxml.at("//div[@class = 'boilerplate-feedback']") or return
        docxml.at("//aside").previous = <<~FN
          <aside id="ftn0">#{to_xml(f.remove)}</aside>
        FN
      end

      def authority_style(docxml)
        copyright_style(docxml)
        license_style(docxml)
        officer_style(docxml)
      end

      def copyright_style(docxml)
        docxml.at("//div[@class = 'boilerplate-copyright']")&.xpath(".//p")
          &.reverse&.each_with_index do |p, i|
          p["class"] =
            i.zero? ? "IEEEStdsTitleDraftCRBody" : "IEEEStdsTitleDraftCRaddr"
        end
      end

      def license_style(docxml)
        docxml.at("//div[@class = 'boilerplate-license']")&.xpath(".//p")
          &.reverse&.each_with_index do |p, i|
          p["class"] =
            i.zero? ? "IEEEStdsTitleDraftCRBody" : "IEEEStdsTitleDraftCRaddr"
        end
      end

      def officer_style(docxml)
        docxml.xpath("//p[@type = 'officeholder']").each do |p|
          officeholder_style(p)
        end
        officemember_style(docxml)
        officeorgrep_style(docxml)
        three_column_officemembers(docxml
          .at("//div[@id = 'boilerplate-participants']"))
      end

      def officeholder_style(para)
        n = para.next_element
        p = para.previous_element
        n && n.name == "p" && n["type"] != "officeholder" and
          klass = "IEEEStdsNamesCtrCxSpLast"
        p && p.name == "p" && p["type"] != "officeholder" and
          klass = "IEEEStdsNamesCtrCxSpFirst"
        para["class"] = klass || "IEEEStdsNamesCtrCxSpMiddle"
      end

      SECTIONBREAK = <<~BREAK.freeze
        <span lang="EN-US" style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family:
        "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-ansi-language:
        EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'><br clear="all"
        style='page-break-before:auto;mso-break-type:section-break'></span>
      BREAK

      def officemember_style(docxml)
        docxml.xpath("//p[@type = 'officemember' or @type = 'officeorgmember']")
          .each do |p|
          p["class"] = stylesmap[:nameslist]
        end
        docxml.xpath("//p[@type = 'emeritus_sign']").each do |p|
          p["class"] = "IEEEStdsParaMemEmeritus"
        end
      end

      def officeorgrep_style(docxml)
        docxml.xpath("//p[@type = 'officeorgrepmemberhdr']").each do |p|
          p["class"] = stylesmap[:nameslist]
          p["style"] =
            "margin-bottom:6.0pt;tab-stops:right 432.0pt;"
        end
        docxml.xpath("//p[@type = 'officeorgrepmember']").each do |p|
          p["class"] = stylesmap[:nameslist]
          p["style"] =
            "margin-top:6.0pt;tab-stops:right dotted 432.0pt;"
        end
      end

      def three_column_officemembers(div)
        div or return
        ret = three_column_officemembers_split(div)
        three_column_officemembers_render(div, ret)
      end

      def three_column_officemembers_split(div)
        prev = false
        div.xpath(".//div").each { |d| d.replace(d.children) }
        div.elements.each_with_object([[]]) do |e, m|
          member = e.name == "p" && e["type"] == "officemember"
          (prev == member and m[-1] << to_xml(e)) or m << [to_xml(e)]
          prev = member
        end.map(&:join)
      end

      def three_column_officemembers_render(div, ret)
        div.children = ret[0]
        out = ret[1..-1].map.with_index do |d, i|
          para = i % 2 == 1 && i != ret.size - 2 ? "<p>&#xa0;</p>" : ""
          "<div class='WordSection'>#{para}#{d}</div>"
        end.join(SECTIONBREAK)
        div.document.at("//div[@class = 'WordSectionIntro']")
          .previous_element.previous = SECTIONBREAK + out
      end

      def feedback_table(docxml)
        docxml.at("//div[@class = 'boilerplate-feedback']")&.xpath(".//table")
          &.each do |t|
          t.xpath(".//tr").each do |tr|
            feedback_table1(tr)
          end
          t.replace(t.at(".//tbody").elements)
        end
      end

      # STYLE
      def feedback_table1(trow)
        trow.name = "p"
        trow["class"] = "IEEEStdsCRTextReg"
        trow.xpath("./td").each do |td|
          td.next_element and td << "<span style='mso-tab-count:1'> </span>"
          td.replace(td.children)
        end
      end

      def feedback_style(docxml)
        docxml.at("//div[@class = 'boilerplate-feedback']")&.xpath("./div")
          &.each_with_index do |div, i|
          i.zero? or div.elements.first.previous = "<p>&#xa0;</p>"
          i == 4 and
            div.xpath(".//p[br]").each do |p|
              p.replace(to_xml(p).gsub(%r{<br/>}, "</p><p>"))
            end
          feedback_style1(div, i)
        end
      end

      # STYLE
      def feedback_style1(div, idx)
        div.xpath(".//p").each_with_index do |p, j|
          p["class"] = idx == 4 ? "IEEEStdsCRTextItal" : "IEEEStdsCRTextReg"
          j.zero? && idx.zero? and
            p.children.first.previous =
              '<a style="mso-footnote-id:ftn0" href="#_ftnref0" name="_ftn0" title=""/>'
        end
      end

      def authority_cleanup1(docxml, klass)
        dest = docxml.at("//div[@id = 'boilerplate-#{klass}-destination']")
        auth = docxml.at("//div[@id = 'boilerplate-#{klass}' " \
                         "or @class = 'boilerplate-#{klass}']")
        auth&.xpath(".//h1[not(text())] | .//h2[not(text())]")&.each(&:remove)
        authority_cleanup_hdr(auth)
        dest and auth and dest.replace(auth.remove)
      end

      def authority_cleanup_hdr(auth)
        (1..2).each do |i|
          auth&.xpath(".//h#{i}")&.each do |h|
            h.name = "p"
            h["class"] = "level#{i}frontmatter"
          end
        end
      end

      def abstract_cleanup(docxml)
        dest = docxml.at("div[@id = 'abstract-destination']") or return
        if f = docxml.at("//div[@class = 'abstract']")
          f.previous_element.remove
          abstract_cleanup1(f, dest)
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
        dest.elements.first.children.first.previous =
          "<span class='IEEEStdsAbstractHeader'><span lang='EN-US'>" \
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
            i.next_element["class"] == stylesmap[:intro]
          i.next_element.name = "p"
        end
      end
    end
  end
end
