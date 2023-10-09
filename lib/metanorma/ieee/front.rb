require "isoics"

module Metanorma
  module IEEE
    class Converter < Standoc::Converter
      def metadata_committee(node, xml)
        node.attr("committee") || node.attr("society") ||
          node.attr("working-group") or return
        node.attr("balloting-group") && !node.attr("balloting-group-type") and
          node.set_attr("balloting-group-type", "individual")
        xml.editorialgroup do |a|
          committee_component("society", node, a)
          committee_component("balloting-group", node, a)
          committee_component("working-group", node, a)
          committee_component("committee", node, a)
        end
      end

      def metadata_other_id(node, xml)
        a = node.attr("isbn-pdf") and
          xml.docidentifier a, type: "ISBN", scope: "PDF"
        a = node.attr("isbn-print") and
          xml.docidentifier a, type: "ISBN", scope: "print"
      end

      def metadata_id(node, xml)
        id = node.attr("docnumber") || ""
        xml.docidentifier (node.attr("docidentifier") || id), type: "IEEE"
        id = node.attr("stdid-pdf") and
          xml.docidentifier id, type: "IEEE", scope: "PDF"
        id = node.attr("stdid-print") and
          xml.docidentifier id, type: "IEEE", scope: "print"
        xml.docnumber node.attr("docnumber")
      end

      def metadata_publisher(node, xml)
        publishers = node.attr("publisher") || "IEEE"
        csv_split(publishers).each do |p|
          xml.contributor do |c|
            c.role type: "publisher"
            c.organization do |a|
              organization(a, p, true, node, !node.attr("publisher"))
            end
          end
        end
      end

      def metadata_copyright(node, xml)
        publishers = node.attr("copyright-holder") || node.attr("publisher") ||
          "IEEE"
        csv_split(publishers).each do |p|
          metadata_copyright1(node, p, xml)
        end
      end

      def metadata_copyright1(node, pub, xml)
        xml.copyright do |c|
          c.from (node.attr("copyright-year") || Date.today.year)
          c.owner do |owner|
            owner.organization do |o|
              organization(o, pub, true, node,
                           !(node.attr("copyright-holder") || node.attr("publisher")))
            end
          end
        end
      end

      def metadata_status(node, xml)
        status = node.attr("status") || node.attr("docstage") ||
          (node.attr("draft") ? "draft" : "approved")
        xml.status do |s|
          s.stage status
        end
      end

      def datetypes
        super + %w{feedback-ended}
      end

      def metadata_subdoctype(node, xml)
        xml.subdoctype (node.attr("docsubtype") || "document")
        s = node.attr("trial-use") and xml.trial_use s
      end

      def org_abbrev
        { "Institute of Electrical and Electronic Engineers" => "IEEE" }
      end

      def relaton_relations
        super + %w(merges updates)
      end

      def metadata_ext(node, xml)
        super
        structured_id(node, xml)
      end

      def structured_id(node, xml)
        return unless node.attr("docnumber")

        xml.structuredidentifier do |i|
          i.docnumber node.attr("docnumber")
          i.agency "IEEE"
          i.class_ doctype(node)
          a = node.attr("edition") and i.edition a
          a = node.attr("draft") and i.version a
          a = node.attr("amendment-number") and i.amendment a
          a = node.attr("corrigendum-number") and i.corrigendum a
          a = node.attr("copyright-year") and i.year a
        end
      end
    end
  end
end
