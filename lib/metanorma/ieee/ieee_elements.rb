# frozen_string_literal: true

module Metanorma
  module Ieee
    # IEEE-specific data elements extending the engine's ISO 690
    # vocabulary, passed to the renderer as its element map
    module IeeeElements
      HOME_PUBLISHERS =
        ["International Organization for Standardization", "ISO",
         "International Electrotechnical Commission", "IEC",
         "Institute of Electrical and Electronics Engineers",
         "IEEE"].freeze

      class << self
        # 1.x home_standard: the SDO standards by publisher NAME
        def home_publisher?(model)
          Array(model.contributor).any? do |c|
            next false unless Array(c.role).any? do |r|
              r.is_a?(String) ? r == "publisher" : r.type == "publisher"
            end

            Array(c.organization&.name)
              .any? { |n| HOME_PUBLISHERS.include?(n.content) }
          end
        end
      end

      # 1.x home_standard: ISO/IEC/IEEE by publisher NAME
      class IeeeRenderer < ::Relaton::Render::Iso690::Renderer
        def home_docid?(model)
          IeeeElements.home_publisher?(model)
        end
      end

      # The IEEE DOI and ISBN kinds carry their kind label with a
      # colon ("DOI: https://doi.org/…")
      class IeeeIdentifier < ::Relaton::Render::Iso690::Elements::Identifier
        private

        def render_id(docidentifier)
          return "#{docidentifier.type}: #{docidentifier.content}" if
            %w[DOI ISBN].include?(docidentifier.type)

          super
        end
      end
    end
  end
end

module Metanorma
  module Ieee
    module IeeeElements
      # The IEEE component part: "in Pellegrini, A. D., and P. K.
      # Smith (eds.): <em>host</em>" — lowercase "in", the host
      # editors in the serial join, the role marker before the colon
      class IeeeComponentPart < ::Relaton::Render::Iso690::Elements::ComponentPart
        def render
          h = host or return ""
          out = +"in #{host_names(h)} (#{eds_label(h)}): "
          out += host_title.to_s
          production = ::Relaton::Render::Iso690::Elements::Production
            .new(h, style: @style, i18n: @i18n).render.to_s
          out += ", #{production}" unless production.empty?
          out
        end

        private

        def host_editors(h)
          Array(h.contributor).select { |c| has_role?(c, "editor") }
        end

        def eds_label(h)
          @i18n.label(host_editors(h).one? ? "ed" : "eds")
        end

        # The IEEE host form: the first editor inverted, subsequent
        # editors direct
        def host_names(h)
          names = host_editors(h).each_with_index.map { |c, i|
            person = c.person or next ""

            if i.zero?
              [person_surname(person), person_given(person)]
                .reject(&:empty?).join(", ")
            else
              [person_given(person), person_surname(person)]
                .reject(&:empty?).join(" ")
            end
          }.reject(&:empty?)
          join_names(names)
        end
      end
    end
  end
end

module Metanorma
  module Ieee
    module IeeeElements
      # The IEEE access date, bare ("accessed September 3, 2019"),
      # unbracketed
      class IeeeAccess < ::Relaton::Render::Iso690::Elements::Access
        def render
          "#{@i18n.label('viewed')} #{date_text}"
        end
      end
    end
  end
end

module Metanorma
  module Ieee
    module IeeeElements
      # The IEEE medium, capitalized and carrying its own trailing
      # comma ("Dataset,", "Preprint,")
      class IeeeMedium < ::Relaton::Render::Iso690::Elements::Medium
        private

        def medium
          m = @model.medium or return ""
          text = m.carrier.to_s
          text = m.genre.to_s if text.empty?
          text = [m.form.to_s, m.size.to_s].reject(&:empty?)
            .join(", ") if text.empty?
          text.empty? ? "" : "#{text.sub(/^\w/) { |c| c.upcase }},"
        end
      end
    end
  end
end
