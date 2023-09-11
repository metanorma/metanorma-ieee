require_relative "validate_section"
require_relative "validate_style"

module Metanorma
  module IEEE
    class Converter < Standoc::Converter
      def validate(doc)
        content_validate(doc)
        schema_validate(formattedstr_strip(doc.dup),
                        File.join(File.dirname(__FILE__), "ieee.rng"))
      end

      def content_validate(doc)
        super
        bibdata_validate(doc.root)
        title_validate(doc.root)
        locality_validate(doc.root)
        bibitem_validate(doc.root)
        list_validate(doc)
        table_style(doc)
        figure_validate(doc)
        amend_validate(doc)
      end

      def bibdata_validate(doc)
        doctype_validate(doc)
        stage_validate(doc)
      end

      def doctype_validate(xmldoc)
        %w(standard recommended-practice guide whitepaper redline other)
          .include?(@doctype) or
          @log.add("Document Attributes", nil,
                   "#{@doctype} is not a recognised document type")
        docsubtype = xmldoc.at("//bibdata/ext/subdoctype")&.text or return
        %w(amendment corrigendum erratum document).include? docsubtype or
          @log.add("Document Attributes", nil,
                   "#{docsubtype} is not a recognised document subtype")
      end

      def stage_validate(xmldoc)
        stage = xmldoc&.at("//bibdata/status/stage")&.text
        %w(draft approved superseded withdrawn).include? stage or
          @log.add("Document Attributes", nil,
                   "#{stage} is not a recognised stage")
      end

      def locality_validate(root)
        locality_range_validate(root)
        locality_erefs_validate(root)
      end

      # Style manual 17.2 &c
      def locality_range_validate(root)
        root.xpath("//eref | xref").each do |e|
          e.at(".//localityStack[@connective = 'from'] | .//referenceTo") and
            @log.add("Style", e, "Cross-reference contains range, "\
                                 "should be separate cross-references")
        end
      end

      # Style manual 12.3.2
      def locality_erefs_validate(root)
        root.xpath("//eref[descendant::locality]").each do |t|
          if !/[:-](\d+{4})$/.match?(t["citeas"])
            @log.add("Style", t,
                     "Undated reference #{t['citeas']} should not contain "\
                     "specific elements")
          end
        end
      end

      def bibitem_validate(root)
        normative_dated_refs(root)
      end

      # Style manual 12.3.1
      def normative_dated_refs(root)
        root.xpath("//references[@normative = 'true']/bibitem").each do |b|
          b.at(".//date") or
            @log.add("Style", b,
                     "Normative reference #{b&.at('./@id')&.text} is not dated.")
        end
      end

      def list_validate(doc)
        listcount_validate(doc)
        listdepth_validate(doc)
      end

      # Template provision of styles
      def listdepth_validate(doc)
        doc.xpath("//ul[.//ul//ul]").each do |u|
          next unless u.ancestors("ul").empty?

          @log.add("Style", u,
                   "Use ordered lists for lists more than two levels deep.")
        end
        doc.xpath("//ol[.//ol//ol//ol//ol//ol]").each do |u|
          next unless u.ancestors("ol").empty?

          @log.add("Style", u,
                   "Ordered lists should not be more than five levels deep.")
        end
      end

      # Style manual 13.3
      def listcount_validate(doc)
        doc.xpath("//sections//clause | //annex").each do |c|
          next if c.xpath(".//ol").empty?

          ols = c.xpath(".//ol") -
            c.xpath(".//ul//ol | .//ol//ol | .//clause//ol")
          ols.size > 1 and
            style_warning(c, "More than 1 ordered list in a numbered clause",
                          nil)
        end
      end

      # Style manual 17.1
      def figure_validate(xmldoc)
        xrefs = xrefs(xmldoc)
        figure_name_validate(xmldoc, xrefs)
        figure_name_style_validate(xmldoc)
        table_figure_name_validate(xmldoc, xrefs)
        table_figure_quantity_validate(xmldoc)
      end

      def xrefs(xmldoc)
        klass = IsoDoc::IEEE::HtmlConvert.new(language: @lang, script: @script)
        xrefs = IsoDoc::IEEE::Xref
          .new(@lang, @script, klass, IsoDoc::IEEE::I18n.new(@lang, @script),
               { hierarchicalassets: @hierarchical_assets })
        xrefs.parse(Nokogiri::XML(xmldoc.to_xml))
        xrefs
      end

      def image_name_prefix(xmldoc)
        num = xmldoc.at("//bibdata/docnumber") or return
        yr = xmldoc.at("//bibdata/date[@type = 'published']") ||
          xmldoc.at("//bibdata/date[@type = 'issued']") ||
          xmldoc.at("//bibdata/copyright/from")
        yr = yr&.text || Date.now.year
        "#{num.text}-#{yr.sub(/-*$/, '')}"
      end

      def figure_name_validate(xmldoc, xrefs)
        pref = image_name_prefix(xmldoc)
        (xmldoc.xpath("//figure") - xmldoc.xpath("//table//figure"))
          .each do |f|
            (i = f.at("./image") and !i["src"]&.start_with?("data:")) or next

            num = xrefs.anchor(f["id"], :label)
            base = File.basename(i["src"], ".*")
            base == "#{pref}_fig#{num}" or
              @log.add("Style", i,
                       "Image name #{base} is expected to be #{pref}_fig#{num}")
          end
      end

      # Style manual 17.2
      def figure_name_style_validate(docxml)
        docxml.xpath("//figure/name").each do |td|
          style_regex(/^(?<num>\p{Lower}\s*)/, "figure heading should be capitalised",
                      td, td.text)
        end
      end

      def table_figure_name_validate(xmldoc, xrefs)
        xmldoc.xpath("//table[.//figure]").each do |t|
          xmldoc.xpath(".//figure").each do |f|
            (i = f.at("./image") and !i["src"]&.start_with?("data:")) or next

            num = tablefigurenumber(t, f, xrefs)
            base = File.basename(i["src"])
            base == num or
              @log.add("Style", i,
                       "Image name #{base} is expected to be #{num}")
          end
        end
      end

      def tablefigurenumber(table, figure, xrefs)
        tab = xrefs.anchor(table["id"], :label)
        td = figure.at("./ancestor::td | ./ancestor::th")
        cols = td.xpath("./preceding-sibling::td | ./preceding-sibling::td")
        rows = td.parent.xpath("./preceding::tr") &
          td.at("./ancestor::table").xpath(".//tr")
        "Tab#{tab}Row#{rows.size + 1}Col#{cols.size + 1}"
      end

      def table_figure_quantity_validate(xmldoc)
        xmldoc.xpath("//td[.//image] | //th[.//image]").each do |d|
          d.xpath(".//image").size > 1 and
            @log.add("Style", d,
                     "More than one image in the table cell")
        end
      end

      # Style manual 20.2.2
      def amend_validate(xmldoc)
        xmldoc.xpath("//amend").each do |a|
          desc = a.at("./description")
          if desc && !desc.text.strip.empty?
            amend_validate1(a, desc.text.strip,
                            a.at("./newcontent//figure | "\
                                 "./newcontent//formula"))
          else @log.add("Style", a,
                        "Editorial instruction is missing from change")
          end
        end
      end

      def amend_validate1(amend, description, figure_or_formula)
        case amend["change"]
        when "add" then /^Insert /.match?(description) or
          @log.add("Style", amend,
                   "'Add' change description should start with _Insert_")
        when "delete" then /^Insert /.match?(description) or
          @log.add("Style", amend,
                   "'Delete' change description should start with _Delete_")
        when "modify"
          amend_validate_modify(amend, description, figure_or_formula)
        end
      end

      AMD_VALID_MOD = [
        "'Modify' change description should start with _Change_ or _Replace_",
        "'Modify' change description for change involving figure or equation "\
        "should start with _Replace_",
        "'Modify' change description for change not involving figure or "\
        "equation should start with _Change_",
      ].freeze

      def amend_validate_modify(amend, description, figure_or_formula)
        if !/^Change |^Replace/.match?(description)
          @log.add("Style", amend, AMD_VALID_MOD[0])
        elsif /^Change /.match?(description)
          !figure_or_formula or @log.add("Style", amend, AMD_VALID_MOD[1])
        else
          figure_or_formula or @log.add("Style", amend, AMD_VALID_MOD[2])
        end
      end
    end
  end
end
