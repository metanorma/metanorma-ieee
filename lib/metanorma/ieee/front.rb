module Metanorma
  module IEEE
    class Converter < Standoc::Converter
      def metadata_committee(node, xml)
        return unless node.attr("committee") || node.attr("society")

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
        xml.docidentifier id, type: "IEEE"
        id = node.attr("stdid-pdf") and
          xml.docidentifier id, type: "IEEE", scope: "PDF"
        id = node.attr("stdid-print") and
          xml.docidentifier id, type: "IEEE", scope: "print"
        xml.docnumber node.attr("docnumber")
      end

      def metadata_author(node, xml)
        super
        wg_members(node, xml)
        bg_members(node, xml)
        std_board_members(node, xml)
      end

      def metadata_editor(name, role, xml)
        xml.contributor do |c|
          c.role role, **{ type: "editor" }
          c.person do |p|
            p.name do |n|
              n.completename name
            end
          end
        end
      end

      def metadata_multi_editors(names, role, xml)
        csv_split(names).each do |n|
          metadata_editor(n, role, xml)
        end
      end

      def wg_members(node, xml)
        a = node.attr("wg_chair") and
          metadata_editor(a, "Working Group Chair", xml)
        a = node.attr("wg_vicechair") and
          metadata_editor(a, "Working Group Vice-Chair", xml)
        a = node.attr("wg_members") and
          metadata_multi_editors(a, "Working Group Member", xml)
      end

      def bg_members(node, xml)
        a = node.attr("balloting_group_members") and
          metadata_multi_editors(a, "Balloting Group Member", xml)
      end

      def std_board_members(node, xml)
        a = node.attr("std_board_chair") and
          metadata_editor(a, "Standards Board Chair", xml)
        a = node.attr("std_board_vicechair") and
          metadata_editor(a, "Standards Board Vice-Chair", xml)
        a = node.attr("std_board_pastchair") and
          metadata_editor(a, "Standards Board Past Chair", xml)
        a = node.attr("std_board_secretary") and
          metadata_editor(a, "Standards Board Secretary", xml)
        a = node.attr("balloting_group_members") and
          metadata_multi_editors(a, "Standards Board Member", xml)
      end

      def metadata_publisher(node, xml)
        publishers = node.attr("publisher") || "IEEE"
        csv_split(publishers).each do |p|
          xml.contributor do |c|
            c.role **{ type: "publisher" }
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
          xml.copyright do |c|
            c.from (node.attr("copyright-year") || Date.today.year)
            c.owner do |owner|
              owner.organization do |o|
                organization(
                  o, p, true, node,
                  !(node.attr("copyright-holder") || node.attr("publisher"))
                )
              end
            end
          end
        end
      end

      def org_abbrev
        { "Institute of Electrical and Electronic Engineers" => "IEEE" }
      end
    end
  end
end
