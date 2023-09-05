module IsoDoc
  module IEEE
    class WordConvert < IsoDoc::WordConvert
      # STYLE
      def admonition_cleanup(docxml)
        super
        docxml.xpath("//div[@class = 'zzHelp']").each do |d|
          d.xpath(".//p").each do |p|
            [stylesmap[:admonition], stylesmap[:MsoNormal]]
              .include?(p["class"]) || !p["class"] or next
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
            thead_cell_cleanup(t)
          end
        end
      end

      def thead_cell_cleanup(cell)
        s = stylesmap[:table_columnhead]
        if cell.at("./p")
          cell.xpath("./p").each do |p|
            p["class"] = s
          end
        else
          cell.children =
            "<p class='#{s}'>#{to_xml(cell.children)}</p>"
        end
      end

      def tbody_cleanup(docxml)
        docxml.xpath("//tbody | //tfoot").each do |h|
          next if h.at("./ancestor::div[@class = 'boilerplate-feedback']")

          h.xpath(".//th").each { |t| tbody_head_cleanup(t) }
          h.xpath(".//td | .//th").each { |t| tbody_cleanup1(t) }
        end
      end

      def tbody_head_cleanup(cell)
        cell.at("./p") or
          cell.children = "<p>#{to_xml(cell.children)}</p>"
        cell.xpath("./p").each do |p|
          p.replace to_xml(p).gsub(%r{<br/>}, "</p><p>")
        end
      end

      def tbody_cleanup1(cell)
        if cell.at("./p")
          cell.xpath("./p").each_with_index do |p, i|
            p["class"] = td_style(cell, i)
          end
        else
          cell.children =
            "<p class='#{td_style(cell, 0)}'>#{to_xml(cell.children)}</p>"
        end
      end

      def td_style(cell, idx)
        if cell.name == "th" && idx.zero? then stylesmap[:table_head]
        elsif cell.name == "th" then stylesmap[:table_subhead]
        elsif cell["align"] == "center" ||
            cell["style"].include?("text-align:center")
          stylesmap[:tabledata_center]
        else stylesmap[:tabledata_left]
        end
      end

      def caption_cleanup(docxml)
        table_caption(docxml)
        figure_caption(docxml)
        example_caption(docxml)
      end

      def table_caption(docxml)
        docxml.xpath("//p[@class = 'TableTitle']").each do |s|
          s.children = to_xml(s.children)
            .sub(/^#{@i18n.table}(\s+[A-Z0-9.]+)?/, "")
        end
      end

      def figure_caption(docxml)
        docxml.xpath("//p[@class = 'FigureTitle']").each do |s|
          s.children = to_xml(s.children)
            .sub(/^#{@i18n.figure}(\s+[A-Z0-9.]+)?/, "")
        end
      end

      def example_caption(docxml)
        docxml.xpath("//p[@class = 'example-title']").each do |s|
          s.children = "<em>#{to_xml(s.children)}</em>"
          s["class"] = stylesmap[:MsoNormal]
        end
      end

      def sourcecode_cleanup(docxml)
        docxml.xpath("//p[@class = 'Sourcecode']").each do |s|
          s.replace(to_xml(s).gsub(%r{<br/>}, "</p><p class='Sourcecode'>"))
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
        unless id = @notesequences[:lookup][@xrefs.anchor(div["id"],
                                                          :sequence)]
          @notesequences[:max] += 1
          id = @notesequences[:max]
          @notesequences[:lookup][@xrefs.anchor(div["id"], :sequence)] =
            id
        end
        id
      end

      # hardcoded list style for notes
      # STYLE
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
    end
  end
end
