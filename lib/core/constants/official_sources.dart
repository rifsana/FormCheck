class OfficialSource {
  final String id;
  final String title;
  final String url;
  final String verifiedDate;
  final String note;
  final bool isVerified;

  const OfficialSource({
    required this.id,
    required this.title,
    required this.url,
    required this.verifiedDate,
    required this.note,
    this.isVerified = true,
  });
}

class OfficialSources {
  static const String verifiedDate = 'October 2026';

  static const OfficialSource passportSevaPortal = OfficialSource(
    id: 'passport_seva_portal',
    title: 'Passport Seva Portal',
    url: 'https://www.passportindia.gov.in',
    verifiedDate: verifiedDate,
    note: 'Official portal of the Ministry of External Affairs, Government of India.',
  );

  static const OfficialSource docAdvisor = OfficialSource(
    id: 'doc_advisor_fresh',
    title: 'Passport Seva Document Advisor (Fresh Passport)',
    url: 'https://www.passportindia.gov.in/AppOnlineProject/docAdvisor/attachmentAdvFreshInp',
    verifiedDate: verifiedDate,
    note: 'Official MEA requirements engine for Proof of Date of Birth, Present Address, and Non-ECR eligibility for fresh adult applications.',
  );

  static const OfficialSource listDob = OfficialSource(
    id: 'list_dob',
    title: 'Passport Seva Proof of Date of Birth Guidelines',
    url: 'https://www.passportindia.gov.in/AppOnlineProject/online/ListDOB',
    verifiedDate: verifiedDate,
    note: 'Prescribed list of 8 acceptable documents for establishing Date of Birth (Birth Certificate, Matriculation, PAN, Aadhaar, etc.) relaxed Dec 2016.',
  );

  static const OfficialSource listDocuments = OfficialSource(
    id: 'list_documents',
    title: 'Passport Seva Proof of Address Guidelines',
    url: 'https://www.passportindia.gov.in/AppOnlineProject/online/ListDocuments',
    verifiedDate: verifiedDate,
    note: 'Prescribed proof of present address and identification guidelines for adult applicants.',
  );

  static const OfficialSource nonEcrDocuments = OfficialSource(
    id: 'non_ecr_documents',
    title: 'Passport Seva Non-ECR Categories & Evidence',
    url: 'https://www.passportindia.gov.in/AppOnlineProject/online/nonEcrDocuments',
    verifiedDate: verifiedDate,
    note: 'Official statutory categories eligible for Emigration Check Not Required (Non-ECR) status under the Emigration Act 1983.',
  );

  static const OfficialSource faqEcr = OfficialSource(
    id: 'faq_ecr_stamping',
    title: 'Passport Seva FAQ: ECR vs Non-ECR & Stamping Rules',
    url: 'https://www.passportindia.gov.in/AppOnlineProject/online/faqServicesAvailable',
    verifiedDate: verifiedDate,
    note: 'Confirms physical ECNR stamps are discontinued. Passports have no mark if Non-ECR, or Emigration Check Required printed on the last page. Clearance applies only for employment in 18 notified countries.',
  );

  static const OfficialSource applicationGuide = OfficialSource(
    id: 'application_guide',
    title: 'Passport Seva Application & Submission Guide',
    url: 'https://www.passportindia.gov.in/AppOnlineProject/online/Apply',
    verifiedDate: verifiedDate,
    note: 'PSK/POPSK biometric capture, in-person document verification rules, and counter workflows.',
  );

  static const OfficialSource feeCalculator = OfficialSource(
    id: 'fee_calculator',
    title: 'Passport Seva Fee Calculator',
    url: 'https://www.passportindia.gov.in/AppOnlineProject/fee/feeInput',
    verifiedDate: verifiedDate,
    note: 'Official fee breakdown for 36-page (Rs 1,500) and 60-page (Rs 2,000) Normal fresh passport applications.',
  );
}
