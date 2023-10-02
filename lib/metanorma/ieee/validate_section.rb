module Metanorma
  module IEEE
    class Converter < Standoc::Converter
      def section_validate(doc)
        unless %w(amendment technical-corrigendum).include? @doctype
          sections_presence_validate(doc.root)
          sections_sequence_validate(doc.root)
        end
        subclause_validate(doc.root)
        onlychild_clause_validate(doc.root)
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
        bibliography_validate(root)
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
      end

      # Style manual 13.1
      def subclause_validate(root)
        root.xpath("//clause/clause/clause/clause/clause/clause")
          .each do |c|
          style_warning(c, "Exceeds the maximum clause depth of 5", nil)
        end
      end

      # Style manual 13.1
      def onlychild_clause_validate(root)
        root.xpath(Standoc::Utils::SUBCLAUSE_XPATH).each do |c|
          next unless c.xpath("../clause").size == 1

          title = c.at("./title")
          location = c["id"] || "#{c.text[0..60]}..."
          location += ":#{title.text}" if c["id"] && !title.nil?
          @log.add("Style", nil, "#{location}: subclause is only child")
        end
      end

      # Style manual 19.1
      def bibliography_validate(root)
        bib = root.at("//references[@normative = 'false']") or return
        if annex = bib.at(".//ancestor::annex")
          prec = annex.xpath("./preceding-sibling::annex")
          foll = annex.xpath("./following-sibling::annex")
          valid = prec.empty? || foll.empty?
        else valid = false
        end
        valid or @log.add("Style", bib, "Bibliography must be either the first "\
                                        "or the last document annex")
      end
    end
  end
end
