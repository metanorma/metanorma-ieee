module IsoDoc
  module IEEE
    class I18n < IsoDoc::I18n
      def load_yaml2x(str)
        ::YAML.load_file(File.join(File.dirname(__FILE__),
                                 "i18n-#{str}.yaml"))
      end

      def load_yaml1(lang, script)
        y = case lang
            when "en"
              load_yaml2x(lang)
            else load_yaml2x("en")
            end
        super.deep_merge(y)
      end
    end
  end
end
