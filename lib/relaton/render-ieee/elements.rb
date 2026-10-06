require "date"

module Relaton
  module Render
    module Ieee
      # IEEE's rendering of the ISO 690 clause 7 elements, through the
      # renderer's element map: accessed dates unbracketed ("accessed
      # September 3, 2019"), host data before the host title, extents
      # falling back to the host's, DOI identifiers prefixed, and
      # untyped items carrying the Preprint designation.
      module Elements
        class Access < ::Relaton::Render::Iso690::Elements::Access
          def render
            "accessed #{date_text}"
          end

          private

          def date_text
            d = Array(@model.date).find { |x| x.type == "accessed" } or
              return ""
            value = (d.at || d.from || d.to).to_s
            parts = value.split("-")
            case parts.size
            when 3
              date = ::Date.parse(value)
              "#{month(date.month)} #{date.day}, #{date.year}"
            when 2
              "#{month(parts[1].to_i)} #{parts[0]}"
            else
              value
            end
          end

          def month(num)
            @i18n.label("month_#{num}")
          end
        end

        class ComponentPart < ::Relaton::Render::Iso690::Elements::ComponentPart
          # IEEE: host editors precede the host title
          # ("in Pellegrini, A. D., and P. K. Smith (eds.): _The nature
          # of play_"); the host's edition is not cited
          def render
            "#{lead}#{host_editors}#{host_title}#{host_production}"
          end

          private

          def lead
            "#{@i18n.label('in')} "
          end

          def host_editors
            eds = Array(host&.contributor)
              .select { |c| has_role?(c, "editor") }
            names = eds.each_with_index
              .map { |c, i| host_person_name(c, first: i.zero?) }
              .reject(&:empty?)
            return "" if names.empty?

            "#{join_names(names)} " \
              "#{@i18n.label(eds.one? ? 'ed' : 'eds')}: "
          end

          def host_production
            return "" if host.nil?

            production = ::Relaton::Render::Iso690::Elements::Production
              .new(host, style: @style, i18n: @i18n)
            production.present? ? ", #{production.render}" : ""
          end
        end

        class Extent < ::Relaton::Render::Iso690::Elements::Extent
          private

          # A serial part carries its extent on the host it is included
          # in, not on itself
          def localities
            own = super
            return own unless own.empty?

            host = Array(@model.relation)
              .filter_map do |r|
                %w[partOf includedIn].include?(r.type) ? r.bibitem : nil
              end.first
            return [] unless host

            Array(host.extent).flat_map do |e|
              Array(e.locality) +
                Array(e.locality_stack).flat_map { |s| Array(s.locality) }
            end
          end
        end

        class Identifier < ::Relaton::Render::Iso690::Elements::Identifier
          # IEEE cites the DOI by name, without re-prefixing a content
          # value that already carries the resolver address
          def render_id(docidentifier)
            return "DOI: #{doi_content(docidentifier)}" if
              docidentifier.type == "DOI"

            super
          end

          private

          def doi_content(docidentifier)
            content = docidentifier.content.to_s
            content.sub(/\Ahttps:\/\/doi\.org\//) { "https://doi.org/" }
          end
        end

        class Medium < ::Relaton::Render::Iso690::Elements::Medium
          private

          def medium
            rendered = super
            return rendered unless rendered.empty?

            @model.type.to_s.empty? ? "Preprint" : ""
          end
        end

        # IEEE separates reference segments with commas; the engine's
        # absent-slot separator collapse would orphan one, so volatile
        # adjacent segments travel as joined groups (see SEGMENT_GROUPS)
        class SegmentGroup < ::Relaton::Render::Iso690::Element
          def present?
            segments.any? { |name| sub(name).present? }
          end

          def render
            segments.filter_map do |name|
              el = sub(name)
              el.render if el.present?
            end.join(", ")
          end

          private

          def sub(name)
            ::Relaton::Render::Iso690::Elements.build(name, @model,
                                                      style: @style,
                                                      i18n: @i18n,
                                                      elements: ELEMENTS)
          end
        end

        SEGMENT_GROUPS = {
          mediumdate: %i[medium date],
          edprod: %i[edition production],
          extentdate: %i[extent date],
          dateextent: %i[date extent],
          proddate: %i[production date],
          accloc: %i[access location],
        }.freeze

        def self.segment_group(names)
          Class.new(SegmentGroup) do
            define_method(:segments) { names }
          end
        end

        ELEMENTS = {
          access: Access,
          component_part: ComponentPart,
          extent: Extent,
          identifier: Identifier,
          medium: Medium,
        }.merge(SEGMENT_GROUPS.to_h { |k, v| [k, segment_group(v)] }).freeze
      end
    end
  end
end
