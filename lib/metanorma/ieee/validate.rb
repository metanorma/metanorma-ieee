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
        title_validate(doc.root)
      end

      def title_validate(xml)
        title_validate_type(xml)
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
    end
  end
end
