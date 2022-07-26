require_relative "init"
require_relative "presentation_terms"
require_relative "presentation_ref"
require "isodoc"

module IsoDoc
  module IEEE
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def initialize(options)
        @hierarchical_assets = options[:hierarchical_assets]
        super
      end

      def eref_localities_conflated(refs, target, node)
        droploc = node["droploc"]
        node["droploc"] = true
        ret = resolve_eref_connectives(eref_locality_stacks(refs, target,
                                                            node))
        node["droploc"] = droploc
        eref_localities1(target,
                         prefix_clause(target, refs.first.at(ns("./locality"))),
                         l10n(ret[1..-1].join), nil, node, @lang)
      end

      def prefix_clause(target, loc)
        loc["type"] == "clause" or return loc["type"]

        if subclause?(target, loc["type"],
                      loc&.at(ns("./referenceFrom"))&.text)
          ""
        else "clause"
        end
      end

      def subclause?(target, type, from)
        (from&.match?(/\./) && type == "clause") ||
          target&.gsub(/<[^>]+>/, "")&.match(/^IEV$|^IEC 60050-/)
      end

      def eref_localities1(target, type, from, upto, node, lang = "en")
        return nil if type == "anchor"

        type = type.downcase
        lang == "zh" and
          return l10n(eref_localities1_zh(target, type, from, upto,
                                          node))
        ret = ""
        node["droploc"] != "true" && !subclause?(target, type,
                                                 from) and
          ret = eref_locality_populate(type, node)
        ret += " #{from}" if from
        ret += "&#x2013;#{upto}" if upto
        ret += ")" if type == "list"
        l10n(ret)
      end

      def anchor_linkend1(node)
        linkend = @xrefs.anchor(node["target"], :xref)
        @xrefs.anchor(node["target"], :type) == "clause" &&
          @xrefs.anchor(node["target"], :level) > 1 &&
          !start_of_sentence(node) and
          linkend = linkend.sub(/^Clause /, "")
        container = @xrefs.anchor(node["target"], :container, false)
        prefix_container?(container, node) and
          linkend = prefix_container(container, linkend, node["target"])
        capitalise_xref(node, linkend, anchor_value(node["target"]))
      end

      def block_delim
        "&#x2014;"
      end

      def note1(elem)
        return if elem.parent.name == "bibitem" || elem["notag"] == "true"

        n = @xrefs.get[elem["id"]]
        lbl = if n.nil? || n[:label].nil? || n[:label].empty? then @i18n.note
              else l10n("#{@i18n.note} #{n[:label]}")
              end
        prefix_name(elem, block_delim, lbl, "name")
      end

      def display_order(docxml)
        i = 0
        i = display_order_xpath(docxml, "//preface/*", i)
        i = display_order_at(docxml, "//clause[@type = 'overview']", i)
        i = display_order_at(docxml, @xrefs.klass.norm_ref_xpath, i)
        i = display_order_at(docxml, "//sections/terms | "\
                                     "//sections/clause[descendant::terms]", i)
        i = display_order_at(docxml, "//sections/definitions", i)
        i = display_order_xpath(docxml, @xrefs.klass.middle_clause(docxml), i)
        i = display_order_xpath(docxml, "//annex", i)
        i = display_order_xpath(docxml, @xrefs.klass.bibliography_xpath, i)
        display_order_xpath(docxml, "//indexsect", i)
      end

      def annex1(elem)
        lbl = @xrefs.anchor(elem["id"], :label)
        if t = elem.at(ns("./title"))
          t.children = "<strong>#{t.children.to_xml}</strong>"
        end
        prefix_name(elem, "<br/>", lbl, "title")
      end

      def bibdata_i18n(bib)
        super
        bibdata_dates(bib)
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
        return nil if isodate.nil?

        arr = isodate.split("-")
        if arr.size == 1 && (/^\d+$/.match isodate)
          Date.new(*arr.map(&:to_i)).strftime("%Y")
        elsif arr.size == 2
          Date.new(*arr.map(&:to_i)).strftime("%b %Y")
        else
          Date.parse(isodate).strftime("%d %b %Y")
        end
      end

      def amend1(elem)
        elem.xpath(ns("./description/p")).each do |p|
          p.children = p.children.to_xml.strip
          amend_format(p)
        end
        super
      end

      def amend_format(para)
        2.times do
          para.children.size == 1 &&
            %(em strong).include?(para.children.first.name) and
            para.children = para.elements.first.children
        end
        para.children = "<strong><em>#{para.children.to_xml}</em></strong>"
      end

      def section(docxml)
        boilerplate(docxml)
        super
      end

      def boilerplate(docxml)
        docxml.xpath(ns("//clause[@id = 'boilerplate-participants']/"\
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
            m[key] = dtd.text.strip
        end
        list.replace(participant_para(map, idx))
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
        "<p type='officeholder' align='center'>#{name}, #{br}"\
          "<em>#{map['role']}</em></p>"
      end

      def participant_name(map)
        map["company"] || map["name"] || "#{map['given']} #{map['surname']}"
      end

      include Init
    end
  end
end
