module IsoDoc
  module Ieee
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def bibdata_i18n(bib)
        super
        bibdata_dates(bib)
      end

      def bibdata_dates(bib)
        bibdata_date_format(bib)
        bibdata_date_defaults(bib)
      end

      def bibdata_date_format(bib)
        bib.xpath(ns("./date")).each do |d|
          d.next = d.dup
          d.next["format"] = "ddMMMyyyy"
          d.next.xpath(ns("./from | ./to | ./on")).each do |x|
            x.children = ddMMMyyyy(x.text)
          end
        end
      end

      def bibdata_date_defaults(bib)
        bib.at(ns("./date[@type = 'ieee-sasb-approved']")) and return
        ins = bib.at(ns("./docnumber")) ||
          bib.at(ns("./docidentifier[last()]")) ||
          bib.at(ns("./title[last()]")) or return
        ins.next = <<~XML
          <date type="ieee-sasb-approved" format="text">
             <on>&lt;Date Approved&gt;</on>
          </date>
        XML
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
    end
  end
end
