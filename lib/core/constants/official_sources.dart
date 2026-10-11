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

  static const OfficialSource docAdvisor = OfficialSource(
    id: 'doc_advisor_fresh',
    title: 'Passport Seva Document Advisor (Fresh Passport)',
    url:
        'https://www.passportindia.gov.in/psp/docAdvisor/attachmentAdvFreshInp',
    verifiedDate: verifiedDate,
    note: 'Official requirements for Proof of Date of Birth, Present Address, and Non-ECR for fresh adult applications.',
  );

  static const OfficialSource listDob = OfficialSource(
    id: 'list_dob',
    title: 'Passport Seva Proof of Date of Birth Guidelines',
    url: 'https://www.passportindia.gov.in/psp/ListDOB',
    verifiedDate: verifiedDate,
    note: 'Prescribed list of acceptable documents for establishing Date of Birth (Birth Certificate, Matriculation, PAN, Aadhaar, etc.).',
  );

  static const OfficialSource listDocuments = OfficialSource(
    id: 'list_documents',
    title: 'Passport Seva General Document Requirements',
    url: 'https://www.passportindia.gov.in/psp/ListDocuments',
    verifiedDate: verifiedDate,
    note: 'Prescribed proof of present address and identification guidelines.',
  );

  static const OfficialSource nonEcrDocuments = OfficialSource(
    id: 'non_ecr_documents',
    title: 'Passport Seva Non-ECR Category & Documents Guide',
    url: 'https://www.passportindia.gov.in/psp/onlineHtml/NonEcrDocuments',
    verifiedDate: verifiedDate,
    note: 'Official eligibility criteria and evidence required to qualify for Emigration Check Not Required (Non-ECR) status.',
  );

  static const OfficialSource applicationGuide = OfficialSource(
    id: 'application_guide',
    title: 'Passport Seva Application & Submission Guide',
    url: 'https://www.passportindia.gov.in/psp/Apply',
    verifiedDate: verifiedDate,
    note: 'Submission workflow at PSK/POPSK, in-person biometric capture, and document verification rules.',
  );

  static const OfficialSource feeCalculator = OfficialSource(
    id: 'fee_calculator',
    title: 'Passport Seva Fee Calculator',
    url: 'https://www.passportindia.gov.in/psp/FeeCalculator',
    verifiedDate: verifiedDate,
    note: 'Official fee breakdown for 36-page and 60-page Normal/Tatkaal passport applications.',
  );
}
