require "spec_helper"

RSpec.describe IsoDoc do
  it "processes IsoXML term with multiple paragraph definitions" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
          <p>For the purposes of this document, the following terms and definitions apply.</p>
      <term id="paddy1"><preferred><expression><name>paddy</name></expression></preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747e">rice retaining its husk after threshing, mark 2</p>
      <p>rice retaining its husk after threshing, mark 3</p>
      <source status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </source>
      </verbal-definition>
      </definition>
      <source status='identical'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'>t1</termref>
          </origin>
        </source>
      </term>
    INPUT
    presxml = <<~PRESXML
       <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1" id="_">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <p class="zzSTDTitle1" displayorder="2"/>
             <terms id="_" obligation="normative" displayorder="3">
                <title id="_">Terms and Definitions</title>
                <fmt-title depth="1" id="_">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Terms and Definitions</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="_">1</semx>
                </fmt-xref-label>
                <p>For the purposes of this document, the following terms and definitions apply.</p>
                <term id="paddy1">
                   <preferred id="_">
                      <expression>
                         <name>paddy</name>
                      </expression>
                   </preferred>
                   <domain id="_">rice</domain>
                   <definition id="_">
                      <verbal-definition>
                         <p id="_">rice retaining its husk after threshing, mark 2</p>
                         <p>rice retaining its husk after threshing, mark 3</p>
                         <source status="modified" id="_">
                            <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                               <locality type="clause">
                                  <referenceFrom>3.1</referenceFrom>
                               </locality>
                            </origin>
                            <modification id="_">
                               <p id="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
                            </modification>
                         </source>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>paddy</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                         </semx>
                         :
                         <semx element="definition" source="_">
                            rice retaining its husk after threshing, mark 2 rice retaining its husk after threshing, mark 3 (
                            <semx element="source" source="_">
                               <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011" id="_">
                                  <locality type="clause">
                                     <referenceFrom>3.1</referenceFrom>
                                  </locality>
                               </origin>
                               <semx element="origin" source="_">
                                  <fmt-origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                                     <locality type="clause">
                                        <referenceFrom>3.1</referenceFrom>
                                     </locality>
                                     <span class="std_publisher">ISO </span>
                                     <span class="std_docNumber">7301</span>
                                     :
                                     <span class="std_year">2011</span>
                                     , 3.1
                                  </fmt-origin>
                               </semx>
                               , modified —
                               <semx element="modification" source="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</semx>
                            </semx>
                            )
                         </semx>
                         (
                         <semx element="source" source="_">
                            <origin citeas="" id="_">
                               <termref base="IEV" target="xyz">t1</termref>
                            </origin>
                            <semx element="origin" source="_">
                               <fmt-origin citeas="">
                                  <termref base="IEV" target="xyz">t1</termref>
                               </fmt-origin>
                            </semx>
                         </semx>
                         )
                      </p>
                   </fmt-definition>
                   <source status="identical" id="_">
                      <origin citeas="">
                         <termref base="IEV" target="xyz">t1</termref>
                      </origin>
                   </source>
                </term>
             </terms>
          </sections>
       </iso-standard>
    PRESXML
    expect(Canon.format_xml(strip_guid(IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Canon.format_xml(presxml)
  end

  it "processes IsoXML term with multiple definitions" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
          <p>For the purposes of this document, the following terms and definitions apply.</p>
      <term id="paddy1"><preferred><expression><name>paddy</name></expression></preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its <xref target="paddy1"><em>husk</em></xref> after threshing</p></verbal-definition></definition>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747e">rice retaining its husk after threshing, mark 2</p>
      <source status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </source>
      </verbal-definition>
      </definition>
      <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f892"  keep-with-next="true" keep-lines-together="true">
        <p id="_65c9a509-9a89-4b54-a890-274126aeb55c">Foreign seeds, husks, bran, sand, dust.</p>
        <ul>
        <li>A</li>
        </ul>
      </termexample>
      <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f894">
        <ul>
        <li>A</li>
        </ul>
      </termexample>
      <source status='identical'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'>t1</termref>
          </origin>
        </source>
        <source status='modified'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'/>
          </origin>
          <modification>
            <p id='_'>with adjustments</p>
          </modification>
        </source>
      </term>
    INPUT
    presxml = <<~PRESXML
       <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1" id="_">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <p class="zzSTDTitle1" displayorder="2"/>
             <terms id="_" obligation="normative" displayorder="3">
                <title id="_">Terms and Definitions</title>
                <fmt-title depth="1" id="_">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Terms and Definitions</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="_">1</semx>
                </fmt-xref-label>
                <p>For the purposes of this document, the following terms and definitions apply.</p>
                <term id="paddy1">
                   <preferred id="_">
                      <expression>
                         <name>paddy</name>
                      </expression>
                   </preferred>
                   <domain id="_">rice</domain>
                   <definition id="_">
                      <verbal-definition>
                         <p id="_">
                            rice retaining its
                            <xref target="paddy1">
                               <em>husk</em>
                            </xref>
                            after threshing
                         </p>
                      </verbal-definition>
                   </definition>
                   <definition id="_">
                      <verbal-definition>
                         <p id="_">rice retaining its husk after threshing, mark 2</p>
                         <source status="modified" id="_">
                            <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                               <locality type="clause">
                                  <referenceFrom>3.1</referenceFrom>
                               </locality>
                            </origin>
                            <modification id="_">
                               <p id="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
                            </modification>
                         </source>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>paddy</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                         </semx>
                         :
                         <semx element="definition" source="_">
                            <strong>(A)</strong>
                             rice retaining its
                            <xref target="paddy1" id="_">
                               <em>husk</em>
                            </xref>
                            <semx element="xref" source="_">
                               <fmt-xref target="paddy1">
                                  <em>husk</em>
                               </fmt-xref>
                            </semx>
                            after threshing
                         </semx>
                         <semx element="definition" source="_">
                            <strong>(B)</strong>
                             rice retaining its husk after threshing, mark 2 (
                            <semx element="source" source="_">
                               <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011" id="_">
                                  <locality type="clause">
                                     <referenceFrom>3.1</referenceFrom>
                                  </locality>
                               </origin>
                               <semx element="origin" source="_">
                                  <fmt-origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                                     <locality type="clause">
                                        <referenceFrom>3.1</referenceFrom>
                                     </locality>
                                     <span class="std_publisher">ISO </span>
                                     <span class="std_docNumber">7301</span>
                                     :
                                     <span class="std_year">2011</span>
                                     , 3.1
                                  </fmt-origin>
                               </semx>
                               , modified —
                               <semx element="modification" source="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</semx>
                            </semx>
                            )
                         </semx>
                         (
                         <semx element="source" source="_">
                            <origin citeas="" id="_">
                               <termref base="IEV" target="xyz">t1</termref>
                            </origin>
                            <semx element="origin" source="_">
                               <fmt-origin citeas="">
                                  <termref base="IEV" target="xyz">t1</termref>
                               </fmt-origin>
                            </semx>
                         </semx>
                         ;
                         <semx element="source" source="_">
                            <origin citeas="" id="_">
                               <termref base="IEV" target="xyz"/>
                            </origin>
                            <semx element="origin" source="_">
                               <fmt-origin citeas="">
                                  <termref base="IEV" target="xyz"/>
                               </fmt-origin>
                            </semx>
                            , modified —
                            <semx element="modification" source="_">with adjustments</semx>
                         </semx>
                         )
                      </p>
                   </fmt-definition>
                   <termexample id="_" keep-with-next="true" keep-lines-together="true" autonum="1">
                      <fmt-name id="_">
                         <em>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Example</span>
                               <semx element="autonum" source="_">1</semx>
                            </span>
                         </em>
                         <em>
                            <span class="fmt-caption-delim">:</span>
                         </em>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy1">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy1">1</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <p id="_">Foreign seeds, husks, bran, sand, dust.</p>
                      <ul>
                         <li id="_">
                            <fmt-name id="_">
                               <semx element="autonum" source="_">—</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                   </termexample>
                   <termexample id="_" autonum="2">
                      <fmt-name id="_">
                         <em>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Example</span>
                               <semx element="autonum" source="_">2</semx>
                            </span>
                         </em>
                         <em>
                            <span class="fmt-caption-delim">:</span>
                         </em>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy1">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy1">1</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <ul>
                         <li id="_">
                            <fmt-name id="_">
                               <semx element="autonum" source="_">—</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                   </termexample>
                   <source status="identical" id="_">
                      <origin citeas="">
                         <termref base="IEV" target="xyz">t1</termref>
                      </origin>
                   </source>
                   <source status="modified" id="_">
                      <origin citeas="">
                         <termref base="IEV" target="xyz"/>
                      </origin>
                      <modification id="_">
                         <p id="_">with adjustments</p>
                      </modification>
                   </source>
                </term>
             </terms>
          </sections>
       </iso-standard>
    PRESXML
    expect(Canon.format_xml(strip_guid(IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Canon.format_xml(presxml)

    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
          <p>For the purposes of this document, the following terms and definitions apply.</p>
      <term id="paddy1"><preferred><expression><name>paddy</name></expression></preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></verbal-definition></definition>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747e">rice retaining its husk after threshing, mark 2</p>
      </verbal-definition>
      </definition>
      <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f892"  keep-with-next="true" keep-lines-together="true">
        <p id="_65c9a509-9a89-4b54-a890-274126aeb55c">Foreign seeds, husks, bran, sand, dust.</p>
        <ul>
        <li>A</li>
        </ul>
      </termexample>
      <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f894">
        <ul>
        <li>A</li>
        </ul>
      </termexample>
      <source status='identical'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'>t1</termref>
          </origin>
        </source>
        <source status='modified'>
          <origin citeas=''>
            <termref base='IEV' target='xyz'/>
          </origin>
          <modification>
            <p id='_'>with adjustments</p>
          </modification>
        </source>
      </term>
    INPUT
    presxml = <<~PRESXML
       <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1" id="_">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <p class="zzSTDTitle1" displayorder="2"/>
             <terms id="_" obligation="normative" displayorder="3">
                <title id="_">Terms and Definitions</title>
                <fmt-title depth="1" id="_">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Terms and Definitions</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="_">1</semx>
                </fmt-xref-label>
                <p>For the purposes of this document, the following terms and definitions apply.</p>
                <term id="paddy1">
                   <preferred id="_">
                      <expression>
                         <name>paddy</name>
                      </expression>
                   </preferred>
                   <domain id="_">rice</domain>
                   <definition id="_">
                      <verbal-definition>
                         <p id="_">rice retaining its husk after threshing</p>
                      </verbal-definition>
                   </definition>
                   <definition id="_">
                      <verbal-definition>
                         <p id="_">rice retaining its husk after threshing, mark 2</p>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>paddy</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                         </semx>
                         :
                         <semx element="definition" source="_">
                            <strong>(A)</strong>
                             rice retaining its husk after threshing
                         </semx>
                         <semx element="definition" source="_">
                            <strong>(B)</strong>
                             rice retaining its husk after threshing, mark 2
                         </semx>
                         (
                         <semx element="source" source="_">
                            <origin citeas="" id="_">
                               <termref base="IEV" target="xyz">t1</termref>
                            </origin>
                            <semx element="origin" source="_">
                               <fmt-origin citeas="">
                                  <termref base="IEV" target="xyz">t1</termref>
                               </fmt-origin>
                            </semx>
                         </semx>
                         ;
                         <semx element="source" source="_">
                            <origin citeas="" id="_">
                               <termref base="IEV" target="xyz"/>
                            </origin>
                            <semx element="origin" source="_">
                               <fmt-origin citeas="">
                                  <termref base="IEV" target="xyz"/>
                               </fmt-origin>
                            </semx>
                            , modified —
                            <semx element="modification" source="_">with adjustments</semx>
                         </semx>
                         )
                      </p>
                   </fmt-definition>
                   <termexample id="_" keep-with-next="true" keep-lines-together="true" autonum="1">
                      <fmt-name id="_">
                         <em>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Example</span>
                               <semx element="autonum" source="_">1</semx>
                            </span>
                         </em>
                         <em>
                            <span class="fmt-caption-delim">:</span>
                         </em>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy1">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy1">1</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">1</semx>
                      </fmt-xref-label>
                      <p id="_">Foreign seeds, husks, bran, sand, dust.</p>
                      <ul>
                         <li id="_">
                            <fmt-name id="_">
                               <semx element="autonum" source="_">—</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                   </termexample>
                   <termexample id="_" autonum="2">
                      <fmt-name id="_">
                         <em>
                            <span class="fmt-caption-label">
                               <span class="fmt-element-name">Example</span>
                               <semx element="autonum" source="_">2</semx>
                            </span>
                         </em>
                         <em>
                            <span class="fmt-caption-delim">:</span>
                         </em>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <fmt-xref-label container="paddy1">
                         <span class="fmt-xref-container">
                            <span class="fmt-element-name">Clause</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="paddy1">1</semx>
                         </span>
                         <span class="fmt-comma">,</span>
                         <span class="fmt-element-name">Example</span>
                         <semx element="autonum" source="_">2</semx>
                      </fmt-xref-label>
                      <ul>
                         <li id="_">
                            <fmt-name id="_">
                               <semx element="autonum" source="_">—</semx>
                            </fmt-name>
                            A
                         </li>
                      </ul>
                   </termexample>
                   <source status="identical" id="_">
                      <origin citeas="">
                         <termref base="IEV" target="xyz">t1</termref>
                      </origin>
                   </source>
                   <source status="modified" id="_">
                      <origin citeas="">
                         <termref base="IEV" target="xyz"/>
                      </origin>
                      <modification id="_">
                         <p id="_">with adjustments</p>
                      </modification>
                   </source>
                </term>
             </terms>
          </sections>
       </iso-standard>
    PRESXML
    expect(Canon.format_xml(strip_guid(IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Canon.format_xml(presxml)
  end

  it "processes IsoXML term with multiple preferred or preferred and admitted terms" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <sections>
          <terms id="_terms_and_definitions" obligation="normative"><title>Terms and Definitions</title>
      <term id="paddy1">
      <preferred><expression><name>A</name></expression></preferred>
      <preferred><expression><name>B</name></expression></preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></verbal-definition></definition>
      </term>
      <term id="paddy2">
      <preferred><expression><name language="eng">C</name></expression></preferred>
      <preferred><expression><name language="eng">D</name></expression><abbreviation-type>initialism</abbreviation-type></preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747a">rice retaining its husk after threshing</p></verbal-definition></definition>
      </term>
      <term id="paddy1a">
      <preferred><expression><name>E</name></expression></preferred>
      <admitted><expression><name>F</name></expression></admitted>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747f">rice retaining its husk after threshing</p></verbal-definition></definition>
      </term>
      <term id="paddy2a">
      <preferred><expression><name language="eng">G</name></expression></preferred>
      <admitted><expression><name language="eng">H</name></expression><abbreviation-type>initialism</abbreviation-type></admitted>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747a">rice retaining its husk after threshing</p></verbal-definition></definition>
      </term>
      <term id="paddy3">
      <preferred geographic-area="US"><expression><name>I</name></expression></preferred>
      <preferred><expression><name>J</name></expression></preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747b">rice retaining its husk after threshing</p></verbal-definition></definition>
      </term>
            <term id="paddy4">
      <preferred><expression language="eng"><name>K</name></expression></preferred>
      <preferred><expression language="fra"><name>L</name></expression></preferred>
      <domain>rice</domain>
      <definition><verbal-definition><p id="_eb29b35e-123e-4d1c-b50b-2714d41e747c">rice retaining its husk after threshing</p></verbal-definition></definition>
      </term>
                </terms>
        </sections>
      </iso-standard>
    INPUT
    presxml = <<~PRESXML
       <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1" id="_">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <p class="zzSTDTitle1" displayorder="2"/>
             <terms id="_" obligation="normative" displayorder="3">
                <title id="_">Terms and Definitions</title>
                <fmt-title depth="1" id="_">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Terms and Definitions</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="_">1</semx>
                </fmt-xref-label>
                <term id="paddy1">
                   <preferred id="_">
                      <expression>
                         <name>A</name>
                      </expression>
                   </preferred>
                   <preferred id="_">
                      <expression>
                         <name>B</name>
                      </expression>
                   </preferred>
                   <domain id="_">rice</domain>
                   <definition id="_">
                      <verbal-definition>
                         <p id="_">rice retaining its husk after threshing</p>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>A</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                         </semx>
                         :
                         <semx element="definition" source="_">rice retaining its husk after threshing</semx>
                         <em>Syn:</em>
                         <semx element="related" source="_">
                            <fmt-preferred>
                               <semx element="preferred" source="_">
                                  <strong>B</strong>
                                  <span class="fmt-designation-field">
                                     , &lt;
                                     <semx element="domain" source="_">rice</semx>
                                     &gt;
                                  </span>
                               </semx>
                            </fmt-preferred>
                         </semx>
                         .
                      </p>
                   </fmt-definition>
                </term>
                <term id="_">
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>B</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                         </semx>
                         :
                         <em>See:</em>
                         <semx element="related" source="_">
                            <fmt-preferred>
                               <semx element="preferred" source="_">
                                  <strong>A</strong>
                                  <span class="fmt-designation-field">
                                     , &lt;
                                     <semx element="domain" source="_">rice</semx>
                                     &gt;
                                  </span>
                               </semx>
                            </fmt-preferred>
                         </semx>
                         .
                      </p>
                   </fmt-definition>
                </term>
                <term id="paddy2">
                   <preferred id="_">
                      <expression>
                         <name language="eng">C</name>
                      </expression>
                   </preferred>
                   <preferred id="_">
                      <expression>
                         <name language="eng">D</name>
                      </expression>
                      <abbreviation-type>initialism</abbreviation-type>
                   </preferred>
                   <domain id="_">rice</domain>
                   <definition id="_">
                      <verbal-definition>
                         <p id="_">rice retaining its husk after threshing</p>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>C</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                         </semx>
                         (
                         <semx element="preferred" source="_">
                            <strong>D</strong>
                         </semx>
                         ):
                         <semx element="definition" source="_">rice retaining its husk after threshing</semx>
                      </p>
                   </fmt-definition>
                </term>
                <term id="paddy1a">
                   <preferred id="_">
                      <expression>
                         <name>E</name>
                      </expression>
                   </preferred>
                   <admitted id="_">
                      <expression>
                         <name>F</name>
                      </expression>
                   </admitted>
                   <domain id="_">rice</domain>
                   <definition id="_">
                      <verbal-definition>
                         <p original-id="_">rice retaining its husk after threshing</p>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>E</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                         </semx>
                         :
                         <semx element="definition" source="_">rice retaining its husk after threshing</semx>
                         <em>Syn:</em>
                         <semx element="related" source="_">
                            <fmt-preferred>
                               <semx element="admitted" source="_">
                                  <strong>F</strong>
                               </semx>
                            </fmt-preferred>
                         </semx>
                         .
                      </p>
                   </fmt-definition>
                </term>
                <term id="_">
                   <fmt-definition id="_">
                      <p>
                         <semx element="admitted" source="_">
                            <strong>F</strong>
                         </semx>
                         :
                         <em>See:</em>
                         <semx element="related" source="_">
                            <fmt-preferred>
                               <semx element="preferred" source="_">
                                  <strong>E</strong>
                                  <span class="fmt-designation-field">
                                     , &lt;
                                     <semx element="domain" source="_">rice</semx>
                                     &gt;
                                  </span>
                               </semx>
                            </fmt-preferred>
                         </semx>
                         .
                      </p>
                   </fmt-definition>
                </term>
                <term id="paddy2a">
                   <preferred id="_">
                      <expression>
                         <name language="eng">G</name>
                      </expression>
                   </preferred>
                   <admitted id="_">
                      <expression>
                         <name language="eng">H</name>
                      </expression>
                      <abbreviation-type>initialism</abbreviation-type>
                   </admitted>
                   <domain id="_">rice</domain>
                   <definition id="_">
                      <verbal-definition>
                         <p original-id="_">rice retaining its husk after threshing</p>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>G</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                         </semx>
                         (
                         <semx element="admitted" source="_">
                            <strong>H</strong>
                         </semx>
                         ):
                         <semx element="definition" source="_">rice retaining its husk after threshing</semx>
                      </p>
                   </fmt-definition>
                </term>
                <term id="paddy3">
                   <preferred geographic-area="US" id="_">
                      <expression>
                         <name>I</name>
                      </expression>
                   </preferred>
                   <preferred id="_">
                      <expression>
                         <name>J</name>
                      </expression>
                   </preferred>
                   <domain id="_">rice</domain>
                   <definition id="_">
                      <verbal-definition>
                         <p id="_">rice retaining its husk after threshing</p>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>I</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                            , US
                         </semx>
                         :
                         <semx element="definition" source="_">rice retaining its husk after threshing</semx>
                         <em>Syn:</em>
                         <semx element="related" source="_">
                            <fmt-preferred>
                               <semx element="preferred" source="_">
                                  <strong>J</strong>
                                  <span class="fmt-designation-field">
                                     , &lt;
                                     <semx element="domain" source="_">rice</semx>
                                     &gt;
                                  </span>
                               </semx>
                            </fmt-preferred>
                         </semx>
                         .
                      </p>
                   </fmt-definition>
                </term>
                <term id="_">
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>J</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                         </semx>
                         :
                         <em>See:</em>
                         <semx element="related" source="_">
                            <fmt-preferred>
                               <semx element="preferred" source="_">
                                  <strong>I</strong>
                                  <span class="fmt-designation-field">
                                     , &lt;
                                     <semx element="domain" source="_">rice</semx>
                                     &gt;
                                  </span>
                                  , US
                               </semx>
                            </fmt-preferred>
                         </semx>
                         .
                      </p>
                   </fmt-definition>
                </term>
                <term id="paddy4">
                   <preferred id="_">
                      <expression language="eng">
                         <name>K</name>
                      </expression>
                   </preferred>
                   <preferred id="_">
                      <expression language="fra">
                         <name>L</name>
                      </expression>
                   </preferred>
                   <domain id="_">rice</domain>
                   <definition id="_">
                      <verbal-definition>
                         <p id="_">rice retaining its husk after threshing</p>
                      </verbal-definition>
                   </definition>
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>K</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                            , eng
                         </semx>
                         :
                         <semx element="definition" source="_">rice retaining its husk after threshing</semx>
                         <em>Syn:</em>
                         <semx element="related" source="_">
                            <fmt-preferred>
                               <semx element="preferred" source="_">
                                  <strong>L</strong>
                                  <span class="fmt-designation-field">
                                     , &lt;
                                     <semx element="domain" source="_">rice</semx>
                                     &gt;
                                  </span>
                                  , fra
                               </semx>
                            </fmt-preferred>
                         </semx>
                         .
                      </p>
                   </fmt-definition>
                </term>
                <term id="_">
                   <fmt-definition id="_">
                      <p>
                         <semx element="preferred" source="_">
                            <strong>L</strong>
                            <span class="fmt-designation-field">
                               , &lt;
                               <semx element="domain" source="_">rice</semx>
                               &gt;
                            </span>
                            , fra
                         </semx>
                         :
                         <em>See:</em>
                         <semx element="related" source="_">
                            <fmt-preferred>
                               <semx element="preferred" source="_">
                                  <strong>K</strong>
                                  <span class="fmt-designation-field">
                                     , &lt;
                                     <semx element="domain" source="_">rice</semx>
                                     &gt;
                                  </span>
                                  , eng
                               </semx>
                            </fmt-preferred>
                         </semx>
                         .
                      </p>
                   </fmt-definition>
                </term>
             </terms>
          </sections>
       </iso-standard>
    PRESXML
    expect(Canon.format_xml(strip_guid(IsoDoc::Ieee::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Canon.format_xml(presxml)
  end
end
