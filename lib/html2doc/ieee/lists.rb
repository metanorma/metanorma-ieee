class Html2Doc
  class Ieee < ::Html2Doc
    def style_list(elem, level, liststyle, listnumber)
      return unless liststyle

      sameelem_level = elem.ancestors.map(&:name).count(elem.parent.name)
      if elem["style"]
        elem["style"] += ";"
      else
        elem["style"] = ""
      end
      sameelem_level1 = sameelem_level
      if liststyle == "l11" && sameelem_level.to_i > 1
        liststyle = "l21"
        sameelem_level1 -= 1
      end
      if liststyle == "l16"
        s = case elem.parent["type"]
            when "a" then 1
            when "1" then 2
            else 3
            end
        sameelem_level1 += s - (sameelem_level1 % 3)
        sameelem_level1 < 1 and sameelem_level1 += 3
      end
      elem["style"] += "mso-list:#{liststyle} level#{sameelem_level1} lfo#{listnumber}-#{level};"
      elem["style"] += "text-indent:-0.79cm; margin-left:#{0.4 + (level.to_i * 0.76)}cm;"
      elem.parent["level"] = level
      elem.parent["sameelem_level"] = sameelem_level
    end

    def list2para(list)
      return if list.xpath("./li").empty?

      level = list["level"] || "1"
      list.delete("level")
      samelevel = list["sameelem_level"] || "1"
      list.delete("sameelem_level")
      list2para1(list, samelevel, list.name)
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

        l["style"] +=
          l.first_element_child["style"]&.sub(/mso-list[^;]+;/, "") || ""
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
