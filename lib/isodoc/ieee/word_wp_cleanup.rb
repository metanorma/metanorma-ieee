module IsoDoc
  module IEEE
    class WordWPConvert < WordConvert
      def stylesmap
        {
          example: "IEEEStdsParagraph", # x
          MsoNormal: "MsoBodyText",
          NormRef: "MsoBodyText",
          Biblio: "References",
          figure: "MsoBodyText",
          formula: "IEEEStdsEquation", # x
          Sourcecode: "IEEEStdsComputerCode", # x
          TableTitle: "TableTitles",
          FigureTitle: "FigureHeadings",
          admonition: "IEEEStdsWarning", # x
          abstract: "Abstract",
          AbstractTitle: "Unnumberedheading",
          level1frontmatter: "Unnumberedheading",
          level2frontmatter: "IEEEStdsLevel2frontmatter", # x
          level3frontmatter: "IEEEStdsLevel3frontmatter", # x
          level1header: "IEEESectionHeader",
          level2header: "IEEEStdsLevel2Header", # x
          level3header: "IEEEStdsLevel3Header", # x
          level4header: "IEEEStdsLevel4Header", # x
          level5header: "IEEEStdsLevel5Header", # x
          level6header: "IEEEStdsLevel6Header", # x
          zzSTDTitle1: "Titleofdocument",
          tabledata_center: "IEEEStdsTableData-Center", # x
          tabledata_left: "Tablecelltext",
          table_head: "IEEEStdsTableLineHead", # x
          table_subhead: "IEEEStdsTableLineSubhead", # x
          table_columnhead: "Tablecolumnheader",
          nameslist: "IEEEnames",
          intro: "Intro",
        }
      end

      APPENDIX_STYLE = %w(Appendix Appendixlevel2 Appendixlevel3).freeze

      def headings_style(hdr, idx)
        if hdr.at("./ancestor::div[@class = 'Annex']")
          headings_style_annex(hdr, idx)
        elsif hdr.at("./ancestor::div[@class = 'Section3' or " \
                     "@class = 'WordSectionContents']")
          headings_style_preface(hdr, idx)
        else
          headings_style_body(hdr, idx)
        end
      end

      def headings_style_annex(hdr, idx)
        hdr.delete("class")
        if idx == 1
          hdr.next = BLUELINE
          hdr["style"] = "margin-left:0cm;#{hdr['style']}"
        else
          hdr["class"] = "Unnumberedheading"
        end
      end

      def headings_style_preface(hdr, idx)
        hdr.name = "p"
        hdr["class"] = stylesmap["level#{idx}frontmatter".to_sym]
      end

      def headings_style_body(hdr, idx)
        idx == 1 and hdr.name = "p"
        if hdr["class"] != stylesmap[:AbstractTitle]
          if idx == 1
            hdr["class"] = stylesmap["level#{idx}header".to_sym]
          else
            hdr["style"] = "mso-list:l22 level#{idx} lfo33;#{hdr['style']}"
          end
        end
      end

      def toWord(result, filename, dir, header)
        result = from_xhtml(word_cleanup(to_xhtml(result)))
          .gsub("-DOUBLE_HYPHEN_ESCAPE-", "--")
        @wordstylesheet = wordstylesheet_update
        ::Html2Doc::IEEE_WP.new(
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

      def table_cleanup(docxml)
        super
        docxml.xpath("//div[@class = 'table_container']//div[@class = 'Note']//p")
          .each do |n|
          n["class"] = "Tablenotes"
        end
      end

      def authority_cleanup(docxml)
        %w(copyright disclaimers tm participants).each do |t|
          authority_cleanup1(docxml, t)
        end
        authority_style(docxml)
      end

      def authority_style(docxml)
        copyright_style(docxml)
        legal_style(docxml)
        officer_style(docxml)
      end

      def feedback_table(docxml)
        docxml.at("//div[@class = 'boilerplate-copyright']")&.xpath(".//table")
          &.each do |t|
          t.xpath(".//tr").each do |tr|
            feedback_table1(tr)
          end
          t.replace(t.at(".//tbody").elements)
        end
      end

      def feedback_table1(trow)
        trow.name = "p"
        trow["class"] = "CopyrightInformationPage"
        trow["align"] = "left"
        trow.xpath("./td").each do |td|
          td.next_element and td << "<span style='mso-tab-count:1'> </span>"
          td.xpath("./p").each { |p| p.replace(p.children) }
          td.replace(td.children)
        end
      end

      def copyright_style(docxml)
        docxml.at("//div[@class = 'boilerplate-copyright']")&.xpath(".//p")
          &.each do |p|
          p["class"] ||= "CopyrightInformationPage"
        end
        feedback_table(docxml)
      end

      def legal_style(docxml)
        %w(disclaimers tm).each do |e|
          docxml.at("//div[@id = 'boilerplate-#{e}']")&.xpath(".//p")
            &.each do |p|
            p["class"] ||= "Disclaimertext"
          end
        end
      end

      def officer_style(docxml)
        officemember_style(docxml)
      end

      def officemember_style(docxml)
        docxml.xpath("//p[@type = 'officemember' or @type = 'officeorgmember']")
          .each do |p|
          p["class"] = stylesmap[:nameslist]
        end
      end

      BLUELINE = <<~XHTML.freeze
        <o:wrapblock><v:line id="Line_x0020_23" o:spid="_x0000_s2052"
        style='visibility:visible;mso-wrap-style:square;mso-left-percent:-10001;
        mso-top-percent:-10001;mso-position-horizontal:absolute;
        mso-position-horizontal-relative:char;mso-position-vertical:absolute;
        mso-position-vertical-relative:line;mso-left-percent:-10001;mso-top-percent:-10001'
        from="55.05pt,2953.75pt" to="217pt,2953.75pt"
          o:gfxdata="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
        " strokecolor="#00aeef" strokeweight="8pt">
          <o:lock v:ext="edit" shapetype="f"/>
          <w:wrap type="topAndBottom" anchorx="page"/>
         </v:line></o:wrapblock><br style='mso-ignore:vglayout' clear='ALL'/>
      XHTML

      def abstract_cleanup(docxml)
        if f = docxml.at("//div[@class = 'abstract_div']")
          abstract_cleanup1(f, nil)
        end
      end

      def abstract_cleanup1(source, _dest)
        source.elements.reject { |e| %w(h1 h2).include?(e.name) }.each do |e|
          e.xpath("self::p | .//p").each do |p|
            p["class"] ||= stylesmap[:abstract]
            p["style"] = "margin-left:0cm;margin-right:0.25cm;#{p['style']}"
          end
        end
      end

      def insert_toc(intro, docxml, level)
        toc = assemble_toc(docxml, level)
        if intro&.include?("WORDTOC")
          #s = docxml.at("//div[@class = 'WordSectionContents']")
          #s.at("./p[@class='Unnumberedheading']")&.remove
          intro.sub("WORDTOC", toc)
        else
          source = docxml.at("//div[@class = 'TOC']") and
            source.children = toc
          intro
        end
      end
    end
  end
end
