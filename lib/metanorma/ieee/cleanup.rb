require_relative "cleanup_ref"
require_relative "term_lookup_cleanup"

module Metanorma
  module IEEE
    class Converter < Standoc::Converter
      def initial_boilerplate(xml, isodoc)
        intro_boilerplate(xml, isodoc)
        super
      end

      def intro_boilerplate(xml, isodoc)
        return unless intro = xml.at("//introduction/title")

        template = <<~ADM
          This introduction is not part of P{{ docnumeric }}{% if draft %}/D{{ draft }}{% endif %}, {{ full_doctitle }}
        ADM
        adm = isodoc.populate_template(template)
        intro.next = "<admonition>#{adm}</admonition>"
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
    end
  end
end
