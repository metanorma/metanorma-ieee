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
    end
  end
end
