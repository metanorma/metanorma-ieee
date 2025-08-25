require_relative "cleanup_ref"
require_relative "cleanup_ref_fn"
require_relative "cleanup_boilerplate"
require_relative "term_lookup_cleanup"

module Metanorma
  module Ieee
    class Converter < Standoc::Converter
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
        type = "[not(@type = 'boilerplate' or @type = 'Availability' or " \
          "@type = 'license')]"
        n = xmldoc.at("//preface//note#{type}[not(./ancestor::abstract)] | " \
                      "//sections//note#{type} | //termnote#{type} | " \
                      "//annex//note#{type}") or return
        ins = n.at("./p[last()]")
        ins << "<fn reference='_note_cleanup1'>" \
               "<p>#{@i18n.note_inform_fn}</p></fn>"
        add_id(ins.last_element_child)
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
        Metanorma::Ieee::TermLookupCleanup.new(xmldoc, @log).call
      end

      def boilerplate_isodoc(xmldoc)
        x = xmldoc.dup
        x.root.add_namespace(nil, xml_namespace)
        xml = Nokogiri::XML(x.to_xml)
        i = isodoc(@lang, @script, @locale)
        i.bibdata_i18n(xml.at("//xmlns:bibdata"))
        i.localdir = @localdir
        i.info(xml, nil)
        i
      end

      def text_from_paras(node)
        r = node.at("./p") and node = r
        node.children.to_xml.strip
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
          .gsub(%r{</?(conn|comma|enum-comma)>}, "")
        m = @isodoc.i18n.boolean_conj(tm_id_extract(merges), "and")
          .gsub(%r{</?(conn|comma|enum-comma)>}, "")
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

      def published?(stage, _xmldoc)
        %w(approved superseded withdrawn).include?(stage&.downcase)
      end
    end
  end
end
