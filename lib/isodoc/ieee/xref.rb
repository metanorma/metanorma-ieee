require "isodoc"

module IsoDoc
  module IEEE
    class Counter < ::IsoDoc::XrefGen::Counter
    end

    class Xref < ::IsoDoc::Xref
      def initialize(lang, script, klass, labels, options)
        super
        @hierarchical_assets = options[:hierarchicalassets]
      end

      def clause_order_main(docxml)
        [
          { path: "//clause[@type = 'overview']" },
          { path: @klass.norm_ref_xpath },
          { path: "//sections/terms | " \
                  "//sections/clause[descendant::terms]" },
          { path: "//sections/definitions | " \
                  "//sections/clause[descendant::definitions][not(descendant::terms)]" },
          { path: @klass.middle_clause(docxml), multi: true },
        ]
      end

      def middle_sections
        " #{@klass.norm_ref_xpath} | " \
          "//sections/terms | " \
          "//sections/definitions | //clause[parent::sections]"
      end

      def middle_section_asset_names(doc)
        middle_sections =
          "#{@klass.norm_ref_xpath} | //sections/terms | " \
          "//sections/definitions | //clause[parent::sections]"
        if @hierarchical_assets
          hierarchical_asset_names(doc.xpath("//xmlns:preface/child::*"),
                                   "Preface")
          doc.xpath(ns(middle_sections)).each do |c|
            hierarchical_asset_names(c, @anchors[c["id"]][:label])
          end
        else
          sequential_asset_names(doc.xpath(ns("//preface/*")))
          sequential_asset_names(doc.xpath(ns(middle_sections)))
        end
      end

      def sequential_formula_names(clause)
        c = Counter.new
        clause.xpath(ns(".//formula")).noblank.each do |t|
          @anchors[t["id"]] = anchor_struct(
            c.increment(t).print, nil,
            t["inequality"] ? @labels["inequality"] : @labels["formula"],
            "formula", t["unnumbered"]
          )
        end
      end

      def termnote_anchor_names(docxml)
        docxml.xpath(ns("//*[termnote]")).each do |t|
          c = Counter.new
          sequence = UUIDTools::UUID.random_create.to_s
          notes = t.xpath(ns("./termnote"))
          notes.noblank.each do |n|
            @anchors[n["id"]] =
              anchor_struct("#{@labels['termnote']} #{increment_label(notes, n, c)}",
                            n, @labels["note_xref"], "termnote", false)
                .merge(sequence: sequence)
          end
        end
      end

      def note_anchor_names1(notes, counter)
        sequence = UUIDTools::UUID.random_create.to_s
        notes.each do |n|
          next if @anchors[n["id"]] || blank?(n["id"])

          @anchors[n["id"]] =
            anchor_struct(increment_label(notes, n, counter), n,
                          @labels["note_xref"], "note", false)
              .merge(sequence: sequence)
        end
      end

      def annex_name_lbl(clause, num)
        super.sub(%r{<br/>(.*)$}, "<br/><span class='obligation'>\\1</span>")
      end
    end
  end
end
