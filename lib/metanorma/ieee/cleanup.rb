require_relative "cleanup_ref"
require_relative "term_lookup_cleanup"

module Metanorma
  module IEEE
    class Converter < Standoc::Converter
      def initial_boilerplate(xml, isodoc)
        intro_boilerplate(xml, isodoc)
        super if @document_scheme == "ieee-sa-2021"
        xml.at("//boilerplate") or return
        initial_note(xml)
        word_usage(xml)
        participants(xml)
        footnote_boilerplate_renumber(xml)
      end

      def footnote_boilerplate_renumber(xml)
        xml.xpath("//boilerplate//fn").each_with_index do |f, i|
          f["reference"] = "_boilerplate_#{i + 1}"
        end
      end

      def intro_boilerplate(xml, isodoc)
        intro = xml.at("//introduction/title") or return
        template = <<~ADM
          This introduction is not part of P{{ docnumeric }}{% if draft %}/D{{ draft }}{% endif %}, {{ full_doctitle }}
        ADM
        adm = isodoc.populate_template(template)
        intro.next = "<admonition>#{adm}</admonition>"
      end

      def initial_note(xml)
        n = xml.at("//boilerplate//note[@id = 'boilerplate_front']")
        s = xml.at("//sections")
        (n && s) or return
        s.children.empty? and s << " "
        s.children.first.previous = n.remove
      end

      def word_usage(xml)
        @document_scheme == "ieee-sa-2021" or return
        n = xml.at("//boilerplate//clause[@id = 'boilerplate_word_usage']")
          &.remove
        s = xml.at("//clause[@type = 'overview']")
        (n && s) or return
        s << n
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
        overview_once_cleanup(xml)
        overview_children_cleanup(xml)
      end

      def overview_children_cleanup(xml)
        %w(scope purpose word-usage).each do |x|
          (xml.xpath("//clause[@type = '#{x}']") -
            xml.xpath("//sections/clause[@type = 'overview']" \
                      "//clause[@type = '#{x}']"))
            .each { |c| c.delete("type") }
        end
      end

      def overview_once_cleanup(xml)
        found = false
        xml.xpath("//sections//clause[@type = 'overview']").each do |c|
          found and c.delete("type")
          found = true if c.parent.name == "sections"
        end
        xml.xpath("//annex//clause[@type = 'overview'] | " \
                  "//preface//clause[@type = 'overview']").each do |c|
          c.delete("type")
        end
      end

      def note_cleanup(xmldoc)
        super
        n = xmldoc.at("//preface//note[not(@type = 'boilerplate')]" \
                      "[not(./ancestor::abstract)] | " \
                      "//sections//note[not(@type = 'boilerplate')] | " \
                      "//annex//note[not(@type = 'boilerplate')]") or
          return
        ins = n.at("./p[last()]")
        ins << "<fn reference='_boilerplate_cleanup1'>" \
               "<p>#{@i18n.note_inform_fn}</p></fn>"
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
        fnote["table"] and return [idx, seen]
        content = footnote_content(fnote)
        idx += 1
        if seen[content]
          fnote.children = "<p>See Footnote #{seen[content]}.</p>"
        else seen[content] = idx
        end
        fnote["reference"] = idx.to_s
        [idx, seen]
      end

      TERM_CLAUSE = "//sections//terms".freeze

      def termdef_boilerplate_insert(xmldoc, isodoc, once = false)
        once = true
        super
      end

      def term_defs_boilerplate_cont(src, term, isodoc); end

      def termlookup_cleanup(xmldoc)
        Metanorma::IEEE::TermLookupCleanup.new(xmldoc, @log).call
      end

      def boilerplate_isodoc(xmldoc)
        x = xmldoc.dup
        x.root.add_namespace(nil, self.class::XML_NAMESPACE)
        xml = Nokogiri::XML(x.to_xml)
        i = isodoc(@lang, @script, @locale)
        i.bibdata_i18n(xml.at("//xmlns:bibdata"))
        i.info(xml, nil)
        i
      end

      PARTICIPANT_BOILERPLATE_LOCATIONS =
        { "boilerplate-participants-wg": "working group",
          "boilerplate-participants-bg": "balloting group",
          "boilerplate-participants-sb": "standards board",
          "boilerplate-participants-blank": nil }.freeze

      def participants(xml)
        @document_scheme == "ieee-sa-2021" or return
        PARTICIPANT_BOILERPLATE_LOCATIONS.each do |k, v|
          populate_participants(xml, k.to_s, v)
        end
        p = xml.at(".//p[@type = 'emeritus_sign']")
        ul = xml.at("//clause[@id = 'boilerplate-participants-sb']//ul")
        p && ul and ul.next = p
        xml.at("//sections//clause[@type = 'participants']")&.remove
      end

      def populate_participants(xml, target, subtitle)
        t = xml.at("//clause[@id = '#{target}']/membership") or return
        s = xml.xpath("//clause[@type = 'participants']/clause").detect do |x|
          n = x.at("./title") and n.text.strip.downcase == subtitle
        end
        t.replace(populate_participants1(s || t))
      end

      def populate_participants1(clause)
        participants_dl_to_ul(clause)
        clause.xpath(".//ul | .//ol").each do |ul|
          ul.name = "ul"
          ul.xpath("./li").each { |li| populate_participants2(li) }
          ul.xpath(".//p[normalize-space() = '']").each(&:remove)
        end
        clause.at("./title")&.remove
        clause.children.to_xml
      end

      def participants_dl_to_ul(clause)
        clause.xpath(".//dl").each do |dl|
          dl.ancestors("dl, ul, ol").empty? or next
          dl.name = "ul"
          dl.xpath("./dt").each(&:remove)
          dl.xpath("./dd").each { |li| li.name = "li" }
        end
      end

      def populate_participants2(list)
        curr = list
        p = curr.at("./p") and curr = p
        if dl = curr.at("./dl")
          ret = extract_participants(dl)
          dl.children = ret.keys.map do |k|
            "<dt>#{k}</dt><dd><p>#{ret[k]}</p></dd>"
          end.join
        else
          list.children = "<dl><dt>name</dt><dd><p>#{curr.children.to_xml}" \
                          "</p></dd><dt>role</dt><dd><p>member</p></dd></dl>"
        end
      end

      def extract_participants(dlist)
        key = ""
        map = dlist.xpath("./dt | ./dd").each_with_object({}) do |dtd, m|
          (dtd.name == "dt" and key = dtd.text.sub(/:+$/, "")) or
            m[key.strip.downcase] =
              @c.encode(@c.decode(dtd.text.strip), :hexadecimal)
        end
        map["role"] ||= "member"
        map
      end

      def bibdata_cleanup(xmldoc)
        super
        provenance_title(xmldoc)
      end

      def provenance_title(xmldoc)
        u = xmldoc.xpath("//bibdata/relation[@type = 'updates']")
        m = xmldoc.xpath("//bibdata/relation[@type = 'merges']")
        u.empty? and m.empty? and return
        ins = xmldoc.at("//bibdata/title")
        t = provenance_title1(u, m)
        ins.next = "<title type='provenance' language='en' " \
                   "format='application/xml'>#{t}</title>"
      end

      def provenance_title1(updates, merges)
        ret = ""
        u = @isodoc.i18n.boolean_conj(tm_id_extract(updates), "and")
        m = @isodoc.i18n.boolean_conj(tm_id_extract(merges), "and")
        u.empty? or ret += "Revision of #{u}"
        !u.empty? && !m.empty? and ret += "<br/>"
        m.empty? or ret += "Incorporates #{m}"
        ret
      end

      def tm_id_extract(relations)
        relations.map do |u|
          u.at("./bibitem/docidentifier[@scope = 'trademark']") ||
            u.at("./bibitem/docidentifier[@primary = 'true']") ||
            u.at("./bibitem/docidentifier")
        end.map(&:text)
      end
    end
  end
end
