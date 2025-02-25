require "isodoc"
require_relative "init"
require_relative "word_cleanup"
require_relative "word_cleanup_blocks"
require_relative "word_authority"
require_relative "word_wp_convert"

module IsoDoc
  module Ieee
    class WordConvert < IsoDoc::WordConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
        init_wp(options.dup)
      end

      def init_wp(options)
        @wp = ::IsoDoc::Ieee::WordWPConvert.new(options)
      end

      def convert1(docxml, filename, dir)
        if %w(amendment corrigendum).include?(@doctype)
          @header = html_doc_path("header_amd.html")
        end
        super
      end

      def convert(input_filename, file = nil, debug = false,
          output_filename = nil)
        file ||= File.read(input_filename, encoding: "utf-8")
        docxml = Nokogiri::XML(file, &:huge)
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
          clause_name(clause, clause.at(ns("./fmt-title")), s,
                      { class: stylesmap[:AbstractTitle] })
          clause.elements.each { |e| parse(e, s) unless e.name == "fmt-title" }
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
          footnotes docxml, div3
          comments div3
        end
      end

      def middle_title_ieee(docxml, out)
        title = docxml.at(ns("//p[@class = 'zzSTDTitle1']")) or return
        out.p(class: stylesmap[:zzSTDTitle1],
              style: "margin-left:0cm;margin-top:70.0pt") do |p|
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
            %w(fmt-stem dl fmt-name).include? n.name and next
            parse(n, div)
          end
        end
      end

      def dt_dd?(node)
        %w{dt dd}.include? node.name
      end

      def formula_where(dlist, out)
        dlist or return
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
        name.nil? and return
        name&.at(ns(".//strong"))&.remove # supplied by CSS list numbering
        div.h1 class: "Annex" do |t|
          # annex_name1(name, t)
          children_parse(name, t)
          clause_parse_subtitle(name, t)
        end
      end

      def span_parse(node, out)
        if node["class"] == "fmt-obligation"
          node.delete("class")
          node["style"] = "font-weight:normal;"
        end
        super
      end

      def termnote_parse(node, out)
        name = node.at(ns("./fmt-name"))
        para = node.at(ns("./p"))
        out.div **note_attrs(node) do |div|
          div.p do |p|
            name and termnote_label(p, name)
            children_parse(para, p)
          end
          para.xpath("./following-sibling::*").each { |n| parse(n, div) }
        end
      end

      def termnote_label(para, name)
        para.span class: "note_label" do |s|
          name.children.each { |n| parse(n, s) }
        end
      end

      # STYLE
      def table_of_contents(clause, out)
        out.div class: "WordSectionContents" do |div|
          clause_name(clause, clause.at(ns("./fmt-title")), div,
                      { class: "IEEEStdsLevel1frontmatter" })
          clause.elements.each do |e|
            parse(e, div) unless e.name == "fmt-title"
          end
        end
      end

      # Figure 1— remove each of these
      def figure_name_parse(_node, div, name)
        name.nil? and return
        name.at(".//xmlns:semx[@element = 'autonum']/"\
          "preceding-sibling::*[normalize-space() = '']")&.remove
        name.xpath(ns(".//span[@class = 'fmt-element-name']  | "\
                      ".//span[@class = 'fmt-caption-delim'] | "\
                      ".//semx[@element = 'autonum']")).each(&:remove)
        super
      end

      def table_title_parse(node, out)
        name = node.at(ns("./fmt-name")) or return
        name.at(".//xmlns:semx[@element = 'autonum']/"\
          "preceding-sibling::*[normalize-space() = '']")&.remove
        name.xpath(ns(".//span[@class = 'fmt-element-name']  | "\
                      ".//span[@class = 'fmt-caption-delim'] | "\
                      ".//semx[@element = 'autonum']")).each(&:remove)
        super
      end

      include BaseConvert
      include Init
    end
  end
end
