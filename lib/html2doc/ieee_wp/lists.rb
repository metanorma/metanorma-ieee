class Html2Doc
  class Ieee_Wp < ::Html2Doc
    def list2para(list)
      list.name == "ol" and return super
      return if list.xpath("./li").empty?

      list.xpath("./li/p").each do |p|
        p["class"] ||= "BulletedList"
      end
      list.xpath("./li").each do |l|
        l.name = "p"
        l["class"] ||= "BulletedList"
        next unless l.first_element_child&.name == "p"

        l["style"] ||= ""
        l["style"] += l.first_element_child["style"]
          &.sub(/mso-list[^;]+;/, "") || ""
        l.first_element_child.replace(l.first_element_child.children)
      end
      list.replace(list.children)
    end
  end
end
