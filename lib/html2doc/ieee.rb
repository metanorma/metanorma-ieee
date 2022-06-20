class Html2Doc
  class IEEE < ::Html2Doc
    def process_footnote_texts(docxml, footnotes)
      body = docxml.at("//body")
      list = body.add_child("<div style='mso-element:footnote-list'/>")
      footnotes.each_with_index do |f, i|
        if i.zero?
          fn = list.first.add_child(footnote_container_nofn(docxml, i + 1))
          f.parent = fn.first
          footnote_div_to_p_unstyled(f)
        else
          fn = list.first.add_child(footnote_container(docxml, i + 1))
          f.parent = fn.first
          footnote_div_to_p(f)
        end
      end
      footnote_cleanup(docxml)
    end

    def footnote_container_nofn(_docxml, idx)
      <<~DIV
        <div style='mso-element:footnote' id='ftn#{idx}'>
          <a style='mso-footnote-id:ftn#{idx}' href='#_ftn#{idx}'
             name='_ftnref#{idx}' title='' id='_ftnref#{idx}'></a></div>
      DIV
    end

    def footnote_div_to_p_unstyled(elem)
      if %w{div aside}.include? elem.name
        if elem.at(".//p")
          elem.replace(elem.children)
        else
          elem.name = "p"
        end
      end
    end

    def transform_footnote_text(note)
      note["id"] = ""
      note.xpath(".//div").each { |div| div.replace(div.children) }
      note.xpath(".//aside | .//p").each do |p|
        p.name = "p"
        %w(IEEEStdsCRTextReg IEEEStdsCRTextItal).include?(p["class"]) or
          p["class"] = "IEEEStdsFootnote"
      end
      note.remove
    end

    def list2para(list)
      return if list.xpath("./li").empty?

      if list.name == "ol"
        list2para_ol(list)
      else
        list2para_ul(list)
      end
    end

    def list2para_ul(list)
      list.xpath("./li").first["class"] ||= "IEEEStdsUnorderedListCxSpFirst"
      list.xpath("./li").last["class"] ||= "IEEEStdsUnorderedListCxSpLast"
      list.xpath("./li/p").each do |p|
        p["class"] ||= "IEEEStdsUnorderedListCxSpMiddle"
      end
      list.xpath("./li").each do |l|
        l.name = "p"
        l["class"] ||= "IEEEStdsUnorderedListCxSpMiddle"
        l&.first_element_child&.name == "p" and
          l.first_element_child.replace(l.first_element_child.children)
      end
      list.replace(list.children)
    end

    def list2para_ol(list)
      list.xpath("./li").first["class"] ||= "IEEEStdsNumberedListLevel1CxSpFirst"
      list.xpath("./li").last["class"] ||= "IEEEStdsNumberedListLevel1CxSpLast"
      list.xpath("./li/p").each do |p|
        p["class"] ||= "IEEEStdsNumberedListLevel1CxSpMiddle"
      end
      list.xpath("./li").each do |l|
        l.name = "p"
        l["class"] ||= "IEEEStdsNumberedListLevel1CxSpMiddle"
        l&.first_element_child&.name == "p" and
          l.first_element_child.replace(l.first_element_child.children)
      end
      list.replace(list.children)
    end
  end
end
