module Metanorma
  module Ieee
    class Converter < Standoc::Converter
      def initial_boilerplate(xml, isodoc)
        intro_boilerplate(xml, isodoc)
        super if @document_scheme == "ieee-sa-2021"
        xml.at("//boilerplate") or return
        initial_note(xml)
        word_usage(xml)
        participants(xml)
        footnote_boilerplate_renumber(xml)
      end

      def footnote_boilerplate_renumber(xml)
        xml.xpath("//boilerplate//fn").each_with_index do |f, i|
          f["reference"] = "_boilerplate_#{i + 1}"
        end
      end

      def intro_boilerplate(xml, isodoc)
        intro = xml.at("//introduction/title") or return
        adm = isodoc.populate_template(@i18n.introduction_disclaimer)
        intro.next = "<admonition>#{adm}</admonition>"
        add_id(intro.next)
      end

      def initial_note(xml)
        n = xml.at("//boilerplate//note[@anchor = 'boilerplate_front']")
        s = xml.at("//sections")
        (n && s) or return
        s.children.empty? and s << " "
        s.children.first.previous = n.remove
      end

      def word_usage(xml)
        @document_scheme == "ieee-sa-2021" or return
        n = xml.at("//boilerplate//clause[@anchor = 'boilerplate_word_usage']")
          &.remove
        s = xml.at("//clause[@type = 'overview']")
        (n && s) or return
        s << n
      end

      PARTICIPANT_BOILERPLATE_LOCATIONS =
        { "boilerplate-participants-wg": "working group",
          "boilerplate-participants-bg": "balloting group",
          "boilerplate-participants-sb": "standards board",
          "boilerplate-participants-blank": nil }.freeze

      def participants(xml)
        @document_scheme == "ieee-sa-2021" or return
        PARTICIPANT_BOILERPLATE_LOCATIONS.each do |k, v|
          populate_participants(xml, k.to_s, v)
        end
        emeritus_sign(xml)
        xml.at("//sections//clause[@type = 'participants']")&.remove
      end

      def emeritus_sign(xml)
        p = xml.at(".//p[@type = 'emeritus_sign']") or return
        ul = xml.at("//clause[@anchor = 'boilerplate-participants-sb']//ul") or
          return
        has_asterisk = ul.xpath(".//p")&.any? do |li|
          li.text.strip.end_with?("*")
        end
        if has_asterisk then ul.next = p
        else p.remove
        end
      end

      def populate_participants(xml, target, subtitle)
        t = xml.at("//clause[@anchor = '#{target}']/membership") or return
        s = xml.xpath("//clause[@type = 'participants']/clause").detect do |x|
          n = x.at("./title") and n.text.strip.downcase == subtitle
        end
        t.replace(populate_participants1(s || t))
      end

      def populate_participants1(clause)
        participants_dl_to_ul(clause)
        clause.xpath(".//ul | .//ol").each do |ul|
          ul.name = "ul"
          ul.xpath("./li").each { |li| populate_participants2(li) }
          ul.xpath(".//p[normalize-space() = '']").each(&:remove)
        end
        clause.at("./title")&.remove
        clause.children.to_xml
      end

      def participants_dl_to_ul(clause)
        clause.xpath(".//dl").each do |dl|
          dl.ancestors("dl, ul, ol").empty? or next
          dl.name = "ul"
          dl.xpath("./dt").each(&:remove)
          dl.xpath("./dd").each { |li| li.name = "li" }
        end
      end

      def populate_participants2(list)
        add_id(list)
        curr = list
        p = curr.at("./p[text() != '']") and curr = p
        if dl = curr.at("./dl")
          ret = extract_participants(dl)
          dl.children = ret.keys.map do |k|
            "<dt>#{k}</dt><dd #{add_id_text}><p>#{ret[k]}</p></dd>"
          end.join
        else list.children = <<~XML
          <dl><dt>name</dt><dd #{add_id_text}><p>#{curr.children.to_xml}
          </p></dd><dt>role</dt><dd #{add_id_text}><p>member</p></dd></dl>
        XML
        end
      end

      def extract_participants(dlist)
        key = ""
        map = dlist.xpath("./dt | ./dd").each_with_object({}) do |dtd, m|
          (dtd.name == "dt" and key = dtd.text.sub(/:+$/, "")) or
            m[key.strip.downcase] = text_from_paras(dtd)
        end
        map["company"] &&= "<span class='organization'>#{map['company']}</span>"
        map["role"] ||= "member"
        map
      end
    end
  end
end
