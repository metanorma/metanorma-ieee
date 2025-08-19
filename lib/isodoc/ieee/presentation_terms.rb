module IsoDoc
  module Ieee
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def multidef(_elem, defn, fmt_defn)
        ctr = IsoDoc::XrefGen::Counter.new("@")
        coll = defn.each_with_object([]) do |d, m|
          ctr.increment(d)
          ret = semx_fmt_dup(d)
          ret.at(ns("./verbal-definition | ./non-verbal-definition")).elements
            .first.add_first_child("<strong>(#{ctr.print})</strong>&#xa0;")
          m << ret
        end
        fmt_defn << coll.map { |c| to_xml(c) }.join(" ")
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

      def unwrap_definition(_elem, fmt_defn)
        fmt_defn.xpath(ns(".//semx[@element = 'definition']")).each do |d|
          unwrap_definition1(d)
        end
      end

      def wrap_nodeset_in_parens(xpath)
        unless xpath.empty?
          xpath[0].previous = " ("
          xpath[-1].next = ")"
        end
      end

      def unwrap_definition1(d)
        %w(verbal-definition non-verbal-representation).each do |e|
          v = d.at(ns("./#{e}")) or next
          if v.elements.all? { |n| %w(source p).include?(n.name) }
            p = v.xpath(ns("./p"))
            s = v.xpath(ns("./source"))
            s.empty? or s = " (#{s.map { |x| to_xml(x) }.join})"
            v.children =
              "#{p.map(&:children).map { |x| to_xml(x) }.join("\n")}#{s}"
          else
            wrap_nodeset_in_parens(v.xpath(ns("./source")))
          end
          v.replace(v.children)
        end
      end

      def termcleanup(docxml)
        collapse_term docxml
        # temp attribute from insert_related_type
        docxml.xpath(ns("//term//semx[@type]")).each do |x|
          x.delete("type")
        end
        super
      end

      def termcontainers(docxml)
        super
        docxml.xpath(ns("//term[not(./fmt-definition)]")).each do |t|
          t << "<fmt-definition #{add_id_text}></fmt-definition>"
        end
      end

      def collapse_term(docxml)
        docxml.xpath(ns("//term")).each { |t| collapse_term1(t) }
      end

      def collapse_term1(term)
        ret = collapse_term_template(
          pref: term.at(ns("./fmt-preferred"))&.remove,
          def: term.at(ns("./fmt-definition")),
          rels: term.at(ns("./fmt-related"))&.remove,
          source: term.at(ns("./fmt-termsource"))&.remove,
          fns: term.xpath(ns("./fn")).map(&:remove),
        )
        term.at(ns("./fmt-admitted"))&.remove
        ins = term.at(ns("./fmt-definition")) and
          ins.children = ret
      end

      def collapse_term_related(rels)
        rels or return
        collapse_term_related1(rels)
        ret = rels.xpath(ns("./p")).map do |x|
          to_xml(x.children).strip
        end.join(". ")
        ret += "." unless ret.empty?
        ret
      end

      def collapse_term_related1(rels)
        rels.xpath(ns("./p")).each do |p|
          orig = p.at(ns(".//semx[@element = 'related']"))
          p.add_first_child "<em>#{@i18n.relatedterms[orig['type']]}:</em> "
          p.xpath(ns(".//semx[@element = 'related']")).each do |r|
            r.at(ns("./fmt-preferred")) or
              r.add_first_child "**RELATED TERM NOT FOUND**"
          end
        end
      end

      def collapse_term_template(opt)
        defn, multiblock = collapse_unwrap_definition(opt[:def])
        t = collapse_term_pref(opt)
        tail = collapse_term_template_tail(opt)
        if multiblock
          tail = tail.strip.empty? ? "" : "<p>#{tail}</p>"
          "<p>#{t}:</p> #{defn}#{tail}"
        else "<p>#{t}: #{defn} #{tail}</p>"
        end
      end

      def collapse_term_template_tail(opt)
        opt[:source] and src = "(#{to_xml(opt[:source].children).strip})"
        opt[:fns].empty? or fn = opt[:fns].map(&:to_xml).join
        "#{collapse_term_related(opt[:rels])} #{src}#{fn}"
      end

      def collapse_term_pref(opt)
        p = opt[:pref]
        p.text.strip.empty? and return "**TERM NOT FOUND**"
        wrap_nodeset_in_parens(p.xpath(ns(".//semx[@element = 'source']")))
        p.xpath(ns(".//fmt-termsource")).each { |x| x.replace(x.children) }
        to_xml(p.children).strip
      end

      def collapse_unwrap_definition(defn)
        defn.nil? and return nil, nil
        s = defn.xpath(ns(".//fmt-termsource"))
        p = defn.at(ns(".//p"))
        !s.empty? && p and p << s.map(&:remove).map(&:children)
          .map { |x| to_xml(x) }.join
        # fmt-definition/semx/p
        elems = defn.at(ns("./semx")) || defn
        multiblock = elems.at(ns("./table | ./formula | ./dl | ./ol | ./ul")) ||
          elems.xpath(ns("./p")).size > 1
        [defn.elements, multiblock]
      end

      def termsource_label(elem, sources)
        adapt = termsource_adapt(elem["status"]) and
          sources = "#{adapt}#{sources}"
        elem.replace(l10n(sources))
      end

      def termsource_adapt(status)
        case status
        when "adapted" then @i18n.adapted_from
        end
      end

      # domain is rendered in designation_field instead
      def termdomain(elem, domain); end

      def termnote1(elem)
        lbl = termnote_label(elem)
        prefix_name(elem, { label: block_delim }, lower2cap(lbl), "name")
      end

      def termnote_label(elem)
        lbl = l10n(@xrefs.anchor(elem["id"], :label)&.strip || "???")
        l10n lbl
      end

      def term(docxml); end

      def license_termnote(elem, idx)
        elem.name = "fn"
        elem["reference"] = "_termnote_license_#{idx}"
        elem.parent << elem
        prev = elem.children[-1] # space at end of term?
        prev.text? and prev.replace(prev.text.rstrip)
      end
    end
  end
end
