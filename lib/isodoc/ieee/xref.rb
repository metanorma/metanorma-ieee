require "isodoc"

module IsoDoc
  module IEEE
    class Counter < ::IsoDoc::XrefGen::Counter
    end

    class Xref < ::IsoDoc::Xref
      def initialize(lang, script, klass, labels, options)
        super
        @hierarchical_assets = options[:hierarchical_assets]
      end

      def initial_anchor_names(doc)
        if @parse_settings.empty? || @parse_settings[:clauses]
          doc.xpath(ns("//preface/*")).each do |c|
            c.element? and preface_names(c)
          end
        end
        if @parse_settings.empty?
          if @hierarchical_assets
            hierarchical_asset_names(doc.xpath("//xmlns:preface/child::*"),
                                     "Preface")
          else
            sequential_asset_names(doc.xpath(ns("//preface/*")))
          end
        end
        if @parse_settings.empty? || @parse_settings[:clauses]
          n = Counter.new
          n = section_names(doc.at(ns("//clause[@type = 'overview']")), n, 1)
          n = section_names(doc.at(ns(@klass.norm_ref_xpath)), n, 1)
          n = section_names(doc.at(ns("//sections/terms | "\
                                      "//sections/clause[descendant::terms]")), n, 1)
          n = section_names(doc.at(ns("//sections/definitions")), n, 1)
          clause_names(doc, n)
        end
        if @parse_settings.empty?
          middle_section_asset_names(doc)
          termnote_anchor_names(doc)
          termexample_anchor_names(doc)
        end
      end

      def middle_sections
        " #{@klass.norm_ref_xpath} | "\
          "//sections/terms | //preface/clause | "\
          "//sections/definitions | //clause[parent::sections]"
      end

      def middle_section_asset_names(doc)
        middle_sections =
          "#{@klass.norm_ref_xpath} | //sections/terms | "\
          "//sections/definitions | //clause[parent::sections]"
        if @hierarchical_assets
          doc.xpath(ns(middle_sections)).each do |c|
            hierarchical_asset_names(c, @anchors[c["id"]][:label])
          end
        else
          sequential_asset_names(doc.xpath(ns(middle_sections)))
        end
      end

      def sequential_formula_names(clause)
        c = Counter.new
        clause.xpath(ns(".//formula")).reject do |n|
          blank?(n["id"])
        end.each do |t|
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
          notes = t.xpath(ns("./termnote"))
          notes.reject { |n| blank?(n["id"]) }.each do |n|
=begin
            c.increment(n)
            l = "#{@labels['termnote']} #{increment_label(notes, n, c, increment: false)}"
            @anchors[n["id"]] =
              { label: l, type: "termnote",
                value: c.print, elem: @labels["termnote"],
                xref: l10n("#{anchor(t['id'], :xref)}, "\
                           "#{@labels['note_xref']} #{c.print}") }
=end
@anchors[n["id"]] =
            anchor_struct("#{@labels['termnote']} #{increment_label(notes, n, c)}",
                          n,
                          @labels["note_xref"], "termnote", false)
          end
        end
      end
    end
  end
end
