require "isoics"
require "pubid"

# The pubid monogem: all flavors load through the registry — no
# per-flavor gems (pubid-ieee is the legacy 1.x line).
Pubid.eager_load_flavors!

# relaton-iso 3.x still calls `base_identifier` and `part.value` from the
# pubid 1.x API. pubid 2.x renamed `base_identifier` -> `base` and `part`
# returns a bare String. Provide compatibility shims.
module Pubid
  class Identifier
    alias_method :base_identifier, :base unless method_defined?(:base_identifier)
  end
end

class String
  alias_method :value, :itself unless method_defined?(:value)
end

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
        metadata_id_nonprimary(node, xml)
        add_noko_elem(xml, "docidentifier", node.attr("isbn-pdf"),
                      type: "ISBN", scope: "PDF")
        add_noko_elem(xml, "docidentifier", node.attr("isbn-print"),
                      type: "ISBN", scope: "print")
        add_noko_elem(xml, "docnumber", node.attr("docnumber"))
      end

      def metadata_id_nonprimary(node, xml)
        add_noko_elem(xml, "docidentifier", node.attr("stdid-pdf"),
                      type: "IEEE", scope: "PDF")
        add_noko_elem(xml, "docidentifier", node.attr("stdid-print"),
                      type: "IEEE", scope: "print")
      end

      def metadata_id_primary(node, xml)
        params = ieee_id_params(node)
        params[:number] or return
        ieee_id_out(xml, params)
      end

      def metadata_id_primary_type(_node)
        "IEEE"
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
          { amendment: { version: node.attr("amendment-number"),
                         year: ieee_id_year(node, initial: false) } }
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
        add_noko_elem(xml, "docidentifier",
                      pubid_create(params).to_s,
                      type: "IEEE", primary: "true")
      end

      # ── pubid 2.x construction layer ────────────────────────────────
      #
      # pubid 2 replaced pubid-ieee 1.x's `Identifier.create(**params)`
      # with flavor-based identifier classes built from typed components
      # (Pubid::Ieee::Identifiers::*). The helpers below translate the
      # legacy params hash into those constructions.

      def pubid_create(params)
        base = pubid_standard(params)
        if params[:corrigendum]
          Pubid::Ieee::Identifiers::Corrigendum.new(
            base: base,
            number: params[:corrigendum][:version].to_s,
            year: params[:corrigendum][:year].to_s,
          )
        elsif params[:amendment]
          Pubid::Ieee::Identifiers::Amendment.new(
            base: base,
            number: params[:amendment][:version].to_s,
            year: params[:amendment][:year].to_s,
          )
        else
          base
        end
      end

      def pubid_standard(params)
        attrs = pubid_standard_attrs(params)
        pubid_select(params).new(**attrs)
      end

      def pubid_standard_attrs(params)
        attrs = {}
        attrs[:number] = params[:number].to_s if params[:number]
        if params[:part]
          attrs[:parts] = [params[:part].to_s]
          attrs[:separator] = "-"
        end
        attrs[:year] = params[:year].to_s if params[:year]
        attrs[:publisher] = params[:publisher] if params[:publisher]
        if params[:copublisher] && !Array(params[:copublisher]).empty?
          attrs[:copublisher] = Array(params[:copublisher])
        end
        attrs[:redline] = true if params[:redline]
        if params[:draft]
          attrs[:draft] = pubid_draft_string(params[:draft])
          attrs[:type] = "Draft Std"
        end
        attrs
      end

      def pubid_draft_string(draft)
        return draft.to_s if draft.is_a?(String)
        s = "D#{draft[:version]}"
        s += ".#{draft[:revision]}" if draft[:revision]
        s
      end

      def pubid_select(_params)
        base_pubid
      end

      def base_pubid
        Pubid::Ieee::Identifiers::Standard
      end

      def default_publisher
        "IEEE"
      end

      def metadata_status(node, xml)
        xml.status do |s|
          add_noko_elem(s, "stage", ieee_stage(node),
                        abbreviation: node.attr("docstage-abbrev"))
        end
      end

      def ieee_stage(node)
        node.attr("status") || node.attr("docstage") ||
          (node.attr("version") || node.attr("draft") ? "draft" : "approved")
      end

      # Relaton schema: <version><revision-date>...</revision-date><draft>...</draft></version>
      def metadata_version(node, xml)
        metadata_edition(node, xml)
        draft = metadata_version_value(node)
        revdate = node.attr("revdate")
        (draft || revdate) or return
        xml.version do |v|
          revdate and add_noko_elem(v, "revision-date", revdate)
          draft and add_noko_elem(v, "draft", draft)
        end
      end

      def metadata_version_value(node)
        draft = node.attr("version") and return draft
        draft = node.attr("draft") or return nil
        draft.empty? and return nil
        draft
      end

      def datetypes
        super + %w{feedback-ended ieee-sasb-approved}
      end

      def metadata_subdoctype(node, xml)
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
        # Shadow of /bibdata/status/stage: the ext copy is validated
        # against the IEEE stage vocabulary, status/stage staying
        # schema-generic (metanorma-model-iso#156); slotted before
        # trialuse per the ext grammar sequence
        add_noko_elem(xml, "stage", ieee_stage(node))
        add_noko_elem(xml, "trial_use", node.attr("trial-use"))
        program(node, xml)
      end

      def program(node, xml)
        add_noko_elem(xml, "program", node.attr("program"))
      end

      def structured_id(node, xml)
        node.attr("docnumber") or return
        xml.structuredidentifier do |i|
          add_noko_elem(i, "agency", "IEEE")
          i.class_ doctype(node)
          add_noko_elem(i, "docnumber", node.attr("docnumber"))
          add_noko_elem(i, "edition", node.attr("edition"))
          draft = metadata_version_value(node)
          revdate = node.attr("revdate")
          (draft || revdate) and
            i.version do |v|
              revdate and add_noko_elem(v, "revision-date", revdate)
              draft and add_noko_elem(v, "draft", draft)
            end
          add_noko_elem(i, "amendment", node.attr("amendment-number"))
          add_noko_elem(i, "corrigendum", node.attr("corrigendum-number"))
          add_noko_elem(i, "year", node.attr("copyright-year"))
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
