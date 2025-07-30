require "spec_helper"
require "fileutils"

RSpec.describe IsoDoc::Ieee::WordConvert do
  it "processes boilerplate" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
      <ieee-standard xmlns="https://www.metanorma.org/ns/ieee" type="semantic" version="0.0.1">
      <bibdata type="standard">
      <title language="en" format="text/plain">Empty</title>

      <title language="intro-en" format="text/plain">Introduction</title>

      <title language="main-en" format="text/plain">Main Title -- Title</title>

      <title language="part-en" format="text/plain">Title Part</title>

      <title language="intro-fr" format="text/plain">Introduction Française</title>

      <title language="main-fr" format="text/plain">Titre Principal</title>

      <title language="part-fr" format="text/plain">Part du Titre</title>
      <docidentifier type="IEEE">1000</docidentifier><docnumber>1000</docnumber>
      <date type="confirmed"><on>1000-12-01</on></date>
      <date type="confirmed" format="ddMMMyyyy"><on>01 Dec 1000</on></date>
      <date type="issued"><on>1001-12-01</on></date>
      <date type="issued" format="ddMMMyyyy"><on>01 Dec 1001</on></date>
      <contributor><role type="editor">Working Group Chair</role><person>
      <name><completename>AB</completename></name>
      </person></contributor><contributor><role type="editor">Working Group Vice-Chair</role><person>
      <name><completename>CD</completename></name>
      </person></contributor><contributor><role type="editor">Working Group Member</role><person>
      <name><completename>E, F, Jr.</completename></name>
      </person></contributor><contributor><role type="editor">Working Group Member</role><person>
      <name><completename>GH</completename></name>
      </person></contributor><contributor><role type="editor">Working Group Member</role><person>
      <name><completename>IJ</completename></name>
      </person></contributor><contributor><role type="editor">Balloting Group Member</role><person>
      <name><completename>KL</completename></name>
      </person></contributor><contributor><role type="editor">Balloting Group Member</role><person>
      <name><completename>MN</completename></name>
      </person></contributor><contributor><role type="editor">Standards Board Chair</role><person>
      <name><completename>OP</completename></name>
      </person></contributor><contributor><role type="editor">Standards Board Vice-Chair</role><person>
      <name><completename>QR</completename></name>
      </person></contributor><contributor><role type="editor">Standards Board Past Chair</role><person>
      <name><completename>ST</completename></name>
      </person></contributor><contributor><role type="editor">Standards Board Secretary</role><person>
      <name><completename>UV</completename></name>
      </person></contributor><contributor><role type="editor">Standards Board Member</role><person>
      <name><completename>KL</completename></name>
      </person></contributor><contributor><role type="editor">Standards Board Member</role><person>
      <name><completename>MN</completename></name>
      </person></contributor><contributor><role type="publisher"/><organization>
      <name>Institute of Electrical and Electronic Engineers</name>
      <abbreviation>IEEE</abbreviation></organization></contributor><edition>2</edition><version><revision-date>2000-01-01</revision-date><draft>0.3.4</draft></version><language>en</language><script>Latn</script><status><stage>20</stage><substage>20</substage><iteration>3</iteration></status><copyright><from>2000</from><owner><organization>
      <name>Institute of Electrical and Electronic Engineers</name>
      <abbreviation>IEEE</abbreviation></organization></owner></copyright><ext><doctype>standard</doctype><editorialgroup><society>SECRETARIAT</society><balloting-group>SC</balloting-group><working-group>WG</working-group><working-group>WG1</working-group><committee>TC</committee><committee>TC1</committee></editorialgroup><ics><code>1</code></ics><ics><code>2</code></ics><ics><code>3</code></ics></ext></bibdata>

<boilerplate><copyright-statement>

<clause id="_2746e248-b08e-5318-47d4-e45bbe84a410" inline-header="false" obligation="normative">
<p id="copyright" align="left">Copyright © 2025 by The Institute of Electrical and Electronics Engineers, Inc.<br/> Three Park Avenue <br/> New York, New York 10016-5997, USA</p>

<p id="_23944417-305f-cfcd-5d8a-78dbfdf64407">All rights reserved.</p>
</clause>
</copyright-statement>

<license-statement>

<clause id="_ee385f52-0268-d6c9-3c07-020cee221252" inline-header="false" obligation="normative">
<p id="_d6f8653f-2402-d2bc-b19b-1c7fd6cbc51d">This document is an unapproved draft of a proposed IEEE Standard. As such, this document is subject to change. USE AT YOUR OWN RISK! IEEE copyright statements SHALL NOT BE REMOVED from draft or approved IEEE standards, or modified in any way. Because this is an unapproved draft, this document must not be utilized for any conformance/compliance purposes. Permission is hereby granted for officers from each IEEE Standards Working Group or Committee to reproduce the draft document developed by that Working Group for purposes of international standardization consideration.  IEEE Standards Department must be informed of the submission for consideration prior to any reproduction for international standardization consideration (<link target="mailto:stds-ipr@ieee.org"/>). Prior to adoption of this document, in whole or in part, by another standards development organization, permission must first be obtained from the IEEE Standards Department (<link target="mailto:stds-ipr@ieee.org"/>). When requesting permission, IEEE Standards Department will require a copy of the standard development organization’s document highlighting the use of IEEE content. Other entities seeking permission to reproduce this document, in whole or in part, must also obtain permission from the IEEE Standards Department.</p>

<p id="_2bf4a522-09dc-0682-e576-3656a7f2fa10" align="left">IEEE Standards Department<br/> 445 Hoes Lane <br/> Piscataway, NJ 08854, USA</p>
</clause>
</license-statement>

<legal-statement>

<clause id="boilerplate-disclaimers" inline-header="false" obligation="normative">
<title>Important Notices and Disclaimers Concerning IEEE Standards Documents</title>
<p id="_DV_M4">IEEE Standards documents are made available for use subject to important notices and legal disclaimers. These notices and disclaimers, or a reference to this page ( <link target="https://standards.ieee.org/ipr/disclaimers.html"/>), appear in all IEEE standards and may be found under the heading “Important Notices and Disclaimers Concerning IEEE Standards Documents.”</p>

<clause id="_052f32db-362e-d3d8-6d6a-2da7e20275e6" inline-header="false" obligation="normative">
<title>Notice and Disclaimer of Liability Concerning the Use of IEEE Standards Documents</title>
<p id="_12e0a564-00a5-a5a2-c778-cd4bd0684675">IEEE Standards documents are developed within IEEE Societies and subcommittees of IEEE Standards Association (IEEE SA) Board of Governors. IEEE develops its standards through an accredited consensus development process, which brings together volunteers representing varied viewpoints and interests to achieve the final product. IEEE standards are documents developed by volunteers with scientific, academic, and industry-based expertise in technical working groups. Volunteers involved in technical working groups are not necessarily members of IEEE or IEEE SA and participate without compensation from IEEE. While IEEE administers the process and establishes rules to promote fairness in the consensus development process, IEEE does not independently evaluate, test, or verify the accuracy of any of the information or the soundness of any judgments contained in its standards.</p>

<p id="_25b912d5-f77f-52bd-ce2c-378a936363d9">IEEE makes no warranties or representations concerning its standards, and expressly disclaims all warranties, express or implied, concerning all standards, including but not limited to the warranties of merchantability, fitness for a particular purpose and non-infringement IEEE Standards documents do not guarantee safety, security, health, or environmental protection, or compliance with law, or guarantee against interference with or from other devices or networks. In addition, IEEE does not warrant or represent that the use of the material contained in its standards is free from patent infringement. IEEE Standards documents are supplied “AS IS” and “WITH ALL FAULTS.”</p>

<p id="_7ba07456-f0bd-dcfb-06d1-d46241b07965">Use of an IEEE standard is wholly voluntary. The existence of an IEEE standard does not imply that there are no other ways to produce, test, measure, purchase, market, or provide other goods and services related to the scope of the IEEE standard. Furthermore, the viewpoint expressed at the time a standard is approved and issued is subject to change brought about through developments in the state of the art and comments received from users of the standard.</p>

<p id="_7eb6ffdb-a341-415d-c6d9-bf466d96d92e">In publishing and making its standards available, IEEE is not suggesting or rendering professional or other services for, or on behalf of, any person or entity, nor is IEEE undertaking to perform any duty owed by any other person or entity to another. Any person utilizing any IEEE Standards document should rely upon their own independent judgment in the exercise of reasonable care in any given circumstances or, as appropriate, seek the advice of a competent professional in determining the appropriateness of a given IEEE standard.</p>

<p id="_fcea0c34-5981-0e30-d0aa-6b51b96daa5d">IN NO EVENT SHALL IEEE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO: THE NEED TO PROCURE SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE PUBLICATION, USE OF, OR RELIANCE UPON ANY STANDARD, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE AND REGARDLESS OF WHETHER SUCH DAMAGE WAS FORESEEABLE.</p>
</clause>

<clause id="_b59d082b-7169-6ddf-b261-fe65c1de03e3" inline-header="false" obligation="normative">
<title>Translations</title>
<p id="_df70bd17-f94f-b5f2-71fd-f0609ecdc929">The IEEE consensus balloting process involves the review of documents in English only. In the event that an IEEE standard is translated, only the English language version published by IEEE is the approved IEEE standard.</p>
</clause>

<clause id="_02a6ee32-13e7-6353-2e82-60458d85b6e5" inline-header="false" obligation="normative">
<title>Use by artificial intelligence systems</title>
<p id="_6f226d29-7492-e1a8-c19e-1584878e9e88">In no event shall material in any IEEE Standards documents be used for the purpose of creating, training, enhancing, developing, maintaining, or contributing to any artificial intelligence systems without the express, written consent of IEEE SA in advance. “Artificial intelligence” refers to any software, application, or other system that uses artificial intelligence, machine learning, or similar technologies, to analyze, train, process, or generate content. Requests for consent can be submitted using the Contact Us form.</p>
</clause>

<clause id="_c01e86b6-8073-84d8-3c36-2ff02a4561e8" inline-header="false" obligation="normative">
<title>Official statements</title>
<p id="_01059bbe-7368-c0be-401e-40df758d34d5">A statement, written or oral, that is not processed in accordance with the IEEE SA Standards Board Operations Manual is not, and shall not be considered or inferred to be, the official position of IEEE or any of its committees and shall not be considered to be, or be relied upon as, a formal position of IEEE or IEEE SA. At lectures, symposia, seminars, or educational courses, an individual presenting information on IEEE standards shall make it clear that the presenter’s views should be considered the personal views of that individual rather than the formal position of IEEE, IEEE SA, the Standards Committee, or the Working Group. Statements made by volunteers may not represent the formal position of their employer(s) or affiliation(s). News releases about IEEE standards issued by entities other than IEEE SA should be considered the view of the entity issuing the release rather than the formal position of IEEE or IEEE SA.</p>
</clause>

<clause id="_9712d875-b224-b7a0-0d50-6c6b717cd4f9" inline-header="false" obligation="normative">
<title>Comments on standards</title>
<p id="_44323e77-9965-1728-9d85-aec6915bc8a1">Comments for revision of IEEE Standards documents are welcome from any interested party, regardless of membership affiliation with IEEE or IEEE SA. However,  <strong>IEEE does not provide interpretations, consulting information, or advice pertaining to IEEE Standards documents</strong>.</p>
 
<p id="_eebcc83e-4c9f-e661-5138-be464d0a18b1">Suggestions for changes in
documents should be in the form of a proposed change of text, together with
appropriate supporting comments. Since IEEE standards represent a consensus of
concerned interests, it is important that any responses to comments and
questions also receive the concurrence of a balance of interests. For this reason, IEEE and the members of its Societies and subcommittees of the IEEE SA Board of Governors are not able to provide an instant response to comments or questions, except
in those cases where the matter has previously been addressed.
For the same reason, IEEE does not respond to interpretation requests. Any
person who would like to participate in evaluating comments or in revisions to
an IEEE standard is welcome to join the relevant IEEE SA working group. You can
indicate interest in a working group using the Interests tab in the Manage
Profile &amp; Interests area of the <link target="https://development.standards.ieee.org/myproject-web/public/view.html#landing">IEEE SA myProject system</link>.<fn reference="_boilerplate_1"><p id="_cf98d73e-ebbe-a714-9f6f-4e28c8701280">Available at: <link target="https://development.standards.ieee.org/myproject-web/public/view.html#landing"/>.</p>
</fn>
An IEEE Account is needed to access the application.</p> 

<p id="_8ab66f55-0bbc-f045-ba59-1026275dacb2">Comments on standards should be submitted using the <link target="https://standards.ieee.org/about/contact/">Contact Us</link> form.<fn reference="_boilerplate_2"><p id="_174430d7-dcfd-da04-c1c4-1d6860f91dd4">Available at: <link target="https://standards.ieee.org/about/contact/"/>.</p>
</fn></p>
</clause>

<clause id="_9fec55a4-278f-c0e2-ffc4-8220d3559379" inline-header="false" obligation="normative"> 
<title>Laws and regulations</title>
<p id="_a881a8cc-d576-715e-3277-232789c96ae0">Users of IEEE Standards documents should consult all applicable laws and regulations. Compliance with the provisions of any IEEE Standards document does not constitute compliance to any applicable regulatory requirements. Implementers of the standard are responsible for observing or referring to the applicable regulatory requirements. IEEE does not, by the publication of its standards, intend to urge action that is not in compliance with applicable laws, and these documents may not be construed as doing so.</p>
</clause>

<clause id="_4ccd39f4-0662-55fc-541f-24a23386637c" inline-header="false" obligation="normative"> 
<title>Data privacy</title>
<p id="_f552ad0b-ab4d-2dbf-8276-b7249b03b07a">Users of IEEE Standards documents should evaluate the standards for considerations of data privacy and data ownership in the context of assessing and using the standards in compliance with applicable laws and regulations.</p>
</clause>

<clause id="_4e803cdb-b79a-4347-6c71-9153a2167cb0" inline-header="false" obligation="normative">
<title>Copyrights</title>
<p id="_ad188111-2b90-ffc0-6ac0-211849604313">IEEE draft and approved standards are copyrighted by IEEE under U.S. and international copyright laws. They are made available by IEEE and are adopted for a wide variety of both public and private uses. These include both use by reference, in laws and regulations, and use in private self-regulation, standardization, and the promotion of engineering practices and methods. By making these documents available for use and adoption by public authorities and private users, neither IEEE nor its licensors waive any rights in copyright to the documents.</p>
</clause>

<clause id="_18833e52-84d2-a095-bb62-506473aabf20" inline-header="false" obligation="normative">
<title>Photocopies</title>
<p id="_146006a0-e0af-519b-d1ec-e667e99ae190">Subject to payment of the appropriate licensing fees, IEEE will grant users a limited, non-exclusive license to photocopy portions of any individual standard for company or organizational internal use or individual, non-commercial use only. To arrange for payment of licensing fees, please contact Copyright Clearance Center, Customer Service, 222 Rosewood Drive, Danvers, MA 01923 USA; +1 978 750 8400; https://www.copyright.com/. Permission to photocopy portions of any individual standard for educational classroom use can also be obtained through the Copyright Clearance Center.</p>
</clause>

<clause id="_0d8c4577-05d7-5084-4ef5-9a1c779d7085" inline-header="false" obligation="normative">
<title>Updating of IEEE Standards documents</title>
<p id="_4645c353-adde-6cf2-7119-bef3b38cd74b">Users of IEEE Standards documents should be aware that these documents may be superseded at any time by the issuance of new editions or may be amended from time to time through the issuance of amendments, corrigenda, or errata. An official IEEE document at any point in time consists of the current edition of the document together with any amendments, corrigenda, or errata then in effect.</p>

<p id="_54b809c4-f085-04b1-9e44-6f61abaa797c">Every IEEE standard is subjected to review at least every 10 years. When a document is more than 10 years old and has not undergone a revision process, it is reasonable to conclude that its contents, although still of some value, do not wholly reflect the present state of the art. Users are cautioned to check to determine that they have the latest edition of any IEEE standard.</p>

<p id="_a6b311f9-8572-de53-c37a-4f5825b100e7">In
order to determine whether a given document is the current edition and whether
it has been amended through the issuance of amendments, corrigenda, or errata,
visit <link target="https://ieeexplore.ieee.org/browse/standards/collection/ieee/">IEEE Xplore</link>
or <link target="https://standards.ieee.org/about/contact/">contact IEEE</link>.<fn reference="_boilerplate_3"><p id="_661a7600-c446-a535-e186-a115d9f6fa24">Available at <link target="https://ieeexplore.ieee.org/browse/standards/collection/ieee"/>.</p>
</fn>
For more information about the IEEE SA or IEEE’s standards development process,
visit the IEEE SA Website.</p>
</clause>

<clause id="_44c7ee35-bdb2-bec1-3f4b-244aaa151166" inline-header="false" obligation="normative">
<title>Errata</title>
<p id="_1053f234-e2f9-0b30-cba5-22ce4a5af370">Errata, if any, for all IEEE standards can be accessed on the
<link target="https://standards.ieee.org/standard/index.html">IEEE SA Website</link>.<fn reference="_boilerplate_4"><p id="_fd45a0cb-ca83-bb04-3160-4e28ca2cde16">Available at: <link target="https://standards.ieee.org/standard/index.html"/>.</p>
</fn>
Search for standard number and year of approval to access the web page of the
published standard. Errata links are located under the Additional Resources Details section.
Errata are also available in <link target="https://ieeexplore.ieee.org/browse/standards/collection/ieee/">IEEE Xplore</link>.
Users are encouraged to periodically check for errata.</p>
</clause>

<clause id="_7d888b8f-073b-1704-9cc0-a34cda3fd1af" inline-header="false" obligation="normative">
<title>Patents</title>
<p id="_b481a25a-44b1-6022-88b2-75c9981c0ebd">IEEE standards are developed in compliance with the <link target="https://standards.ieee.org/about/sasb/patcom/materials.html">IEEE SA Patent Policy</link>.<fn reference="_boilerplate_5"><p id="_a62fd954-b3fe-6790-fd42-6ca1fd67cf6b">Available at: <link target="https://standards.ieee.org/about/sasb/patcom/materials.html"/>.</p>
</fn></p>

<p id="_386a006e-9bea-b246-756f-2a9a862a4d59">Attention is called to the possibility that implementation of this standard may require use of subject matter covered by patent rights. By publication of this standard, no position is taken by the IEEE with respect to the existence or validity of any patent rights in connection therewith. If a patent holder or patent applicant has filed a statement of assurance via an Accepted Letter of Assurance, then the statement is listed on the IEEE SA Website at  <link target="https://standards.ieee.org/about/sasb/patcom/patents.html"/>. Letters of Assurance may indicate whether the Submitter is willing or unwilling to grant licenses under patent rights without compensation or under reasonable rates, with reasonable terms and conditions that are demonstrably free of any unfair discrimination to applicants desiring to obtain such licenses.</p>

<p id="_f8d540bc-463d-253a-7af2-01d29f6772e8">Essential Patent Claims may exist for which a Letter of Assurance has not been received. The IEEE is not responsible for identifying Essential Patent Claims for which a license may be required, for conducting inquiries into the legal validity or scope of Patents Claims, or determining whether any licensing terms or conditions provided in connection with submission of a Letter of Assurance, if any, or in any licensing agreements are reasonable or non-discriminatory. Users of this standard are expressly advised that determination of the validity of any patent rights, and the risk of infringement of such rights, is entirely their own responsibility. Further information may be obtained from the IEEE Standards Association.</p>
</clause>

<clause id="_2764f7f8-3aff-6e95-fc21-6520d6dbe9d6" inline-header="false" obligation="normative">
<title>IMPORTANT NOTICE</title>
<p id="_d69d10c9-52b2-d1bb-3812-091121e046bc">Technologies, application of technologies, and recommended procedures in various industries evolve over time. The IEEE standards development process allows participants to review developments in industries, technologies, and practices, and to determine what, if any, updates should be made to the IEEE standard. During this evolution, the technologies and recommendations in IEEE standards may be implemented in ways not foreseen during the standard’s development. IEEE standards development activities consider research and information presented to the standards development group in developing any safety recommendations. Other information about safety practices, changes in technology or technology implementation, or impact by peripheral systems also may be pertinent to safety considerations during implementation of the standard. Implementers and users of IEEE Standards documents are responsible for determining and complying with all appropriate safety, security, environmental, health, data privacy, and interference protection practices and all applicable laws and regulations.</p>
</clause>
</clause>

          <clause id="boilerplate-participants">
            <fmt-title id="_">Participants</fmt-title>
              <p id="_6c151db1-c395-acf1-1fa2-c8db0131136b">At the time this draft Standard was completed, the WG Working Group had the following membership:</p>
              <p align="center" type="officeholder" id="_08d02fae-f1d9-e550-fbdd-4645fe7d095f"><strong>AB</strong>, <em>Chair</em></p>
              <p align="center" type="officeholder" id="_31eadeb4-3307-4629-948d-2cb3c6412966"><strong>CD</strong>, <em>Vice Chair</em></p>
              <p type="officemember" id="_67b33631-2fbb-f564-e9f0-82282edefdef">E, F, Jr.</p>
              <p type="officemember" id="_0e9e363e-d5c0-b780-8cec-621969a23c4b">GH</p>
              <p type="officemember" id="_876f6c07-835a-7987-3116-f58991fa75b2">IJ</p>
              <p id="_46f7565b-0bef-19ea-ec10-9cbb61112146">The following members of the SC Standards Association balloting group voted on this Standard. Balloters may have voted for approval, disapproval, or abstention.</p>
              <p type="officemember" id="_4bb301e0-e632-db01-7a13-a25dc1d19245">KL</p>
              <p type="officemember" id="_6d22f033-4acc-bb26-cdbc-17c15081ac6f">MN</p>
              <p id="_44e9013d-e106-6625-4bd8-23ccd243ada0">When the IEEE SA Standards Board approved this Standard on , it had the following membership:</p>
              <p align="center" type="officeholder" id="_996af77c-8f97-8120-2122-160468d38421"><strong>OP</strong>, <em>Chair</em></p>
              <p align="center" type="officeholder" id="_788af112-e13f-9cb6-8d24-abf8696f77c9"><strong>QR</strong>, <em>Vice Chair</em></p>
              <p align="center" type="officeholder" id="_da7481f4-39f9-6c55-6d46-1b8884b61b9d"><strong>ST</strong>, <em>Past Chair</em></p>
              <p align="center" type="officeholder" id="_1aeba399-1582-a62f-8b2b-69d7c8b4af2d"><strong>UV</strong>, <em>Secretary</em></p>
              <p type="officemember" id="_433b1929-28dc-9529-4780-b8adbc2abef5">KL</p>
              <p type="officemember" id="_57925a1f-9722-e750-d098-a02dfb15d545">MN</p>
              <p type="emeritus_sign" id="_49166d58-0938-7cc1-a872-016042bb1c33">*Member Emeritus</p>
          </clause>
        </legal-statement>
        <feedback-statement>
          <clause>
            <p align="left" id="_e934c824-e425-4780-49ab-b5b213d3ad03">The Institute of Electrical and Electronics Engineers, Inc.<br/> 3 Park Avenue, New York, NY 10016-5997, USA</p>
          </clause>

          <clause>
            <p id="_7c8abde4-b041-07c0-6748-0cf04bff9724">Copyright © 2000 by The Institute of Electrical and Electronics Engineers, Inc.</p>
            <p id="_c254dc66-2cc9-5a51-1956-7e591b1e96dc">All rights reserved. Published . Printed in the United States of America.</p>
          </clause>

          <clause>
            <p id="_3db6f550-190c-379c-93b3-c26e27566acd">IEEE is a registered trademark in the U.S. Patent &amp; Trademark Office, owned by The Institute of Electrical and Electronics Engineers, Incorporated.</p>
          </clause>

          <clause>
            <table unnumbered="true">
              <tbody>
                <tr><td>PDF:</td>	<td>ISBN 978-0-XXXX-XXXX-X</td>	<td>STDXXXXX</td></tr>
                <tr><td>Print:</td>	<td>ISBN 978-0-XXXX-XXXX-X</td>	<td>STDPDXXXXX</td></tr>
              </tbody>
            </table>
          </clause>

          <clause>
            <p id="_c46d91eb-fa3d-4310-9757-5dfad377d35c">IEEE prohibits discrimination, harassment, and bullying.</p>
            <p id="_41116375-3164-0b50-5b78-07ca1a84051f">For more information, visit <link target="https://www.ieee.org/about/corporate/governance/p9-26.html"/>.</p>
            <p id="_45b2ec47-59fb-6b29-c7ac-95d64eecd2e6">No part of this publication may be reproduced in any form, in an electronic retrieval system or otherwise, without the prior written permission of the publisher.</p>
          </clause>
        </feedback-statement>
      </boilerplate>

      <sections><clause id="_clause" inline-header="false" obligation="normative" displayorder="1">
      <fmt-title id="_">Clause</fmt-title>
      <p id="_2e901de4-4c14-e534-d135-862a24df22ee">Hello</p>
      </clause>
      </sections>
      </ieee-standard>
    INPUT
    word = <<~OUTPUT
       <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US">
          <div class="WordSection1">
             <p class="IEEEStdsTitle" style="margin-top:50.0pt;margin-right:0cm;margin-bottom:36.0pt;margin-left:0cm">
                <span lang="EN-US" xml:lang="EN-US">P1000™/D0.3.4</span>
                <br/>
                <span lang="EN-US" xml:lang="EN-US">Draft Standard for Empty</span>
             </p>
             <p class="IEEEStdsTitleParaSans">
                <span lang="EN-US" xml:lang="EN-US">Developed by the</span>
             </p>
             <p class="IEEEStdsTitleParaSans">
                <span lang="EN-US" xml:lang="EN-US">
                   <p class="MsoNormal"> </p>
                </span>
             </p>
             <p class="IEEEStdsTitleParaSansBold">
                <span lang="EN-US" xml:lang="EN-US">TC</span>
             </p>
             <p class="IEEEStdsTitleParaSans">
                <span lang="EN-US" xml:lang="EN-US">of the</span>
             </p>
             <p class="IEEEStdsTitleParaSansBold">
                <span lang="EN-US" xml:lang="EN-US">IEEE SECRETARIAT</span>
             </p>
             <p class="IEEEStdsTitleParaSans">
                <span lang="EN-US" xml:lang="EN-US">
                   <p class="MsoNormal"> </p>
                </span>
             </p>
             <p class="IEEEStdsTitleParaSans">
                <span lang="EN-US" xml:lang="EN-US">
                   <p class="MsoNormal"> </p>
                </span>
             </p>
             <p class="IEEEStdsTitleParaSans">
                <span lang="EN-US" xml:lang="EN-US">Approved 01 Dec 1001</span>
             </p>
             <p class="IEEEStdsTitleParaSans">
                <span lang="EN-US" xml:lang="EN-US">
                   <p class="MsoNormal"> </p>
                </span>
             </p>
             <p class="IEEEStdsTitleParaSansBold">
                <span lang="EN-US" xml:lang="EN-US">IEEE SA Standards Board</span>
             </p>
             <p class="IEEEStdsCopyrightaddrs">
                <span lang="EN-US" xml:lang="EN-US">
                   <p class="MsoNormal"> </p>
                </span>
             </p>
             <div class="boilerplate-copyright">
                <div>
                   <a name="_" id="_"/>
                   <p style="text-align:left;" align="left" class="IEEEStdsTitleDraftCRaddr">
                      <a name="copyright" id="copyright"/>
                      Copyright © 2025 by The Institute of Electrical and Electronics Engineers, Inc.
                      <br/>
                      Three Park Avenue
                      <br/>
                      New York, New York 10016-5997, USA
                   </p>
                   <p class="IEEEStdsTitleDraftCRBody">
                      <a name="_" id="_"/>
                      All rights reserved.
                   </p>
                </div>
             </div>
             <div class="boilerplate-license">
                <div>
                   <a name="_" id="_"/>
                   <p class="IEEEStdsTitleDraftCRaddr">
                      <a name="_" id="_"/>
                      This document is an unapproved draft of a proposed IEEE Standard. As such, this document is subject to change. USE AT YOUR OWN RISK! IEEE copyright statements SHALL NOT BE REMOVED from draft or approved IEEE standards, or modified in any way. Because this is an unapproved draft, this document must not be utilized for any conformance/compliance purposes. Permission is hereby granted for officers from each IEEE Standards Working Group or Committee to reproduce the draft document developed by that Working Group for purposes of international standardization consideration. IEEE Standards Department must be informed of the submission for consideration prior to any reproduction for international standardization consideration (
                      <a href="mailto:stds-ipr@ieee.org">stds-ipr@ieee.org</a>
                      ). Prior to adoption of this document, in whole or in part, by another standards development organization, permission must first be obtained from the IEEE Standards Department (
                      <a href="mailto:stds-ipr@ieee.org">stds-ipr@ieee.org</a>
                      ). When requesting permission, IEEE Standards Department will require a copy of the standard development organization’s document highlighting the use of IEEE content. Other entities seeking permission to reproduce this document, in whole or in part, must also obtain permission from the IEEE Standards Department.
                   </p>
                   <p style="text-align:left;" align="left" class="IEEEStdsTitleDraftCRBody">
                      <a name="_" id="_"/>
                      IEEE Standards Department
                      <br/>
                      445 Hoes Lane
                      <br/>
                      Piscataway, NJ 08854, USA
                   </p>
                </div>
             </div>
             <p class="IEEEStdsParagraph"> </p>
          </div>
          <p class="IEEEStdsParagraph">
             <br clear="all" class="section"/>
          </p>
          <div class="WordSection2">
             <div>
                <a name="abstract-destination" id="abstract-destination"/>
             </div>
             <p class="IEEEStdsKeywords">
                <a name="_" id="_">
                   <span class="IEEEStdsKeywordsHeader">
                      <span lang="EN-US" xml:lang="EN-US">
                         <p class="MsoNormal"> </p>
                      </span>
                   </span>
                </a>
             </p>
             <p class="IEEEStdsKeywords">
                <span style="mso-bookmark:_Ref">
                   <span class="IEEEStdsKeywordsHeader">
                      <span lang="EN-US" xml:lang="EN-US">Keywords: </span>
                   </span>
                   <span lang="EN-US" xml:lang="EN-US"/>
                </span>
             </p>
             <p class="IEEEStdsParagraph">
                <span lang="EN-US" xml:lang="EN-US">
                   <p class="MsoNormal"> </p>
                </span>
             </p>
             <p class="IEEEStdsCRFootnote">
                <a class="FootnoteRef" href="#_ftn1" type="footnote" style="mso-footnote-id:ftn1" name="_" title="" id="_">
                   <span class="MsoFootnoteReference">
                      <span style="mso-special-character:footnote"/>
                   </span>
                </a>
             </p>
          </div>
          <span lang="EN-US" style="font-size:10.0pt;font-family:&quot;Times New Roman&quot;,serif; mso-fareast-font-family:&quot;Times New Roman&quot;;color:white;mso-ansi-language:EN-US; mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
             <br clear="all" style="page-break-before:always;mso-break-type:section-break"/>
          </span>
          <div class="WordSection3">
             <div>
                <a name="boilerplate-disclaimers" id="boilerplate-disclaimers"/>
                <p class="IEEEStdsLevel1frontmatter">Important Notices and Disclaimers Concerning IEEE Standards Documents</p>
                <p class="IEEEStdsParagraph">
                   <a name="_" id="_"/>
                   IEEE Standards documents are made available for use subject to important notices and legal disclaimers. These notices and disclaimers, or a reference to this page (
                   <a href="https://standards.ieee.org/ipr/disclaimers.html">https://standards.ieee.org/ipr/disclaimers.html</a>
                   ), appear in all IEEE standards and may be found under the heading “Important Notices and Disclaimers Concerning IEEE Standards Documents.”
                </p>
                <div>
                   <a name="_" id="_"/>
                   <p class="IEEEStdsLevel2frontmatter">Notice and Disclaimer of Liability Concerning the Use of IEEE Standards Documents</p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      IEEE Standards documents are developed within IEEE Societies and subcommittees of IEEE Standards Association (IEEE SA) Board of Governors. IEEE develops its standards through an accredited consensus development process, which brings together volunteers representing varied viewpoints and interests to achieve the final product. IEEE standards are documents developed by volunteers with scientific, academic, and industry-based expertise in technical working groups. Volunteers involved in technical working groups are not necessarily members of IEEE or IEEE SA and participate without compensation from IEEE. While IEEE administers the process and establishes rules to promote fairness in the consensus development process, IEEE does not independently evaluate, test, or verify the accuracy of any of the information or the soundness of any judgments contained in its standards.
                   </p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      IEEE makes no warranties or representations concerning its standards, and expressly disclaims all warranties, express or implied, concerning all standards, including but not limited to the warranties of merchantability, fitness for a particular purpose and non-infringement IEEE Standards documents do not guarantee safety, security, health, or environmental protection, or compliance with law, or guarantee against interference with or from other devices or networks. In addition, IEEE does not warrant or represent that the use of the material contained in its standards is free from patent infringement. IEEE Standards documents are supplied “AS IS” and “WITH ALL FAULTS.”
                   </p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      Use of an IEEE standard is wholly voluntary. The existence of an IEEE standard does not imply that there are no other ways to produce, test, measure, purchase, market, or provide other goods and services related to the scope of the IEEE standard. Furthermore, the viewpoint expressed at the time a standard is approved and issued is subject to change brought about through developments in the state of the art and comments received from users of the standard.
                   </p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      In publishing and making its standards available, IEEE is not suggesting or rendering professional or other services for, or on behalf of, any person or entity, nor is IEEE undertaking to perform any duty owed by any other person or entity to another. Any person utilizing any IEEE Standards document should rely upon their own independent judgment in the exercise of reasonable care in any given circumstances or, as appropriate, seek the advice of a competent professional in determining the appropriateness of a given IEEE standard.
                   </p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      IN NO EVENT SHALL IEEE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO: THE NEED TO PROCURE SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE PUBLICATION, USE OF, OR RELIANCE UPON ANY STANDARD, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE AND REGARDLESS OF WHETHER SUCH DAMAGE WAS FORESEEABLE.
                   </p>
                </div>
                <div>
                   <a name="_" id="_"/>
                   <p class="IEEEStdsLevel2frontmatter">Translations</p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      The IEEE consensus balloting process involves the review of documents in English only. In the event that an IEEE standard is translated, only the English language version published by IEEE is the approved IEEE standard.
                   </p>
                </div>
                <div>
                   <a name="_" id="_"/>
                   <p class="IEEEStdsLevel2frontmatter">Use by artificial intelligence systems</p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      In no event shall material in any IEEE Standards documents be used for the purpose of creating, training, enhancing, developing, maintaining, or contributing to any artificial intelligence systems without the express, written consent of IEEE SA in advance. “Artificial intelligence” refers to any software, application, or other system that uses artificial intelligence, machine learning, or similar technologies, to analyze, train, process, or generate content. Requests for consent can be submitted using the Contact Us form.
                   </p>
                </div>
                <div>
                   <a name="_" id="_"/>
                   <p class="IEEEStdsLevel2frontmatter">Official statements</p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      A statement, written or oral, that is not processed in accordance with the IEEE SA Standards Board Operations Manual is not, and shall not be considered or inferred to be, the official position of IEEE or any of its committees and shall not be considered to be, or be relied upon as, a formal position of IEEE or IEEE SA. At lectures, symposia, seminars, or educational courses, an individual presenting information on IEEE standards shall make it clear that the presenter’s views should be considered the personal views of that individual rather than the formal position of IEEE, IEEE SA, the Standards Committee, or the Working Group. Statements made by volunteers may not represent the formal position of their employer(s) or affiliation(s). News releases about IEEE standards issued by entities other than IEEE SA should be considered the view of the entity issuing the release rather than the formal position of IEEE or IEEE SA.
                   </p>
                </div>
                <div>
                   <a name="_" id="_"/>
                   <p class="IEEEStdsLevel2frontmatter">Comments on standards</p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      Comments for revision of IEEE Standards documents are welcome from any interested party, regardless of membership affiliation with IEEE or IEEE SA. However,
                      <b>IEEE does not provide interpretations, consulting information, or advice pertaining to IEEE Standards documents</b>
                      .
                   </p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      Suggestions for changes in documents should be in the form of a proposed change of text, together with appropriate supporting comments. Since IEEE standards represent a consensus of concerned interests, it is important that any responses to comments and questions also receive the concurrence of a balance of interests. For this reason, IEEE and the members of its Societies and subcommittees of the IEEE SA Board of Governors are not able to provide an instant response to comments or questions, except in those cases where the matter has previously been addressed. For the same reason, IEEE does not respond to interpretation requests. Any person who would like to participate in evaluating comments or in revisions to an IEEE standard is welcome to join the relevant IEEE SA working group. You can indicate interest in a working group using the Interests tab in the Manage Profile Interests area of the
                      <a href="https://development.standards.ieee.org/myproject-web/public/view.html#landing">IEEE SA myProject system</a>
                      .
                      <span style="mso-bookmark:_Ref" class="MsoFootnoteReference">
                         <a class="FootnoteRef" type="footnote" href="#_ftn2" style="mso-footnote-id:ftn2" name="_" title="" id="_">
                            <span class="MsoFootnoteReference">
                               <span style="mso-special-character:footnote"/>
                            </span>
                         </a>
                      </span>
                      An IEEE Account is needed to access the application.
                   </p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      Comments on standards should be submitted using the
                      <a href="https://standards.ieee.org/about/contact/">Contact Us</a>
                      form.
                      <span style="mso-bookmark:_Ref" class="MsoFootnoteReference">
                         <a class="FootnoteRef" type="footnote" href="#_ftn3" style="mso-footnote-id:ftn3" name="_" title="" id="_">
                            <span class="MsoFootnoteReference">
                               <span style="mso-special-character:footnote"/>
                            </span>
                         </a>
                      </span>
                   </p>
                </div>
                <div>
                   <a name="_" id="_"/>
                   <p class="IEEEStdsLevel2frontmatter">Laws and regulations</p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      Users of IEEE Standards documents should consult all applicable laws and regulations. Compliance with the provisions of any IEEE Standards document does not constitute compliance to any applicable regulatory requirements. Implementers of the standard are responsible for observing or referring to the applicable regulatory requirements. IEEE does not, by the publication of its standards, intend to urge action that is not in compliance with applicable laws, and these documents may not be construed as doing so.
                   </p>
                </div>
                <div>
                   <a name="_" id="_"/>
                   <p class="IEEEStdsLevel2frontmatter">Data privacy</p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      Users of IEEE Standards documents should evaluate the standards for considerations of data privacy and data ownership in the context of assessing and using the standards in compliance with applicable laws and regulations.
                   </p>
                </div>
                <div>
                   <a name="_" id="_"/>
                   <p class="IEEEStdsLevel2frontmatter">Copyrights</p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      IEEE draft and approved standards are copyrighted by IEEE under U.S. and international copyright laws. They are made available by IEEE and are adopted for a wide variety of both public and private uses. These include both use by reference, in laws and regulations, and use in private self-regulation, standardization, and the promotion of engineering practices and methods. By making these documents available for use and adoption by public authorities and private users, neither IEEE nor its licensors waive any rights in copyright to the documents.
                   </p>
                </div>
                <div>
                   <a name="_" id="_"/>
                   <p class="IEEEStdsLevel2frontmatter">Photocopies</p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      Subject to payment of the appropriate licensing fees, IEEE will grant users a limited, non-exclusive license to photocopy portions of any individual standard for company or organizational internal use or individual, non-commercial use only. To arrange for payment of licensing fees, please contact Copyright Clearance Center, Customer Service, 222 Rosewood Drive, Danvers, MA 01923 USA; +1 978 750 8400; https://www.copyright.com/. Permission to photocopy portions of any individual standard for educational classroom use can also be obtained through the Copyright Clearance Center.
                   </p>
                </div>
                <div>
                   <a name="_" id="_"/>
                   <p class="IEEEStdsLevel2frontmatter">Updating of IEEE Standards documents</p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      Users of IEEE Standards documents should be aware that these documents may be superseded at any time by the issuance of new editions or may be amended from time to time through the issuance of amendments, corrigenda, or errata. An official IEEE document at any point in time consists of the current edition of the document together with any amendments, corrigenda, or errata then in effect.
                   </p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      Every IEEE standard is subjected to review at least every 10 years. When a document is more than 10 years old and has not undergone a revision process, it is reasonable to conclude that its contents, although still of some value, do not wholly reflect the present state of the art. Users are cautioned to check to determine that they have the latest edition of any IEEE standard.
                   </p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      In order to determine whether a given document is the current edition and whether it has been amended through the issuance of amendments, corrigenda, or errata, visit
                      <a href="https://ieeexplore.ieee.org/browse/standards/collection/ieee/">IEEE Xplore</a>
                      or
                      <a href="https://standards.ieee.org/about/contact/">contact IEEE</a>
                      .
                      <span style="mso-bookmark:_Ref" class="MsoFootnoteReference">
                         <a class="FootnoteRef" type="footnote" href="#_ftn4" style="mso-footnote-id:ftn4" name="_" title="" id="_">
                            <span class="MsoFootnoteReference">
                               <span style="mso-special-character:footnote"/>
                            </span>
                         </a>
                      </span>
                      For more information about the IEEE SA or IEEE’s standards development process, visit the IEEE SA Website.
                   </p>
                </div>
                <div>
                   <a name="_" id="_"/>
                   <p class="IEEEStdsLevel2frontmatter">Errata</p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      Errata, if any, for all IEEE standards can be accessed on the
                      <a href="https://standards.ieee.org/standard/index.html">IEEE SA Website</a>
                      .
                      <span style="mso-bookmark:_Ref" class="MsoFootnoteReference">
                         <a class="FootnoteRef" type="footnote" href="#_ftn5" style="mso-footnote-id:ftn5" name="_" title="" id="_">
                            <span class="MsoFootnoteReference">
                               <span style="mso-special-character:footnote"/>
                            </span>
                         </a>
                      </span>
                      Search for standard number and year of approval to access the web page of the published standard. Errata links are located under the Additional Resources Details section. Errata are also available in
                      <a href="https://ieeexplore.ieee.org/browse/standards/collection/ieee/">IEEE Xplore</a>
                      . Users are encouraged to periodically check for errata.
                   </p>
                </div>
                <div>
                   <a name="_" id="_"/>
                   <p class="IEEEStdsLevel2frontmatter">Patents</p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      IEEE standards are developed in compliance with the
                      <a href="https://standards.ieee.org/about/sasb/patcom/materials.html">IEEE SA Patent Policy</a>
                      .
                      <span style="mso-bookmark:_Ref" class="MsoFootnoteReference">
                         <a class="FootnoteRef" type="footnote" href="#_ftn6" style="mso-footnote-id:ftn6" name="_" title="" id="_">
                            <span class="MsoFootnoteReference">
                               <span style="mso-special-character:footnote"/>
                            </span>
                         </a>
                      </span>
                   </p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      Attention is called to the possibility that implementation of this standard may require use of subject matter covered by patent rights. By publication of this standard, no position is taken by the IEEE with respect to the existence or validity of any patent rights in connection therewith. If a patent holder or patent applicant has filed a statement of assurance via an Accepted Letter of Assurance, then the statement is listed on the IEEE SA Website at
                      <a href="https://standards.ieee.org/about/sasb/patcom/patents.html">https://standards.ieee.org/about/sasb/patcom/patents.html</a>
                      . Letters of Assurance may indicate whether the Submitter is willing or unwilling to grant licenses under patent rights without compensation or under reasonable rates, with reasonable terms and conditions that are demonstrably free of any unfair discrimination to applicants desiring to obtain such licenses.
                   </p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      Essential Patent Claims may exist for which a Letter of Assurance has not been received. The IEEE is not responsible for identifying Essential Patent Claims for which a license may be required, for conducting inquiries into the legal validity or scope of Patents Claims, or determining whether any licensing terms or conditions provided in connection with submission of a Letter of Assurance, if any, or in any licensing agreements are reasonable or non-discriminatory. Users of this standard are expressly advised that determination of the validity of any patent rights, and the risk of infringement of such rights, is entirely their own responsibility. Further information may be obtained from the IEEE Standards Association.
                   </p>
                </div>
                <div>
                   <a name="_" id="_"/>
                   <p class="IEEEStdsLevel2frontmatter">IMPORTANT NOTICE</p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      Technologies, application of technologies, and recommended procedures in various industries evolve over time. The IEEE standards development process allows participants to review developments in industries, technologies, and practices, and to determine what, if any, updates should be made to the IEEE standard. During this evolution, the technologies and recommendations in IEEE standards may be implemented in ways not foreseen during the standard’s development. IEEE standards development activities consider research and information presented to the standards development group in developing any safety recommendations. Other information about safety practices, changes in technology or technology implementation, or impact by peripheral systems also may be pertinent to safety considerations during implementation of the standard. Implementers and users of IEEE Standards documents are responsible for determining and complying with all appropriate safety, security, environmental, health, data privacy, and interference protection practices and all applicable laws and regulations.
                   </p>
                </div>
             </div>
          </div>
          <b style="mso-bidi-font-weight:normal">
             <span lang="EN-US" style="font-size:12.0pt; mso-bidi-font-size:10.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-fareast-font-family: &quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
                <br clear="all" style="page-break-before:always;mso-break-type:section-break"/>
             </span>
          </b>
          <div class="WordSection4">
             <div>
                <a name="boilerplate-participants" id="boilerplate-participants"/>
                <p class="IEEEStdsLevel1frontmatter">Participants</p>
                <p class="IEEEStdsParagraph">
                   <a name="_" id="_"/>
                   At the time this draft Standard was completed, the WG Working Group had the following membership:
                </p>
                <p style="text-align:center;" align="center" class="IEEEStdsNamesCtrCxSpFirst">
                   <a name="_" id="_"/>
                   <b>AB</b>
                   ,
                   <i>Chair</i>
                </p>
                <p style="text-align:center;" align="center" class="IEEEStdsNamesCtrCxSpLast">
                   <a name="_" id="_"/>
                   <b>CD</b>
                   ,
                   <i>Vice Chair</i>
                </p>
             </div>
          </div>
          <span lang="EN-US" style="font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
             <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
             <div class="WordSection5">
                <p class="IEEEStdsNamesList">
                   <a name="_" id="_"/>
                   E, F, Jr.
                </p>
                <p class="IEEEStdsNamesList">
                   <a name="_" id="_"/>
                   GH
                </p>
                <p class="IEEEStdsNamesList">
                   <a name="_" id="_"/>
                   IJ
                </p>
             </div>
             <span lang="EN-US" style="font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
                <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
                <div class="WordSection6">
                   <p class="IEEEStdsParagraph"> </p>
                   <p class="IEEEStdsParagraph">
                      <a name="_" id="_"/>
                      The following members of the SC Standards Association balloting group voted on this Standard. Balloters may have voted for approval, disapproval, or abstention.
                   </p>
                </div>
                <span lang="EN-US" style="font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
                   <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
                   <div class="WordSection7">
                      <p class="IEEEStdsNamesList">
                         <a name="_" id="_"/>
                         KL
                      </p>
                      <p class="IEEEStdsNamesList">
                         <a name="_" id="_"/>
                         MN
                      </p>
                   </div>
                   <span lang="EN-US" style="font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
                      <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
                      <div class="WordSection8">
                         <p class="IEEEStdsParagraph"> </p>
                         <p class="IEEEStdsParagraph">
                            <a name="_" id="_"/>
                            When the IEEE SA Standards Board approved this Standard on , it had the following membership:
                         </p>
                         <p style="text-align:center;" align="center" class="IEEEStdsNamesCtrCxSpFirst">
                            <a name="_" id="_"/>
                            <b>OP</b>
                            ,
                            <i>Chair</i>
                         </p>
                         <p style="text-align:center;" align="center" class="IEEEStdsNamesCtrCxSpMiddle">
                            <a name="_" id="_"/>
                            <b>QR</b>
                            ,
                            <i>Vice Chair</i>
                         </p>
                         <p style="text-align:center;" align="center" class="IEEEStdsNamesCtrCxSpMiddle">
                            <a name="_" id="_"/>
                            <b>ST</b>
                            ,
                            <i>Past Chair</i>
                         </p>
                         <p style="text-align:center;" align="center" class="IEEEStdsNamesCtrCxSpLast">
                            <a name="_" id="_"/>
                            <b>UV</b>
                            ,
                            <i>Secretary</i>
                         </p>
                      </div>
                      <span lang="EN-US" style="font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
                         <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
                         <div class="WordSection9">
                            <p class="IEEEStdsNamesList">
                               <a name="_" id="_"/>
                               KL
                            </p>
                            <p class="IEEEStdsNamesList">
                               <a name="_" id="_"/>
                               MN
                            </p>
                         </div>
                         <span lang="EN-US" style="font-size:9.0pt;mso-bidi-font-size:10.0pt;font-family: &quot;Times New Roman&quot;,serif;mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
                            <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
                            <div class="WordSection10">
                               <p class="IEEEStdsParaMemEmeritus">
                                  <a name="_" id="_"/>
                                  *Member Emeritus
                               </p>
                            </div>
                         </span>
                      </span>
                   </span>
                </span>
             </span>
          </span>
          <b style="mso-bidi-font-weight:normal">
             <span lang="EN-US" style="font-size:12.0pt; mso-bidi-font-size:10.0pt;font-family:&quot;Arial&quot;,sans-serif;mso-fareast-font-family: &quot;Times New Roman&quot;;mso-bidi-font-family:&quot;Times New Roman&quot;;mso-ansi-language: EN-US;mso-fareast-language:JA;mso-bidi-language:AR-SA" xml:lang="EN-US">
                <br clear="all" style="page-break-before:always;mso-break-type:section-break"/>
             </span>
          </b>
          <div class="authority">
             <div class="boilerplate-legal">
     
     
     
                 
               </div>
          </div>
          <p class="IEEEStdsParagraph"> </p>
          <p class="IEEEStdsParagraph">
             <br clear="all" class="section"/>
          </p>
          <div class="WordSectionMiddleTitle">
             <p class="IEEEStdsTitle" style="margin-left:0cm;margin-top:70.0pt">Draft Standard for Empty</p>
          </div>
          <p class="IEEEStdsParagraph">
             <br clear="all" style="page-break-before:auto;mso-break-type:section-break"/>
          </p>
          <div class="WordSectionMain">
             <div>
                <a name="_" id="_"/>
                <p class="IEEEStdsLevel1Header">Clause</p>
                <p class="IEEEStdsParagraph">
                   <a name="_" id="_"/>
                   Hello
                </p>
             </div>
          </div>
          <div style="mso-element:footnote-list">
             <div style="mso-element:footnote" id="ftn1">
                <p style="text-align:left;" align="left" class="IEEEStdsCRTextReg">
                   <a name="_" id="_"/>
                   <a style="mso-footnote-id:ftn1" href="#_ftn1" name="_" title="" id="_"/>
                   <a style="mso-footnote-id:ftn0" href="#_ftnref0" name="_" title="" id="_"/>
                   The Institute of Electrical and Electronics Engineers, Inc.
                   <br/>
                   3 Park Avenue, New York, NY 10016-5997, USA
                </p>
                <p class="IEEEStdsCRTextReg"> </p>
                <p class="IEEEStdsCRTextReg">
                   <a name="_" id="_"/>
                   Copyright © 2000 by The Institute of Electrical and Electronics Engineers, Inc.
                </p>
                <p class="IEEEStdsCRTextReg">
                   <a name="_" id="_"/>
                   All rights reserved. Published . Printed in the United States of America.
                </p>
                <p class="IEEEStdsCRTextReg"> </p>
                <p class="IEEEStdsCRTextReg">
                   <a name="_" id="_"/>
                   IEEE is a registered trademark in the U.S. Patent Trademark Office, owned by The Institute of Electrical and Electronics Engineers, Incorporated.
                </p>
                <p class="IEEEStdsCRTextReg"> </p>
                <p class="IEEEStdsCRTextReg">
                   PDF:
                   <span style="mso-tab-count:1"> </span>
                   ISBN 978-0-XXXX-XXXX-X
                   <span style="mso-tab-count:1"> </span>
                   STDXXXXX
                </p>
                <p class="IEEEStdsCRTextReg">
                   Print:
                   <span style="mso-tab-count:1"> </span>
                   ISBN 978-0-XXXX-XXXX-X
                   <span style="mso-tab-count:1"> </span>
                   STDPDXXXXX
                </p>
                <p class="IEEEStdsCRTextItal"> </p>
                <p class="IEEEStdsCRTextItal">
                   <a name="_" id="_"/>
                   IEEE prohibits discrimination, harassment, and bullying.
                </p>
                <p class="IEEEStdsCRTextItal">
                   <a name="_" id="_"/>
                   For more information, visit
                   <a href="https://www.ieee.org/about/corporate/governance/p9-26.html">https://www.ieee.org/about/corporate/governance/p9-26.html</a>
                   .
                </p>
                <p class="IEEEStdsCRTextItal">
                   <a name="_" id="_"/>
                   No part of this publication may be reproduced in any form, in an electronic retrieval system or otherwise, without the prior written permission of the publisher.
                </p>
             </div>
             <div style="mso-element:footnote" id="ftn2">
                <p class="IEEEStdsFootnote">
                   <a name="_" id="_"/>
                   <a style="mso-footnote-id:ftn2" href="#_ftn2" name="_" title="" id="_">
                      <span class="MsoFootnoteReference">
                         <span style="mso-special-character:footnote"/>
                      </span>
                   </a>
                   Available at:
                   <a href="https://development.standards.ieee.org/myproject-web/public/view.html#landing">https://development.standards.ieee.org/myproject-web/public/view.html#landing</a>
                   .
                </p>
             </div>
             <div style="mso-element:footnote" id="ftn3">
                <p class="IEEEStdsFootnote">
                   <a name="_" id="_"/>
                   <a style="mso-footnote-id:ftn3" href="#_ftn3" name="_" title="" id="_">
                      <span class="MsoFootnoteReference">
                         <span style="mso-special-character:footnote"/>
                      </span>
                   </a>
                   Available at:
                   <a href="https://standards.ieee.org/about/contact/">https://standards.ieee.org/about/contact/</a>
                   .
                </p>
             </div>
             <div style="mso-element:footnote" id="ftn4">
                <p class="IEEEStdsFootnote">
                   <a name="_" id="_"/>
                   <a style="mso-footnote-id:ftn4" href="#_ftn4" name="_" title="" id="_">
                      <span class="MsoFootnoteReference">
                         <span style="mso-special-character:footnote"/>
                      </span>
                   </a>
                   Available at
                   <a href="https://ieeexplore.ieee.org/browse/standards/collection/ieee">https://ieeexplore.ieee.org/browse/standards/collection/ieee</a>
                   .
                </p>
             </div>
             <div style="mso-element:footnote" id="ftn5">
                <p class="IEEEStdsFootnote">
                   <a name="_" id="_"/>
                   <a style="mso-footnote-id:ftn5" href="#_ftn5" name="_" title="" id="_">
                      <span class="MsoFootnoteReference">
                         <span style="mso-special-character:footnote"/>
                      </span>
                   </a>
                   Available at:
                   <a href="https://standards.ieee.org/standard/index.html">https://standards.ieee.org/standard/index.html</a>
                   .
                </p>
             </div>
             <div style="mso-element:footnote" id="ftn6">
                <p class="IEEEStdsFootnote">
                   <a name="_" id="_"/>
                   <a style="mso-footnote-id:ftn6" href="#_ftn6" name="_" title="" id="_">
                      <span class="MsoFootnoteReference">
                         <span style="mso-special-character:footnote"/>
                      </span>
                   </a>
                   Available at:
                   <a href="https://standards.ieee.org/about/sasb/patcom/materials.html">https://standards.ieee.org/about/sasb/patcom/materials.html</a>
                   .
                </p>
             </div>
          </div>
       </body>
    OUTPUT
    presxml = IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    IsoDoc::Ieee::WordConvert.new({}).convert("test", presxml, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:body")
    doc.at("//xmlns:div[@class = 'WordSectionContents']")&.remove
    expect(strip_guid(Canon.format_xml(doc.to_xml)))
      .to be_equivalent_to Canon.format_xml(word)
  end

  it "processes boilerplate, whitepaper" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
      <ieee-standard xmlns="https://www.metanorma.org/ns/ieee" type="semantic" version="1.1.2" schema-version="v1.2.5">
      <bibdata type="standard">
      <title language="en" format="text/plain">Paper Title</title>
      <docidentifier type="IEEE" scope="PDF">STD 2</docidentifier><docidentifier type="IEEE" scope="print">STD 3</docidentifier><docidentifier type="ISBN" scope="PDF">ISBN 2</docidentifier><docidentifier type="ISBN" scope="print">ISBN 3</docidentifier><date type="issued"><on>2929</on></date>
      <contributor><role type="author"/><person>
        <name><forename>Y</forename><surname>X</surname></name>
        <affiliation>
        <name>Z</name>
        </affiliation>
        </person></contributor><contributor><role type="author"/><person>
        <name><forename>Y1</forename><surname>X1</surname></name>
        <affiliation>
        <name>Z1</name>
        </affiliation>
        </person></contributor>
      <contributor>
        <role type="publisher"/><organization>
      <name>Institute of Electrical and Electronic Engineers</name>
      <abbreviation>IEEE</abbreviation></organization></contributor><language>en</language><script>Latn</script><abstract><p class="MsoNormal">Abstract paragraph to go here. Abstract should be written in the passive voice.</p>
      </abstract><status><stage>approved</stage></status><copyright><from>2020</from><owner><organization>
      <name>Institute of Electrical and Electronic Engineers</name>
      <abbreviation>IEEE</abbreviation></organization></owner></copyright><ext><doctype>whitepaper</doctype><subdoctype>document</subdoctype><editorialgroup><society/><balloting-group/><working-group>NAME OF GROUP</working-group><committee/></editorialgroup><program>NAME OF PROGRAM</program></ext></bibdata>
      <metanorma-extension><presentation-metadata><name>TOC Heading Levels</name><value>2</value></presentation-metadata><presentation-metadata><name>HTML TOC Heading Levels</name><value>2</value></presentation-metadata><presentation-metadata><name>DOC TOC Heading Levels</name><value>2</value></presentation-metadata></metanorma-extension>
      <boilerplate><copyright-statement>

      <clause id="_ac978fe4-3697-abcd-2c35-fb5a0f0016e8" inline-header="false" obligation="normative">
      <p id="_5edf4f42-7b4e-8a0b-c2fa-f12199347c47" align="left">The Institute of Electrical and Electronics Engineers, Inc.  3 Park Avenue, New York, NY 10016-5997, USA</p>
      </clause>

      <clause id="_e03cf062-2da3-0866-a5c5-5f5d3bb31eed" inline-header="false" obligation="normative">
      <p id="_1620dc64-f069-f105-3984-9df0a1699ef1">Copyright © 2020 by The Institute of Electrical and Electronics Engineers, Inc.</p>

      <p id="_045e17df-8ed4-9f90-f275-11d64f7f6ca4">All rights reserved. 2929. Printed in the United States of America.</p>
      </clause>

      <clause id="_856c5c01-e499-6864-52d9-261b72d02061" inline-header="false" obligation="normative">
      <table id="_isbn_pdf_print" unnumbered="true"><thead><tr><th valign="top" align="left">PDF:</th>
      <th valign="top" align="left">ISBN ISBN 2</th>
      <th valign="top" align="left">STD 2</th>
      </tr></thead>
      <tbody><tr><td valign="top" align="left">Print:</td>
      <td valign="top" align="left">ISBN ISBN 3</td>
      <td valign="top" align="left">STD 3</td>
      </tr></tbody>
      </table>
      </clause>

      <clause id="_74775e1c-4918-cdfe-a1d5-893d6e182032" inline-header="false" obligation="normative">
      <p id="_e7338b59-dc75-69c1-7134-82364712614f">IEEE is a registered trademark in the U.S. Patent &amp; Trademark Office, owned by The Institute of Electrical and Electronics Engineers, Incorporated. All other trademarks are the property of the respective trademark owners.</p>
      </clause>

      <clause id="_103cf355-3179-e8fb-d9a3-069e25f787d0" inline-header="false" obligation="normative">
      <p id="_7703c817-5c5b-1691-5924-66c3cdccea5f">IEEE prohibits discrimination, harassment, and bullying.<br/>
      For more information, visit <link target="https://www.ieee.org/about/corporate/governance/p9-26.html"/>.</p>

      <p id="_6a9c8211-4969-dcf5-082a-35753fe09366">No part of this publication may be reproduced in any form, in an electronic retrieval system or otherwise, without the prior written permission of the publisher.</p>

      <p id="_61975d88-5749-8438-098e-f8ef9880bda6">Find IEEE standards and standards-related product listings at: <link target="http://standards.ieee.org"/>.</p>
      </clause>
      </copyright-statement>

      <legal-statement>

      <clause id="boilerplate-tm" inline-header="false" obligation="normative">
      <fmt-title id="_">Trademarks and Disclaimers</fmt-title>
      <p id="_2943a585-5a3a-9f8c-8335-61aa7e36237a">IEEE believes the information in this publication is accurate as of its publication date; such information is subject to change without notice. IEEE is not responsible for any inadvertent errors.</p>
      <p id="_22abb8b0-f41d-a114-18a7-6c32b1cb6505">The ideas and proposals in this specification are the respective author’s views and do not represent the views of the affiliated organization.</p>
      </clause>

      <clause id="boilerplate-disclaimers" inline-header="false" obligation="normative">
      <fmt-title id="_">Notice and Disclaimer of Liability Concerning the Use of IEEE SA Documents</fmt-title>
      <p id="_de579a5e-46f6-6692-c0e2-b5d0be40cded">This IEEE Standards Association (“IEEE SA”) publication (“Work”) is not a consensus standard document. Specifically, this document is NOT AN IEEE STANDARD. Information contained in this Work has been created by, or obtained from, sources believed to be reliable, and reviewed by members of the activity that produced this Work. IEEE and the NAME OF GROUP expressly disclaim all warranties (express, implied, and statutory) related to this Work, including, but not limited to, the warranties of: merchantability; fitness for a particular purpose; non-infringement; quality, accuracy, effectiveness, currency, or completeness of the Work or content within the Work. In addition, IEEE and the NAME OF GROUP disclaim any and all conditions relating to: results; and workmanlike effort. This document is supplied “AS IS” and “WITH ALL FAULTS.”</p>

      <p id="_c3569df8-1d60-fbcd-1906-839532e2b00c">Although the NAME OF GROUP members who have created this Work believe that the information and guidance given in this Work serve as an enhancement to users, all persons must rely upon their own skill and judgment when making use of it. IN NO EVENT SHALL IEEE SA OR NAME OF GROUP MEMBERS BE LIABLE FOR ANY ERRORS OR OMISSIONS OR DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO: PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS WORK, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE AND REGARDLESS OF WHETHER SUCH DAMAGE WAS FORESEEABLE.</p>

      <p id="_1576a8b3-eb38-b0fe-b250-0b334d20d6d1">Further, information contained in this Work may be protected by intellectual property rights held by third parties or organizations, and the use of this information may require the user to negotiate with any such rights holders in order to legally acquire the rights to do so, and such rights holders may refuse to grant such rights. Attention is also called to the possibility that implementation of any or all of this Work may require use of subject matter covered by patent rights. By publication of this Work, no position is taken by the IEEE with respect to the existence or validity of any patent rights in connection therewith. The IEEE is not responsible for identifying patent rights for which a license may be required, or for conducting inquiries into the legal validity or scope of patents claims. Users are expressly advised that determination of the validity of any patent rights, and the risk of infringement of such rights, is entirely their own responsibility. No commitment to grant licenses under patent rights on a reasonable or non-discriminatory basis has been sought or received from any rights holder.</p>

      <p id="_d451393b-d570-5fcd-1d1f-1556d8303ec5">This Work is published with the understanding that IEEE and the NAME OF GROUP members are supplying information through this Work, not attempting to render engineering or other professional services. If such services are required, the assistance of an appropriate professional should be sought. IEEE is not responsible for the statements and opinions advanced in this Work.</p>
      </clause>

      <clause id="boilerplate-participants" inline-header="false" obligation="normative">
      <fmt-title id="_">Acknowledgements</fmt-title>
      <clause id="boilerplate-participants-blank" inline-header="false" obligation="normative">
      <p id="_dd7f13f9-b62e-c727-143c-579781e427bd">Special thanks are given to the following reviewers of this paper:</p>


      <ul id="_e115cc7e-7367-265f-c4c7-8d5a7b88bb9b"><li><dl id="_e0c28df8-965b-f5f0-9506-268d01c09788"><dt>name</dt><dd><p id="_99ba8045-d32b-0b43-3e2a-122011255691">Balloter1</p></dd><dt>role</dt><dd><p id="_52405e54-3177-faed-535c-42aec7e9e3d9">Member</p></dd></dl>
      </li>
      <li><dl id="_c07d5b71-2952-3458-82a9-9b3a70d647dc"><dt>name</dt><dd><p id="_5ddb8faf-3e66-4121-0aa5-8f771a01c98c">Balloter2</p></dd><dt>role</dt><dd><p id="_9aa67092-ebff-f324-6d07-dcd911c748d1">Member</p></dd></dl>
      </li>
      <li><dl id="_2adbb6b4-73e5-d040-add5-0010102edd81"><dt>name</dt><dd><p id="_3dffac91-2ec7-13c3-54f6-2122c6adfac1">Balloter3</p></dd><dt>role</dt><dd><p id="_3fb59b8e-30bf-6bcf-a8d7-426bf218e43a">Member</p></dd></dl>
      </li>
      <li><dl id="_5d397b50-b99f-018d-cfab-025e32a57c1f"><dt>name</dt><dd><p id="_b0e8e7e1-086a-4db5-09d9-6c30fecfa612">Balloter4</p></dd><dt>role</dt><dd><p id="_83f512bf-f564-b093-6a2b-1c71acbd2b27">Member</p></dd></dl>
      </li>
      <li><dl id="_8357eaf1-41bd-a5c1-c2b4-f81e226e01ba"><dt>name</dt><dd><p id="_e3a14bce-23a3-686a-9f01-a16f2ace304c">Balloter5</p></dd><dt>role</dt><dd><p id="_e85a0b35-1575-eabd-7c69-ead0aa26e35a">Member</p></dd></dl>
      </li>
      <li><dl id="_79eea843-62bb-045c-fed6-2f3984d30c99"><dt>name</dt><dd><p id="_b8c35909-7e7e-76de-65c2-10ddf3611ada">Balloter6</p></dd><dt>role</dt><dd><p id="_8ad56939-4aef-5fcf-9906-4be5c10e3ee4">Member</p></dd></dl>
      </li>
      <li><dl id="_fe579002-5af4-2add-d6a1-80e735b3dd2b"><dt>name</dt><dd><p id="_bcf2bd7d-7ec8-ac8f-dae7-2dc74e9942ad">Balloter7</p></dd><dt>role</dt><dd><p id="_885731af-6a15-aba4-d524-af359305b99f">Member</p></dd></dl>
      </li>
      <li><dl id="_db20e333-7892-a797-d4a9-056dec9d5f98"><dt>name</dt><dd><p id="_35df4a25-5415-4faf-550a-883dbfa084fc">Balloter8</p></dd><dt>role</dt><dd><p id="_142b15ba-782a-e129-14c1-c46925e20d22">Member</p></dd></dl>
      </li>
      <li><dl id="_a2c31281-dca1-482f-ad20-287a3e6e83d8"><dt>name</dt><dd><p id="_f4af8454-59ea-b560-24b5-dc74d7de0821">Balloter9</p></dd><dt>role</dt><dd><p id="_78500054-c220-8465-4ab3-428affd08cf3">Member</p></dd></dl>
      </li>
      </ul>

      </clause>
      </clause>
      </legal-statement>
      </boilerplate>
            <sections><clause id="_clause" inline-header="false" obligation="normative" displayorder="1">
            <fmt-title id="_">Clause</fmt-title>
            <p id="_2e901de4-4c14-e534-d135-862a24df22ee">Hello</p>
            </clause>
            </sections>
      </ieee-standard>
    INPUT
    word = <<~OUTPUT
           <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US">
         <div class="WordSection1">
           <p class="MsoBodyText">
             <span lang="EN-US" style="mso-no-proof:yes" xml:lang="EN-US">
               <a name="_" id="_"/>
             </span>
           </p>
           <p class="MsoBodyText">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <p class="MsoBodyText">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <p class="MsoBodyText">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <p class="MsoBodyText"/>
           <p class="MsoBodyText">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <p class="MsoBodyText">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <p class="MsoBodyText">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <p class="MsoBodyText">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <p class="MsoBodyText">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <p class="StyleHeading3Left175" style="margin-right:7.2pt">
             <span lang="EN-US" style="font-family:&quot;Arial Black&quot;,sans-serif" xml:lang="EN-US">NAME OF PROGRAM<p class="MsoNormal"/></span>
           </p>
           <p class="MsoBodyText">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <p class="Titleline" style="margin-right:7.2pt">
             <a name="_" id="_"/>
             <a name="_" id="_"/>
             <a name="_" id="_"/>
             <a name="_" id="_"/>
             <a name="_" id="_">
               <span style="mso-bookmark:_Toc46424326">
                 <span style="mso-bookmark:_Toc45554015">
                   <span style="mso-bookmark:_Toc45552042">
                     <span style="mso-bookmark:_Toc45551699">
                       <span lang="EN-US" xml:lang="EN-US">Paper Title</span>
                     </span>
                   </span>
                 </span>
               </span>
             </a>
           </p>
           <p class="MsoBodyText">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <p class="MsoBodyText">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <p class="AuthoredbyCover" style="margin-right:7.2pt">
             <span lang="EN-US" xml:lang="EN-US">Authored
       by</span>
           </p>
           <p class="AuthoredbyCover" style="margin-right:7.2pt">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <p class="Authornames" style="margin-right:7.2pt">
             <span class="SpellE">
               <span lang="EN-US" xml:lang="EN-US">Y X</span>
             </span>
           </p>
           <p class="Authornames" style="margin-right:7.2pt">
             <i style="mso-bidi-font-style:                         normal">
               <span lang="EN-US" xml:lang="EN-US">Z<p class="MsoNormal"/></span>
             </i>
           </p>
           <p class="Authornames" style="margin-right:7.2pt">
             <span class="SpellE">
               <span lang="EN-US" xml:lang="EN-US">Y1 X1</span>
             </span>
           </p>
           <p class="Authornames" style="margin-right:7.2pt">
             <i style="mso-bidi-font-style:                         normal">
               <span lang="EN-US" xml:lang="EN-US">Z1<p class="MsoNormal"/></span>
             </i>
           </p>
           <p class="names" style="margin-right:7.2pt">
             <div v:shape="Text_x0020_Box_x0020_46" style="padding:0pt 0pt 0pt 0pt" class="shape">
               <p class="MsoBodyText">
                 <span lang="EN-US" xml:lang="EN-US">3 Park Avenue | New <span style="letter-spacing:-.2pt">York, </span>NY 10016-5997 | USA</span>
               </p>
             </div>
             <span lang="EN-US" xml:lang="EN-US">
               <br clear="all" style="mso-special-character:line-break;page-break-before: always"/>
             </span>
           </p>
           <div>
             <a name="boilerplate-tm" id="boilerplate-tm"/>
             <p class="Unnumberedheading">Trademarks and Disclaimers</p>
             <p class="Disclaimertext"><a name="_" id="_"/>IEEE believes the information in this publication is accurate as of its publication date; such information is subject to change without notice. IEEE is not responsible for any inadvertent errors.</p>
             <p class="Disclaimertext"><a name="_" id="_"/>The ideas and proposals in this specification are the respective author’s views and do not represent the views of the affiliated organization.</p>
           </div>
           <div>
             <a name="boilerplate-participants" id="boilerplate-participants"/>
             <p class="Unnumberedheading">Acknowledgements</p>
             <div>
               <a name="boilerplate-participants-blank" id="boilerplate-participants-blank"/>
               <p class="MsoBodyText"><a name="_" id="_"/>Special thanks are given to the following reviewers of this paper:</p>
               <p class="IEEEnames">Balloter1</p>
               <p class="IEEEnames">Balloter2</p>
               <p class="IEEEnames">Balloter3</p>
               <p class="IEEEnames">Balloter4</p>
               <p class="IEEEnames">Balloter5</p>
               <p class="IEEEnames">Balloter6</p>
               <p class="IEEEnames">Balloter7</p>
               <p class="IEEEnames">Balloter8</p>
               <p class="IEEEnames">Balloter9</p>
             </div>
           </div>
           <div>
             <a name="boilerplate-feedback-destination" id="boilerplate-feedback-destination"/>
           </div>
           <!--<span lang="EN-US" style='font-size:11.0pt;mso-bidi-font-size:10.0pt;line-height:
       150%;font-family:"Calibri",sans-serif;mso-fareast-font-family:Calibri;
       mso-ansi-language:EN-US;mso-fareast-language:EN-US;mso-bidi-language:AR-SA'><br
       clear="all" style='mso-special-character:line-break;page-break-before:always'/>
       </span>-->
           <p class="MsoBodyText">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <div class="boilerplate-copyright">
             <div>
               <a name="_" id="_"/>
               <p style="text-align:left;" align="left" class="CopyrightInformationPage"><a name="_" id="_"/>The Institute of Electrical and Electronics Engineers, Inc.  3 Park Avenue, New York, NY 10016-5997, USA</p>
             </div>
             <div>
               <a name="_" id="_"/>
               <p class="CopyrightInformationPage"><a name="_" id="_"/>Copyright © 2020 by The Institute of Electrical and Electronics Engineers, Inc.</p>
               <p class="CopyrightInformationPage"><a name="_" id="_"/>All rights reserved. 2929. Printed in the United States of America.</p>
             </div>
             <div>
               <a name="_" id="_"/>
               <div align="center" class="table_container">
                 <p class="CopyrightInformationPage" align="left">Print:<span style="mso-tab-count:1"/>ISBN ISBN 3<span style="mso-tab-count:1"/>STD 3</p>
               </div>
             </div>
             <div>
               <a name="_" id="_"/>
               <p class="CopyrightInformationPage"><a name="_" id="_"/>IEEE is a registered trademark in the U.S. Patent  Trademark Office, owned by The Institute of Electrical and Electronics Engineers, Incorporated. All other trademarks are the property of the respective trademark owners.</p>
             </div>
             <div>
               <a name="_" id="_"/>
               <p class="CopyrightInformationPage"><a name="_" id="_"/>IEEE prohibits discrimination, harassment, and bullying.<br/>
       For more information, visit <a href="https://www.ieee.org/about/corporate/governance/p9-26.html">https://www.ieee.org/about/corporate/governance/p9-26.html</a>.</p>
               <p class="CopyrightInformationPage"><a name="_" id="_"/>No part of this publication may be reproduced in any form, in an electronic retrieval system or otherwise, without the prior written permission of the publisher.</p>
               <p class="CopyrightInformationPage"><a name="_" id="_"/>Find IEEE standards and standards-related product listings at: <a href="http://standards.ieee.org">http://standards.ieee.org</a>.</p>
             </div>
           </div>
           <div>
             <a name="boilerplate-license-destination" id="boilerplate-license-destination"/>
           </div>
           <br clear="all" style="mso-special-character:line-break;page-break-before: always"/>
           <div>
             <a name="boilerplate-disclaimers" id="boilerplate-disclaimers"/>
             <p class="Unnumberedheading">Notice and Disclaimer of Liability Concerning the Use of IEEE SA Documents</p>
             <p class="Disclaimertext"><a name="_" id="_"/>This IEEE Standards Association (“IEEE SA”) publication (“Work”) is not a consensus standard document. Specifically, this document is NOT AN IEEE STANDARD. Information contained in this Work has been created by, or obtained from, sources believed to be reliable, and reviewed by members of the activity that produced this Work. IEEE and the NAME OF GROUP expressly disclaim all warranties (express, implied, and statutory) related to this Work, including, but not limited to, the warranties of: merchantability; fitness for a particular purpose; non-infringement; quality, accuracy, effectiveness, currency, or completeness of the Work or content within the Work. In addition, IEEE and the NAME OF GROUP disclaim any and all conditions relating to: results; and workmanlike effort. This document is supplied “AS IS” and “WITH ALL FAULTS.”</p>
             <p class="Disclaimertext"><a name="_" id="_"/>Although the NAME OF GROUP members who have created this Work believe that the information and guidance given in this Work serve as an enhancement to users, all persons must rely upon their own skill and judgment when making use of it. IN NO EVENT SHALL IEEE SA OR NAME OF GROUP MEMBERS BE LIABLE FOR ANY ERRORS OR OMISSIONS OR DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO: PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS WORK, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE AND REGARDLESS OF WHETHER SUCH DAMAGE WAS FORESEEABLE.</p>
             <p class="Disclaimertext"><a name="_" id="_"/>Further, information contained in this Work may be protected by intellectual property rights held by third parties or organizations, and the use of this information may require the user to negotiate with any such rights holders in order to legally acquire the rights to do so, and such rights holders may refuse to grant such rights. Attention is also called to the possibility that implementation of any or all of this Work may require use of subject matter covered by patent rights. By publication of this Work, no position is taken by the IEEE with respect to the existence or validity of any patent rights in connection therewith. The IEEE is not responsible for identifying patent rights for which a license may be required, or for conducting inquiries into the legal validity or scope of patents claims. Users are expressly advised that determination of the validity of any patent rights, and the risk of infringement of such rights, is entirely their own responsibility. No commitment to grant licenses under patent rights on a reasonable or non-discriminatory basis has been sought or received from any rights holder.</p>
             <p class="Disclaimertext"><a name="_" id="_"/>This Work is published with the understanding that IEEE and the NAME OF GROUP members are supplying information through this Work, not attempting to render engineering or other professional services. If such services are required, the assistance of an appropriate professional should be sought. IEEE is not responsible for the statements and opinions advanced in this Work.</p>
           </div>
           <p class="MsoBodyText"> </p>
         </div>
         <p class="MsoBodyText">
           <br clear="all" class="section"/>
         </p>
         <div class="WordSection2">
           <p class="MsoToc3" style="margin-right:7.2pt"/>
           <div style="margin-left:130.5pt;tab-stops:right dotted 510.7pt"/>
           <div class="authority">
             <div class="boilerplate-legal"/>
           </div>
           <p class="MsoBodyText"> </p>
         </div>
         <p class="MsoBodyText">
           <br clear="all" class="section"/>
         </p>
         <div class="WordSection3">
           <p class="Titleofdocument" style="margin-left:0cm;margin-top:70.0pt">Whitepaper for Paper Title</p>
           <wrapblock/>
           <br style="mso-ignore:vglayout" clear="ALL"/>
           <p class="MsoBodyText"/>
           <div>
             <a name="_" id="_"/>
             <p class="IEEESectionHeader">Clause</p>
             <p class="MsoBodyText"><a name="_" id="_"/>Hello</p>
           </div>
         </div>
         <p class="MsoBodyText">
           <br clear="all" class="section"/>
         </p>
         <div class="WordSection4">
           <p class="MsoBodyText">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <p class="MsoBodyText">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <p class="MsoBodyText">
             <span lang="EN-US" xml:lang="EN-US">
               <p class="MsoNormal"> </p>
             </span>
           </p>
           <p class="MsoBodyText"/>
           <p class="Titleline" style="margin-right:7.2pt">
             <wrapblock/>
             <br style="mso-ignore:vglayout" clear="ALL">
               <a name="_" id="_"/>
               <a name="_" id="_"/>
               <a name="_" id="_"/>
               <a name="_" id="_"/>
               <a name="_" id="_">
                 <span style="mso-bookmark:_Toc45554030">
                   <span style="mso-bookmark:_Toc45552713">
                     <span style="mso-bookmark:_Toc45552056">
                       <span style="mso-bookmark:_Toc45551731">
                         <span lang="EN-US" xml:lang="EN-US">RAISING THE WORLD’S
       STANDARDS</span>
                       </span>
                     </span>
                   </span>
                 </span>
               </a>
             </br>
             <p class="BackCover" style="margin-right:7.2pt">
               <span lang="EN-US" xml:lang="EN-US">
                 <p class="MsoNormal"> </p>
               </span>
             </p>
             <p class="MsoBodyText">
               <span lang="EN-US" xml:lang="EN-US">
                 <p class="MsoNormal"> </p>
               </span>
             </p>
             <p class="MsoBodyText">
               <span lang="EN-US" xml:lang="EN-US">
                 <p class="MsoNormal"> </p>
               </span>
             </p>
             <p class="MsoBodyText">
               <span lang="EN-US" xml:lang="EN-US">
                 <p class="MsoNormal"> </p>
               </span>
             </p>
             <p class="MsoBodyText">
               <span lang="EN-US" xml:lang="EN-US">
                 <p class="MsoNormal"> </p>
               </span>
             </p>
             <p class="MsoBodyText">
               <span lang="EN-US" xml:lang="EN-US">
                 <p class="MsoNormal"> </p>
               </span>
             </p>
             <p class="MsoBodyText">
               <span lang="EN-US" xml:lang="EN-US">
                 <p class="MsoNormal"> </p>
               </span>
             </p>
             <p class="MsoBodyText">
               <span lang="EN-US" xml:lang="EN-US">
                 <p class="MsoNormal"> </p>
               </span>
             </p>
             <p class="MsoBodyText">
               <span lang="EN-US" xml:lang="EN-US">
                 <p class="MsoNormal"> </p>
               </span>
             </p>
             <p class="MsoBodyText">
               <span lang="EN-US" xml:lang="EN-US">
                 <p class="MsoNormal"> </p>
               </span>
             </p>
             <p class="MsoBodyText">
               <span lang="EN-US" xml:lang="EN-US">
                 <p class="MsoNormal"> </p>
               </span>
             </p>
             <p class="MsoBodyText">
               <span lang="EN-US" xml:lang="EN-US">
                 <p class="MsoNormal"> </p>
               </span>
             </p>
             <p class="MsoBodyText" style="text-indent:126.0pt;line-height:normal">
               <span lang="EN-US" xml:lang="EN-US">3 Park Avenue, New York, NY 10016-5997 USA<span style="mso-spacerun:yes">  </span><a href="http://standards.ieee.org/"><span style="color:#00B0F0;text-decoration:none;text-underline:none"><span style="mso-spacerun:yes"> </span></span><span style="color:#00A9E9">http://standards.ieee.org</span></a></span>
             </p>
             <p class="MsoBodyText" style="text-indent:126.0pt;line-height:normal">
               <span lang="EN-US" xml:lang="EN-US">Tel.+1732-981-0060 Fax+1732-562-1571</span>
             </p>
           </p>
         </div>
         <div style="mso-element:footnote-list"/>
       </body>
    OUTPUT
    presxml = IsoDoc::Ieee::PresentationXMLConvert.new(presxml_options)
      .convert("test", input.sub("<doctype>standard</doctype>",
                                 "<doctype>whitepaper</doctype>"), true)
    IsoDoc::Ieee::WordConvert.new({}).convert("test", presxml, false)
    expect(File.exist?("test.doc")).to be true
    doc = Nokogiri::XML(word2xml("test.doc"))
      .at("//xmlns:body")
    doc.at("//xmlns:div[@class = 'WordSectionContents']")&.remove
    doc.xpath("//xmlns:p[@class = 'MsoToc1']").each(&:remove)
    doc.xpath("//v:shape | //v:shapetype | //v:rect | //v:line | //v:group",
              "v" => "urn:schemas-microsoft-com:vml").each(&:remove)
    expect(strip_guid(Canon.format_xml(doc.to_xml)))
      .to be_equivalent_to Canon.format_xml(word)
  end
end
