require "isoics"
require "pubid-ieee"

module Metanorma
  module Ieee
    class Converter < Standoc::Converter
      def metadata_committee(node, xml)
        metadata_committee_prep(node) or return
        xml.editorialgroup do |a|
          committee_component("society", node, a)
          committee_component("balloting-group", node, a)
          committee_component("working-group", node, a)
          committee_component("committee", node, a)
        end
      end

      def metadata_committee_prep(node)
        node.attr("doctype") == "whitepaper" &&
          node.attr("docsubtype") == "industry-connection-report" and
          node.set_attr("working-group",
                        "IEEE SA Industry Connections activity")
        node.attr("committee") || node.attr("society") ||
          node.attr("working-group") or return
        node.attr("balloting-group") && !node.attr("balloting-group-type") and
          node.set_attr("balloting-group-type", "individual")
        true
      end

      def metadata_other_id(node, xml)
        a = node.attr("isbn-pdf") and
          xml.docidentifier a, type: "ISBN", scope: "PDF"
        a = node.attr("isbn-print") and
          xml.docidentifier a, type: "ISBN", scope: "print"
        xml.docnumber node.attr("docnumber")
      end

      def metadata_id(node, xml)
        if id = node.attr("docidentifier")
          xml.docidentifier id, **attr_code(type: "IEEE", primary: "true")
        else ieee_id(node, xml)
        end
        id = node.attr("stdid-pdf") and
          xml.docidentifier id, type: "IEEE", scope: "PDF"
        id = node.attr("stdid-print") and
          xml.docidentifier id, type: "IEEE", scope: "print"
      end

      def ieee_id(node, xml)
        params = ieee_id_params(node)
        params[:number] or return
        ieee_id_out(xml, params)
      end

      def ieee_id_params(node)
        core = ieee_id_params_core(node)
        amd = ieee_id_params_amd(node, core) || {}
        core.merge(amd)
      end

      def compact_blank(hash)
        hash.compact.reject { |_, v| v.is_a?(String) && v.empty? }
      end

      def ieee_id_params_core(node)
        pub = ieee_id_pub(node)
        ret = { number: node.attr("docnumber"),
                part: node.attr("partnumber"),
                year: ieee_id_year(node, initial: true),
                redline: @doctype == "redline",
                publisher: pub[0],
                copublisher: pub[1..-1] }
        ret[:copublisher].empty? and ret.delete(:copublisher)
        compact_blank(ret)
      end

      def ieee_id_params_amd(node, core)
        if a = node.attr("corrigendum-number")
          { corrigendum: { version: a,
                           year: ieee_id_year(node, initial: false) } }
        elsif node.attr("amendment-number")
          { amendment: pubid_select(core).create(**core) }
        end
      end

      def ieee_id_pub(node)
        (node.attr("publisher") || default_publisher).split(/[;,]/)
          .map(&:strip).map { |x| org_abbrev[x] || x }
      end

      def ieee_id_year(node, initial: false)
        unless initial
          y = node.attr("copyright-year") || node.attr("updated-date")
        end
        y ||= node.attr("published-date") || node.attr("copyright-year")
        y&.sub(/-.*$/, "") || Date.today.year
      end

      def ieee_id_out(xml, params)
        id = pubid_select(params).create(**params)
        xml.docidentifier id.to_s, type: "IEEE", primary: "true"
      end

      def pubid_select(_params)
        base_pubid
      end

      def base_pubid
        Pubid::Ieee::Identifier
      end

      def default_publisher
        "IEEE"
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
      end

      def org_abbrev
        { "Institute of Electrical and Electronic Engineers" => "IEEE",
          "International Organization for Standardization" => "ISO",
          "International Electrotechnical Commission" => "IEC" }
      end

      def relaton_relations
        super + %w(merges updates)
      end

      def metadata_ext(node, xml)
        super
        s = node.attr("trial-use") and xml.trial_use s
        program(node, xml)
      end

      def program(node, xml)
        p = node.attr("program") and xml.program p
      end

      def structured_id(node, xml)
        node.attr("docnumber") or return
        xml.structuredidentifier do |i|
          i.docnumber node.attr("docnumber")
          i.agency "IEEE"
          i.class_ doctype(node)
          a = node.attr("edition") and i.edition a
          a = metadata_version_value(node) and i.version a
          a = node.attr("amendment-number") and i.amendment a
          a = node.attr("corrigendum-number") and i.corrigendum a
          a = node.attr("copyright-year") and i.year a
        end
      end
    end
  end
end
