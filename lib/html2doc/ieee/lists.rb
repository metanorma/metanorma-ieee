class Html2Doc
  class IEEE < ::Html2Doc
    def style_list(elem, level, liststyle, listnumber)
      super
      elem.parent["level"] = level
    end

    def list2para(list)
      return if list.xpath("./li").empty?

      level = list["level"] || "1"
      list.delete("level")
      list2para1(list, level, list.name)
    end

    def list2para1(list, level, type)
      list.xpath("./li").first["class"] ||= list_style(type, level, "First")
      list.xpath("./li").last["class"] ||= list_style(type, level, "Last")
      list.xpath("./li/p").each do |p|
        p["class"] ||= list_style(type, level, "Middle")
      end
      list.xpath("./li").each do |l|
        l.name = "p"
        l["class"] ||= list_style(type, level, "Middle")
        next unless l&.first_element_child&.name == "p"

        l["style"] += (l.first_element_child["style"] || "")
        l.first_element_child.replace(l.first_element_child.children)
      end
      list.replace(list.children)
    end

    def list_style(listtype, level, position)
      case listtype
      when "ol" then "IEEEStdsNumberedListLevel#{level}CxSp#{position}"
      when "ul"
        case level
        when "1" then "IEEEStdsUnorderedListCxSp#{position}"
        else "IEEEStdsUnorderedListLevel2"
        end
      end
    end
  end
end
