module IsoDoc
  module IEEE
    class WordConvert < IsoDoc::WordConvert
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
        officemember_style(docxml)
        three_column_officemembers(docxml
          .at("//div[@id = 'boilerplate-participants']"))
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
        <span lang="EN-US" style='font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family:
        "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-ansi-language:
        EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA'><br clear="all"
        style='page-break-before:auto;mso-break-type:section-break'></span>
      BREAK

      def officemember_style(docxml)
        docxml.xpath("//p[@type = 'officemember']").each do |p|
          p["class"] = "IEEEStdsNamesList"
        end
        docxml.xpath("//p[@type = 'emeritus_sign']").each do |p|
          p["class"] = "IEEEStdsParaMemEmeritus"
        end
      end

      def three_column_officemembers(div)
        ret = three_column_officemembers_split(div)
        three_column_officemembers_render(div, ret)
      end

      def three_column_officemembers_split(div)
        prev = false
        div.elements.each_with_object([[]]) do |e, m|
          member = e.name == "p" && e["type"] == "officemember"
          (prev == member and m[-1] << e.to_xml) or m << [e.to_xml]
          prev = member
        end.map(&:join)
      end

      def three_column_officemembers_render(div, ret)
        div.children = ret[0]
        out = ret[1..-1].map.with_index do |d, i|
          para = i % 2 == 1 && i != ret.size - 1 ? "<p>&#xa0;</p>" : ""
          "<div class='WordSection'>#{para}#{d}</div>"
        end.join(SECTIONBREAK)
        div.document.at("//div[@class = 'WordSection11']")
          .previous_element.previous = SECTIONBREAK + out
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
          feedback_style1(div, i)
        end
      end

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
    end
  end
end
