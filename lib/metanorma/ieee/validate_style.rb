module Metanorma
  module IEEE
    class Converter < Standoc::Converter
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

      # Style manual 16.2, 16.3.2
      def table_style(docxml)
        docxml.xpath("//td").each do |td|
          style_regex(/^(?<num>[\u2212-]?[0-9]{5,}[.0-9]*|-?[0-9]+\.[0-9]{5,})$/,
                      "number in table not broken up in threes", td, td.text)
        end
        docxml.xpath("//table").each { |t| table_style_columns(t) }
        docxml.xpath("//table/name | //th").each do |td|
          style_regex(/^(?<num>\p{Lower}\S*)/, "table heading should be capitalised",
                      td, td.text)
        end
      end

      # deliberately doing naive, ignoring rowspan
      def table_style_columns(table)
        table_extract_columns(table).each do |col|
          next unless col.any? do |x|
            /^[0-9. ]+$/.match?(x) &&
              (/\d{3} \d/.match?(x) || /\d \d{3}/.match?(x))
          end

          col.each do |x|
            /^[0-9. ]+$/.match?(x) && /\d{4}/.match?(x) and
              @log.add("Style", table,
                       "#{x} is a 4-digit number in a table column with "\
                       "numbers broken up in threes")
          end
        end
      end

      def table_extract_columns(table)
        ret = table.xpath(".//tr").each_with_object([]) do |tr, m|
          tr.xpath("./td | ./th").each_with_index do |d, i|
            m[i] ||= []
            m[i] << d.text
          end
        end
        ret.map { |x| x.is_a?(Array) ? x : [] }
      end
    end
  end
end
