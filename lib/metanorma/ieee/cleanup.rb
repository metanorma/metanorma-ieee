module Metanorma
  module IEEE
    class Converter < Standoc::Converter
      BIBLIO =
        "//bibliography/references[@normative = 'false'][not(@hidden)] | "\
        "//bibliography/clause[.//references[@normative = 'false']] | "\
        "//annex//references[@normative = 'false'][not(@hidden)]".freeze

      def boilerplate_cleanup(xmldoc)
        f = xmldoc.at(BIBLIO) and biblio_preface(f)
        super
      end

      def biblio_preface(ref)
        if ref.at("./note[@type = 'boilerplate']")
          unwrap_boilerplate_clauses(ref, ".")
        else
          pref = @i18n.biblio_pref
          ref.at("./title").next = "<p>#{pref}</p>"
        end
      end

      def initial_boilerplate(xml, isodoc)
        intro_boilerplate(xml, isodoc)
        super
      end

      def intro_boilerplate(xml, isodoc)
        return unless intro = xml.at("//introduction/title")

        template = <<~ADM
          This introduction is not part of P{{ docnumeric }}{% if draft %}/D{{ draft }}{% endif %}, {{ full_doctitle }}
        ADM
        adm = isodoc.populate_template(template)
        intro.next = "<admonition>#{adm}</admonition>"
      end

      def obligations_cleanup_norm(xml)
        super
        xml.xpath("//sections/clause").each do |r|
          r["obligation"] = "normative"
        end
      end

      def sections_cleanup(xml)
        super
        overview_cleanup(xml)
      end

      def overview_cleanup(xml)
        %w(scope purpose word-usage).each do |x|
          (xml.xpath("//clause[@type = '#{x}']") -
            xml.xpath("//sections/clause[1][@type = 'overview']"\
                      "//clause[@type = '#{x}']"))
            .each { |c| c.delete("type") }
        end
        (xml.xpath("//clause[@type = 'overview']") -
         xml.xpath("//sections/clause[1]"))
          .each { |c| c.delete("type") }
      end

      def note_cleanup(xmldoc)
        super
        n = xmldoc.at("//preface//note[not(@type = 'boilerplate')]"\
                      "[not(./ancestor::abstract)] | "\
                      "//sections//note[not(@type = 'boilerplate')] | "\
                      "//annex//note[not(@type = 'boilerplate')]") or
          return
        ins = n.at("./p[last()]")
        ins << "<fn><p>#{@i18n.note_inform_fn}</p></fn>"
      end

      def sort_biblio(bib)
        bib.sort do |a, b|
          sort_biblio_key(a) <=> sort_biblio_key(b)
        end
      end

      OTHERIDS = "@type = 'DOI' or @type = 'metanorma' or @type = 'ISSN' or "\
                 "@type = 'ISBN'".freeze

      # Alphabetic by rendering: author surname or designation, followed by title
      def sort_biblio_key(bib)
        name = designator_or_name(bib)
        title = bib.at("./title[@type = 'main']")&.text ||
          bib.at("./title")&.text || bib.at("./formattedref")&.text
        "#{name}. #{title}"
      end

      def designator_or_name(bib)
        case bib["type"]
        when "standard", "techreport"
          n = bib.at("./docidentifier[@primary]") ||
            bib.at("./docidentifier[not(#{OTHERIDS})]")
          n&.text || "ZZZZ"
        else
          bib1 = bib.dup
          bib1.add_namespace(nil, self.class::XML_NAMESPACE)
          i = IsoDoc::IEEE::PresentationXMLConvert.new({ lang: @lang,
                                                         script: @script })
          i.i18n_init(@lang, @script)
          i.creatornames(bib1)
        end
      end

      def normref_cleanup(xmldoc)
        super
        normref_reorder(xmldoc)
      end

      def normref_reorder(xmldoc)
        xmldoc.xpath("//references[@normative = 'true']").each do |r|
          biblio_reorder1(r)
        end
      end

      # end of citeas generation
      def quotesource_cleanup(xmldoc)
        super
        trademark_ieee_erefs(xmldoc)
      end

      # Style manual 12.3.5
      def trademark_ieee_erefs(xmldoc)
        ieee = xmldoc.xpath("//references/bibitem")
          .each_with_object({}) do |b, m|
          n = b.at("./contributor[role/@type = 'publisher']/organization/name")
          n&.text == "Institute of Electrical and Electronics Engineers" and
            m[b["id"]] = true
        end
        trademark_ieee_erefs1(xmldoc, "//preface//eref", ieee)
        trademark_ieee_erefs1(xmldoc, "//sections//eref | //annex//eref", ieee)
      end

      def trademark_ieee_erefs1(xmldoc, path, ieee)
        xmldoc.xpath(path).each_with_object({}) do |e, m|
          ieee[e["bibitemid"]] or next
          m[e["bibitemid"]] or e["citeas"] += "\u2122"
          m[e["bibitemid"]] = true
        end
      end

      def termdef_cleanup(xmldoc)
        term_reorder(xmldoc)
        super
      end

      def term_reorder(xmldoc)
        xmldoc.xpath("//terms").each do |t|
          term_reorder1(t)
        end
      end

      def term_reorder1(terms)
        ins = terms.at("./term")&.previous_element or return
        coll = terms.xpath("./term")
        ret = sort_terms(coll)
        coll.each(&:remove)
        ret.reverse.each { |t| ins.next = t }
      end

      def sort_terms(terms)
        terms.sort do |a, b|
          sort_terms_key(a) <=> sort_terms_key(b)
        end
      end

      def sort_terms_key(term)
        d = term.at("./preferred/expression/name | "\
                    "./preferred/letter-designation/name | "\
                    "./preferred/graphical-symbol/figure/name | "\
                    "./preferred/graphical-symbol/figure/@id")
        d.text.downcase
      end

      def table_footnote_renumber1(fnote, idx, seen)
        content = footnote_content(fnote)
        idx += 1
        if seen[content]
          fnote.children = "<p>See Footnote #{seen[content]}.</p>"
        else seen[content] = idx
        end
        fnote["reference"] = (idx - 1 + "a".ord).chr
        fnote["table"] = true
        [idx, seen]
      end

      def other_footnote_renumber1(fnote, idx, seen)
        return [idx, seen] if fnote["table"]

        content = footnote_content(fnote)
        idx += 1
        if seen[content]
          fnote.children = "<p>See Footnote #{seen[content]}.</p>"
        else seen[content] = idx
        end
        fnote["reference"] = idx.to_s
        [idx, seen]
      end

      def biblio_renumber(xmldoc)
        i = 0
        xmldoc.xpath("//references[not(@normative = 'true')]"\
                     "[not(@hidden = 'true')]").each do |r|
          r.xpath("./bibitem[not(@hidden = 'true')]").each do |b|
            i += 1
            next unless docid = b.at("./docidentifier[@type = 'metanorma']")
            next unless /^\[\d+\]$/.match?(docid.text)

            docid.children = "[B#{i}]"
          end
        end
      end

      TERM_CLAUSE = "//sections//terms".freeze

      def termdef_boilerplate_insert(xmldoc, isodoc, once = false)
        once = true
        super
      end

      def term_defs_boilerplate_cont(src, term, isodoc); end
    end
  end
end
