module Metanorma
  module Ieee
    class Converter < Standoc::Converter
      BIBITEM_NO_AVAIL =
        "//references[@normative='true']/bibitem[not(note[@type = 'Availability'])] | "\
        "//references[@normative='false']/bibitem[not(note[@type = 'Availability'])]".freeze

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
            !has_itu_t && !itu_t || (has_itu_t && itu_t)
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
        Array(msg).each do |msg1|
          note = %(<note type="Availability"><p>#{msg1}</p></note>)
          if b = insert_availability_note_ins(bib)
            b.next = note
          end
        end
      end

      def insert_availability_note_ins(bib)
        if b = bib.at("./language | ./script | ./abstract | ./status")
          b.previous
        else bib.at("./contributor") || bib.at("./date") ||
          bib.at("./docnumber") || bib.at("./docidentifier") ||
          bib.at("./title")
        end
      end
    end
  end
end
