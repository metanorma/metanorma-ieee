require "isodoc"

module IsoDoc
  module Ieee
    class Counter < ::IsoDoc::XrefGen::Counter
    end

    class Xref < ::IsoDoc::Xref
      def initialize(lang, script, klass, labels, options)
        super
        @hierarchical_assets = options[:hierarchicalassets]
      end

      def initial_anchor_names(doc)
        @doctype = doc&.at(ns("//bibdata/ext/doctype"))&.text
        super
      end

      def clause_order_main(docxml)
        ret = [
          { path: "//sections/abstract" }, # whitepaper
          { path: "//clause[@type = 'overview']" },
          { path: @klass.norm_ref_xpath },
          { path: "//sections/terms | " \
                  "//sections/clause[descendant::terms]" },
          { path: "//sections/definitions | " \
                  "//sections/clause[descendant::definitions][not(descendant::terms)]" },
          { path: @klass.middle_clause(docxml), multi: true },
        ]
        docxml.at(ns("//bibdata/ext/doctype"))&.text == "whitepaper" and
          ret << { path: @klass.bibliography_xpath }
        ret
      end

      def clause_order_back(docxml)
        ret = super
        docxml.at(ns("//bibdata/ext/doctype"))&.text == "whitepaper" and
          ret.shift
        ret
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
          sequential_asset_names(doc.xpath(ns("//preface/* | #{middle_sections}")))
          # sequential_asset_names(doc.xpath(ns(middle_sections)))
        end
      end

      def sequential_formula_names(clause, container: false)
        c = Counter.new
        clause.xpath(ns(".//formula")).noblank.each do |t|
          @anchors[t["id"]] = anchor_struct(
            c.increment(t).print, t,
            t["inequality"] ? @labels["inequality"] : @labels["formula"],
            "formula", { container: container, unnumb: t["unnumbered"] }
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
              { label: termnote_label(n, increment_label(notes, n, c)),
                value: c.print, elem: @labels["termnote"],
                container: t["id"], type: "termnote",
                xref: anchor_struct_xref(c.print, n, @labels["note_xref"]) }
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
                          @labels["note_xref"], "note", { container: true })
              .merge(sequence: sequence)
        end
      end

      def annex_name_lbl(clause, num)
        if @doctype == "whitepaper"
          title = Common::case_with_markup(@labels["annex"], "capital",
                                           @script)
          l10n(labelled_autonum(title, num))
        else super
        end
      end
    end
  end
end
