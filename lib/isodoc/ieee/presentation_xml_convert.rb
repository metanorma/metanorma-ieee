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
        docxml.xpath(ns("//clause[@id = 'boilerplate-participants']//ul"))
          .each do |ulist|
          ulist.xpath(ns("./li")).each do |list|
            participants1(list)
          end
          ulist.replace(ulist.children)
        end
      end

      def participants1(list)
        key = ""
        map = list.xpath(ns(".//dt | .//dd")).each_with_object({}) do |dtd, m|
          (dtd.name == "dt" and key = dtd.text) or
            m[key] = dtd.text.strip
        end
        list.replace(participant_para(map))
      end

      def participant_para(map)
        name = participant_name(map)
        if map["role"]&.casecmp("member")&.zero?
          (map["company"] and "<p type='officeorgmember'>#{name}</p>") or
            "<p type='officemember'>#{name}</p>"
        else
          "<p type='officeholder' align='center'><strong>#{name}</strong>, "\
            "<em>#{map['role']}</em></p>"
        end
      end

      def participant_name(map)
        map["company"] || map["name"] || "#{map['given']} #{map['surname']}"
      end

      include Init
    end
  end
end
