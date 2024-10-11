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
        name = designator_or_name(bib)
        title = bib.at("./title[@type = 'main']")&.text ||
          bib.at("./title")&.text || bib.at("./formattedref")&.text
        title.gsub!(/[[:punct:]]/, "")
        @c.decode("#{name} #{title}").strip.downcase
      end

      def designator_or_name(bib)
        case bib["type"]
        when "standard", "techreport" then designator_docid(bib)
        else
          bib1 = bib.dup
          bib1.add_namespace(nil, self.class::XML_NAMESPACE)
          n = @i.creatornames(bib1)
          n.nil? && bib["type"].nil? and n = designator_docid(bib)
          n
        end
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
            m[b["id"]] = b.at("./docidentifier[@scope = 'trademark']")&.text
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
        elsif docid = bib.at("./docidentifier") || bib.at("./title[last()]") ||
            bib.at("./formattedref")
          docid.next =
            "<docidentifier type='metanorma-ordinal'>[B#{idx}]</docidentifier>"
        end
      end

      def select_docid(ref, type = nil)
        ret = super
        if %w(standard techreport).include?(ref["type"]) then ret
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

      BIBITEM_NO_AVAIL =
        "//references/bibitem[not(note[@type = 'Availability'])]".freeze

      def withdrawn_note(xmldoc, provenance_notes)
        xmldoc.xpath(BIBITEM_NO_AVAIL).each do |b|
          bib_pubs(b).include?(IEEE) or next
          b.at("./status/stage")&.text == "withdrawn" or next
          docid = b.at("./docidentifier[@type = 'IEEE'][not(@scope)]")
          note = provenance_notes["ieee-withdrawn"].sub("%", docid.text)
          insert_availability_note(b, note)
        end
      end

      AVAIL_PUBS = {
        ieee: IEEE,
        cispr: "International special committee on radio interference",
        etsi: "European Telecommunications Standards Institute",
        oasis: "OASIS",
        "w3c": "World Wide Web Consortium",
        "3gpp": "3rd Generation Partnership Project",
      }.freeze

      def available_note(xmldoc, provenance_notes)
        iso_iec_available_note(xmldoc, provenance_notes["iso-iec"], true, true)
        iso_iec_available_note(xmldoc, provenance_notes["iso"], true, false)
        iso_iec_available_note(xmldoc, provenance_notes["iec"], false, true)
        itu_available_note(xmldoc, provenance_notes["itut"], true)
        itu_available_note(xmldoc, provenance_notes["itur"], false)
        nist_available_note(xmldoc, provenance_notes["fips"], true)
        nist_available_note(xmldoc, provenance_notes["nist"], false)
        ietf_available_note(xmldoc, provenance_notes["ietf"])
        AVAIL_PUBS.each do |k, v|
          sdo_available_note(xmldoc, provenance_notes[k.to_s], v)
        end
      end

      def sdo_available_note(xmldoc, note, publisher)
        ret = xmldoc.xpath(BIBITEM_NO_AVAIL).detect do |b|
          bib_pubs(b).include?(publisher)
        end
        insert_availability_note(ret, note)
      end

      def iso_iec_available_note(xmldoc, note, iso, iec)
        ret = xmldoc.xpath(BIBITEM_NO_AVAIL).detect do |b|
          pubs = bib_pubs(b)
          has_iec = pubs.include?("International Electrotechnical Commission")
          has_iso = pubs.include?("International Organization for Standardization")
          ((has_iec && iec) || (!has_iec && !iec)) &&
            ((has_iso && iso) || (!has_iso && !iso))
        end
        insert_availability_note(ret, note)
      end

      def ietf_available_note(xmldoc, note)
        ret = xmldoc.xpath(BIBITEM_NO_AVAIL).detect do |b|
          b.at("./docidentifier[@type = 'IETF']")
        end
        insert_availability_note(ret, note)
      end

      def itu_available_note(xmldoc, note, itu_t)
        ret = xmldoc.xpath(BIBITEM_NO_AVAIL).detect do |b|
          has_itu_t = /^ITU-T/.match?(b.at("./docidentifier[@type = 'ITU']")&.text)
          bib_pubs(b).include?("International Telecommunication Union") &&
            (!has_itu_t && !itu_t) || (has_itu_t && itu_t)
        end
        insert_availability_note(ret, note)
      end

      def nist_available_note(xmldoc, note, fips)
        ret = xmldoc.xpath(BIBITEM_NO_AVAIL).detect do |b|
          id = b.at("./docidentifier[@type = 'NIST']")
          has_fips = /\bFIPS\b/.match?(id&.text)
          id && ((has_fips && !fips) || (!has_fips && fips))
        end
        insert_availability_note(ret, note)
      end

      def insert_availability_note(bib, msg)
        bib or return
        note = %(<note type="Availability"><p>#{msg}</p></note>)
        if b = bib.at("./language | ./script | ./abstract | ./status")
          b.previous = note
        else b = bib.at("./contributor") || bib.at("./date") ||
          bib.at("./docnumber") || bib.at("./docidentifier") ||
          bib.at("./title") and b.next = note
        end
      end
    end
  end
end
