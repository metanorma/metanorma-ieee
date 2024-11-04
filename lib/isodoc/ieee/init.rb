require "isodoc"
require_relative "metadata"
require_relative "xref"
require_relative "i18n"

module IsoDoc
  module Ieee
    module Init
      def metadata_init(lang, script, locale, i18n)
        @meta = Metadata.new(lang, script, locale, i18n)
      end

      def xref_init(lang, script, _klass, i18n, options)
        html = PresentationXMLConvert.new(language: lang, script: script)
        options = options.merge(hierarchicalassets: @hierarchical_assets)
        @xrefs = Xref.new(lang, script, html, i18n, options)
      end

      def i18n_init(lang, script, locale, i18nyaml = nil)
        @i18n = I18n.new(lang, script, locale: locale,
                                       i18nyaml: i18nyaml || @i18nyaml)
      end

      def bibrenderer
        ::Relaton::Render::Ieee::General.new(language: @lang,
                                             i18nhash: @i18n.get)
      end

      def fileloc(loc)
        File.join(File.dirname(__FILE__), loc)
      end

      def std_docid_semantic(id)
        id.nil? and return nil
        ret = Nokogiri::XML.fragment(id)
        ret.traverse do |x|
          x.text? or next
          x.replace(std_docid_semantic1(x.text))
        end
        to_xml(ret)
      end

      def std_docid_semantic1(id)
        ids = id.split(/\p{Zs}/)
        agency?(ids[0].sub(%r{^([^/]+)/.*$}, "\\1")) or return id
        std_docid_semantic_full(id)
      end

      # AGENCY+ TYPE NUMBER YEAR
      def std_docid_semantic_full(ident)
        m = ident.match(%r{(?<text>[^0-9]+\p{Zs})
                        (?<num>[0-9]+[^:]*)
                        (?:[:](?<yr>(?:19|20)\d\d))?}x)
        m or return ident
        ret = std_docid_sdo(m[:text]) +
          "<span class='std_docNumber'>#{m[:num]}</span>"
        m[:yr] and ret += ":<span class='std_year'>#{m[:yr]}</span>"
        ret.gsub(%r{</span>(\p{Zs}+)<}, "\\1</span><")
      end

      def std_docid_sdo(text)
        found = false
        text.split(%r{([\p{Zs}|/]+)}).reverse.map do |x|
          if /[A-Za-z]/.match?(x)
            k = if found || agency?(x) then "std_publisher"
                else "std_documentType"
                end
            found = true
            "<span class='#{k}'>#{x}</span>"
          else x end
        end.reverse.join.gsub(%r{</span>(\p{Zs}+)<}, "\\1</span><")
      end
    end
  end
end
