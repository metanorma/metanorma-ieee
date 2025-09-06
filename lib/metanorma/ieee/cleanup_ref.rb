module Metanorma
  module Ieee
    class Converter < Standoc::Converter
      BIBLIO =
        "//bibliography/references[@normative = 'false'][not(@hidden)] | " \
        "//bibliography/clause[.//references[@normative = 'false']] | " \
        "//annex//references[@normative = 'false'][not(@hidden)]".freeze

      def boilerplate_cleanup(xmldoc)
        f = xmldoc.at(BIBLIO) and biblio_preface(f)
        super
      end

      def biblio_preface(ref)
        if ref.at("./note[@type = 'boilerplate']")
          unwrap_boilerplate_clauses(ref, ".")
        else
          ref.at("./title").next = "<p>#{@i18n.biblio_pref}</p>"
        end
      end

      def sort_biblio(bib)
        @i = IsoDoc::Ieee::PresentationXMLConvert
          .new({ lang: @lang, script: @script, locale: @locale })
        @i.i18n_init(@lang, @script, @locale)
        sort_keys = bib.each_with_object({}) do |b, m|
          m[b["id"]] = sort_biblio_key(b)
        end
        bib.sort { |a, b| sort_keys[a["id"]] <=> sort_keys[b["id"]] }
      end

      # Alphabetic by rendering: author surname or designation, followed by title
      def sort_biblio_key(bib)
        name, docid = designator_or_name(bib)
        title = bib.at("./title[@type = 'main']")&.text ||
          bib.at("./title")&.text || bib.at("./formattedref")&.text
        title.gsub!(/[[:punct:]]/, "")
        @c.decode("#{name} #{title} #{docid}").strip.downcase
      end

      def designator_or_name(bib)
        id = designator_docid(bib)
        if %w(standard techreport).include?(bib["type"]) && id != "ZZZZ" &&
            id != bib.at("./docidentifier[@type='metanorma']")&.text
          ret = id
        else
          bib1 = dup_with_namespace(bib)
          n = @i.creatornames(bib1)
          n.nil? && bib["type"].nil? and n = id
          ret = n
        end
        [ret, id]
      end

      def designator_docid(bib)
        n = bib.at("./docidentifier[@primary]") ||
          bib.at("./docidentifier[not(#{skip_docid})]")
        n or return "ZZZZ"
        @isodoc.docid_prefix(n["type"], n.children.to_xml)
      end

      def normref_cleanup(xmldoc)
        super
        normref_no_ordinals(xmldoc)
        normref_reorder(xmldoc)
      end

      def normref_no_ordinals(xmldoc)
        xmldoc.xpath("//references[@normative = 'true']/bibitem/" \
                    "docidentifier[@type = 'metanorma']").each do |d|
          /^\[?\d+\]?$/.match?(d.text) and d.remove
        end
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

      IEEE = "Institute of Electrical and Electronics Engineers".freeze

      # Style manual 12.3.5
      def trademark_ieee_erefs(xmldoc)
        ieee = xmldoc.xpath("//references/bibitem")
          .each_with_object({}) do |b, m|
          bib_pubs(b).include?(IEEE) and
            m[b["anchor"]] = b.at("./docidentifier[@scope = 'trademark']")&.text
        end
        trademark_ieee_erefs1(xmldoc, "//preface//eref", ieee)
        trademark_ieee_erefs1(xmldoc, "//sections//eref | //annex//eref", ieee)
      end

      def trademark_ieee_erefs1(xmldoc, path, ieee)
        xmldoc.xpath(path).each_with_object({}) do |e, m|
          ieee[e["bibitemid"]] or next
          m[e["bibitemid"]] or e["citeas"] = ieee[e["bibitemid"]]
          m[e["bibitemid"]] = true
        end
      end

      def biblio_renumber(xmldoc)
        i = 0
        xmldoc.xpath("//references[not(@normative = 'true')]" \
                     "[not(@hidden = 'true')]").each do |r|
                       r.xpath("./bibitem[not(@hidden = 'true')]").each do |b|
                         i += 1
                         biblio_renumber1(b, i)
                       end
                     end
      end

      def biblio_renumber1(bib, idx)
        docid = bib.at("./docidentifier[@type = 'metanorma' or " \
                       "@type = 'metanorma-ordinal']")
        if /^\[?\d+\]?$/.match?(docid&.text)
          docid.children = "[B#{idx}]"
          # fix metanorma to metanorma-ordinal if designation supplied
          if bib.at("./docidentifier[@type = 'title']")
            docid["type"] = "metanorma-ordinal"
          end
        elsif docid = bib.at("./docidentifier") || bib.at("./title[last()]") ||
            bib.at("./formattedref")
          docid.next =
            "<docidentifier type='metanorma-ordinal'>[B#{idx}]</docidentifier>"
        end
      end

      def select_docid(ref, type = nil)
        ret = super
        if %w(standard).include?(ref["type"]) then ret
        else
          ref.at("./docidentifier[@type = 'metanorma-ordinal']") || ret
        end
      end

      def section_names_refs_cleanup(xml)
        @doctype == "whitepaper" or return super
        replace_title(xml, "//bibliography/references", @i18n&.references, true)
      end

      def bibitem_cleanup(xmldoc)
        super
        supply_designations(xmldoc)
        supply_withdrawn_notes(xmldoc)
      end

      # force existence of a designation for standards
      def supply_designations(xmldoc)
        xmldoc.xpath("//references/bibitem[@type = 'standard']").each do |b|
          b.at("./docidentifier[not(@type = 'metanorma' or @type = 'DOI' or " \
            "@type = 'metanorma-ordinal')]") and next
          t = b.at("./title") or next
          b.at("./title[last()]").next =
            "<docidentifier type='title' primary='true'>#{t.text}</docidentifier>"
        end
      end

      def supply_withdrawn_notes(xmldoc)
        f = File.join(File.dirname(__FILE__), "ieee-footnotes.yaml")
        @provenance_notes = YAML.safe_load(File.read(f))
        withdrawn_note(xmldoc, @provenance_notes)
      end

      def biblio_reorder(xmldoc)
        super
        available_note(xmldoc, @provenance_notes)
      end

      def bib_pubs(bib)
        bib.xpath("./contributor[role/@type = 'publisher']/organization/name")
          .map(&:text)
      end

      def reference_names(xmldoc)
        #require "debug"; binding.b
        super
      end
    end
  end
end
