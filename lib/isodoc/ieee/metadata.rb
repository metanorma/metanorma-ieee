require "isodoc"
require "twitter_cldr"

module IsoDoc
  module IEEE
    class Metadata < IsoDoc::Metadata
      def initialize(lang, script, i18n, fonts_options = {})
        super
        @metadata[:issueddate] = "&lt;Date Approved&gt;"
      end

      def bibdate(isoxml, _out)
        isoxml.xpath(ns("//bibdata/date[@format = 'ddMMMyyyy']")).each do |d|
          set("#{d['type'].gsub(/-/, '_')}date".to_sym, Common::date_range(d))
        end
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
        s = isoxml.at(ns("//bibdata/ext/subdoctype"))&.text and
          set(:docsubtype, s.split(/[- ]/).map(&:capitalize).join(" "))
        s = isoxml.at(ns("//bibdata/ext/trial-use"))&.text and s == "true" and
          set(:trial_use, true)
      end

      def author(xml, _out)
        super
        society(xml)
        tc(xml)
        wg(xml)
        bg(xml)
        std_group(xml)
      end

      def society(xml)
        society = xml.at(ns("//bibdata/ext/editorialgroup/"\
                            "society"))&.text || "&lt;Society&gt;"
        set(:society, society)
      end

      def tc(xml)
        tc = xml.at(ns("//bibdata/ext/editorialgroup/"\
                       "committee"))&.text || "&lt;Committee Name&gt;"
        set(:technical_committee, tc)
      end

      def editor_names(xml, role)
        xml.xpath(ns("//bibdata/contributor[role/@type = 'editor']"\
                     "[role = '#{role}']/person/name/completename"))
          &.each&.map(&:text)
      end

      def editor_org_names(xml, role)
        xml.xpath(ns("//bibdata/contributor[role/@type = 'editor']"\
                     "[role = '#{role}']/organization/name"))
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
        ["Chair", "Vice-Chair", "Secretary"].each do |r|
          a = editor_name(xml, "Working Group #{r}") and
            m[r.downcase.gsub(/ /, "-")] = a
        end
        wg_members(xml, m)
        wg_org_members(xml, m)
      end

      def wg_members(xml, members)
        a = editor_names(xml, "Working Group Member") and members["members"] = a
        members["members"].empty? and (1..9).each do |i|
          members["members"] << "Participant#{i}"
        end
        set(:wg_members, members)
      end

      def wg_org_members(xml, members)
        a = editor_org_names(xml, "Working Group Member")
        a.empty? and return
        members["org_members"] = a
        set(:wg_org_members, a)
      end

      def bg(xml)
        bg = xml.at(ns("//bibdata/ext/editorialgroup/"\
                       "balloting-group")) or return nil
        set(:balloting_group, bg.text)
        set(:balloting_group_type, bg["type"])
        m = {}
        m["members"] = editor_names(xml, "Balloting Group Member")
        m["members"].empty? and (1..9).each do |i|
          m["members"] << "Balloter#{i}"
        end
        set(:balloting_group_members, m["members"])
      end

      def std_group(xml)
        m = {}
        ["Chair", "Vice-Chair", "Past Chair", "Secretary"].each do |r|
          m[r.downcase.gsub(/ /, "-")] =
            editor_name(xml, "Standards Board #{r}") || "&lt;Name&gt;"
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
        dn = isoxml.at(ns("//bibdata/ext/structuredidentifier/amendment")) and
          set(:amd, dn.text)
        dn = isoxml.at(ns("//bibdata/ext/structuredidentifier/corrigendum")) and
          set(:corr, dn.text)
      end

      def title(isoxml, _out)
        super
        draft = isoxml&.at(ns("//bibdata/version/draft"))
        doctype(isoxml, _out)
        set(:full_doctitle, fulltitle(@metadata[:doctype], draft))
        set(:abbrev_doctitle, fulltitle(@metadata[:doctype_abbrev], draft))
      end

      def fulltitle(type, draft)
        title = "#{type || '???'} for #{@metadata[:doctitle] || '???'}"
        draft and title = "Draft #{title}"
        title
      end

      def relations(isoxml, _out)
        super
        relations_get(isoxml, "updates")
        relations_get(isoxml, "merges")
      end

      def relations_get(isoxml, type)
        std = isoxml.xpath(ns("//bibdata/relation[@type = '#{type}']"))
        return if std.empty?

        ret = std.map do |x|
          x.at(ns(".//docidentifier[@primary = 'true']"))&.text ||
            x.at(ns(".//docidentifier"))&.text
        end
        set(type.to_sym, ret)
      end

      def ddMMMyyyy(isodate)
        return nil if isodate.nil?

        arr = isodate.split("-")
        if arr.size == 1 && (/^\d+$/.match isodate)
          Date.new(*arr.map(&:to_i)).strftime("%Y")
        elsif arr.size == 2
          Date.new(*arr.map(&:to_i)).strftime("%b %Y")
        else
          Date.parse(isodate).strftime("%d %b %Y")
        end
      end
    end
  end
end
