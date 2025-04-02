module IsoDoc
  module Ieee
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def deprecates(desgn)
        desgn.remove
      end

      def designation_boldface(desgn)
        name = desgn.at(ns("./expression/name | ./letter-symbol/name")) or return
        name.children = "<strong>#{name.children}</strong>"
      end

      def related(docxml)
        insert_related_type(docxml)
        admitted_to_related docxml
        term_reorder(docxml)
        docxml.xpath(ns("//term[fmt-related/semx]")).each do |f|
          related_term(f)
        end
      end

      # temporarily insert related/@type to fmt-related/semx, for sorting
      def insert_related_type(docxml)
        docxml.xpath(ns("//fmt-related/semx")).each do |r|
          orig = semx_orig(r)
          r["type"] = orig["type"]
        end
      end

      def related_term(term)
        r = term.at(ns("./fmt-related"))
        r.xpath(ns(".//xref | .//eref | .//termref")).each(&:remove)
        coll = sort_related(r.xpath(ns("./semx")))
        r.children = term_related_collapse(coll)
      end

      def term_related_collapse(coll)
        ret = [[coll[0]]]
        coll[1..-1].each do |r|
          if ret[-1][0]["type"] != r["type"]
            ret << [r]
            next
          end
          ret[-1] << r
        end
        ret.map do |x|
          x.map do |y|
            to_xml(y)
          end.join("; ")
        end.map { |x| "<p>#{x}</p>" }.join("\n")
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

      def designation_field(desgn, name, orig)
        if desgn["element"] == "preferred"
          f = orig.parent.xpath(ns("./domain | ./subject"))
            .map { |u| to_xml(semx_fmt_dup(u)) }.join(", ")
          name << "<span class='fmt-designation-field'>, &#x3c;#{f}&#x3e;</span>" unless f.empty?
        end
        super
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
          ret = term.parent.at(ns(".//semx[@source = '#{p['id']}']")).remove
          fdf1 = ret.at(ns(".//span[@class = 'fmt-designation-field']"))
          fdf1 && (fdf1&.text == fdf) and fdf1.remove # repetition of domain suppressed
          to_xml(ret).strip
        end.join(", ")
        out += " (#{tail})"
        term.children = out
      end

      def concept1(node)
        concept_render(node, ital: "false", ref: "false", bold: "false",
                             linkref: "false", linkmention: "false")
      end
    end
  end
end
