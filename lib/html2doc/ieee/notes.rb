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

    def cleanup(docxml)
      super
      docxml.xpath("//div[@class = 'Note']").each do |d|
        d.delete("class")
      end
      docxml
    end
  end
end
