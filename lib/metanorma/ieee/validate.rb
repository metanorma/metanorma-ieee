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
      end

      def bibdata_validate(doc)
        doctype_validate(doc)
        # stage_validate(doc)
        # substage_validate(doc)
      end

      def doctype_validate(xmldoc)
        doctype = xmldoc&.at("//bibdata/ext/doctype")&.text
        %w(standard recommended-practice guide
           amendment technical-corrigendum).include? doctype or
          @log.add("Document Attributes", nil,
                   "#{doctype} is not a recognised document type")
      end

      def title_validate(xml)
        title_validate_type(xml)
        title_validate_capitalisation(xml)
      end

      # Style Manual 11.3
      def title_validate_type(xml)
        title = xml.at("//bibdata/title") or return
        draft = xml.at("//bibdata//draft")
        type = xml.at("//bibdata/ext/doctype")
        subtype = xml.at("//bibdata/ext/subdoctype")
        target = draft ? "Draft " : ""
        target += subtype ? "#{strict_capitalize_phrase(subtype.text)} " : ""
        target += type ? "#{strict_capitalize_phrase(type.text)} " : ""
        /^#{target}/.match?(title.text) or
          @log.add("Style", title,
                   "Expected title to start as: #{target}")
      end

      def strict_capitalize_phrase(str)
        ret = str.split(/[ -]/).map do |w|
          letters = w.chars
          letters.first.upcase! unless /^[ -]/.match?(w)
          letters.join
        end.join(" ")
        ret = "Trial-Use" if ret == "Trial Use"
        ret
      end

      # Style Manual 11.3
      def title_validate_capitalisation(xml)
        title = xml.at("//bibdata/title") or return
        found = false
        title.text.split(/[ -]/).each do |w|
          /^[[:upper:]]/.match?(w) or preposition?(w) or
            found = true
        end
        found and @log.add("Style", title,
                           "Title contains uncapitalised word other than preposition")
      end

      def preposition?(word)
        %w(aboard about above across after against along amid among anti around
           as at before behind below beneath beside besides between beyond but
           by concerning considering despite down during except excepting
           excluding following for from in inside into like minus near of off
           on onto opposite outside over past per plus regarding round save
           since than through to toward towards under underneath unlike until
           up upon versus via with within without a an the).include?(word)
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
               { hierarchical_assets: @hierarchical_assets })
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
            i = f.at("./image") or next
            next if i["src"].start_with?("data:")

            num = xrefs.anchor(f["id"], :label)
            File.basename(i["src"], ".*") == "#{pref}_fig#{num}" or
              @log.add("Style", i,
                       "Image name #{i['src']} is expected to be #{pref}_fig#{num}")
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
            i = f.at("./image") or next
            next if i["src"].start_with?("data:")

            num = tablefigurenumber(t, f, xrefs)
            File.basename(i["src"]) == num or
              @log.add("Style", i,
                       "Image name #{i['src']} is expected to be #{num}")
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
    end
  end
end
