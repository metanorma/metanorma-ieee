require_relative "validate_section"

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
        locality_erefs_validate(doc.root)
        bibitem_validate(doc.root)
        listcount_validate(doc)
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

      # Style manual 12.3.2
      def locality_erefs_validate(root)
        root.xpath("//eref[descendant::locality]").each do |t|
          if !/[:-](\d+{4})$/.match?(t["citeas"])
            @log.add("Style", t,
                     "undated reference #{t['citeas']} should not contain "\
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

      # Style manual 13.3
      def listcount_validate(doc)
        doc.xpath("//clause | //annex").each do |c|
          next if c.xpath(".//ol").empty?

          ols = c.xpath(".//ol") -
            c.xpath(".//ul//ol | .//ol//ol | .//clause//ol")
          ols.size > 1 and
            style_warning(c, "More than 1 ordered list in a numbered clause",
                          nil)
        end
      end

      ASSETS_TO_STYLE =
        "//termsource | //formula | //termnote | "\
        "//p[not(ancestor::boilerplate)] | //li[not(p)] | //dt | "\
        "//dd[not(p)] | //td[not(p)][not(ancestor::boilerplate)] | "\
        "//th[not(p)][not(ancestor::boilerplate)] | //example".freeze

      def extract_text(node)
        return "" if node.nil?

        node1 = Nokogiri::XML.fragment(node.to_s)
        node1.xpath("//link | //locality | //localityStack").each(&:remove)
        ret = ""
        node1.traverse { |x| ret += x.text if x.text? }
        HTMLEntities.new.decode(ret)
      end

      def asset_style(root)
        root.xpath(ASSETS_TO_STYLE).each { |e| style(e, extract_text(e)) }
      end

      def style_regex(regex, warning, node, text)
        (m = regex.match(text)) && style_warning(node, warning, m[:num])
      end

      def style_warning(node, msg, text = nil)
        return if @novalid

        w = msg
        w += ": #{text}" if text
        @log.add("Style", node, w)
      end

      def style(node, text)
        return if @novalid

        style_number(node, text)
        style_percent(node, text)
        style_units(node, text)
      end

      # Style manual 14.2
      def style_number(node, text)
        style_regex(/\b(?<num>[0-9]+,[0-9]+)/i,
                    "possible decimal comma", node, text)
        style_regex(/(?:^|\s)(?<num>[\u2212-]?\.[0-9]+)/i,
                    "decimal without initial zero", node, text)
      end

      # Style manual 14.2
      def style_percent(node, text)
        style_regex(/\b(?<num>[0-9.]+%)/,
                    "no space before percent sign", node, text)
      end

      # leaving out as problematic: N J K C S T H h d B o E
      SI_UNIT = "(m|cm|mm|km|μm|nm|g|kg|mgmol|cd|rad|sr|Hz|Hz|MHz|Pa|hPa|kJ|"\
                "V|kV|W|MW|kW|F|μF|Ω|Wb|°C|lm|lx|Bq|Gy|Sv|kat|l|t|eV|u|Np|Bd|"\
                "bit|kB|MB|Hart|nat|Sh|var)".freeze

      # Style manual 14.2
      def style_units(node, text)
        style_regex(/(\b|^)(?<num>[0-9][0-9.]*#{SI_UNIT})\b/o,
                    "no space between number and SI unit", node, text)
        style_regex(/(\b|^)(?<num>[0-9.]+\s*\u00b1\s*[0-9.]+\s*#{SI_UNIT})\b/o,
                    "unit is needed on both value and tolerance", node, text)
      end
    end
  end
end
