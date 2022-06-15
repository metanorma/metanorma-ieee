require "isodoc"

module IsoDoc
  module IEEE
    class Counter < ::IsoDoc::XrefGen::Counter
    end

    class Xref < ::IsoDoc::Xref
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
