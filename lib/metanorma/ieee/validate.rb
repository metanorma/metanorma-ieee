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

      def section_validate(doc)
        doctype = doc&.at("//bibdata/ext/doctype")&.text
        unless %w(amendment technical-corrigendum).include? doctype
          sections_presence_validate(doc.root)
          sections_sequence_validate(doc.root)
        end
        super
      end

      def sections_presence_validate(root)
        root.at("//sections/clause[@type = 'overview']") or
          @log.add("Style", nil, "Overview clause missing")
        root.at("//sections/clause[@type = 'overview']/clause[@type = 'scope']") or
          @log.add("Style", nil, "Scope subclause missing")
        root.at("//sections/clause[@type = 'overview']/clause[@type = 'word-usage']") or
          @log.add("Style", nil, "Word Usage subclause missing")
        root.at("//references[@normative = 'true']") or
          @log.add("Style", nil, "Normative references missing")
        root.at("//terms") or
          @log.add("Style", nil, "Definitions missing")
      end

      def seqcheck(names, msg, accepted)
        n = names.shift
        return [] if n.nil?

        test = accepted.map { |a| n.at(a) }
        if test.all?(&:nil?)
          @log.add("Style", nil, msg)
        end
        names
      end

      # spec of permissible section sequence
      # we skip normative references, it goes to end of list
      SEQ = [
        { msg: "Initial section must be (content) Abstract",
          val: ["./self::abstract"] },
        { msg: "Prefatory material must be followed by (clause) Overview",
          val: ["./self::clause[@type = 'overview']"] },
        { msg: "Normative References must be followed by "\
               "Definitions",
          val: ["./self::terms | .//terms"] },
      ].freeze

      SECTIONS_XPATH =
        "//preface/abstract | //sections/terms | .//annex | "\
        "//sections/definitions | //sections/clause | "\
        "//references[not(parent::clause)] | "\
        "//clause[descendant::references][not(parent::clause)]".freeze

      def sections_sequence_validate(root)
        names, n = sections_sequence_validate_start(root)
        names, n = sections_sequence_validate_body(names, n)
        sections_sequence_validate_end(names, n)
      end

      def sections_sequence_validate_start(root)
        names = root.xpath(SECTIONS_XPATH)
        names = seqcheck(names, SEQ[0][:msg], SEQ[0][:val])
        n = names[0]
        names = seqcheck(names, SEQ[1][:msg], SEQ[1][:val])
        names = seqcheck(names, SEQ[2][:msg], SEQ[2][:val])
        n = names.shift
        n = names.shift if n&.at("./self::definitions")
        [names, n]
      end

      def sections_sequence_validate_body(names, elem)
        [names, elem]
      end

      def sections_sequence_validate_end(names, elem)
        while elem&.name == "annex"
          elem = names.shift
          if elem.nil?
            @log.add("Style", nil, "Document must include (references) "\
                                   "Normative References")
          end
        end
        elem&.at("./self::references[@normative = 'true']") ||
          @log.add("Style", nil, "Document must include (references) "\
                                 "Normative References")
        elem = names&.shift
        elem&.at("./self::references[@normative = 'false']") ||
          @log.add("Style", elem,
                   "Final section must be (references) Bibliography")
        names.empty? ||
          @log.add("Style", elem,
                   "There are sections after the final Bibliography")
      end
    end
  end
end
