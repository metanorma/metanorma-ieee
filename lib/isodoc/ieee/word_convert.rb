require "isodoc"
require_relative "init"
require_relative "word_cleanup"
require_relative "word_cleanup_blocks"
require_relative "word_authority"
require_relative "word_wp_convert"

module IsoDoc
  module IEEE
    class WordConvert < IsoDoc::WordConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
        init_wp(options)
      end

      def init_wp(options)
        @wp = ::IsoDoc::IEEE::WordWPConvert.new(options)
      end

      def convert1(docxml, filename, dir)
        doctype = docxml.at(ns("//bibdata/ext/doctype"))
        if %w(amendment corrigendum).include?(doctype&.text)
          @header = html_doc_path("header_amd.html")
        end
        super
      end

      def convert(input_filename, file = nil, debug = false,
          output_filename = nil)
        file ||= File.read(input_filename, encoding: "utf-8")
        docxml = Nokogiri::XML(file) { |config| config.huge }
        doctype = docxml&.at(ns("//bibdata/ext/doctype"))&.text
        if @wp && doctype == "whitepaper"
          @wp.convert(input_filename, file, debug, output_filename)
        else
          super
        end
      end

      def default_fonts(options)
        { bodyfont: (if options[:script] == "Hans"
                       '"Source Han Sans",serif'
                     else
                       '"Times New Roman",serif'
                     end),
          headerfont: (if options[:script] == "Hans"
                         '"Source Han Sans",sans-serif'
                       else
                         '"Arial",sans-serif'
                       end),
          monospacefont: '"Courier New",monospace',
          normalfontsize: "12.0pt",
          footnotefontsize: "11.0pt",
          smallerfontsize: "10.0pt",
          monospacefontsize: "10.0pt" }
      end

      def default_file_locations(_options)
        { wordstylesheet: html_doc_path("wordstyle.scss"),
          standardstylesheet: html_doc_path("ieee.scss"),
          header: html_doc_path("header.html"),
          wordcoverpage: html_doc_path("word_ieee_titlepage.html"),
          wordintropage: html_doc_path("word_ieee_intro.html"),
          ulstyle: "l11", olstyle: "l16" }
      end

      def abstract(clause, out)
        page_break(out)
        out.div **attr_code(id: clause["id"], class: "abstract") do |s|
          clause_name(clause, clause.at(ns("./title")), s,
                      { class: stylesmap[:AbstractTitle] })
          clause.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      MAIN_ELEMENTS =
        "//sections/*[@displayorder][not(@class = 'zzSTDTitle1')] | " \
        "//annex[@displayorder] | " \
        "//bibliography/*[@displayorder] | //colophon/*[@displayorder] | " \
        "//indexsect[@displayorder]".freeze

      def make_body3(body, docxml)
        body.div class: "WordSectionMiddleTitle" do |div3|
          middle_title_ieee(docxml, div3)
        end
        section_break(body, continuous: true)
        body.div class: "WordSectionMain" do |div3|
          content(div3, docxml, ns(self.class::MAIN_ELEMENTS))
          footnotes div3
          comments div3
        end
      end

      def middle_title_ieee(docxml, out)
        title = docxml.at(ns("//p[@class = 'zzSTDTitle1']")) or return
        out.p(class: stylesmap[:zzSTDTitle1], style: "margin-top:70.0pt") do |p|
          title.children.each { |n| parse(n, p) }
        end
      end

      def admonition_name_parse(_node, div, name)
        div.p class: stylesmap[:admonition], style: "text-align:center;" do |p|
          p.b do |b|
            name.children.each { |n| parse(n, b) }
          end
        end
      end

      def admonition_class(node)
        if node["type"] == "editorial" then "zzHelp"
        elsif node.ancestors("introduction").empty?
          stylesmap[:admonition]
        else stylesmap[:intro]
        end
      end

      def formula_parse(node, out)
        out.div **formula_attrs(node) do |div|
          formula_parse1(node, div)
          formula_where(node.at(ns("./dl")), div)
          node.children.each do |n|
            next if %w(stem dl name).include? n.name

            parse(n, div)
          end
        end
      end

      def dt_dd?(node)
        %w{dt dd}.include? node.name
      end

      def formula_where(dlist, out)
        return unless dlist

        dlist.elements.select { |n| dt_dd? n }.each_slice(2) do |dt, dd|
          formula_where1(out, dt, dd)
        end
      end

      # STYLE
      def formula_where1(out, dterm, ddefn)
        out.p class: "IEEEStdsEquationVariableList" do |p|
          dterm.children.each { |n| parse(n, p) }
          insert_tab(p, 1)
          if ddefn.at(ns("./p"))
            ddefn.elements.each do |e|
              e.children.each { |n| parse(n, p) }
            end
          else ddefn.children.each { |n| parse(n, p) }
          end
        end
      end

      def annex_attrs(node)
        { id: node["id"], class: "Annex" }
      end

      def annex_name(_annex, name, div)
        return if name.nil?

        name&.at(ns("./strong"))&.remove # supplied by CSS list numbering
        div.h1 class: "Annex" do |t|
          annex_name1(name, t)
          clause_parse_subtitle(name, t)
        end
      end

      def annex_name1(name, out)
        name.children.each do |c2|
          if c2.name == "span" && c2["class"] == "obligation"
            out.span style: "font-weight:normal;" do |s|
              c2.children.each { |c3| parse(c3, s) }
            end
          else parse(c2, out)
          end
        end
      end

      def termnote_parse(node, out)
        name = node&.at(ns("./name"))&.remove
        out.div **note_attrs(node) do |div|
          div.p do |p|
            name and termnote_label(p, name)
            para_then_remainder(node.first_element_child, node, p, div)
          end
        end
      end

      def termnote_label(para, name)
        para.span class: "note_label" do |s|
          name.children.each { |n| parse(n, s) }
          s << termnote_delim
        end
      end

      # STYLE
      def table_of_contents(clause, out)
        out.div class: "WordSectionContents" do |div|
          clause_name(clause, clause.at(ns("./title")), div,
                      { class: "IEEEStdsLevel1frontmatter" })
          clause.elements.each do |e|
            parse(e, div) unless e.name == "title"
          end
        end
      end

      include BaseConvert
      include Init
    end
  end
end
