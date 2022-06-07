require "isodoc"
require "twitter_cldr"

module IsoDoc
  module IEEE
    class Metadata < IsoDoc::Metadata
=begin
<p class=MsoHeader><span lang=EN-US>P{{ docnumeric }}{% if draft %}/D{{ draft }},
    {{ draft_month }} {{ draft_year }}{% endif %}</span></p>

  <p class=MsoHeader><span lang=EN-US>{% if draft %}Draft{% endif %} {{ doctype_abbrev }} for{% endif %}
    {{ title }}</span></p>
=end

    end
  end
end
