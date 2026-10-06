module Relaton
  module Render
    module Ieee
      class Parse < ::Relaton::Render::Parse
        def simple_or_host_xml2hash(doc, host)
          ret = super
          ret.merge(home_standard: home_standard(doc, ret[:publisher_raw]))
        end

        def home_standard(_doc, pubs)
          pubs&.any? do |r|
            ["International Organization for Standardization", "ISO",
             "International Electrotechnical Commission", "IEC",
             "Institute of Electrical and Electronics Engineers",
             "IEEE"].include?(r[:nonpersonal])
          end
        end

        # Fall back to person contributors when none carry a recognised role;
        # bibliographic entries with a person but no explicit role still
        # need to sort by that person's name.
        def creatornames1(doc)
          cr = super
          return cr unless cr.empty? && doc
          persons = Array(doc.contributor).select(&:person)
          persons.empty? ? Array(doc.contributor) : persons
        end
      end
    end
  end
end
