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
        wc(xml)
        bg(xml)
        std_group(xml)
      end

      def tc(xml)
        tc = xml.at(ns("//bibdata/ext/editorialgroup/"\
                       "committee")) or return nil
        set(:committee, tc.text)
      end

      def editor_names(xml, role)
        xml.xpath(ns("//bibdata/contributor[role/@type = 'editor']"\
                     "[role = '#{role}']/person/name/completename"))
          &.each&.map(&:text)
      end

      def editor_name(xml, role)
        editor_names(xml, role)&.first
      end

      def wg(xml)
        wg = xml.at(ns("//bibdata/ext/editorialgroup/"\
                       "working-group")) or return nil
        set(:working_group, wg.text)
        m = {}
        ["Chair", "Vice-Chair"].each do |r|
          a = editor_name(xml, "Working Group #{r}") and
            m[r.downcase.gsub(/ /, "-")] = a
        end
        a = editor_names(xml, "Working Group Member") and m["members"] = a
        set(:wg_members, m)
      end

      def bg(xml)
        bg = xml.at(ns("//bibdata/ext/editorialgroup/"\
                       "balloting-group")) or return nil
        set(:balloting_group, bg.text)
        m = {}
        m["members"] = editor_names(xml, "Balloting Group Member")
        m["members"].empty? and (1..9).each do |i|
          m["members"] << "Balloter#{i}"
        end
        set(:balloting_group_members, m)
      end

      def std_group(xml)
        m = {}
        ["Chair", "Vice-Chair", "Past Chair", "Secretary"].each do |r|
          m[r.downcase.gsub(/ /, "-")] =
            editor_name(xml, "Standards Board #{r}") || "<Name>"
        end
        m["members"] = editor_names(xml, "Standards Board Member")
        m["members"].empty? and (1..9).each do |i|
          m["members"] << "SBMember#{i}"
        end
        set(:std_board, m)
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
