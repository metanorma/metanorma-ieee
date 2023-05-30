require "isoics"
require "date"
require "pubid-ieee"

module Metanorma
  module IEEE
    class Converter < Standoc::Converter
      def metadata_committee(node, xml)
        return unless node.attr("committee") || node.attr("society")

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
        if id = node.attr("docidentifier")
          xml.docidentifier id, **attr_code(type: "IEEE")
        else iso_id(node, xml)
        end
        id = node.attr("stdid-pdf") and
          xml.docidentifier id, type: "IEEE", scope: "PDF"
        id = node.attr("stdid-print") and
          xml.docidentifier id, type: "IEEE", scope: "print"
        xml.docnumber node.attr("docnumber")
      end

      def iso_id(node, xml)
        node.attr("docnumber") || node.attr("updates") ||
          node.attr("supplements") || node.attr("includes") or
          return
        params = iso_id_params(node)
        iso_id_out(xml, params)
      end

      def iso_id_params(node)
        relns = %w(updates supplements merges).each_with_object([]) do |x, r|
          if node.attr(x)
            relation = relation_to_pubid(x, node)
            id = iso_id_params_parse_ids(node, x)
            x == "supplements" and id = id.first
            r << { relation: relation, id: id }
          end
        end
        iso_id_params_resolve(iso_id_params_core(node), iso_id_params_add(node),
                              node, relns)
      end

      def iso_id_params_parse_ids(node, relation)
        node.attr(relation).split(/;\s*/).map do |n|
          orig_id = Pubid::Ieee::Identifier.parse(n)
          orig_id.edition ||= 1
          orig_id
        end
      end

      def relation_to_pubid(relation, node)
        case relation
        when "merges" then "incorporates"
        when "supplements" then "supplement"
        when "updates"
          if node.attr("amendment-number") then "amendment"
          elsif node.attr("corrigendum-number") then "corrigendum_comment"
          else "revision"
          end
        else "revision"
        end
      end

      # unpublished is for internal use
      def iso_id_params_core(node)
        pub, copub = iso_id_params_pub(node)
        { number: node.attr("docnumber"),
          part: "-#{node.attr('partnumber')}",
          subpart: "-#{node.attr('subpartnumber')}",
          type: get_typeabbr(node),
          redline: node.attr("doctype") == "redline",
          conformance: node.attr("conformance"),
          publisher: pub,
          draft: iso_id_params_draft(node),
          copublisher: copub }.compact
      end

      def iso_id_params_pub(node)
        pub = (node.attr("publisher") || "IEEE").split(/[;,]/)
        publisher = pub[0]
        copublisher = pub[1..-1]
        copublisher.empty? and copublisher = nil
        [publisher, copublisher]
      end

      def iso_id_params_draft(node)
        if node.attr("docstage") == "draft"
          { version: node.attr("draft")&.to_i,
            revision: node.attr("revision")&.to_i }
            .merge(date_parse(node.attr("issued-date")))
        end
      end

      def date_parse(date)
        date or return {}
        d = date.split("-")
        ret = {}
        d[0] and ret[:year] = d[0]
        d[2] and ret[:day] = d[2]
        d[1] and ret[:month] = Date::MONTHNAMES[d[1].to_i]
        ret
      end

      # Draft? Supplement?
      def get_typeabbr(_node)
        :std
      end

      def iso_id_params_add(node)
        { number: node.attr("amendment-number") ||
          node.attr("corrigendum-number"),
          year: iso_id_year(node),
          edition: { version: node.attr("edition") } }.compact
      end

      def iso_id_year(node)
        node.attr("copyright-year") || node.attr("updated-date")
          &.sub(/-.*$/, "") || Date.today.year
      end

      def iso_id_params_resolve(params, params2, _node, relations)
        unless relations.empty?
          params.delete(:unpublished)
          params.delete(:part)
          params.delete(:subpart)
        end
        relations.each do |r|
          params2[r[:relation].to_sym] = r[:id]
        end
        params.merge!(params2)
        params
      end

      def iso_id_out(xml, params)
        xml.docidentifier iso_id_default(params).to_s,
                          **attr_code(type: "IEEE")
        xml.docidentifier iso_id_default(params).to_s(with_trademark: true),
                          **attr_code(type: "IEEE-tm")
      rescue StandardError => e
        clean_abort("Document identifier: #{e}", xml)
      end

      def iso_id_default(params)
        params_nolang = params.dup.tap { |hs| hs.delete(:language) }
        params1 = if params[:unpublished]
                    params_nolang.dup.tap do |hs|
                      hs.delete(:year)
                    end
                  else params_nolang
                  end
        params1.delete(:unpublished)
        Pubid::Ieee::Identifier.create(**params1)
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
        super + %w(merges updates supplements)
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
