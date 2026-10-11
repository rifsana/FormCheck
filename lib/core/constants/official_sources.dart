class OfficialSource {
  final String title;
  final String url;
  final String verifiedDate;
  final String note;

  const OfficialSource({
    required this.title,
    required this.url,
    required this.verifiedDate,
    required this.note,
  });
}

class OfficialSources {
  static const String verifiedDate = 'October 2026';

  static const OfficialSource docAdvisor = OfficialSource(
    title: 'Passport Seva Document Advisor (Fresh Passport)',
    url:
        'https://www.passportindia.gov.in/psp/docAdvisor/attachmentAdvFreshInp',
    verifiedDate: verifiedDate,
    note: 'Official requirements for Proof of Date of Birth, Present Address, and Non-ECR.',
  );

  static const OfficialSource applicationInstructions = OfficialSource(
    title: 'Passport Seva Application Guide',
    url: 'https://www.passportindia.gov.in/psp/Apply',
    verifiedDate: verifiedDate,
    note: 'Step-by-step guidance for registration, appointment booking, and submission at PSK/POPSK.',
  );

  static const OfficialSource feeCalculator = OfficialSource(
    title: 'Passport Seva Fee Calculator',
    url: 'https://www.passportindia.gov.in/psp/FeeCalculator',
    verifiedDate: verifiedDate,
    note: 'Official fee breakdown for 36-page and 60-page Normal/Tatkaal passport applications.',
  );
}
