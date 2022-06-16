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
        # potentially overridden in middle_section_asset_names()
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
          n = section_names(doc.at(ns("//clause[@type = 'scope']")), n, 1)
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
        "//foreword | //introduction | //acknowledgements | "\
          " #{@klass.norm_ref_xpath} | "\
          "//sections/terms | //preface/clause | "\
          "//sections/definitions | //clause[parent::sections]"
      end

      def middle_section_asset_names(doc)
        return super unless @hierarchical_assets

        doc.xpath(ns(middle_sections)).each do |c|
          hierarchical_asset_names(c, @anchors[c["id"]][:label])
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
    end
  end
end
