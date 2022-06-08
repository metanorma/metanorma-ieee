require "isodoc"
require "twitter_cldr"

module IsoDoc
  module IEEE
    class Metadata < IsoDoc::Metadata
      def bibdate(isoxml, _out)
        draft = isoxml.at(ns("//bibdata/date[@type = 'issued']")) ||
          isoxml.at(ns("//bibdata/date[@type = 'circulated']")) ||
          isoxml.at(ns("//bibdata/date[@type = 'created']")) ||
          isoxml.at(ns("//bibdata/version/revision-date")) or return
        date = DateTime.parse(draft.text)
        set(:draft_month, date.strftime("%B"))
        set(:draft_year, date.strftime("%Y"))
      rescue StandardError
      end

      def doctype(isoxml, _out)
        b = isoxml.at(ns("//bibdata/ext/doctype"))&.text or return
        set(:doctype, b.split(/[- ]/).map(&:capitalize).join(" "))
        set(:doctype_abbrev, @labels["doctype_abbrev"][b])
        s = isoxml.at(ns("//bibdata/ext/docsubtype"))&.text and
          set(:docsubtype, s.split(/[- ]/).map(&:capitalize).join(" "))
      end

      def author(xml, _out)
        super
        tc(xml)
      end

      def tc(xml)
        tc = xml.at(ns("//bibdata/ext/editorialgroup/"\
                       "technical-committee")) or return nil
        set(:committee, tc.text)
      end

      def otherid(isoxml, _out)
        id = "bibdata/docidentifier[@type = 'ISBN']"
        dn = isoxml.at(ns("//#{id}[@scope = 'PDF']"))
        set(:isbn_pdf, dn&.text || "978-0-XXXX-XXXX-X")
        dn = isoxml.at(ns("//#{id}[@scope = 'print']"))
        set(:isbn_print, dn&.text || "978-0-XXXX-XXXX-X")
      end

      def docid(isoxml, _out)
        super
        id = "bibdata/docidentifier[@type = 'IEEE']"
        dn = isoxml.at(ns("//#{id}[@scope = 'PDF']"))
        set(:stdid_pdf, dn&.text || "STDXXXXX")
        dn = isoxml.at(ns("//#{id}[@scope = 'print']"))
        set(:stdid_print, dn&.text || "STDPDXXXXX")
      end
    end
  end
end
