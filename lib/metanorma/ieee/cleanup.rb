module Metanorma
  module IEEE
    class Converter < Standoc::Converter
      BIBLIO =
        "//bibliography/references[@normative = 'false'][not(@hidden)] | "\
        "//bibliography/clause[.//references[@normative = 'false']] | "\
        "//annex/references[@normative = 'false'][not(@hidden)]".freeze

      def boilerplate_cleanup(xmldoc)
        f = xmldoc.at(BIBLIO) and biblio_preface(f)
        super
      end

      def biblio_preface(ref)
        if ref.at("./note[@type = 'boilerplate']")
          unwrap_boilerplate_clauses(ref, ".")
        else
          pref = @i18n.biblio_pref
          ref.at("./title").next = "<p>#{pref}</p>"
        end
      end

      def initial_boilerplate(xml, isodoc)
        intro_boilerplate(xml, isodoc)
        super
      end

      def intro_boilerplate(xml, isodoc)
        return unless intro = xml.at("//introduction/title")

        template = <<~ADM
          This introduction is not part of P{{ docnumeric }}{% if draft %}/D{{ draft }}{% endif %}, {{ doctitle }}
        ADM
        adm = isodoc.populate_template(template)
        intro.next = "<admonition>#{adm}</admonition>"
      end
    end
  end
end
