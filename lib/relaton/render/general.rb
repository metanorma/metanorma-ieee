require "relaton-render"
require_relative "parse"

module Relaton
  module Render
    module Ieee
      class General < ::Relaton::Render::IsoDoc::General
        def config_loc
          YAML.load_file(File.join(File.dirname(__FILE__), "config.yml"))
        end

        def klass_initialize(_options)
          super
          @parseklass = Relaton::Render::Ieee::Parse
        end
      end
    end
  end
end
