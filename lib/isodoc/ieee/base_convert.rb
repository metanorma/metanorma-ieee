require "isodoc"
require "fileutils"

module IsoDoc
  module IEEE
    module BaseConvert
      def clause_attrs(node)
        { id: node["id"], type: node["type"] }
      end

      def scope(isoxml, out, num)
        f = isoxml.at(ns("//clause[@type = 'overview']")) or return num
        out.div **attr_code(id: f["id"]) do |div|
          num = num + 1
          clause_name(num, f&.at(ns("./title")), div, nil)
          f.elements.each do |e|
            parse(e, div) unless e.name == "title"
          end
        end
        num
      end

      def middle_clause(_docxml = nil)
        "//clause[parent::sections][not(@type = 'overview')]"\
          "[not(descendant::terms)]"
      end

      def para_attrs(node)
        super.merge(type: node["type"])
      end
    end
  end
end
