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
    end
  end
end
