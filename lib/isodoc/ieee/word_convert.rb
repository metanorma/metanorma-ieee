require "isodoc"
require_relative "init"
require_relative "word_cleanup"
require_relative "word_cleanup_blocks"
require_relative "word_authority"

module IsoDoc
  module IEEE
    class WordConvert < IsoDoc::WordConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
        super
      end

      def convert1(docxml, filename, dir)
        doctype = docxml.at(ns("//bibdata/ext/doctype"))
        if %w(amendment corrigendum).include?(doctype&.text)
          @header = html_doc_path("header_amd.html")
        end
        super
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

      def abstract(isoxml, out)
        f = isoxml.at(ns("//preface/abstract")) || return
        page_break(out)
        out.div **attr_code(id: f["id"], class: "abstract") do |s|
          clause_name(f, f.at(ns("./title")), s, { class: "AbstractTitle" })
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def make_body3(body, docxml)
        body.div class: "WordSectionMiddleTitle" do |_div3|
          middle_title_ieee(docxml, body)
        end
        section_break(body, continuous: true)
        body.div class: "WordSectionMain" do |div3|
          middle docxml, div3
          footnotes div3
          comments div3
        end
      end

      def middle_title(isoxml, out); end

      def middle_title_ieee(_docxml, out)
        out.p(class: "IEEEStdsTitle", style: "margin-top:70.0pt") do |p|
          p << @meta.get[:full_doctitle]
          @meta.get[:amd] || @meta.get[:corr] and p << "<br/>"
          @meta.get[:amd] and p << "Amendment #{@meta.get[:amd]}"
          @meta.get[:amd] && @meta.get[:corr] and p << " "
          @meta.get[:corr] and p << "Corrigenda #{@meta.get[:corr]}"
        end
      end

      def admonition_name_parse(_node, div, name)
        div.p class: "IEEEStdsWarning", style: "text-align:center;" do |p|
          p.b do |b|
            name.children.each { |n| parse(n, b) }
          end
        end
      end

      def admonition_class(node)
        if node["type"] == "editorial" then "zzHelp"
        elsif node.ancestors("introduction").empty?
          "IEEEStdsWarning"
        else "IEEEStdsIntroduction"
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
        preceding_floating_titles(name, div)
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

      include BaseConvert
      include Init
    end
  end
end
