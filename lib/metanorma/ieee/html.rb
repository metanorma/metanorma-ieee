# frozen_string_literal: true

require "metanorma/iso/html"

module Metanorma
  module Ieee
    # HTML format slice for the flavor: the renderer, registered with
    # the harness from ieee/document.rb. Renders iso-style; the IEEE
    # root uses the IEEE sections plus shared standoc classes.
    module Html
      autoload :Renderer, "#{__dir__}/html/renderer"
    end
  end
end
