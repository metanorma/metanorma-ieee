module IsoDoc
  module IEEE
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def bibdata_i18n(bib)
        super
        bibdata_dates(bib)
        developed_attrib(bib)
        sponsored_attrib(bib)
      end

      def bibdata_dates(bib)
        bib.xpath(ns("./date")).each do |d|
          d.next = d.dup
          d.next["format"] = "ddMMMyyyy"
          d.next.xpath(ns("./from | ./to | ./on")).each do |x|
            x.children = ddMMMyyyy(x.text)
          end
        end
      end

      def ddMMMyyyy(isodate)
        isodate.nil? and return nil
        arr = isodate.split("-")
        if arr.size == 1 && (/^\d+$/.match isodate)
          Date.new(*arr.map(&:to_i)).strftime("%Y")
        elsif arr.size == 2
          Date.new(*arr.map(&:to_i)).strftime("%b %Y")
        else
          Date.parse(isodate).strftime("%d %b %Y")
        end
      end

      def boilerplate(docxml)
        docxml.xpath(ns("//clause[@id = 'boilerplate-participants']/" \
                        "clause/title")).each(&:remove)
        docxml.xpath(ns("//clause[@id = 'boilerplate-participants']/clause"))
          .each do |clause|
          participants(clause)
        end
      end

      def participants(clause)
        clause.xpath(ns(".//ul")).each_with_index do |ulist, idx|
          ulist.xpath(ns("./li")).each { |list| participants1(list, idx) }
          ulist.replace(ulist.children)
        end
        affiliation_header(clause)
      end

      def affiliation_header(clause)
        clause.xpath(ns(".//p[@type = 'officeorgrepmember']")).each do |p|
          prev = p.previous_element
          prev && prev.name == "p" &&
            prev["type"] == "officeorgrepmember" and next
          p.previous = <<~HDR
            <p type='officeorgrepmemberhdr'><em>Organization
            Represented</em><tab/><em>Name of Representative</em></p>
          HDR
        end
      end

      def participants1(list, idx)
        key = ""
        map = list.xpath(ns(".//dt | .//dd")).each_with_object({}) do |dtd, m|
          (dtd.name == "dt" and key = dtd.text) or
            m[key] = text_from_paras(dtd)
              .gsub(/\*/, "<span class='cite_fn'>*</span>")
        end
        list.replace(participant_para(map, idx))
      end

      def text_from_paras(node)
        r = node.at(ns("./p")) and node = r
        node.children.to_xml.strip
      end

      def participant_para(map, idx)
        name = participant_name(map)
        if map["role"]&.casecmp("member")&.zero?
          participant_member_para(map, name, idx)
        else
          participant_officeholder_para(map, name, idx)
        end
      end

      def participant_member_para(map, name, _idx)
        if map["company"] && (map["name"] || map["surname"])
          pers = map["name"] || "#{map['given']} #{map['surname']}"
          "<p type='officeorgrepmember'>#{name}<tab/>#{pers}</p>"
        elsif map["company"] then "<p type='officeorgmember'>#{name}</p>"
        else "<p type='officemember'>#{name}</p>"
        end
      end

      def participant_officeholder_para(map, name, idx)
        name = "<strong>#{name}</strong>" if idx.zero?
        br = map["role"].size > 30 ? "<br/>" : ""
        "<p type='officeholder' align='center'>#{name}, #{br}" \
          "<em><span class='au_role'>#{map['role']}</span></em></p>"
      end

      def participant_name(map)
        map["company"] || map["name"] || "#{map['given']} #{map['surname']}"
      end

      # TODO i18n if needed
      def developed_attrib(bibdata)
        society = bibdata.at(ns("./ext/editorialgroup/society"))
        tc = bibdata.at(ns("./ext/editorialgroup/committee"))
        society || tc or return
        ret = developer_name(tc, society)
        bibdata.at(ns("./ext")) << <<~TAG
          <developed-attribution>#{@i18n.developed_attrib}<br/>#{ret}</developed-attribution>
        TAG
      end

      def developer_name(comm, society)
        ret = ""
        comm and ret += "<strong>#{comm.text}</strong>"
        comm && society and ret += "<br/>of the<br/>"
        society and ret += "IEEE <strong>#{society.text}</strong>"
        ret
      end

      # TODO i18n if needed
      def sponsored_attrib(bibdata)
        ret = sponsors_extract(bibdata).map do |x|
          sponsor_name(x)
        end.join("<br/>and the<br/>")
        ret.empty? and return
        bibdata.at(ns("./ext")) << <<~TAG
          <sponsored-attribution>#{@i18n.sponsored_attrib}<br/>#{ret}</sponsored-attribution>
        TAG
      end

      def sponsors_extract(bibdata)
        bibdata.xpath(ns("./contributor[role/@type = 'enabler']/organization"))
          .each_with_object([]) do |o, m|
            ret = sponsor_extract(o).reverse
            if ret.size > 1 && ["IEEE", "Institute of Electrical and Electronic Engineers"].include?(ret[-1])
              ret.pop
              ret[-1] = "IEEE #{ret[-1]}"
            end
            m << ret
          end
      end

      def sponsor_name(sponsor)
        sponsor.map { |x| "<strong>#{x}</strong>" }.join("<br/>of the<br/>")
      end

      def sponsor_extract(org)
        org.nil? and return []
        [org.at(ns("./name")).children.to_xml] +
          sponsor_extract(org.at(ns("./subdivision")))
      end
    end
  end
end
