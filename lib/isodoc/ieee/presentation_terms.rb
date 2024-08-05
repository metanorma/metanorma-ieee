module IsoDoc
  module IEEE
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def multidef(elem)
        number_multidef(elem)
        collapse_multidef(elem)
      end

      def number_multidef(elem)
        c = IsoDoc::XrefGen::Counter.new("@")
        elem.xpath(ns("./definition")).each do |d|
          c.increment(d)
          d.elements.first.children.first.previous =
            "<strong>(#{c.print})</strong>&#xa0;"
        end
      end

      def collapse_multidef(elem)
        ins = elem.at(ns("./definition")).previous_element
        coll = elem.xpath(ns("./definition"))
        coll.each(&:remove)
        ins.next = "<definition>#{unwrap_multidef(coll)}</definition>"
      end

      def unwrap_multidef(coll)
        if coll.all? do |c|
             c.elements.size == 1 && c.elements.first.name == "p"
           end
          ret = coll.map { |c| to_xml(c.elements.first.children) }
          return "<p>#{ret.join}</p>"
        end
        coll.map { |c| to_xml(c.children) }.join
      end

      def unwrap_definition(docxml)
        docxml.xpath(ns(".//definition/verbal-definition")).each do |v|
          v.elements.all? { |e| %w(termsource p).include?(e.name) } or next
          p = v.xpath(ns("./p"))
          v.children =
            "<p>#{p.map(&:children).map { |x| to_xml(x) }.join("\n")}</p>" \
            "#{v.xpath(ns('./termsource')).to_xml}"
        end
        super
      end

      def related(docxml)
        docxml.xpath(ns("//term[related]")).each { |f| related_term(f) }
      end

      def related_term(term)
        coll = term_related_reorder(term.xpath(ns("./related")))
        term_related_collapse(coll)
      end

      def term_related_collapse(coll)
        prev = 0
        coll[1..-1].each_with_index do |r, i|
          if coll[prev]["type"] != r["type"]
            prev = i and next
          end

          coll[prev].at(ns("./preferred")) << "; #{to_xml(r.at(ns('./preferred'))
              .children)}"
          r.remove
        end
      end

      def sort_terms_key(term)
        d = term.at(ns("./preferred/expression/name | " \
                       "./preferred/letter-symbol/name | " \
                       "./preferred/graphical-symbol/figure/name | " \
                       "./preferred/graphical-symbol/figure/@id | " \
                       "./preferred"))
        f = term.at(ns("./field-of-application")) || term.at(ns("./domain"))
        @c.decode("#{sort_terms_key1(d)} :: #{sort_terms_key1(f)}")
      end

      def sort_terms_key1(elem)
        elem.nil? and return "zzzz"
        dup = elem.dup
        dup.xpath(ns(".//asciimath | .//latexmath")).each(&:remove)
        dup.text&.strip&.downcase || "zzzz"
      end

      def term_related_reorder(coll)
        ins = coll.first.previous_element
        ret = sort_related(coll)
        coll.each(&:remove)
        ret.reverse_each { |t| ins.next = t }
        ins.parent.xpath(ns("./related"))
      end

      def sort_related(coll)
        coll.sort do |a, b|
          sort_related_key(a) <=> sort_related_key(b)
        end
      end

      def sort_related_key(related)
        type = case related["type"]
               when "contrast" then 1
               when "equivalent" then 2
               when "see" then 3
               when "seealso" then 4
               else "5-#{related['type']}"
               end
        "#{type} :: #{sort_terms_key(related)}"
      end

      def terms(docxml)
        admitted_to_related docxml
        super
        collapse_term docxml
      end

      def admitted_to_related(docxml)
        docxml.xpath(ns("//term")).each do |t|
          t.xpath(ns("./admitted | ./preferred")).each_with_index do |a, i|
            (i.zero? ||
             a.at(ns("./abbreviation-type | ./graphical-symbol"))) and next
            admitted_to_related1(a, t.at(ns("./preferred")))
          end
        end
        term_reorder(docxml)
      end

      def admitted_to_related1(adm, pref)
        new = adm.dup
        adm["type"] = "equivalent"
        adm.name = "related"
        adm.children = "<preferred>#{to_xml(adm.children)}</preferred>"
        adm.parent.next = <<~TERM
          <term><preferred>#{to_xml(new.children)}</preferred>
          <related type='see'><preferred>#{to_xml(pref.children)}</preferred></related></term>
        TERM
      end

      def term_reorder(xmldoc)
        xmldoc.xpath(ns("//terms")).each { |t| term_reorder1(t) }
      end

      def term_reorder1(terms)
        ins = terms.at(ns("./term"))&.previous_element or return
        coll = terms.xpath(ns("./term"))
        ret = sort_terms(coll)
        coll.each(&:remove)
        ret.reverse_each { |t| ins.next = t }
      end

      def sort_terms(terms)
        terms.sort do |a, b|
          sort_terms_key(a) <=> sort_terms_key(b)
        end
      end

      def collapse_term(docxml)
        docxml.xpath(ns("//term")).each { |t| collapse_term1(t) }
      end

      def collapse_term1(term)
        ret = collapse_term_template(
          pref: term.at(ns("./preferred"))&.remove,
          def: term.at(ns("./definition")),
          rels: term.xpath(ns("./related")).map(&:remove),
          source: term.at(ns("./termsource")),
        )
        (ins = term.elements.first and ins.previous = ret) or
          term << ret
      end

      def collapse_term_related(rels)
        ret = rels.map do |r|
          p = r.at(ns("./preferred"))
          rel = p ? to_xml(p.children) : "**RELATED TERM NOT FOUND**"
          "<em>#{@i18n.relatedterms[r['type']]}:</em> #{rel}"
        end.join(". ")
        ret += "." unless ret.empty?
        ret
      end

      def collapse_term_template(opt)
        defn = collapse_unwrap_definition(opt[:def])
        src = nil
        opt[:source] and src = "(#{to_xml(opt[:source].remove.children).strip})"
        t = opt[:pref] ? to_xml(opt[:pref].children) : "**TERM NOT FOUND**"
        <<~TERM
          <p>#{t}: #{defn} #{collapse_term_related(opt[:rels])} #{src}</p>
        TERM
      end

      def collapse_unwrap_definition(defn)
        defn.nil? and return nil
        s = defn.remove.xpath(ns("./termsource"))
        p = defn.at(ns("./p"))
        !s.empty? && p and p << s.map(&:remove).map(&:children)
          .map { |x| to_xml(x) }.join
        if defn.elements.size == 1 && defn.elements.first.name == "p"
          defn.elements.first.children
        else defn.elements
        end
      end

      def termsource1(elem)
        while elem&.next_element&.name == "termsource"
          elem << "; #{to_xml(elem.next_element.remove.children)}"
        end
        adapt = termsource_adapt(elem["status"]) and
          elem.children = l10n("#{adapt}#{to_xml(elem.children).strip}")
      end

      def termsource_adapt(status)
        case status
        when "adapted" then @i18n.adapted_from
        end
      end

      def designation_field(desgn, name)
        if desgn.name == "preferred"
          f = desgn.xpath(ns("./../domain | ./../subject")).map(&:remove)
            .map { |u| to_xml(u.children) }.join(", ")
          name << ", &#x3c;#{f}&#x3e;" unless f.empty?
        end
        super
      end

      def merge_second_preferred(term)
        pref =
          term.at(ns("./preferred[not(abbreviation-type)]/expression/name"))
        x = term.xpath(ns("./preferred[expression/name][abbreviation-type] | " \
                          "./admitted[expression/name][abbreviation-type]"))
        (pref && !x.empty?) or return
        tail = x.map do |p|
          to_xml(p.remove.at(ns("./expression/name")).children).strip
        end.join(", ")
        pref << " (#{tail})"
      end

      def termnote1(elem)
        lbl = l10n(@xrefs.anchor(elem["id"], :label)&.strip || "???")
        prefix_name(elem, block_delim, lower2cap(lbl), "name")
      end

      def term(docxml); end

      def concept1(node)
        concept_render(node, ital: "false", ref: "false", bold: "false",
                             linkref: "false", linkmention: "false")
      end
    end
  end
end
