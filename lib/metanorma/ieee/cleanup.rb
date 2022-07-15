require_relative "cleanup_ref"
require_relative "term_lookup_cleanup"

module Metanorma
  module IEEE
    class Converter < Standoc::Converter
      def initial_boilerplate(xml, isodoc)
        intro_boilerplate(xml, isodoc)
        super
        initial_note(xml)
        word_usage(xml)
        participants(xml)
      end

      def intro_boilerplate(xml, isodoc)
        return unless intro = xml.at("//introduction/title")

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
        i = isodoc(@lang, @script)
        i.bibdata_i18n(xml.at("//xmlns:bibdata"))
        i.info(xml, nil)
        i
      end

      def participants(xml)
        populate_participants(xml, "boilerplate-participants-wg",
                              "working group")
        populate_participants(xml, "boilerplate-participants-bg",
                              "balloting group")
        populate_participants(xml, "boilerplate-participants-sb",
                              "standards board")
        p = xml.at(".//p[@type = 'emeritus_sign']")
        ul = xml.at("//clause[@id = 'boilerplate-participants-sb']//ul")
        p && ul and ul.next = p
        xml.at("//clause[@type = 'participants']")&.remove
      end

      def populate_participants(xml, target, subtitle)
        t = xml.at("//clause[@id = '#{target}']/membership")
        s = xml.xpath("//clause[@type = 'participants']/clause").detect do |x|
          n = x.at("./title") and n.text.strip.downcase == subtitle
        end
        t.replace(populate_participants1(s || t))
      end

      #       name
      #       given
      #       surname
      #       role
      #       company

      def populate_participants1(clause)
        clause.xpath(".//ul | .//ol").each do |ul|
          ul.name = "ul"
          ul.xpath("./li").each do |li|
            populate_participants2(li)
          end
          ul.xpath(".//p[normalize-space() = '']").each(&:remove)
        end
        clause.children.to_xml
      end

      def populate_participants2(list)
        c = HTMLEntities.new
        if dl = list.at("./dl")
          ret = extract_participants(dl)
          dl.children = ret.keys.map do |k|
            "<dt>#{k}</dt><dd>#{c.encode(ret[k], :hexadecimal)}</dd>"
          end.join
        else
          list.children = "<dl><dt>name</dt><dd>#{list.children.to_xml}</dd>"\
                          "<dt>role</dt><dd>member</dd></dl>"
        end
      end

      def extract_participants(dlist)
        key = ""
        map = dlist.xpath("./dt | ./dd").each_with_object({}) do |dtd, m|
          (dtd.name == "dt" and key = dtd.text.sub(/:+$/, "")) or
            m[key.strip.downcase] = dtd.text.strip
        end
        map["role"] ||= "member"
        map
      end
    end
  end
end
