require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::IEEE do
  before(:all) do
    @blank_hdr = blank_hdr_gen
  end

  it "inserts boilerplate in front of sections" do
    input = <<~INPUT
      = Widgets
      Author
      :docfile: test.adoc
      :nodoc:
      :draft: 1.2
      :docnumber: 10000
      :doctype: recommended-practice
      :issued-date: 1000-01-01

      == Clause 1
    INPUT
    output = <<~OUTPUT
      <boilerplate>
         <copyright-statement>
           <clause>
             <p id='copyright' align='left'>
               Copyright © #{Date.today.year} by The Institute of Electrical and Electronics
               Engineers, Inc.
               <br/>
               Three Park Avenue
               <br/>
               New York, New York 10016-5997, USA
             </p>
             <p id='_'>All rights reserved.</p>
           </clause>
         </copyright-statement>
         <license-statement>
           <clause>
             <p id='_'>
               This document is an unapproved draft of a proposed IEEE Standard. As
               such, this document is subject to change. USE AT YOUR OWN RISK! IEEE
               copyright statements SHALL NOT BE REMOVED from draft or approved IEEE
               standards, or modified in any way. Because this is an unapproved draft,
               this document must not be utilized for any conformance/compliance
               purposes. Permission is hereby granted for officers from each IEEE
               Standards Working Group or Committee to reproduce the draft document
               developed by that Working Group for purposes of international
               standardization consideration. IEEE Standards Department must be
               informed of the submission for consideration prior to any reproduction
               for international standardization consideration (
               <link target='mailto:stds-ipr@ieee.org'/>
               ). Prior to adoption of this document, in whole or in part, by another
               standards development organization, permission must first be obtained
               from the IEEE Standards Department (
               <link target='mailto:stds-ipr@ieee.org'/>
               ). When requesting permission, IEEE Standards Department will require a
               copy of the standard development organization’s document highlighting
               the use of IEEE content. Other entities seeking permission to reproduce
               this document, in whole or in part, must also obtain permission from the
               IEEE Standards Department.
             </p>
             <p align='left' id='_'>
               IEEE Standards Department
               <br/>
                445 Hoes Lane
               <br/>
                Piscataway, NJ 08854, USA
             </p>
           </clause>
         </license-statement>
         <legal-statement>
           <clause id='boilerplate-disclaimers'>
             <title>Important Notices and Disclaimers Concerning IEEE Standards Documents</title>
             <p id='_'>
               IEEE Standards documents are made available for use subject to important
               notices and legal disclaimers. These notices and disclaimers, or a
               reference to this page (
               <link target='https://standards.ieee.org/ipr/disclaimers.html'/>
               ), appear in all standards and may be found under the heading “Important
               Notices and Disclaimers Concerning IEEE Standards Documents.”
             </p>
             <clause>
               <title>
                 Notice and Disclaimer of Liability Concerning the Use of IEEE
                 Standards Documents
               </title>
               <p id='_'>
                 IEEE Standards documents are developed within the IEEE Societies and
                 the Standards Coordinating Committees of the IEEE Standards
                 Association (IEEE SA) Standards Board. IEEE develops its standards
                 through an accredited consensus development process, which brings
                 together volunteers representing varied viewpoints and interests to
                 achieve the final product. IEEE Standards are documents developed by
                 volunteers with scientific, academic, and industry-based expertise in
                 technical working groups. Volunteers are not necessarily members of
                 IEEE or IEEE SA, and participate without compensation from IEEE. While
                 IEEE administers the process and establishes rules to promote fairness
                 in the consensus development process, IEEE does not independently
                 evaluate, test, or verify the accuracy of any of the information or
                 the soundness of any judgments contained in its standards.
               </p>
               <p id='_'>
                 IEEE makes no warranties or representations concerning its standards,
                 and expressly disclaims all warranties, express or implied, concerning
                 this standard, including but not limited to the warranties of
                 merchantability, fitness for a particular purpose and
                 non-infringement. In addition, IEEE does not warrant or represent that
                 the use of the material contained in its standards is free from patent
                 infringement. IEEE standards documents are supplied “AS IS” and “WITH
                 ALL FAULTS.”
               </p>
               <p id='_'>
                 Use of an IEEE standard is wholly voluntary. The existence of an IEEE
                 Standard does not imply that there are no other ways to produce, test,
                 measure, purchase, market, or provide other goods and services related
                 to the scope of the IEEE standard. Furthermore, the viewpoint
                 expressed at the time a standard is approved and issued is subject to
                 change brought about through developments in the state of the art and
                 comments received from users of the standard.
               </p>
               <p id='_'>
                 In publishing and making its standards available, IEEE is not
                 suggesting or rendering professional or other services for, or on
                 behalf of, any person or entity, nor is IEEE undertaking to perform
                 any duty owed by any other person or entity to another. Any person
                 utilizing any IEEE Standards document, should rely upon his or her own
                 independent judgment in the exercise of reasonable care in any given
                 circumstances or, as appropriate, seek the advice of a competent
                 professional in determining the appropriateness of a given IEEE
                 standard.
               </p>
               <p id='_'>
                 IN NO EVENT SHALL IEEE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
                 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
                 LIMITED TO: THE NEED TO PROCURE SUBSTITUTE GOODS OR SERVICES; LOSS OF
                 USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
                 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
                 TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
                 PUBLICATION, USE OF, OR RELIANCE UPON ANY STANDARD, EVEN IF ADVISED OF
                 THE POSSIBILITY OF SUCH DAMAGE AND REGARDLESS OF WHETHER SUCH DAMAGE
                 WAS FORESEEABLE.
               </p>
             </clause>
             <clause>
               <title>Translations</title>
               <p id='_'>
                 The IEEE consensus development process involves the review of
                 documents in English only. In the event that an IEEE standard is
                 translated, only the English version published by IEEE is the approved
                 IEEE standard.
               </p>
             </clause>
             <clause>
               <title>Official statements</title>
               <p id='_'>
                 A statement, written or oral, that is not processed in accordance with
                 the IEEE SA Standards Board Operations Manual shall not be considered
                 or inferred to be the official position of IEEE or any of its
                 committees and shall not be considered to be, nor be relied upon as, a
                 formal position of IEEE. At lectures, symposia, seminars, or
                 educational courses, an individual presenting information on IEEE
                 standards shall make it clear that the presenter’s views should be
                 considered the personal views of that individual rather than the
                 formal position of IEEE, IEEE SA, the Standards Committee, or the
                 Working Group.
               </p>
             </clause>
             <clause>
               <title>Comments on standards</title>
               <p id='_'>
                 Comments for revision of IEEE Standards documents are welcome from any
                 interested party, regardless of membership affiliation with IEEE or
                 IEEE SA. However, 
                 <strong>
                   IEEE does not provide interpretations, consulting information, or
                   advice pertaining to IEEE Standards documents
                 </strong>
                 .
               </p>
               <p id='_'>
                 Suggestions for changes in documents should be in the form of a
                 proposed change of text, together with appropriate supporting
                 comments. Since IEEE standards represent a consensus of concerned
                 interests, it is important that any responses to comments and
                 questions also receive the concurrence of a balance of interests. For
                 this reason, IEEE and the members of its Societies and Standards
                 Coordinating Committees are not able to provide an instant response to
                 comments, or questions except in those cases where the matter has
                 previously been addressed. For the same reason, IEEE does not respond
                 to interpretation requests. Any person who would like to participate
                 in evaluating comments or in revisions to an IEEE standard is welcome
                 to join the relevant IEEE working group. You can indicate interest in
                 a working group using the Interests tab in the Manage Profile &#x26;
                 Interests area of the 
                 <link target='https://development.standards.ieee.org/myproject-web/public/view.html#landing'>IEEE SA myProject system</link>
                 .
                 <fn reference='_boilerplate_1'>
                   <p id='_'>
                     Available at: 
                     <link target='https://development.standards.ieee.org/myproject-web/public/view.html#landing'/>
                     .
                   </p>
                 </fn>
                  An IEEE Account is needed to access the application.
               </p>
               <p id='_'>
                 Comments on standards should be submitted using the 
                 <link target='https://standards.ieee.org/content/ieee-standards/en/about/contact/index.html'>Contact Us</link>
                  form.
                 <fn reference='_boilerplate_2'>
                   <p id='_'>
                     Available at: 
                     <link target='https://standards.ieee.org/content/ieee-standards/en/about/contact/index.html'/>
                     .
                   </p>
                 </fn>
               </p>
             </clause>
             <clause>
               <title>Laws and regulations</title>
               <p id='_'>
                 Users of IEEE Standards documents should consult all applicable laws
                 and regulations. Compliance with the provisions of any IEEE Standards
                 document does not constitute compliance to any applicable regulatory
                 requirements. Implementers of the standard are responsible for
                 observing or referring to the applicable regulatory requirements. IEEE
                 does not, by the publication of its standards, intend to urge action
                 that is not in compliance with applicable laws, and these documents
                 may not be construed as doing so.
               </p>
             </clause>
             <clause>
               <title>Data privacy</title>
               <p id='_'>
                 Users of IEEE Standards documents should evaluate the standards for
                 considerations of data privacy and data ownership in the context of
                 assessing and using the standards in compliance with applicable laws
                 and regulations.
               </p>
             </clause>
             <clause>
               <title>Copyrights</title>
               <p id='_'>
                 IEEE draft and approved standards are copyrighted by IEEE under US and
                 international copyright laws. They are made available by IEEE and are
                 adopted for a wide variety of both public and private uses. These
                 include both use, by reference, in laws and regulations, and use in
                 private self-regulation, standardization, and the promotion of
                 engineering practices and methods. By making these documents available
                 for use and adoption by public authorities and private users, IEEE
                 does not waive any rights in copyright to the documents.
               </p>
             </clause>
             <clause>
               <title>Photocopies</title>
               <p id='_'>
                 Subject to payment of the appropriate licensing fees, IEEE will grant
                 users a limited, non-exclusive license to photocopy portions of any
                 individual standard for company or organizational internal use or
                 individual, non-commercial use only. To arrange for payment of
                 licensing fees, please contact Copyright Clearance Center, Customer
                 Service, 222 Rosewood Drive, Danvers, MA 01923 USA; +1 978 750 8400;
                 https://www.copyright.com/. Permission to photocopy portions of any
                 individual standard for educational classroom use can also be obtained
                 through the Copyright Clearance Center.
               </p>
             </clause>
             <clause>
               <title>Updating of IEEE Standards documents</title>
               <p id='_'>
                 Users of IEEE Standards documents should be aware that these documents
                 may be superseded at any time by the issuance of new editions or may
                 be amended from time to time through the issuance of amendments,
                 corrigenda, or errata. An official IEEE document at any point in time
                 consists of the current edition of the document together with any
                 amendments, corrigenda, or errata then in effect.
               </p>
               <p id='_'>
                 Every IEEE standard is subjected to review at least every 10 years.
                 When a document is more than 10 years old and has not undergone a
                 revision process, it is reasonable to conclude that its contents,
                 although still of some value, do not wholly reflect the present state
                 of the art. Users are cautioned to check to determine that they have
                 the latest edition of any IEEE standard.
               </p>
               <p id='_'>
                 In order to determine whether a given document is the current edition
                 and whether it has been amended through the issuance of amendments,
                 corrigenda, or errata, visit 
                 <link target='https://ieeexplore.ieee.org/browse/standards/collection/ieee/'>IEEE Xplore</link>
                  or 
                 <link target='https://standards.ieee.org/content/ieee-standards/en/about/contact/index.html'>contact IEEE</link>
                 .
                 <fn reference='_boilerplate_3'>
                   <p id='_'>
                     Available at 
                     <link target='https://ieeexplore.ieee.org/browse/standards/collection/ieee'/>
                     .
                   </p>
                 </fn>
                  For more information about the IEEE SA or IEEE’s standards
                 development process, visit the IEEE SA Website.
               </p>
             </clause>
             <clause>
               <title>Errata</title>
               <p id='_'>
                 Errata, if any, for all IEEE standards can be accessed on the 
                 <link target='https://standards.ieee.org/standard/index.html'>IEEE SA Website</link>
                 .
                 <fn reference='_boilerplate_4'>
                   <p id='_'>
                     Available at: 
                     <link target='https://standards.ieee.org/standard/index.html'/>
                     .
                   </p>
                 </fn>
                  Search for standard number and year of approval to access the web
                 page of the published standard. Errata links are located under the
                 Additional Resources Details section. Errata are also available in 
                 <link target='https://ieeexplore.ieee.org/browse/standards/collection/ieee/'>IEEE Xplore</link>
                 . Users are encouraged to periodically check for errata.
               </p>
             </clause>
             <clause>
               <title>Patents</title>
               <p id='_'>
                 IEEE Standards are developed in compliance with the 
                 <link target='https://standards.ieee.org/about/sasb/patcom/materials.html'>IEEE SA Patent Policy</link>
                 .
                 <fn reference='_boilerplate_5'>
                   <p id='_'>
                     Available at: 
                     <link target='https://standards.ieee.org/about/sasb/patcom/materials.html'/>
                     .
                   </p>
                 </fn>
               </p>
               <p id='_'>
                 Attention is called to the possibility that implementation of this
                 standard may require use of subject matter covered by patent rights.
                 By publication of this standard, no position is taken by the IEEE with
                 respect to the existence or validity of any patent rights in
                 connection therewith. If a patent holder or patent applicant has filed
                 a statement of assurance via an Accepted Letter of Assurance, then the
                 statement is listed on the IEEE SA Website at 
                 <link target='https://standards.ieee.org/about/sasb/patcom/patents.html'/>
                 . Letters of Assurance may indicate whether the Submitter is willing
                 or unwilling to grant licenses under patent rights without
                 compensation or under reasonable rates, with reasonable terms and
                 conditions that are demonstrably free of any unfair discrimination to
                 applicants desiring to obtain such licenses.
               </p>
               <p id='_'>
                 Essential Patent Claims may exist for which a Letter of Assurance has
                 not been received. The IEEE is not responsible for identifying
                 Essential Patent Claims for which a license may be required, for
                 conducting inquiries into the legal validity or scope of Patents
                 Claims, or determining whether any licensing terms or conditions
                 provided in connection with submission of a Letter of Assurance, if
                 any, or in any licensing agreements are reasonable or
                 non-discriminatory. Users of this standard are expressly advised that
                 determination of the validity of any patent rights, and the risk of
                 infringement of such rights, is entirely their own responsibility.
                 Further information may be obtained from the IEEE Standards
                 Association.
               </p>
             </clause>
             <clause>
               <title>IMPORTANT NOTICE</title>
               <p id='_'>
                 IEEE Standards do not guarantee or ensure safety, security, health, or
                 environmental protection, or ensure against interference with or from
                 other devices or networks. IEEE Standards development activities
                 consider research and information presented to the standards
                 development group in developing any safety recommendations. Other
                 information about safety practices, changes in technology or
                 technology implementation, or impact by peripheral systems also may be
                 pertinent to safety considerations during implementation of the
                 standard. Implementers and users of IEEE Standards documents are
                 responsible for determining and complying with all appropriate safety,
                 security, environmental, health, and interference protection practices
                 and all applicable laws and regulations.
               </p>
             </clause>
           </clause>
           <clause id='boilerplate-participants'>
             <title>Participants</title>
             <clause id='boilerplate-participants-wg'>
               <p id='_'>
                 At the time this draft Recommended Practice was completed, the Working
                 Group had the following membership:
               </p>
               <ul id='_'>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>&#x3c;Chair Name&#x3e;</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Chair</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>&#x3c;Vice-chair Name&#x3e;</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Vice Chair</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Participant1</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Participant2</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Participant3</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Participant4</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Participant5</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Participant6</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Participant7</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Participant8</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Participant9</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
               </ul>
             </clause>
             <clause id='boilerplate-participants-bg'>
               <p id='_'>
                 The following members of the Standards Association balloting group
                 voted on this Recommended Practice. Balloters may have voted for
                 approval, disapproval, or abstention.
               </p>
               <ul id='_'>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Balloter1</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Balloter2</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Balloter3</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Balloter4</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Balloter5</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Balloter6</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Balloter7</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Balloter8</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>Balloter9</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
               </ul>
             </clause>
             <clause id='boilerplate-participants-sb'>
               <p id='_'>
                 When the IEEE SA Standards Board approved this Recommended Practice on
                 01 Jan 1000, it had the following membership:
               </p>
               <ul id='_'>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>&#x3c;Name&#x3e;</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Chair</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>&#x3c;Name&#x3e;</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Vice Chair</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>&#x3c;Name&#x3e;</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Past Chair</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>&#x3c;Name&#x3e;</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Secretary</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>SBMember1</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>SBMember2</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>SBMember3</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>SBMember4</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>SBMember5</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>SBMember6</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>SBMember7</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>SBMember8</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
                 <li>
                   <dl id='_'>
                     <dt>name</dt>
                     <dd>
                       <p id='_'>SBMember9</p>
                     </dd>
                     <dt>role</dt>
                     <dd>
                       <p id='_'>Member</p>
                     </dd>
                   </dl>
                 </li>
               </ul>
               <p type='emeritus_sign' id='_'>*Member Emeritus</p>
             </clause>
           </clause>
         </legal-statement>
         <feedback-statement>
           <clause>
             <p align='left' id='_'>
               The Institute of Electrical and Electronics Engineers, Inc.
               <br/>
                3 Park Avenue, New York, NY 10016-5997, USA
             </p>
           </clause>
           <clause>
             <p id='_'>Copyright © #{Date.today.year} by The Institute of Electrical and Electronics Engineers, Inc.</p>
             <p id='_'>
               All rights reserved. Published 01 Jan 1000. Printed in the United States
               of America.
             </p>
           </clause>
           <clause>
             <p id='_'>
               IEEE is a registered trademark in the U.S. Patent &#x26; Trademark
               Office, owned by The Institute of Electrical and Electronics Engineers,
               Incorporated.
             </p>
           </clause>
           <clause>
             <table unnumbered='true' id='_'>
               <tbody>
                 <tr>
                   <td>PDF:</td>
                   <td>ISBN 978-0-XXXX-XXXX-X</td>
                   <td>STDXXXXX</td>
                 </tr>
                 <tr>
                   <td>Print:</td>
                   <td>ISBN 978-0-XXXX-XXXX-X</td>
                   <td>STDPDXXXXX</td>
                 </tr>
               </tbody>
             </table>
           </clause>
           <clause>
             <p id='_'>
               <em>IEEE prohibits discrimination, harassment, and bullying.</em>
               <br/>
               <em>
                 For more information, visit 
                 <link target='https://www.ieee.org/about/corporate/governance/p9-26.html'/>
                 .
               </em>
               <br/>
               <em>
                 No part of this publication may be reproduced in any form, in an
                 electronic retrieval system or otherwise, without the prior written
                 permission of the publisher.
               </em>
             </p>
           </clause>
         </feedback-statement>
       </boilerplate>
    OUTPUT
    ret = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    ret.at("//xmlns:bibdata").remove
    ret = ret.at("//xmlns:boilerplate")
    expect(xmlpp(strip_guid(ret.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "does not insert boilerplate in front of sections if legacy document scheme nominated" do
    input = <<~INPUT
      = Widgets
      Author
      :docfile: test.adoc
      :nodoc:
      :draft: 1.2
      :docnumber: 10000
      :doctype: recommended-practice
      :issued-date: 1000-01-01
      :document-scheme: legacy

      == Clause 1
    INPUT
    output = <<~OUTPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
        <sections>
          <clause id='_' inline-header='false' obligation='normative'>
            <title>Clause 1</title>
          </clause>
        </sections>
      </ieee-standard>
    OUTPUT
    ret = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    ret.at("//xmlns:bibdata").remove
    expect(xmlpp(strip_guid(ret.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "inserts introduction boilerplate in front of sections" do
    input = <<~INPUT
      = Widgets
      Author
      :docfile: test.adoc
      :nodoc:
      :draft: 1.2
      :docnumber: 10000
      :doctype: recommended-practice

      == Introduction

      This is the introduction.

      [bibliography]
      == Normative References

      * [[[GHI,JKL]]]

      [appendix]
      == Appendix C

      [bibliography]
      === Bibliography

      * [[[ABC,DEF]]]
    INPUT
    output = <<~OUTPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
             <preface>
         <introduction id='_' obligation='informative'>
           <title>Introduction</title>
           <admonition>This introduction is not part of P10000/D1.2,
              Draft Recommended Practice for Widgets
            </admonition>
           <p id='_'>This is the introduction.</p>
         </introduction>
       </preface>
         <sections> </sections>
         <annex id='_' inline-header='false' obligation='normative'>
           <title>Appendix C</title>
           <references id='_' normative='false' obligation='informative'>
             <title>Bibliography</title>
             <p id='_'>
               Bibliographical references are resources that provide additional or
               helpful material but do not need to be understood or used to implement
               this standard. Reference to these resources is made for informational
               use only.
             </p>
             <bibitem id='ABC'>
               <formattedref format='application/x-isodoc+xml'/>
               <docidentifier>DEF</docidentifier>
               <docidentifier type='metanorma-ordinal'>[B1]</docidentifier>
             </bibitem>
           </references>
         </annex>
       <bibliography>
         <references id='_' normative='true' obligation='informative'>
           <title>Normative references</title>
           <p id='_'>
             The following referenced documents are indispensable for the application
             of this document (i.e., they must be understood and used, so each
             referenced document is cited in text and its relationship to this
             document is explained). For dated references, only the edition cited
             applies. For undated references, the latest edition of the referenced
             document (including any amendments or corrigenda) applies.
           </p>
           <bibitem id='GHI'>
             <formattedref format='application/x-isodoc+xml'/>
             <docidentifier>JKL</docidentifier>
           </bibitem>
         </references>
       </bibliography>
      </ieee-standard>
    OUTPUT
    ret = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    ret.at("//xmlns:bibdata").remove
    ret.at("//xmlns:boilerplate").remove
    expect(xmlpp(strip_guid(ret.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "inserts boilerplate note in front of sections for amendment" do
    input = <<~INPUT
      = Widgets
      Author
      :docfile: test.adoc
      :nodoc:
      :draft: 1.2
      :docnumber: 10000
      :doctype: recommended-practice
      :docsubtype: amendment

      == Clause

    INPUT
    output = <<~OUTPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
         <sections>
           <note id='boilerplate_front'>
             <p id='_'>
               The editing instructions contained in this amendment define how to merge
               the material contained therein into the existing base standard and its
               amendments to form the comprehensive standard.
             </p>
             <p id='_'>
               The editing instructions are shown in
               <strong>
                 <em>bold italic</em>
               </strong>
               . Four editing instructions are used: change, delete, insert, and
               replace.
               <strong>
                 <em>Change</em>
               </strong>
                is used to make corrections in existing text or tables. The editing
               instruction specifies the location of the change and describes what is
               being changed by using
               <strike>strikethrough</strike>
                (to remove old material) and
               <underline>underscore</underline>
                (to add new material).
               <strong>
                 <em>Delete</em>
               </strong>
                removes existing material.
               <strong>
                 <em>Insert</em>
               </strong>
                adds new material without disturbing the existing material. Insertions
               may require renumbering. If so, renumbering instructions are given in
               the editing instruction.
               <strong>
                 <em>Replace</em>
               </strong>
                is used to make changes in figures or equations by removing the
               existing figure or equation and replacing it with a new one. Editing
               instructions, change markings, and this NOTE will not be carried over
               into future editions because the changes will be incorporated into the
               base standard.
             </p>
           </note>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Clause</title>
           </clause>
         </sections>
       </ieee-standard>
    OUTPUT
    ret = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    ret.at("//xmlns:bibdata").remove
    ret.at("//xmlns:boilerplate").remove
    expect(xmlpp(strip_guid(ret.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "does not insert boilerplate in front of bibliography if already provided" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [appendix]
      == Appendix C

      [bibliography]
      === Bibliography

      [NOTE,type = boilerplate]
      This is boilerplate

      * [[[ABC,DEF]]]
    INPUT
    output = <<~OUTPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
         <sections> </sections>
         <annex id='_' inline-header='false' obligation='normative'>
           <title>Appendix C</title>
           <references id='_' normative='false' obligation='informative'>
             <title>Bibliography</title>
             <p id='_'>This is boilerplate</p>
             <bibitem id='ABC'>
               <formattedref format='application/x-isodoc+xml'/>
               <docidentifier>DEF</docidentifier><docidentifier type='metanorma-ordinal'>[B1]</docidentifier>
             </bibitem>
           </references>
         </annex>
       </ieee-standard>
    OUTPUT
    ret = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    ret.at("//xmlns:bibdata").remove
    ret.at("//xmlns:boilerplate").remove
    expect(xmlpp(strip_guid(ret.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "removes extraneous instances of overview clauses" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Overview

      === Scope

      === Purpose

      == Scope

      == Purpose

      == Overview

    INPUT
    output = <<~OUTPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
               <sections>
           <clause id='_' type='overview' inline-header='false' obligation='normative'>
             <title>Overview</title>
             <clause id='_' type='scope' inline-header='false' obligation='normative'>
               <title>Scope</title>
             </clause>
             <clause id='_' type='purpose' inline-header='false' obligation='normative'>
               <title>Purpose</title>
             </clause>
           </clause>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Scope</title>
           </clause>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Purpose</title>
           </clause>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Overview</title>
           </clause>
         </sections>
       </ieee-standard>
    OUTPUT
    ret = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    ret.at("//xmlns:bibdata").remove
    ret.at("//xmlns:boilerplate").remove
    ret.at("//xmlns:clause[@id = 'boilerplate_word_usage']").remove
    expect(xmlpp(strip_guid(ret.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "inserts footnote note on first note" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Overview

      NOTE: First note

      === Scope

      === Purpose

      == Scope

      NOTE: Second note

      == Purpose

      == Overview

    INPUT
    output = <<~OUTPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
         <sections>
           <clause id='_' type='overview' inline-header='false' obligation='normative'>
             <title>Overview</title>
             <note id='_'>
               <p id='_'>
                 First note
                 <fn reference='1'>
                   <p id='_'>Notes to text, tables, and figures are for information only and do
                    not contain requirements needed to implement the standard.</p>
                 </fn>
               </p>
             </note>
             <clause id='_' type='scope' inline-header='false' obligation='normative'>
               <title>Scope</title>
             </clause>
             <clause id='_' type='purpose' inline-header='false' obligation='normative'>
               <title>Purpose</title>
             </clause>
           </clause>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Scope</title>
             <note id='_'>
               <p id='_'>Second note</p>
             </note>
           </clause>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Purpose</title>
           </clause>
           <clause id='_' inline-header='false' obligation='normative'>
             <title>Overview</title>
           </clause>
         </sections>
       </ieee-standard>
    OUTPUT
    ret = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    ret.at("//xmlns:bibdata").remove
    ret.at("//xmlns:boilerplate").remove
    ret.at("//xmlns:clause[@id = 'boilerplate_word_usage']").remove
    expect(xmlpp(strip_guid(ret.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes footnotes" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      Hello!footnote:[Footnote text]

      Hello.footnote:abc[This is a repeated footnote]

      Repetition.footnote:abc[]
    INPUT
    output = <<~OUTPUT
      <sections>
        <p id='_'>
          Hello!
          <fn reference='1'>
            <p id='_'>Footnote text</p>
          </fn>
        </p>
        <p id='_'>
          Hello.
          <fn reference='2'>
            <p id='_'>This is a repeated footnote</p>
          </fn>
        </p>
        <p id='_'>
          Repetition.
          <fn reference='3'>
            <p id='_'>See Footnote 2.</p>
          </fn>
        </p>
      </sections>
    OUTPUT
    ret = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    expect(xmlpp(strip_guid(ret.at("//xmlns:sections").to_xml)))
      .to be_equivalent_to(xmlpp(output))
  end

  it "processes participants" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Participants

      === Working Group

      * {blank}
      +
      --
      name::: Socrates
      role::: Chair
      --
      * {blank}
      +
      --
      name::: Plato
      role::: Technical editor
      --
      * {blank}
      +
      --
      name::: Aristotle
      role::: Member
      --
      * Anaximander

      This is an additional clause.

      === Balloting Group

      * Athanasius of Alexandria
      * Basil of Caesarea

      And this is another list

      * {blank}
      company::: Microsoft
      * {blank}
      company::: Alphabet
      role::: Member

      === Standards Board

      item::
      name::: Aeschylus
      role::: Chair
      item::
      name::: Sophocles
      role::: Technical editor
      item::
      name::: Euripides
      item:: Aristophanes

      This is an additional clause.

      * {blank}
      company::: Waldorf-Astoria
      * {blank}
      company::: Ritz
      role::: Member

      And again:

      item:: name1
      item:: name2

    INPUT
    output = <<~OUTPUT
      <clause id='boilerplate-participants'>
         <title>Participants</title>
         <clause id='boilerplate-participants-wg'>
           <p id='_'>
             At the time this draft Standard was completed, the Working Group had the
             following membership:
           </p>
           <ul id='_'>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd/>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>member</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd/>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>member</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd/>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>member</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>
                   <p id='_'>Anaximander</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>member</p>
                 </dd>
               </dl>
             </li>
           </ul>
           <p id='_'>This is an additional clause.</p>
         </clause>
         <clause id='boilerplate-participants-bg'>
           <p id='_'>
             The following members of the Standards Association balloting group voted
             on this Standard. Balloters may have voted for approval, disapproval, or
             abstention.
           </p>
           <ul id='_'>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>
                   <p id='_'>Athanasius of Alexandria</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>member</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>
                   <p id='_'>Basil of Caesarea</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>member</p>
                 </dd>
               </dl>
             </li>
           </ul>
           <p id='_'>And this is another list</p>
           <ul id='_'>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd/>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>member</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd/>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>member</p>
                 </dd>
               </dl>
             </li>
           </ul>
         </clause>
         <clause id='boilerplate-participants-sb'>
           <p id='_'>
             When the IEEE SA Standards Board approved this Standard on &#x3c;Date
             Approved&#x3e;, it had the following membership:
           </p>
           <ul id='_'>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>
                   <p id='_'>Aeschylus</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>Chair</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>
                   <p id='_'>Sophocles</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>Technical editor</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>
                   <p id='_'>Euripides</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>member</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>
                   <p id='_'>Aristophanes</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>member</p>
                 </dd>
               </dl>
             </li>
           </ul>
           <p type='emeritus_sign' id='_'>*Member Emeritus</p>
           <p id='_'>This is an additional clause.</p>
           <ul id='_'>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd/>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>member</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd/>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>member</p>
                 </dd>
               </dl>
             </li>
           </ul>
           <p id='_'>And again:</p>
           <ul id='_'>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>
                   <p id='_'>name1</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>member</p>
                 </dd>
               </dl>
             </li>
             <li>
               <dl id='_'>
                 <dt>name</dt>
                 <dd>
                   <p id='_'>name2</p>
                 </dd>
                 <dt>role</dt>
                 <dd>
                   <p id='_'>member</p>
                 </dd>
               </dl>
             </li>
           </ul>
         </clause>
       </clause>
    OUTPUT
    ret = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
      .at("//xmlns:clause[@id = 'boilerplate-participants']")
    expect(xmlpp(strip_guid(ret.to_xml)))
      .to be_equivalent_to(xmlpp(output))
  end

  it "do not insert word usage clause if this is legacy document schema" do
    input = <<~INPUT
      = Widgets
      Author
      :docfile: test.adoc
      :nodoc:
      :draft: 1.2
      :docnumber: 10000
      :doctype: recommended-practice
      :issued-date: 1000-01-01
      :document-scheme: legacy

      .Foreword

      Text

      [abstract]
      == Abstract

      Text

      == Introduction

      === Introduction Subsection

      == Acknowledgements

      [.preface]
      == Dedication

      == Overview

      Text

      === Scope

      Text

      === Purpose

      Text
    INPUT
    output = <<~OUTPUT
      <ieee-standard xmlns='https://www.metanorma.org/ns/ieee' type='semantic' version='#{Metanorma::IEEE::VERSION}'>
         <preface>
           <abstract id='_'>
             <title>Abstract</title>
             <p id='_'>Text</p>
           </abstract>
           <foreword id='_' obligation='informative'>
             <title>Foreword</title>
             <p id='_'>Text</p>
           </foreword>
           <introduction id='_' obligation='informative'>
             <title>Introduction</title>
             <admonition>
               This introduction is not part of P10000/D1.2, Draft Recommended Practice
               for Widgets
             </admonition>
             <clause id='_' inline-header='false' obligation='informative'>
               <title>Introduction Subsection</title>
             </clause>
           </introduction>
           <clause id='_' inline-header='false' obligation='informative'>
             <title>Dedication</title>
           </clause>
           <acknowledgements id='_' obligation='informative'>
             <title>Acknowledgements</title>
           </acknowledgements>
         </preface>
         <sections>
           <clause id='_' type='overview' inline-header='false' obligation='normative'>
             <title>Overview</title>
             <p id='_'>Text</p>
             <clause id='_' type='scope' inline-header='false' obligation='normative'>
               <title>Scope</title>
               <p id='_'>Text</p>
             </clause>
             <clause id='_' type='purpose' inline-header='false' obligation='normative'>
               <title>Purpose</title>
               <p id='_'>Text</p>
             </clause>
           </clause>
         </sections>
       </ieee-standard>
    OUTPUT
    ret = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    ret.at("//xmlns:bibdata").remove
    expect(xmlpp(strip_guid(ret.to_xml)))
      .to be_equivalent_to xmlpp(output)
  end
end
