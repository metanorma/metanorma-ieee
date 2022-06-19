require "isodoc"
require_relative "init"

module IsoDoc
  module IEEE
    class WordConvert < IsoDoc::WordConvert
      def initialize(options)
        @libdir = File.dirname(__FILE__)
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
          ulstyle: "l3",
          olstyle: "l2" }
      end

      def toWord(result, filename, dir, header)
        result = from_xhtml(word_cleanup(to_xhtml(result)))
          .gsub(/-DOUBLE_HYPHEN_ESCAPE-/, "--")
        @wordstylesheet = wordstylesheet_update
        ::Html2Doc::IEEE.new(
          filename: filename,
          imagedir: @localdir,
          stylesheet: @wordstylesheet&.path,
          header_file: header&.path, dir: dir,
          asciimathdelims: [@openmathdelim, @closemathdelim],
          liststyles: { ul: @ulstyle, ol: @olstyle }
        ).process(result)
        header&.unlink
        @wordstylesheet.unlink if @wordstylesheet.is_a?(Tempfile)
      end

      def abstract(isoxml, out)
        f = isoxml.at(ns("//preface/abstract")) || return
        page_break(out)
        out.div **attr_code(id: f["id"], class: "abstract") do |s|
          clause_name(nil, f.at(ns("./title")), s, { class: "AbstractTitle" })
          f.elements.each { |e| parse(e, s) unless e.name == "title" }
        end
      end

      def authority_cleanup(docxml)
        feedback_footnote(docxml)
        %w(copyright license disclaimers participants).each do |t|
          authority_cleanup1(docxml, t)
        end
        coverpage_note_cleanup(docxml)
        abstract_cleanup(docxml)
        authority_style(docxml)
      end

      def feedback_footnote(docxml)
        feedback_style(docxml)
        feedback_table(docxml)
        f = docxml.at("//div[@class = 'boilerplate-feedback']")
        docxml.at("//aside").previous = <<~FN
          <aside id="ftn0">#{f.remove.to_xml}</aside>
        FN
      end

      def authority_style(docxml)
        copyright_style(docxml)
        license_style(docxml)
      end

      def copyright_style(docxml)
        docxml.at("//div[@class = 'boilerplate-copyright']").xpath(".//p")
          .reverse.each_with_index do |p, i|
          p["class"] =
            i.zero? ? "IEEEStdsTitleDraftCRBody" : "IEEEStdsTitleDraftCRaddr"
        end
      end

      def license_style(docxml)
        docxml.at("//div[@class = 'boilerplate-license']").xpath(".//p")
          .reverse.each_with_index do |p, i|
          p["class"] =
            i.zero? ? "IEEEStdsTitleDraftCRBody" : "IEEEStdsTitleDraftCRaddr"
        end
      end

      def feedback_table(docxml)
        docxml.at("//div[@class = 'boilerplate-feedback']").xpath(".//table")
          .each do |t|
          t.xpath(".//tr").each do |tr|
            tr.name = "p"
            tr["class"] = "IEEEStdsCRTextReg"
            tr.xpath("./td").each do |td|
              td.next_element and td << "<span style='mso-tab-count:1'> </span>"
              td.replace(td.children)
            end
          end
          t.replace(t.at(".//tbody").elements)
        end
      end

      def feedback_style(docxml)
        docxml.at("//div[@class = 'boilerplate-feedback']").xpath("./div")
          .each_with_index do |div, i|
          i.zero? or div.elements.first.previous = "<p>&#xa0;</p>"
          div.xpath(".//p").each_with_index do |p, j|
            p["class"] =
              i == 4 ? "IEEEStdsCRTextItal" : "IEEEStdsCRTextReg"
            j.zero? && i.zero? and
              p.children.first.previous =
                '<a style="mso-footnote-id:ftn0" href="#_ftnref0" name="_ftn0" title=""/>'
          end
        end
      end

      def abstract_cleanup(docxml)
        dest = docxml.at("div[@id = 'abstract-destination']")
        if f = docxml.at("//div[@class = 'abstract']")
          abstract_cleanup1(f, dest)
          f.remove
        elsif f = docxml.at("//div[@type = 'scope']")
          abstract_cleanup1(f, dest)
        end
      end

      def abstract_cleanup1(source, dest)
        source.elements.each do |e|
          next if %w(h1 h2).include?(e.name)

          dest << e.dup
          dest.elements.last["class"] = "IEEEStdsAbstractBody"
        end
        dest.elements.first.children.first.previous =
          "<span class='IEEEStdsAbstractHeader'><span lang='EN-US'>"\
          "Abstract:</span></span> "
      end

      def authority_cleanup1(docxml, klass)
        dest = docxml.at("//div[@id = 'boilerplate-#{klass}-destination']")
        auth = docxml.at("//div[@id = 'boilerplate-#{klass}' "\
                         "or @class = 'boilerplate-#{klass}']")
        auth&.xpath(".//h1[not(text())] | .//h2[not(text())]")&.each(&:remove)
        (1..2).each do |i|
          auth&.xpath(".//h#{i}")&.each do |h|
            h.name = "p"
            h["class"] = "IEEEStdsLevel#{i}frontmatter"
          end
        end
        dest and auth and dest.replace(auth.remove)
      end

      def word_cleanup(docxml)
        super
        style_cleanup(docxml)
        docxml
      end

      STYLESMAP = {
      }.freeze

      def style_cleanup(docxml)
        STYLESMAP.each do |k, v|
          docxml.xpath("//*[@class = '#{k}']").each { |s| s["class"] = v }
        end
        docxml.xpath("//p[not(@class)]").each do |p|
          p["class"] = "IEEEStdsParagraph"
        end
      end

      # IEEEStdsParagraph

      include BaseConvert
      include Init
    end
  end
end
