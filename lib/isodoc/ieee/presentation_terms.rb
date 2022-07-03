require_relative "../../relaton/render/general"

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
          d.elements.first.previous = "<strong>(#{c.print})</strong>&#xa0;"
        end
      end

      def collapse_multidef(elem)
        ins = elem.at(ns("./definition")).previous_element
        coll = elem.xpath(ns("./definition"))
        coll.each(&:remove)
        ins.next = "<definition>#{coll.map do |c|
                                    c.children.to_xml
                                  end }</definition>"
      end

      def unwrap_definition(docxml)
        docxml.xpath(ns("//definition/verbal-definition")).each do |v|
          next unless v.elements.all? { |e| %w(termsource p).include?(e.name) }

          s = v.xpath(ns("./termsource"))
          p = v.xpath(ns("./p"))
          v.children =
            "<p>#{p.map(&:children).map(&:to_xml).join("\n")}</p>#{s.to_xml}"
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
          if coll[prev]["type"] == r["type"]
            coll[prev].at(ns("./preferred")) << "; #{r.at(ns('./preferred'))
              .children.to_xml}"
            r.remove
          else prev = i
          end
        end
      end

      def sort_terms_key(term)
        d = term.at(ns("./preferred/expression/name | "\
                       "./preferred/letter-designation/name | "\
                       "./preferred/graphical-symbol/figure/name | "\
                       "./preferred/graphical-symbol/figure/@id"))
        d&.text&.downcase
      end

      def term_related_reorder(coll)
        ins = coll.first.previous_element
        ret = sort_related(coll)
        coll.each(&:remove)
        ret.reverse.each { |t| ins.next = t }
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
        docxml.xpath(ns("//term/admitted")).each do |a|
          a["type"] = "equivalent"
          a.name = "related"
          a.children = "<preferred>#{a.children.to_xml}</preferred>"
        end
      end

      def collapse_term(docxml)
        docxml.xpath(ns("//term")).each do |t|
          collapse_term1(t)
        end
      end

      def collapse_term1(term)
        ret = collapse_term_template(
          pref: term.at(ns("./preferred")).remove,
          def: term.at(ns("./definition")),
          rels: term.xpath(ns("./related")).map(&:remove),
          source: term.at(ns("./termsource")),
        )
        (ins = term.elements.first and ins.previous = ret) or
          term << ret
      end

      def collapse_term_related(rels)
        ret = rels.map do |r|
          "<em>#{@i18n.relatedterms[r['type']]}:</em> "\
            "#{r.at(ns('./preferred')).children.to_xml}"
        end.join(". ")
        ret += "." unless ret.empty?
        ret
      end

      def collapse_term_template(opt)
        defn = collapse_unwrap_definition(opt[:def])
        src = nil
        opt[:source] and src = "(#{opt[:source].remove.children.to_xml.strip})"
        <<~TERM
          <p>#{opt[:pref].children.to_xml}: #{defn}
          #{collapse_term_related(opt[:rels])}
          #{src}</p>
        TERM
      end

      def collapse_unwrap_definition(defn)
        return nil if defn.nil?

        s = defn.remove.xpath(ns("./termsource"))
        p = defn.at(ns("./p"))
        !s.empty? && p and p << s.map(&:remove).map(&:children).map(&:to_xml).join
        if defn.elements.size == 1 && defn.elements.first.name == "p"
          defn.elements.first.children
        else defn.elements
        end
      end

      def termsource1(elem)
        while elem&.next_element&.name == "termsource"
          elem << "; #{elem.next_element.remove.children.to_xml}"
        end
      end

      def designation_field(desgn, name)
        if desgn.name == "preferred"
          f = desgn.xpath(ns("./../domain | ./../subject")).map(&:remove)
            .map { |u| u.children.to_xml }.join(", ")
          name << ", &#x3c;#{f}&#x3e;" unless f.empty?
        end
        super
      end

      def merge_second_preferred(term)
        super
        term.xpath(ns("./preferred[expression/name]")).each_with_index do |p, i|
          unless i.zero?
            p.remove # whatever was eligible to display has already been merged
          end
        end
      end

      def termnote1(elem)
        lbl = l10n(@xrefs.anchor(elem["id"], :label)&.strip || "???")
        prefix_name(elem, block_delim, lower2cap(lbl), "name")
      end

      def term(docxml); end

      def concept1(node)
        concept_render(node, ital: "false", ref: "false",
                             linkref: "false", linkmention: "false")
      end
    end
  end
end
