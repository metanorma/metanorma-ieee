module IsoDoc
  module Ieee
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
        example_caption(docxml)
      end

      def example_caption(docxml)
        docxml.xpath("//p[@class = 'example-title']").each do |s|
          s["class"] = stylesmap[:MsoNormal]
        end
      end

      def sourcecode_cleanup(docxml)
        docxml.xpath("//p[@class = 'Sourcecode']").each do |para|
          br_elements = para.xpath(".//br")
          br_elements.empty? and next
          split_para_at_breaks(para).reverse.each do |new_para|
            para.add_next_sibling(new_para)
          end
          para.remove
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

      private

      def split_para_at_breaks(para)
        result_paras = []
        current_para = create_new_para(para)
        # Process each child node of the para
        para.children.each do |node|
          current_para =
            process_node_for_sourcecode_breaks(node, current_para, result_paras)
        end
        # Add the final para if it has content
        result_paras << current_para if para_has_content?(current_para)
        result_paras
      end

      def create_new_para(original_para)
        new_para = Nokogiri::XML::Node.new("p", original_para.document)
        # Copy all attributes from original para
        original_para.attributes.each do |name, attr|
          new_para[name] = attr.value
        end
        new_para
      end

      def process_node_for_sourcecode_breaks(node, current, result_paras)
        if node.name == "br"
          # Found a break - finish current para and start a new one
          result_paras << current if para_has_content?(current)
          current = create_new_para(node.document.at("//p[@class='Sourcecode']"))
        elsif node.xpath(".//br").any?
          current = process_element_with_breaks(node, current, result_paras)
        else
          current.add_child(node.dup)
        end
        current
      end

      def process_element_with_breaks(node, curr_para, result_paras)
        # Create element structure for current para
        curr_elem = node.dup
        curr_elem.children.remove

        node.children.each do |child|
          if child.name == "br"
            # Close current element and finish para
            element_has_content?(curr_elem) and
              curr_para.add_child(curr_elem.dup)
            para_has_content?(curr_para) and result_paras << curr_para
            # Start new para and reopen element structure
            curr_para = create_new_para(node.document.at("//p[@class='Sourcecode']"))
            curr_elem = node.dup
            curr_elem.children.remove
          elsif child.xpath(".//br").any?
            # Add child to current element
            temp_para = create_new_para(node.document.at("//p[@class='Sourcecode']"))
            temp_para = process_element_with_breaks(child, temp_para, result_paras)
            # If new paras were created, we need to handle the split
            if result_paras.any? && result_paras.last != curr_para
              # A split occurred, add current element to current para and update
              curr_para.add_child(curr_elem.dup) if element_has_content?(curr_elem)
              curr_para = temp_para
              curr_elem = node.dup
              curr_elem.children.remove
            else
              # No split, add the processed child
              curr_elem.add_child(child.dup)
            end
          # Recursively handle nested breaks
          else
            curr_elem.add_child(child.dup)
          end
        end
        # Add final element if it has content
        curr_para.add_child(curr_elem.dup) if element_has_content?(curr_elem)
        curr_para
      end

      def para_has_content?(para)
        para.children.any? && !para.content.strip.empty?
      end

      def element_has_content?(element)
        element.children.any?
      end
    end
  end
end
