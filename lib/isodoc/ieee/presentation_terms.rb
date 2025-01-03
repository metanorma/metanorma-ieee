module IsoDoc
  module Ieee
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def multidef(elem, defn, fmt_defn)
        ctr = IsoDoc::XrefGen::Counter.new("@")
        coll = defn.each_with_object([]) do |d, m|
          ctr.increment(d)
          ret = semx_fmt_dup(d)
          ret.at(ns("./verbal-definition | ./non-verbal-definition")).elements
            .first.add_first_child("<strong>(#{ctr.print})</strong>&#xa0;")
          m << ret
        end
        #require "debug"; binding.b
        fmt_defn << coll.map { |c| to_xml(c) }.join(" ")
        #coll.each { |x| unwrap_definition1(x) }
        #fmt_defn << unwrap_multidef(coll)
      end

      def unwrap_multidef(coll)
        if coll.all? do |c|
          c.elements.size == 1 && c.elements.first.name == "p"
        end
        ret = coll.map do |c|
          c.children = c.elements.first.children
        end
        return "<p>#{ret.map { |x| to_xml(x) }.join}</p>"
        end
        coll.map { |c| to_xml(c.children) }.join(" ")
      end

=begin
    def unwrap_definition(elem)
      elem.xpath(ns("./definition")).each do |d|
        %w(verbal-definition non-verbal-representation).each do |e|
          v = d&.at(ns("./#{e}"))
          v&.replace(v.children)
        end
      end
    end

    to

      def unwrap_definition(_elem, fmt_defn)
      fmt_defn.xpath(ns(".//semx[@element = 'definition']")).each do |d|
        %w(verbal-definition non-verbal-representation).each do |e|
          v = d&.at(ns("./#{e}"))
          v&.replace(v.children)
        end
      end
    en

=end

def designation(docxml)
  super
end

def deprecates(desgn)
  desgn.remove
end

    def designation_boldface(desgn)
      #desgn["element"] == "preferred" or return
      name = desgn.at(ns("./expression/name | ./letter-symbol/name")) or return
      name.children = "<strong>#{name.children}</strong>"
    end

      def unwrap_definition(docxml)
        docxml.xpath(ns(".//definition/verbal-definition")).each do |v|
          v.elements.all? { |e| %w(termsource p).include?(e.name) } or next
          p = v.xpath(ns("./p"))
          s = v.xpath(ns('./termsource'))
          s.empty? or s = " (#{s.map { |x| to_xml(x) }.join("\n")})"
          v.children =
            "<p>#{p.map(&:children).map { |x| to_xml(x) }.join("\n")}#{s}</p>"
        end
        super
      end

      def unwrap_definition(_elem, fmt_defn)
        fmt_defn.xpath(ns(".//semx[@element = 'definition']")).each do |d|
          unwrap_definition1(d)
        end
      end

      def unwrap_definition1(d)
          %w(verbal-definition non-verbal-representation).each do |e|
            v = d.at(ns("./#{e}")) or next
            if v.elements.all? { |e| %w(termsource p).include?(e.name) }
              p = v.xpath(ns("./p"))
              s = v.xpath(ns('./termsource'))
              s.empty? or s = " (#{s.map { |x| to_xml(x) }.join()})"
              v.children =
                "#{p.map(&:children).map { |x| to_xml(x) }.join("\n")}#{s}"
            else
              s = v.xpath(ns('./termsource'))
              unless s.empty?
                s[0].previous = " ("
                s[-1].next = ")"
              end
            end
            v.replace(v.children)
          end
      end

      def related_designation1(desgn)
        super
      end

      def related(docxml)
        insert_related_type(docxml)
        admitted_to_related docxml
        term_reorder(docxml)
        docxml.xpath(ns("//term[fmt-related/semx]")).each { |f| related_term(f) }
      end

      # temporarily insert related/@type to fmt-related/semx, for sorting
      def insert_related_type(docxml)
        docxml.xpath(ns("//fmt-related/semx")).each do |r|
          orig = semx_orig(r)
          r["type"] = orig["type"]
        end
      end

      def related_term(term)
        #require "debug"; binding.b
        #coll = term_related_reorder(term.xpath(ns("./fmt-related/semx")))
        r = term.at(ns("./fmt-related"))
        coll = sort_related(r.xpath(ns("./semx")))
        r.children = term_related_collapse(coll)
      end

      def term_related_collapse(coll)
        prev = 0
        coll[0].wrap("<p></p>")
        coll[1..-1].each_with_index do |r, i|
          if coll[prev]["type"] != r["type"]
            prev = i
            r.wrap("<p></p>")
            next
          end

          #coll[prev].at(ns("./preferred")) << "; #{to_xml(r.at(ns('./preferred'))
          #.children)}"
          coll[prev] << "; #{to_xml(r)}"
          r.remove
        end
      end

      def term_related_collapse(coll)
        prev = 0
        ret = [[coll[0]]]
        coll[1..-1].each do |r|
        if ret[-1][0]["type"] != r["type"]
            ret << [r]
            next
          end
          ret[-1] << r
        end
        ret.map { |x| x.map { |y| to_xml(y) }.join("; ") }.map { |x| "<p>#{x}</p>" }.join("\n")
      end

      def sort_terms_key(term)
        d = term.at(ns("./preferred/expression/name | " \
                       "./preferred/letter-symbol/name | " \
                       "./preferred/graphical-symbol/figure/name | " \
                       "./preferred/graphical-symbol/figure/@id | " \
                       "./preferred | ./fmt-preferred//semx"))
        f = term.at(ns("./field-of-application")) || term.at(ns("./domain"))
        @c.decode("#{sort_terms_key1(d)} :: #{sort_terms_key1(f)}")
      end

      def sort_terms_key1(elem)
        elem.nil? and return "zzzz"
        dup = elem.dup
        dup.xpath(ns(".//asciimath | .//latexmath")).each(&:remove)
        dup.text&.strip&.downcase || "zzzz"
      end

      #KILL
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

      def termcleanup(docxml)
        collapse_term docxml
        docxml.xpath(ns("//term//semx[@type]")).each { |x| x.delete("type") } # temp attribute from insert_related_type
        super
      end

      def admitted_to_related(docxml)
        docxml.xpath(ns("//term")).each do |t|
          t.xpath(ns("./fmt-admitted/semx | ./fmt-preferred/semx")).each_with_index do |a, i|
            orig = semx_orig(a)
            (i.zero? ||
             orig.at(ns("./abbreviation-type | ./graphical-symbol"))) and next
            out = t.at(ns("./fmt-related")) || t.at(ns("./definition")).before("<fmt-related/>").previous
            admitted_to_related1(a, t.at(ns("./fmt-preferred/semx")), out)
            a.parent.name == "fmt-preferred" and a.remove
          end
          t.at(ns("./fmt-admitted"))&.remove
        end
        #term_reorder(docxml)
      end

      def admitted_to_related1(adm, pref, out)
        new = adm.dup
        adm["type"] = "equivalent"
        adm.name = "related"
        adm.children = "<preferred>#{to_xml(adm.children)}</preferred>"
        adm.parent.next = <<~TERM
          <term><preferred>#{to_xml(new.children)}</preferred>
          <related type='see'><preferred>#{to_xml(pref.children)}</preferred></related></term>
        TERM
      end

      def admitted_to_related1(adm, pref, out)
      out << <<~TERM
<semx element='related' source='#{adm['source']}' type='equivalent'><fmt-preferred>#{to_xml(adm)}</p></semx></fmt-preferred>
TERM
        out.parent.next = <<~TERM
          <term><fmt-preferred>#{to_xml(adm)}</fmt-preferred>
          <fmt-related>
            <semx element="related" source="#{pref['source']}" type="see"><fmt-preferred>#{to_xml(pref)}</fmt-preferred></semx>
          </fmt-related>
          <fmt-definition></fmt-definition></term>
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

      def termcontainers(docxml)
        super
        docxml.xpath(ns("//term[not(./fmt-definition)]")).each do |t|
          t << "<fmt-definition></fmt-definition>"
        end
      end

      def collapse_term(docxml)
        docxml.xpath(ns("//term")).each { |t| collapse_term1(t) }
      end

      def collapse_term1(term)
        #pref = term.xpath(ns("./fmt-preferred//semx")).each_with_index.with_object([]) do |(a, i), m|
            #orig = semx_orig(a, term)
#if i.zero? || orig.at(ns("./abbreviation-type | ./graphical-symbol"))
  #m << a
#end
        #end

        ret = collapse_term_template(
          pref: term.at(ns("./fmt-preferred")),
          def: term.at(ns("./fmt-definition")),
          rels: term.at(ns("./fmt-related"))&.remove,
          source: term.at(ns("./fmt-termsource"))&.remove,
        )
        term.at(ns("./fmt-preferred"))&.remove
        term.at(ns("./fmt-admitted"))&.remove
        ins = term.at(ns("./fmt-definition")) and
          ins.children = ret
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

      def collapse_term_related(rels)
        rels or return
        rels.xpath(ns("./p")).each do |p|
          #require "debug"; binding.b
          orig = p.at(ns(".//semx[@element = 'related']"))
          reln = "<em>#{@i18n.relatedterms[orig['type']]}:</em> "
          p.add_first_child reln
          p.xpath(ns(".//semx[@element = 'related']")).each do |r|
            r.at(ns("./fmt-preferred")) or r.add_first_child "**RELATED TERM NOT FOUND**"
          end
        end
        ret = rels.xpath(ns("./p")).map { |x| to_xml(x.children).strip }.join(". ")
        ret += "." unless ret.empty?
        ret
      end

      def collapse_term_template(opt)
        defn, multiblock = collapse_unwrap_definition(opt[:def])
        #require "debug"; binding.b
        src = nil
        opt[:source] and src = "(#{to_xml(opt[:source].remove.children).strip})"
        t = collapse_term_pref(opt)
        #require "debug"; opt[:pref].nil? and binding.b
        #require "debug"; opt[:rels].empty? or binding.b
        tail = "#{collapse_term_related(opt[:rels])} #{src}"
        if multiblock
          tail = tail.strip.empty? ? "" : "<p>#{tail}</p>"
        <<~TERM
          <p>#{t}:</p> #{defn}#{tail}
        TERM
        else
        <<~TERM
          <p>#{t}: #{defn} #{tail}</p>
        TERM
        end
      end

      def collapse_term_pref(opt)
        p = opt[:pref]
        p.text.strip.empty? and return "**TERM NOT FOUND**"
        s = p.xpath(ns(".//semx[@element = 'termsource']"))
        unless s.empty?
          s[0].previous = " ("
          s[-1].next = ")"
        end
        p.xpath(ns(".//fmt-termsource")).each { |x| x.replace(x.children) }
        to_xml(p.children).strip

      end

      def collapse_unwrap_definition(defn)
        #require "debug"; binding.b
        defn.nil? and return nil, nil
        s = defn.xpath(ns(".//fmt-termsource"))
        p = defn.at(ns(".//p"))
        !s.empty? && p and p << s.map(&:remove).map(&:children)
          .map { |x| to_xml(x) }.join
        # fmt-definition/semx/p
        elems = defn.at(ns("./semx")) || defn
        multiblock = elems.at(ns("./table | ./formula | ./dl | ./ol | ./ul")) || elems.xpath(ns("./p")).size > 1
        [defn.elements, multiblock]
      end

      def termsource1(elem)
        while elem&.next_element&.name == "termsource"
          elem << "; #{to_xml(elem.next_element.remove.children)}"
        end
        adapt = termsource_adapt(elem["status"]) and
          elem.children = l10n("#{adapt}#{to_xml(elem.children).strip}")
      end

      def termsource1(elem)
      ret = [semx_fmt_dup(elem)]
      while elem&.next_element&.name == "termsource"
        ret << semx_fmt_dup(elem.next_element.remove)
      end
      s = ret.map { |x| to_xml(x) }.map(&:strip).join("; ")
      adapt = termsource_adapt(elem["status"]) and
        s = "#{adapt}#{s}"
      elem.replace(l10n(s))
    end

      def termsource_adapt(status)
        case status
        when "adapted" then @i18n.adapted_from
        end
      end

      # domain is rendered in designation_field instead
      def termdomain(elem, domain)
        #d = elem.at(ns(".//domain")) or return
        #d["hidden"] = "true"
      end

      def designation_field(desgn, name, orig)
        if desgn["element"] == "preferred"
          f = orig.parent.xpath(ns("./domain | ./subject"))
            .map { |u| to_xml(semx_fmt_dup(u)) }.join(", ")
          #require 'debug'; binding.b
          name << "<span class='fmt-designation-field'>, &#x3c;#{f}&#x3e;</span>" unless f.empty?
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

      def merge_second_preferred(term)
        term.name == "fmt-admitted" and return
        pref =
          term.parent.at(ns("./preferred[not(abbreviation-type)][expression/name]"))
        x = term.parent.xpath(ns("./preferred[expression/name][abbreviation-type] | " \
                          "./admitted[expression/name][abbreviation-type]"))
        (pref && !x.empty?) or return
fmt_pref = term.parent.at(ns(".//semx[@source = '#{pref['id']}']"))
fdf = fmt_pref.at(ns(".//span[@class = 'fmt-designation-field']"))&.text
        out = to_xml(fmt_pref)
        tail = x.map do |p|
          #require "debug"; binding.b
          ret = term.parent.at(ns(".//semx[@source = '#{p['id']}']")).remove
          fdf1 = ret.at(ns(".//span[@class = 'fmt-designation-field']"))
          fdf1 && (fdf1&.text == fdf) and fdf1.remove # repetition of domain suppressed
          to_xml(ret).strip
        end.join(", ")
        out += " (#{tail})"
        term.children = out
      end

      def termnote1(elem)
        lbl = termnote_label(elem)
        prefix_name(elem, { label: block_delim }, lower2cap(lbl), "name")
      end

      def termnote_label(elem)
        lbl = l10n(@xrefs.anchor(elem["id"], :label)&.strip || "???")
        l10n lbl
      end

      def term(docxml); end

      def concept1(node)
        concept_render(node, ital: "false", ref: "false", bold: "false",
                       linkref: "false", linkmention: "false")
      end
    end
  end
end
