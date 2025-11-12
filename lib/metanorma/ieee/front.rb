require "isoics"
require "pubid-ieee"

module Metanorma
  module Ieee
    class Converter < Standoc::Converter
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

      def metadata_committee_types(_node)
        %w(society balloting-group working-group committee)
      end

      def committee_contributors(node, xml, agency, opt)
        metadata_committee_prep(node) or return
        super
      end

      def org_attrs_add_committees(node, ret, opts, opts_orig)
        opts_orig[:groups]&.each_with_index do |g, i|
          i.zero? and next
          opts = committee_contrib_org_prep(node, g, nil, opts_orig)
          ret << org_attrs_parse_core(node, opts).map do |x|
            x.merge(subdivtype: opts[:subdivtype])
          end
        end
        contributors_committees_nest1(ret)
      end

      def contributors_committees_nest1(committees)
        committees.empty? and return committees
        committees = committees.map(&:reverse).reverse.flatten
        committees.each_with_index do |m, i|
          i.zero? and next
          m[:subdiv] = committees[i - 1]
        end
        committees[-1].nil? and return []
        [committees[-1]]
      end

      def committee_contrib_org_prep(node, type, agency, _opts)
        super.merge(role: "authorizer")
      end

      def metadata_other_id(node, xml)
        # a = node.attr("isbn-pdf") and
        add_noko_elem(xml, "docidentifier", node.attr("isbn-pdf"),
                      type: "ISBN", scope: "PDF")
        # xml.docidentifier a, type: "ISBN", scope: "PDF"
        # a = node.attr("isbn-print") and
        #  xml.docidentifier a, type: "ISBN", scope: "print"
        add_noko_elem(xml, "docidentifier", node.attr("isbn-print"),
                      type: "ISBN", scope: "print")
        add_noko_elem(xml, "docnumber", node.attr("docnumber"))
        # xml.docnumber node.attr("docnumber")
      end

      def metadata_id(node, xml)
        if id = node.attr("docidentifier")
          # xml.docidentifier id, **attr_code(type: "IEEE", primary: "true")
          add_noko_elem(xml, "docidentifier", id, type: "IEEE", primary: "true")
        else ieee_id(node, xml)
        end
        # id = node.attr("stdid-pdf") and
        # xml.docidentifier id, type: "IEEE", scope: "PDF"
        add_noko_elem(xml, "docidentifier", node.attr("stdid-pdf"),
                      type: "IEEE", scope: "PDF")
        # id = node.attr("stdid-print") and
        # xml.docidentifier id, type: "IEEE", scope: "print"
        add_noko_elem(xml, "docidentifier", node.attr("stdid-print"),
                      type: "IEEE", scope: "print")
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
                draft: ieee_draft_numbers(node),
                redline: @doctype == "redline",
                publisher: pub[0],
                copublisher: pub[1..-1] }
        ret[:copublisher].empty? and ret.delete(:copublisher)
        compact_blank(ret)
      end

      def ieee_draft_numbers(node)
        draft = node.attr("draft") or return nil
        d = draft.split(".")
        { version: d[0], revision: d[1] }.compact
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
        # id = pubid_select(params).create(**params)
        # xml.docidentifier id.to_s, type: "IEEE", primary: "true"
        add_noko_elem(xml, "docidentifier",
                      pubid_select(params).create(**params).to_s,
                      type: "IEEE", primary: "true")
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
          (node.attr("version") || node.attr("draft") ? "draft" : "approved")
        xml.status do |s|
          add_noko_elem(s, "stage", status)
          # s.stage status
        end
      end

      def datetypes
        super + %w{feedback-ended ieee-sasb-approved}
      end

      def metadata_subdoctype(node, xml)
        # xml.subdoctype (node.attr("docsubtype") || "document")
        add_noko_elem(xml, "subdoctype", node.attr("docsubtype") || "document")
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
        add_noko_elem(xml, "trial_use", node.attr("trial-use"))
        program(node, xml)
      end

      def program(node, xml)
        add_noko_elem(xml, "program", node.attr("program"))
      end

      def structured_id(node, xml)
        node.attr("docnumber") or return
        xml.structuredidentifier do |i|
          add_noko_elem(i, "docnumber", node.attr("docnumber"))
          # i.docnumber node.attr("docnumber")
          add_noko_elem(i, "agency", "IEEE")
          # i.agency "IEEE"
          i.class_ doctype(node)
          add_noko_elem(i, "edition", node.attr("edition"))
          # a = node.attr("edition") and i.edition a
          add_noko_elem(i, "version", metadata_version_value(node))
          # a = metadata_version_value(node) and i.version a
          add_noko_elem(i, "amendment", node.attr("amendment-number"))
          # a = node.attr("amendment-number") and i.amendment a
          add_noko_elem(i, "corrigendum", node.attr("corrigendum-number"))
          # a = node.attr("corrigendum-number") and i.corrigendum a
          add_noko_elem(i, "year", node.attr("copyright-year"))
          # a = node.attr("copyright-year") and i.year a
        end
      end

      def title_other(node, xml)
        t = node.attr("title-full") and
          add_title_xml(xml, t, @lang, "title-full")
        t = node.attr("title-abbrev") and
          add_title_xml(xml, t, @lang, "title-abbrev")
      end
    end
  end
end
