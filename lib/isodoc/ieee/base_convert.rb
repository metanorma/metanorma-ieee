require "isodoc"
require "fileutils"

module IsoDoc
  module IEEE
    module BaseConvert
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
    end
  end
end
