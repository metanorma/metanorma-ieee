module IsoDoc
  module Ieee
    class WordConvert < IsoDoc::WordConvert
      def make_WordToC(docxml, level)
        toc = ""
        if source = docxml.at("//div[@class = 'TOC']")
          toc = to_xml(source.children)
        end
        xpath = (1..level).each.map do |i|
          "//h#{i}[not(ancestor::*[@class = 'WordSection2'])]"
        end.join (" | ")
        annexid = 0
        docxml.xpath(xpath).each do |h|
          x = ""
          if h.name == "h1" && h["class"] == "Annex"
            x, annexid = annex_toc(annexid)
          end
          toc += word_toc_entry(h.name[1].to_i, x + header_strip(h))
        end
        toc.sub(/(<p class="MsoToc1">)/,
                %{\\1#{word_toc_preface(level)}}) + WORD_TOC_SUFFIX1
      end

      def annex_toc(annexid)
        annexid += 1
        x = "#{@i18n.annex} #{('@'.ord + annexid).chr} "
        [x, annexid]
      end

      def table_toc_class
        ["IEEEStds Regular Table Caption", "TableTitle", "tabletitle", "TableCaption"]
      end

      def figure_toc_class
        ["IEEEStds Regular Figure Caption", "FigureTitle", "figuretitle", "FigureCaption"]
      end

      def insert_toc(intro, docxml, level)
        toc = assemble_toc(docxml, level)
        source = docxml.at("//div[@class = 'WordSectionContents']") and
          source << toc
        intro
      end
    end
  end
end
