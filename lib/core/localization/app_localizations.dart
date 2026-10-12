import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
    Locale('ml'),
    Locale('ur'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // General
      'appName': 'FormCheck',
      'appTagline': 'Indian Passport Document Preparation',
      'continueButton': 'Continue',
      'backButton': 'Back',
      'cancel': 'Cancel',
      'iUnderstand': 'I Understand',
      'changeSelection': 'Change Selection',
      'openOfficialAdvisor': 'Open Official Advisor',
      'officialPortal': 'Official Passport Seva Portal',
      'settingsTitle': 'Settings & Language',
      'languageSection': 'Language / भाषा',
      'currentLanguage': 'Current Language',
      'translationNotice': 'Translations are provided for preparation guidance. Always refer to official English terms on government portals.',
      'translationUnderReviewTitle': 'Language Under Official Review',
      'translationUnderReviewBody': 'High-accuracy translations for this language are currently being validated by native reviewers to guarantee complete legal accuracy for passport terms. English, Hindi, Malayalam, and Urdu are currently available.',

      // Home Screen
      'welcomeHeadline': 'Get your passport documents ready.',
      'welcomeSupportingText': 'Know what you need. Clear document requirements. Apply with confidence.',
      'welcomeCta': 'Check my documents',
      'welcomeConciseDisclaimer': 'FormCheck is an independent preparation assistant, not a government service.',
      'benefit1Title': 'Verified checklist',
      'benefit1Desc': 'Mapped strictly to official Passport Seva rules.',
      'benefit2Title': 'Clear guidance',
      'benefit2Desc': 'See every acceptable document and official source.',
      'benefit3Title': 'Private by design',
      'benefit3Desc': 'Your document details stay on your phone.',
      'legalNoticeTitle': 'Legal Notice',
      'privacyArchitectureTitle': 'Privacy Architecture',
      'privacyPoints': '• Zero Cloud Uploads: Document information is never transmitted to remote servers.\n\n• Local Processing: All questionnaire inputs and checklist data are processed strictly on your smartphone.\n\n• No Remote Tracking: FormCheck contains no third-party analytics SDKs, trackers, or background telemetry.\n\n• No Sensitive Identifiers: FormCheck does not ask for or collect sensitive numbers like Aadhaar or PAN.',
      'fullDisclaimerBody': 'FormCheck is an independent preparation assistant and is NOT affiliated with, authorized by, or endorsed by the Ministry of External Affairs (MEA) or the Passport Seva portal. FormCheck does not issue passports or guarantee document acceptance. Always verify official rules on the official Passport Seva portal before attending your appointment.',

      // Questionnaire
      'questionnaireTitle': 'About you',
      'stepOf': 'STEP {step} OF 3',
      'step1Title': 'Your application',
      'step1Subtitle': 'FormCheck is designed for first-time adult applicants applying under the normal scheme.',
      'applicationTypeLabel': 'Application type',
      'freshPassportTitle': 'Fresh passport (First-time)',
      'freshPassportSubtitle':
          'You have never held an ordinary Indian passport before',
      'reissuePassportTitle': 'Renewal or Re-issue',
      'reissuePassportSubtitle':
          'You already hold or previously held an Indian passport',
      'passportSchemeLabel': 'Passport scheme',
      'normalSchemeTitle': 'Normal scheme',
      'normalSchemeSubtitle':
          'Standard processing through normal police verification',
      'tatkaalSchemeTitle': 'Tatkaal scheme',
      'tatkaalSchemeSubtitle':
          'Urgent processing with Annexure F or 3 specified identity proofs',
      'ageCategoryLabel': 'Age category',
      'adultAgeTitle': '18 years or older (Adult)',
      'adultAgeSubtitle': 'Standard adult documentation rules apply',
      'minorAgeTitle': 'Under 18 years (Minor)',
      'minorAgeSubtitle': 'Requires Annexure C/D and parents\' documentation',

      // Step 2: Non-ECR
      'step2Title': 'Emigration status (Non-ECR)',
      'step2Subtitle': 'Applicants with 10th standard or higher education, tax payers, or seniors qualify for Non-ECR passports (no emigration clearance required).',
      'nonEcrCriteriaLabel': 'Do you meet any Non-ECR condition?',
      'critMatriculation': 'Passed 10th standard (Matriculation) or higher',
      'critMatriculationSub': 'Secondary school certificate or higher degree',
      'critTaxPayer': 'Individual Income Tax payer',
      'critTaxPayerSub': 'Assessed for income tax in past year',
      'critAge50': '50 years of age or older',
      'critAge50Sub': 'Verified through valid date of birth proof',
      'critGovtServant': 'Government servant or statutory body employee',
      'critGovtServantSub': 'Holding valid identity certificate or NOC',
      'critDiploma': '2-year recognized vocational diploma holder',
      'critDiplomaSub': 'From state/central government recognized institution',
      'critSpouse': 'Spouse of a Non-ECR eligible person',
      'critSpouseSub': 'With spouse name endorsed or marriage certificate',
      'critNone': 'None of the above (ECR Category)',
      'critNoneSub': 'Passport will have Emigration Check Required stamp',

      // Step 3: Name & History
      'step3Title': 'Name & history',
      'step3Subtitle': 'Passport Seva requires additional Gazette or marriage documentation if your legal name has changed.',
      'nameChangeQuestion': 'Have you ever legally changed your name?',
      'nameChangeSub': 'e.g., after marriage, adoption, or official deed poll',
      'multipleAddressQuestion':
          'Have you lived at more than one address in the past 12 months?',
      'multipleAddressSub':
          'Requires police verification details for each residence',
      'yesOption': 'Yes',
      'noOption': 'No',
      'generateChecklistCta': 'Generate Checklist',
      'unsupportedCategoryTitle': 'Unsupported Category',
      'unsupportedCategoryAdvisorNotice': 'Please visit the official Passport Seva Document Advisor to see the exact requirements for your specific category.',

      // Checklist Screen
      'checklistTitle': 'Your document checklist',
      'requiredDocumentsHeader': 'Required Documents',
      'nonEcrBadge': 'Non-ECR',
      'ecrBadge': 'ECR Category',
      'sectionEveryoneNeeds': 'DOCUMENTS EVERYONE NEEDS',
      'sectionAdditionalDocs': 'ADDITIONAL DOCUMENTS FOR YOUR CASE',
      'sectionWhatToBring': 'WHAT TO BRING TO YOUR APPOINTMENT',
      'appointmentNotice': 'Always carry original documents along with self-attested photocopies to your Passport Seva Kendra (PSK) appointment.',
      'whatDocsAccepted': 'What documents are accepted? ({count})',
      'hideAcceptedDocs': 'Hide accepted documents',
      'acceptableOptionsHeader':
          'ACCEPTABLE OPTIONS (BRING AT LEAST ONE ORIGINAL):',
      'issuingAuthorityPrefix': 'Authority: ',
      'officialAdvisorAction': 'Official Document Advisor',
      'sourceLinkTooltip': 'Official source: {title}',
      'couldNotOpenLink': 'Could not open external official link.',

      // Document Items
      'dobProofTitle': 'Proof of your date of birth',
      'dobProofExplanation': 'One official document verifying your exact birth date is required for all applicants.',
      'addressProofTitle': 'Proof of your current address',
      'addressProofExplanation': 'One document verifying your present residential address is mandatory.',
      'nonEcrEduTitle': 'Non-ECR Educational Qualification',
      'nonEcrEduExplanation': 'Certificate verifying 10th standard (Matriculation) or higher educational degree.',
      'nameChangeTitle': 'Proof of Legal Name Change',
      'nameChangeExplanation': 'Gazette notification or deed poll verifying legal name modification.',
      'inPersonTitle': 'In-Person Appointment Preparation',
      'inPersonExplanation': 'Original documents and self-attested photocopies are verified in-person at the PSK counter.',
    },

    'hi': {
      // General
      'appName': 'फ़ॉर्मचेक (FormCheck)',
      'appTagline': 'भारतीय पासपोर्ट दस्तावेज़ तैयारी',
      'continueButton': 'आगे बढ़ें',
      'backButton': 'पीछे',
      'cancel': 'रद्द करें',
      'iUnderstand': 'समझ गया',
      'changeSelection': 'विकल्प बदलें',
      'openOfficialAdvisor': 'आधिकारिक एडवाइजर खोलें',
      'officialPortal': 'आधिकारिक पासपोर्ट सेवा पोर्टल',
      'settingsTitle': 'सेटिंग्स और भाषा',
      'languageSection': 'भाषा / Language',
      'currentLanguage': 'वर्तमान भाषा',
      'translationNotice': 'अनुवाद केवल तैयारी में सहायता के लिए प्रदान किए गए हैं। सरकारी पोर्टलों पर हमेशा मूल अंग्रेजी शब्दों का संदर्भ लें।',
      'translationUnderReviewTitle': 'भाषा समीक्षाधीन है',
      'translationUnderReviewBody': 'पासपोर्ट नियमों की पूर्ण कानूनी सटीकता सुनिश्चित करने के लिए इस भाषा के अनुवादों की समीक्षा की जा रही है। वर्तमान में अंग्रेज़ी, हिन्दी, मलयालम और उर्दू उपलब्ध हैं।',

      // Home Screen
      'welcomeHeadline': 'अपने पासपोर्ट दस्तावेज़ तैयार करें।',
      'welcomeSupportingText': 'जानें आपको क्या चाहिए। स्पष्ट दस्तावेज़ आवश्यकताएं। आत्मविश्वास के साथ आवेदन करें।',
      'welcomeCta': 'मेरे दस्तावेज़ देखें',
      'welcomeConciseDisclaimer':
          'फ़ॉर्मचेक एक स्वतंत्र तैयारी सहायक है, कोई सरकारी सेवा नहीं।',
      'benefit1Title': 'सत्यापित चेकलिस्ट',
      'benefit1Desc': 'पासपोर्ट सेवा के नियमों के अनुसार तैयार की गई।',
      'benefit2Title': 'स्पष्ट मार्गदर्शन',
      'benefit2Desc': 'प्रत्येक स्वीकार्य दस्तावेज़ और आधिकारिक स्रोत देखें।',
      'benefit3Title': 'गोपनीयता सर्वप्रथम',
      'benefit3Desc': 'आपके दस्तावेज़ की जानकारी आपके फ़ोन पर ही रहती है।',
      'legalNoticeTitle': 'कानूनी सूचना',
      'privacyArchitectureTitle': 'गोपनीयता संरचना',
      'privacyPoints': '• ज़ीरो क्लाउड अपलोड: दस्तावेज़ की जानकारी कभी भी बाहरी सर्वर पर नहीं भेजी जाती।\n\n• स्थानीय प्रोसेसिंग: सभी डेटा केवल आपके स्मार्टफ़ोन पर प्रोसेस होता है।\n\n• कोई ट्रैकिंग नहीं: फ़ॉर्मचेक में कोई तृतीय-पक्ष एनालिटिक्स या टेलीमेट्री नहीं है।\n\n• कोई संवेदनशील पहचानकर्ता नहीं: फ़ॉर्मचेक आधार या पैन जैसे संवेदनशील नंबर एकत्र नहीं करता।',
      'fullDisclaimerBody': 'फ़ॉर्मचेक एक स्वतंत्र तैयारी सहायक है और यह विदेश मंत्रालय (MEA) या पासपोर्ट सेवा पोर्टल से संबद्ध, अधिकृत या समर्थित नहीं है। फ़ॉर्मचेक पासपोर्ट जारी नहीं करता या दस्तावेज़ स्वीकृति की गारंटी नहीं देता। अपने अपॉइंटमेंट में जाने से पहले हमेशा आधिकारिक पोर्टल पर नियमों की पुष्टि करें।',

      // Questionnaire
      'questionnaireTitle': 'आपके बारे में',
      'stepOf': 'चरण {step} / 3',
      'step1Title': 'आपका आवेदन',
      'step1Subtitle': 'फ़ॉर्मचेक सामान्य योजना के तहत पहली बार वयस्क आवेदकों के लिए तैयार किया गया है।',
      'applicationTypeLabel': 'आवेदन का प्रकार',
      'freshPassportTitle': 'नया पासपोर्ट (पहली बार)',
      'freshPassportSubtitle': 'आपने पहले कभी भारतीय पासपोर्ट नहीं लिया है',
      'reissuePassportTitle': 'नवीनीकरण या पुनः जारी',
      'reissuePassportSubtitle': 'आपके पास पहले से भारतीय पासपोर्ट है या था',
      'passportSchemeLabel': 'पासपोर्ट योजना',
      'normalSchemeTitle': 'सामान्य योजना (Normal)',
      'normalSchemeSubtitle': 'मानक पुलिस सत्यापन के साथ नियमित प्रक्रिया',
      'tatkaalSchemeTitle': 'तत्काल योजना (Tatkaal)',
      'tatkaalSchemeSubtitle':
          'अनुलग्नक F या 3 विशिष्ट पहचान प्रमाणों के साथ त्वरित प्रक्रिया',
      'ageCategoryLabel': 'आयु वर्ग',
      'adultAgeTitle': '18 वर्ष या उससे अधिक (वयस्क)',
      'adultAgeSubtitle': 'मानक वयस्क दस्तावेज़ नियम लागू होते हैं',
      'minorAgeTitle': '18 वर्ष से कम (नाबालिग)',
      'minorAgeSubtitle': 'अनुलग्नक C/D और माता-पिता के दस्तावेज़ आवश्यक हैं',

      // Step 2: Non-ECR
      'step2Title': 'उत्प्रवास स्थिति (Non-ECR)',
      'step2Subtitle': '10वीं कक्षा या उससे अधिक शिक्षा, आयकर दाता, या वरिष्ठ नागरिक Non-ECR पासपोर्ट के पात्र हैं (उत्प्रवास मंजूरी की आवश्यकता नहीं)।',
      'nonEcrCriteriaLabel': 'क्या आप किसी Non-ECR शर्त को पूरा करते हैं?',
      'critMatriculation': '10वीं कक्षा (मैट्रिक) या उच्चतर उत्तीर्ण',
      'critMatriculationSub': 'माध्यमिक विद्यालय प्रमाण पत्र या उच्च डिग्री',
      'critTaxPayer': 'व्यक्तिगत आयकर दाता',
      'critTaxPayerSub': 'पिछले वर्ष आयकर निर्धारण हुआ हो',
      'critAge50': '50 वर्ष या उससे अधिक आयु',
      'critAge50Sub': 'वैध जन्म तिथि प्रमाण द्वारा सत्यापित',
      'critGovtServant': 'सरकारी कर्मचारी या सांविधिक निकाय कर्मचारी',
      'critGovtServantSub':
          'वैध पहचान प्रमाण पत्र या अनापत्ति प्रमाण पत्र (NOC)',
      'critDiploma': '2-वर्षीय मान्यता प्राप्त व्यावसायिक डिप्लोमा धारक',
      'critDiplomaSub':
          'राज्य या केंद्र सरकार द्वारा मान्यता प्राप्त संस्थान से',
      'critSpouse': 'Non-ECR पात्र व्यक्ति के पति/पत्नी',
      'critSpouseSub': 'पति/पत्नी का नाम अंकित हो या विवाह प्रमाण पत्र हो',
      'critNone': 'उपरोक्त में से कोई नहीं (ECR श्रेणी)',
      'critNoneSub': 'पासपोर्ट पर Emigration Check Required की मुहर लगेगी',

      // Step 3: Name & History
      'step3Title': 'नाम और इतिहास',
      'step3Subtitle': 'यदि आपका कानूनी नाम बदल गया है, तो पासपोर्ट सेवा को अतिरिक्त राजपत्र (Gazette) या विवाह दस्तावेज़ की आवश्यकता होती है।',
      'nameChangeQuestion': 'क्या आपने कभी कानूनी रूप से अपना नाम बदला है?',
      'nameChangeSub': 'जैसे विवाह, गोद लेने, या आधिकारिक हलफनामे के बाद',
      'multipleAddressQuestion':
          'क्या आप पिछले 12 महीनों में एक से अधिक पते पर रहे हैं?',
      'multipleAddressSub':
          'प्रत्येक निवास के लिए पुलिस सत्यापन विवरण आवश्यक है',
      'yesOption': 'हाँ',
      'noOption': 'नहीं',
      'generateChecklistCta': 'चेकलिस्ट बनाएं',
      'unsupportedCategoryTitle': 'असमर्थित श्रेणी',
      'unsupportedCategoryAdvisorNotice': 'कृपया अपनी विशिष्ट श्रेणी की सटीक आवश्यकताओं को देखने के लिए आधिकारिक पासपोर्ट सेवा डॉक्यूमेंट एडवाइजर पर जाएं।',

      // Checklist Screen
      'checklistTitle': 'आपकी दस्तावेज़ चेकलिस्ट',
      'requiredDocumentsHeader': 'आवश्यक दस्तावेज़',
      'nonEcrBadge': 'Non-ECR श्रेणी',
      'ecrBadge': 'ECR श्रेणी',
      'sectionEveryoneNeeds': 'सभी के लिए आवश्यक दस्तावेज़',
      'sectionAdditionalDocs': 'आपकी श्रेणी के अतिरिक्त दस्तावेज़',
      'sectionWhatToBring': 'अपॉइंटमेंट के लिए क्या लाएं',
      'appointmentNotice': 'अपने पासपोर्ट सेवा केंद्र (PSK) अपॉइंटमेंट के लिए मूल दस्तावेज़ और स्व-सत्यापित प्रतियां अवश्य साथ लाएं।',
      'whatDocsAccepted': 'स्वीकार्य दस्तावेज़ देखें ({count})',
      'hideAcceptedDocs': 'स्वीकार्य दस्तावेज़ छिपाएं',
      'acceptableOptionsHeader':
          'स्वीकार्य विकल्प (कम से कम एक मूल प्रति लाएं):',
      'issuingAuthorityPrefix': 'जारीकर्ता प्राधिकरण: ',
      'officialAdvisorAction': 'आधिकारिक डॉक्यूमेंट एडवाइजर',
      'sourceLinkTooltip': 'आधिकारिक स्रोत: {title}',
      'couldNotOpenLink': 'आधिकारिक लिंक खोलने में असमर्थ।',

      // Document Items
      'dobProofTitle': 'जन्म तिथि का प्रमाण (Proof of DOB)',
      'dobProofExplanation': 'सभी आवेदकों के लिए सटीक जन्म तिथि सत्यापित करने वाला एक आधिकारिक दस्तावेज़ आवश्यक है।',
      'addressProofTitle': 'वर्तमान पते का प्रमाण (Proof of Address)',
      'addressProofExplanation': 'आपके वर्तमान आवासीय पते को सत्यापित करने वाला एक दस्तावेज़ अनिवार्य है।',
      'nonEcrEduTitle': 'Non-ECR शैक्षिक योग्यता प्रमाण',
      'nonEcrEduExplanation': '10वीं कक्षा (मैट्रिक) या उच्च शिक्षा की डिग्री सत्यापित करने वाला प्रमाण पत्र।',
      'nameChangeTitle': 'कानूनी नाम परिवर्तन का प्रमाण',
      'nameChangeExplanation': 'कानूनी नाम परिवर्तन को सत्यापित करने वाली राजपत्र (Gazette) अधिसूचना या विलेख।',
      'inPersonTitle': 'व्यक्तिगत अपॉइंटमेंट तैयारी',
      'inPersonExplanation': 'मूल दस्तावेज़ों और स्व-सत्यापित प्रतियों का PSK काउंटर पर व्यक्तिगत रूप से सत्यापन किया जाता है।',
    },

    'ml': {
      // General
      'appName': 'ഫോംചെക്ക് (FormCheck)',
      'appTagline': 'ഇന്ത്യൻ പാസ്‌പോർട്ട് രേഖാ തയ്യാറെടുപ്പ്',
      'continueButton': 'തുടരുക',
      'backButton': 'പിന്നോട്ട്',
      'cancel': 'റദ്ദാക്കുക',
      'iUnderstand': 'മനസ്സിലായി',
      'changeSelection': 'തിരഞ്ഞെടുപ്പ് മാറ്റുക',
      'openOfficialAdvisor': 'ഔദ്യോഗിക അഡ്വൈസർ തുറക്കുക',
      'officialPortal': 'ഔദ്യോഗിക പാസ്‌പോർട്ട് സേവാ പോർട്ടൽ',
      'settingsTitle': 'സെറ്റിംഗ്സും ഭാഷയും',
      'languageSection': 'ഭാഷ / Language',
      'currentLanguage': 'നിലവിലെ ഭാഷ',
      'translationNotice': 'തയ്യാറെടുപ്പ് മാർഗ്ഗനിർദ്ദേശത്തിനായി മാത്രമാണ് വിവർത്തനങ്ങൾ നൽകിയിട്ടുള്ളത്. സർക്കാർ പോർട്ടലുകളിലെ ഔദ്യോഗിക ഇംഗ്ലീഷ് പദങ്ങൾ പരിശോധിക്കുക.',
      'translationUnderReviewTitle': 'ഭാഷാ പരിശോധനയിലാണ്',
      'translationUnderReviewBody': 'പാസ്‌പോർട്ട് സംബന്ധമായ നിയമപരമായ കൃത്യത ഉറപ്പാക്കാൻ ഈ ഭാഷയിലെ വിവർത്തനം പരിശോധിച്ചുവരികയാണ്. നിലവിൽ ഇംഗ്ലീഷ്, ഹിന്ദി, മലയാളം, ഉറുദു ലഭ്യമാണ്.',

      // Home Screen
      'welcomeHeadline': 'നിങ്ങളുടെ പാസ്‌പോർട്ട് രേഖകൾ തയ്യാറാക്കുക.',
      'welcomeSupportingText': 'നിങ്ങൾക്ക് എന്താണ് വേണ്ടതെന്ന് മനസ്സിലാക്കുക. കൃത്യമായ രേഖാ വിവരങ്ങൾ. ആത്മവിശ്വാസത്തോടെ അപേക്ഷിക്കുക.',
      'welcomeCta': 'രേഖകൾ പരിശോധിക്കുക',
      'welcomeConciseDisclaimer':
          'ഫോംചെക്ക് ഒരു സ്വതന്ത്ര തയ്യാറെടുപ്പ് സഹായിയാണ്, സർക്കാർ സേവനമല്ല.',
      'benefit1Title': 'പരിശോധിച്ച ചെക്ക്‌ലിസ്റ്റ്',
      'benefit1Desc': 'ഔദ്യോഗിക പാസ്‌പോർട്ട് സേവാ നിയമങ്ങൾക്കനുസൃതമായി.',
      'benefit2Title': 'വ്യക്തമായ മാർഗ്ഗനിർദ്ദേശം',
      'benefit2Desc': 'അംഗീകൃത രേഖകളും ഔദ്യോഗിക ഉറവിടങ്ങളും കാണുക.',
      'benefit3Title': 'സ്വകാര്യതയ്ക്ക് മുൻഗണന',
      'benefit3Desc':
          'നിങ്ങളുടെ വിവരങ്ങൾ നിങ്ങളുടെ ഫോണിൽ മാത്രം സൂക്ഷിക്കുന്നു.',
      'legalNoticeTitle': 'നിയമപരമായ അറിയിപ്പ്',
      'privacyArchitectureTitle': 'സ്വകാര്യതാ ഘടന',
      'privacyPoints': '• ക്ലൗഡ് അപ്‌ലോഡുകൾ ഇല്ല: വിവരങ്ങൾ ബാഹ്യ സെർവറുകളിലേക്ക് അയയ്ക്കില്ല.\n\n• ലോക്കൽ പ്രോസസ്സിംഗ്: എല്ലാ വിവരങ്ങളും നിങ്ങളുടെ സ്മാർട്ട്‌ഫോണിൽ മാത്രം പ്രോസസ്സ് ചെയ്യുന്നു.\n\n• ട്രാക്കിംഗ് ഇല്ല: ഫോംചെക്കിൽ അനലിറ്റിക്സ് ട്രാക്കറുകൾ ഇല്ല.\n\n• ആധാർ, പാൻ നമ്പറുകൾ ശേഖരിക്കില്ല.',
      'fullDisclaimerBody': 'ഫോംചെക്ക് ഒരു സ്വതന്ത്ര തയ്യാറെടുപ്പ് സഹായിയാണ്, വിദേശകാര്യ മന്ത്രാലയവുമായോ (MEA) പാസ്‌പോർട്ട് സേവാ പോർട്ടലുമായോ ബന്ധമില്ല. അപ്പോയിന്റ്മെന്റിൽ പങ്കെടുക്കുന്നതിന് മുമ്പ് ഔദ്യോഗിക പോർട്ടലിലെ നിയമങ്ങൾ പരിശോധിക്കുക.',

      // Questionnaire
      'questionnaireTitle': 'നിങ്ങളെക്കുറിച്ച്',
      'stepOf': 'ഘട്ടം {step} / 3',
      'step1Title': 'നിങ്ങളുടെ അപേക്ഷ',
      'step1Subtitle': 'സാധാരണ സ്കീമിൽ ആദ്യമായി അപേക്ഷിക്കുന്ന മുതിർന്നവർക്കായി ഫോംചെക്ക് രൂപകൽപ്പന ചെയ്തിരിക്കുന്നു.',
      'applicationTypeLabel': 'അപേക്ഷാ തരം',
      'freshPassportTitle': 'പുതിയ പാസ്‌പോർട്ട് (ആദ്യമായി)',
      'freshPassportSubtitle':
          'നിങ്ങൾക്ക് മുമ്പ് ഒരിക്കലും ഇന്ത്യൻ പാസ്‌പോർട്ട് ലഭിച്ചിട്ടില്ല',
      'reissuePassportTitle': 'പുതുക്കൽ അല്ലെങ്കിൽ റീ-ഇഷ്യൂ',
      'reissuePassportSubtitle':
          'നിങ്ങൾക്ക് മുമ്പ് ഇന്ത്യൻ പാസ്‌പോർട്ട് ഉണ്ടായിരുന്നു',
      'passportSchemeLabel': 'പാസ്‌പോർട്ട് സ്കീം',
      'normalSchemeTitle': 'സാധാരണ സ്കീം (Normal)',
      'normalSchemeSubtitle': 'സാധാരണ പോലീസ് വെരിഫിക്കേഷനിലൂടെയുള്ള നടപടികൾ',
      'tatkaalSchemeTitle': 'തത്കാൽ സ്കീം (Tatkaal)',
      'tatkaalSchemeSubtitle': 'അടിയന്തര നടപടിക്രമങ്ങൾ',
      'ageCategoryLabel': 'പ്രായപരിധി',
      'adultAgeTitle': '18 വയസ്സോ അതിൽ കൂടുതലോ (മുതിർന്നവർ)',
      'adultAgeSubtitle': 'സാധാരണ മുതിർന്നവരുടെ രേഖാ നിയമങ്ങൾ ബാധകം',
      'minorAgeTitle': '18 വയസ്സിൽ താഴെ (പ്രായപൂർത്തിയാകാത്തവർ)',
      'minorAgeSubtitle': 'രക്ഷിതാക്കളുടെ രേഖകളും അനെക്സറുകളും ആവശ്യമാണ്',

      // Step 2: Non-ECR
      'step2Title': 'എമിഗ്രേഷൻ സ്റ്റാറ്റസ് (Non-ECR)',
      'step2Subtitle': 'പത്താം ക്ലാസ് അല്ലെങ്കിൽ ഉയർന്ന യോഗ്യതയുള്ളവർ, നികുതിദായകർ എന്നിവർക്ക് Non-ECR പാസ്‌പോർട്ടിന് അർഹതയുണ്ട്.',
      'nonEcrCriteriaLabel':
          'നിങ്ങൾക്ക് താഴെ പറയുന്ന ഏതെങ്കിലും Non-ECR യോഗ്യതയുണ്ടോ?',
      'critMatriculation': 'പത്താം ക്ലാസ് (SSLC) അല്ലെങ്കിൽ ഉയർന്ന വിജയം',
      'critMatriculationSub':
          'സെക്കൻഡറി സ്കൂൾ സർട്ടിഫിക്കറ്റ് അല്ലെങ്കിൽ ബിരുദം',
      'critTaxPayer': 'ആദായനികുതി അടയ്ക്കുന്നയാൾ',
      'critTaxPayerSub': 'കഴിഞ്ഞ വർഷം ആദായനികുതി അടച്ച രേഖ',
      'critAge50': '50 വയസ്സോ അതിൽ കൂടുതലോ പ്രായമുള്ളവർ',
      'critAge50Sub': 'ജനനത്തീയതി രേഖ വഴി തെളിയിക്കാം',
      'critGovtServant': 'സർക്കാർ ജീവനക്കാർ',
      'critGovtServantSub': 'തിരിച്ചറിയൽ സർട്ടിഫിക്കറ്റ് അല്ലെങ്കിൽ എൻ.ഒ.സി',
      'critDiploma': '2 വർഷത്തെ അംഗീകൃത വൊക്കേഷണൽ ഡിപ്ലോമ',
      'critDiplomaSub': 'അംഗീകൃത സ്ഥാപനത്തിൽ നിന്നുള്ള സർട്ടിഫിക്കറ്റ്',
      'critSpouse': 'Non-ECR അർഹതയുള്ളയാളുടെ പങ്കാളി',
      'critSpouseSub':
          'വിവാഹ സർട്ടിഫിക്കറ്റ് അല്ലെങ്കിൽ പങ്കാളിയുടെ പേരുള്ള രേഖ',
      'critNone': 'മുകളിൽ പറഞ്ഞവയൊന്നുമില്ല (ECR വിഭാഗം)',
      'critNoneSub': 'പാസ്‌പോർട്ടിൽ Emigration Check Required രേഖപ്പെടുത്തും',

      // Step 3: Name & History
      'step3Title': 'പേരും വിവരങ്ങളും',
      'step3Subtitle': 'നിങ്ങളുടെ പേര് മാറിയിട്ടുണ്ടെങ്കിൽ ഗസറ്റ് വിജ്ഞാപനമോ വിവാഹ സർട്ടിഫിക്കറ്റോ ആവശ്യമാണ്.',
      'nameChangeQuestion':
          'നിങ്ങൾ എപ്പോഴെങ്കിലും നിയമപരമായി പേര് മാറ്റിയിട്ടുണ്ടോ?',
      'nameChangeSub': 'ഉദാഹരണത്തിന് വിവാഹശേഷമോ ഗസറ്റ് വഴിയോ',
      'multipleAddressQuestion':
          'കഴിഞ്ഞ 12 മാസത്തിനിടെ ഒന്നിലധികം വിലാസങ്ങളിൽ താമസിച്ചിട്ടുണ്ടോ?',
      'multipleAddressSub': 'ഓരോ വിലാസത്തിലും പോലീസ് വെരിഫിക്കേഷൻ ആവശ്യമാണ്',
      'yesOption': 'അതെ',
      'noOption': 'അല്ല',
      'generateChecklistCta': 'ചെക്ക്‌ലിസ്റ്റ് തയ്യാറാക്കുക',
      'unsupportedCategoryTitle': 'പിന്തുണയ്ക്കാത്ത വിഭാഗം',
      'unsupportedCategoryAdvisorNotice': 'നിങ്ങളുടെ വിഭാഗത്തിലെ രേഖകൾ കാണാൻ ഔദ്യോഗിക പാസ്‌പോർട്ട് സേവാ ഡോക്യുമെന്റ് അഡ്വൈസർ സന്ദർശിക്കുക.',

      // Checklist Screen
      'checklistTitle': 'നിങ്ങളുടെ രേഖാ ചെക്ക്‌ലിസ്റ്റ്',
      'requiredDocumentsHeader': 'ആവശ്യമായ രേഖകൾ',
      'nonEcrBadge': 'Non-ECR വിഭാഗം',
      'ecrBadge': 'ECR വിഭാഗം',
      'sectionEveryoneNeeds': 'എല്ലാവർക്കും ആവശ്യമായ രേഖകൾ',
      'sectionAdditionalDocs': 'നിങ്ങളുടെ വിഭാഗത്തിന് അധിക രേഖകൾ',
      'sectionWhatToBring': 'അപ്പോയിന്റ്മെന്റിന് കൊണ്ടുവരേണ്ടവ',
      'appointmentNotice': 'പാസ്‌പോർട്ട് സേവാ കേന്ദ്രം (PSK) അപ്പോയിന്റ്മെന്റിനായി യഥാർത്ഥ രേഖകളും സ്വയം സാക്ഷ്യപ്പെടുത്തിയ പകർപ്പുകളും നിർബന്ധമായും കരുതുക.',
      'whatDocsAccepted': 'അംഗീകൃത രേഖകൾ കാണുക ({count})',
      'hideAcceptedDocs': 'അംഗീകൃത രേഖകൾ മറയ്ക്കുക',
      'acceptableOptionsHeader':
          'അംഗീകൃത രേഖകൾ (കുറഞ്ഞത് ഒന്നിലെങ്കിലും ഒറിജിനൽ കൊണ്ടുവരിക):',
      'issuingAuthorityPrefix': 'നൽകിയ അധികാരി: ',
      'officialAdvisorAction': 'ഔദ്യോഗിക ഡോക്യുമെന്റ് അഡ്വൈസർ',
      'sourceLinkTooltip': 'ഔദ്യോഗിക ഉറവിടം: {title}',
      'couldNotOpenLink': 'ഔദ്യോഗിക ലിങ്ക് തുറക്കാൻ കഴിഞ്ഞില്ല.',

      // Document Items
      'dobProofTitle': 'ജനനത്തീയതി തെളിയിക്കുന്ന രേഖ (DOB Proof)',
      'dobProofExplanation':
          'ജനനത്തീയതി തെളിയിക്കുന്നതിന് ഒരു ഔദ്യോഗിക രേഖ നിർബന്ധമാണ്.',
      'addressProofTitle': 'നിലവിലെ വിലാസം തെളിയിക്കുന്ന രേഖ (Address Proof)',
      'addressProofExplanation':
          'നിങ്ങളുടെ ഇപ്പോഴത്തെ വിലാസം തെളിയിക്കുന്ന ഒരു രേഖ നിർബന്ധമാണ്.',
      'nonEcrEduTitle': 'Non-ECR വിദ്യാഭ്യാസ യോഗ്യതാ രേഖ',
      'nonEcrEduExplanation':
          'പത്താം ക്ലാസ് (SSLC) അല്ലെങ്കിൽ ഉയർന്ന വിദ്യാഭ്യാസ സർട്ടിഫിക്കറ്റ്.',
      'nameChangeTitle': 'നിയമപരമായ പേരുമാറ്റ രേഖ',
      'nameChangeExplanation': 'ഗസറ്റ് വിജ്ഞാപനം അല്ലെങ്കിൽ അനുബന്ധ രേഖ.',
      'inPersonTitle': 'നേരിട്ടുള്ള അപ്പോയിന്റ്മെന്റ് തയ്യാറെടുപ്പ്',
      'inPersonExplanation': 'യഥാർത്ഥ രേഖകളും പകർപ്പുകളും പി.എസ്.കെ കൗണ്ടറിൽ നേരിട്ട് പരിശോധിക്കും.',
    },

    'ur': {
      // General
      'appName': 'فارم چیک (FormCheck)',
      'appTagline': 'ہندوستانی پاسپورٹ دستاویزات کی تیاری',
      'continueButton': 'آگے بڑھیں',
      'backButton': 'پیچھے',
      'cancel': 'منسوخ کریں',
      'iUnderstand': 'سمجھ گیا',
      'changeSelection': 'انتخاب تبدیل کریں',
      'openOfficialAdvisor': 'سرکاری ایڈوائزر کھولیں',
      'officialPortal': 'سرکاری پاسپورٹ سیوا پورٹل',
      'settingsTitle': 'ترتیبات اور زبان',
      'languageSection': 'زبان / Language',
      'currentLanguage': 'موجودہ زبان',
      'translationNotice': 'ترجمہ صرف تیاری کی رہنمائی کے لیے فراہم کیا گیا ہے۔ سرکاری پورٹل پر ہمیشہ اصل انگریزی الفاظ دیکھیں۔',
      'translationUnderReviewTitle': 'زبان زیر جائزہ ہے',
      'translationUnderReviewBody': 'پاسپورٹ کی قانونی درستگی کو یقینی بنانے کے لیے اس زبان کے ترجمے کی جانچ کی جا رہی ہے۔ فی الحال انگریزی، ہندی، ملیالم اور اردو دستیاب ہیں۔',

      // Home Screen
      'welcomeHeadline': 'اپنے پاسپورٹ کی دستاویزات تیار کریں۔',
      'welcomeSupportingText': 'جانیں کہ آپ کو کیا درکار ہے۔ واضح دستاویزاتی شرائط۔ اعتماد کے ساتھ درخواست دیں۔',
      'welcomeCta': 'میرے دستاویزات چیک کریں',
      'welcomeConciseDisclaimer':
          'فارم چیک ایک آزاد تیاری کا معاون ہے، کوئی سرکاری سروس نہیں ہے۔',
      'benefit1Title': 'تصدیق شدہ فہرست',
      'benefit1Desc': 'پاسپورٹ سیوا کے باضابطہ قواعد کے مطابق۔',
      'benefit2Title': 'واضح رہنمائی',
      'benefit2Desc': 'ہر قابل قبول دستاویز اور باضابطہ ذریعہ دیکھیں۔',
      'benefit3Title': 'رازداری کا تحفظ',
      'benefit3Desc': 'آپ کے دستاویزات کی معلومات آپ کے فون پر ہی رہتی ہے۔',
      'legalNoticeTitle': 'قانونی نوٹس',
      'privacyArchitectureTitle': 'رازداری کا ڈھانچہ',
      'privacyPoints': '• کلاؤڈ پر کوئی اپ لوڈ نہیں: ڈیٹا کبھی بھی ریموٹ سرور پر نہیں بھیجا جاتا۔\n\n• مقامی پروسیسنگ: تمام ڈیٹا صرف آپ کے فون پر پروسیس ہوتا ہے۔\n\n• کوئی ٹریکنگ نہیں: فارم چیک میں کوئی اینالیٹکس ٹریکر نہیں ہے۔\n\n• آدھار یا پین کارڈ نمبر اکٹھا نہیں کیے جاتے۔',
      'fullDisclaimerBody': 'فارم چیک ایک آزاد تیاری کا معاون ہے اور وزارت خارجہ (MEA) سے منسلک نہیں ہے۔ ملاقات کے لیے جانے سے پہلے ہمیشہ سرکاری پورٹل پر قواعد کی تصدیق کریں۔',

      // Questionnaire
      'questionnaireTitle': 'آپ کے متعلق',
      'stepOf': 'مرحلہ {step} از 3',
      'step1Title': 'آپ کی درخواست',
      'step1Subtitle': 'فارم چیک عام اسکیم کے تحت پہلی بار بالغ درخواست گزاروں کے لیے تیار کیا گیا ہے۔',
      'applicationTypeLabel': 'درخواست کی قسم',
      'freshPassportTitle': 'نیا پاسپورٹ (پہلی بار)',
      'freshPassportSubtitle':
          'آپ کے پاس پہلے کبھی ہندوستانی پاسپورٹ نہیں رہا ہے',
      'reissuePassportTitle': 'تجدید یا دوبارہ اجراء',
      'reissuePassportSubtitle': 'آپ کے پاس پہلے پاسپورٹ رہا ہے',
      'passportSchemeLabel': 'پاسپورٹ اسکیم',
      'normalSchemeTitle': 'عام اسکیم (Normal)',
      'normalSchemeSubtitle': 'معمول کی پولیس تصدیق کے ساتھ معیاری پروسیسنگ',
      'tatkaalSchemeTitle': 'تتکال اسکیم (Tatkaal)',
      'tatkaalSchemeSubtitle': 'فوری پروسیسنگ',
      'ageCategoryLabel': 'عمر کا زمرہ',
      'adultAgeTitle': '18 سال یا اس سے زیادہ (بالغ)',
      'adultAgeSubtitle': 'معیاری بالغوں کے قواعد لاگو ہوتے ہیں',
      'minorAgeTitle': '18 سال سے کم (نابالغ)',
      'minorAgeSubtitle': 'والدین کی دستاویزات درکار ہیں',

      // Step 2: Non-ECR
      'step2Title': 'امیگریشن کی حیثیت (Non-ECR)',
      'step2Subtitle': 'دسویں جماعت یا اس سے زیادہ تعلیم یافتہ افراد یا انکم ٹیکس دہندگان Non-ECR پاسپورٹ کے اہل ہیں۔',
      'nonEcrCriteriaLabel': 'کیا آپ کسی Non-ECR شرط کو پورا کرتے ہیں؟',
      'critMatriculation': 'دسویں جماعت (میٹرک) یا اس سے زیادہ پاس',
      'critMatriculationSub': 'سکول سرٹیفکیٹ یا ڈگری',
      'critTaxPayer': 'انفرادی انکم ٹیکس دہندہ',
      'critTaxPayerSub': 'گزشتہ سال انکم ٹیکس ادا کیا ہو',
      'critAge50': '50 سال یا اس سے زیادہ عمر',
      'critAge50Sub': 'تاریخ پیدائش کے ثبوت سے تصدیق شدہ',
      'critGovtServant': 'سرکاری ملازم',
      'critGovtServantSub': 'شناختی سرٹیفکیٹ یا این او سی',
      'critDiploma': '2 سالہ پیشہ ورانہ ڈپلومہ ہولڈر',
      'critDiplomaSub': 'تسلیم شدہ ادارے سے',
      'critSpouse': 'اہل شخص کا شریک حیات',
      'critSpouseSub': 'نکاح نامہ یا شریک حیات کا نام درج ہو',
      'critNone': 'مذکورہ بالا میں سے کوئی نہیں (ECR زمرہ)',
      'critNoneSub': 'پاسپورٹ پر Emigration Check Required کی مہر لگے گی',

      // Step 3: Name & History
      'step3Title': 'نام اور تاریخ',
      'step3Subtitle':
          'اگر آپ کا قانونی نام تبدیل ہوا ہے تو اضافی دستاویزات درکار ہیں۔',
      'nameChangeQuestion':
          'کیا آپ نے کبھی قانونی طور پر اپنا نام تبدیل کیا ہے؟',
      'nameChangeSub': 'مثلاً شادی کے بعد یا گزٹ کے ذریعے',
      'multipleAddressQuestion':
          'کیا آپ پچھلے 12 مہینوں میں ایک سے زیادہ پتوں پر رہے ہیں؟',
      'multipleAddressSub': 'ہر رہائش گاہ کے لیے پولیس تصدیق درکار ہے',
      'yesOption': 'ہاں',
      'noOption': 'نہیں',
      'generateChecklistCta': 'فہرست تیار کریں',
      'unsupportedCategoryTitle': 'غیر معاون زمرہ',
      'unsupportedCategoryAdvisorNotice': 'براہ کرم اپنے مخصوص زمرے کی شرائط دیکھنے کے لیے سرکاری پاسپورٹ سیوا ایڈوائزر ملاحظہ کریں۔',

      // Checklist Screen
      'checklistTitle': 'آپ کی دستاویزات کی فہرست',
      'requiredDocumentsHeader': 'مطلوبہ دستاویزات',
      'nonEcrBadge': 'Non-ECR زمرہ',
      'ecrBadge': 'ECR زمرہ',
      'sectionEveryoneNeeds': 'سب کے لیے لازمی دستاویزات',
      'sectionAdditionalDocs': 'آپ کے زمرے کے لیے اضافی دستاویزات',
      'sectionWhatToBring': 'ملاقات کے وقت کیا لائیں',
      'appointmentNotice': 'اپنے پاسپورٹ سیوا کیندر (PSK) کی ملاقات کے لیے اصلی دستاویزات اور تصدیق شدہ کاپیاں لازماً ساتھ لائیں۔',
      'whatDocsAccepted': 'قابل قبول دستاویزات دیکھیں ({count})',
      'hideAcceptedDocs': 'قابل قبول دستاویزات چھپائیں',
      'acceptableOptionsHeader':
          'قابل قبول دستاویزات (کم از کم ایک اصلی دستاویز لائیں):',
      'issuingAuthorityPrefix': 'جاری کنندہ ادارہ: ',
      'officialAdvisorAction': 'سرکاری ڈاکومنٹ ایڈوائزر',
      'sourceLinkTooltip': 'سرکاری ذریعہ: {title}',
      'couldNotOpenLink': 'سرکاری لنک کھولنے میں ناکامی۔',

      // Document Items
      'dobProofTitle': 'تاریخ پیدائش کا ثبوت (Proof of DOB)',
      'dobProofExplanation':
          'تاریخ پیدائش کی تصدیق کے لیے ایک سرکاری دستاویز لازمی ہے۔',
      'addressProofTitle': 'موجودہ پتے کا ثبوت (Proof of Address)',
      'addressProofExplanation': 'موجودہ رہائشی پتے کا ایک دستاویز لازمی ہے۔',
      'nonEcrEduTitle': 'تعلیمی قابلیت کا ثبوت (Non-ECR)',
      'nonEcrEduExplanation': 'دسویں جماعت یا اعلیٰ تعلیم کی ڈگری کا سرٹیفکیٹ۔',
      'nameChangeTitle': 'قانونی نام کی تبدیلی کا ثبوت',
      'nameChangeExplanation': 'گزٹ نوٹیفکیشن یا مجاز دستاویز۔',
      'inPersonTitle': 'ملاقات کی تیاری',
      'inPersonExplanation':
          'اصلی دستاویزات کی PSK کاؤنٹر پر تصدیق کی جاتی ہے۔',
    },
  };

  String translate(String key, {Map<String, String>? params}) {
    final langCode = locale.languageCode;
    final dict = _localizedValues[langCode] ?? _localizedValues['en']!;
    var value = dict[key] ?? _localizedValues['en']![key] ?? key;

    if (params != null) {
      params.forEach((paramKey, paramValue) {
        value = value.replaceAll('{$paramKey}', paramValue);
      });
    }

    return value;
  }

  // General Getters
  String get appName => translate('appName');
  String get appTagline => translate('appTagline');
  String get continueButton => translate('continueButton');
  String get backButton => translate('backButton');
  String get cancel => translate('cancel');
  String get iUnderstand => translate('iUnderstand');
  String get changeSelection => translate('changeSelection');
  String get openOfficialAdvisor => translate('openOfficialAdvisor');
  String get officialPortal => translate('officialPortal');
  String get settingsTitle => translate('settingsTitle');
  String get languageSection => translate('languageSection');
  String get currentLanguage => translate('currentLanguage');
  String get translationNotice => translate('translationNotice');
  String get translationUnderReviewTitle =>
      translate('translationUnderReviewTitle');
  String get translationUnderReviewBody =>
      translate('translationUnderReviewBody');

  // Home Screen Getters
  String get welcomeHeadline => translate('welcomeHeadline');
  String get welcomeSupportingText => translate('welcomeSupportingText');
  String get welcomeCta => translate('welcomeCta');
  String get welcomeConciseDisclaimer => translate('welcomeConciseDisclaimer');
  String get benefit1Title => translate('benefit1Title');
  String get benefit1Desc => translate('benefit1Desc');
  String get benefit2Title => translate('benefit2Title');
  String get benefit2Desc => translate('benefit2Desc');
  String get benefit3Title => translate('benefit3Title');
  String get benefit3Desc => translate('benefit3Desc');
  String get legalNoticeTitle => translate('legalNoticeTitle');
  String get privacyArchitectureTitle => translate('privacyArchitectureTitle');
  String get privacyPoints => translate('privacyPoints');
  String get fullDisclaimerBody => translate('fullDisclaimerBody');

  // Questionnaire Getters
  String get questionnaireTitle => translate('questionnaireTitle');
  String stepOf(int step) =>
      translate('stepOf', params: {'step': step.toString()});
  String get step1Title => translate('step1Title');
  String get step1Subtitle => translate('step1Subtitle');
  String get applicationTypeLabel => translate('applicationTypeLabel');
  String get freshPassportTitle => translate('freshPassportTitle');
  String get freshPassportSubtitle => translate('freshPassportSubtitle');
  String get reissuePassportTitle => translate('reissuePassportTitle');
  String get reissuePassportSubtitle => translate('reissuePassportSubtitle');
  String get passportSchemeLabel => translate('passportSchemeLabel');
  String get normalSchemeTitle => translate('normalSchemeTitle');
  String get normalSchemeSubtitle => translate('normalSchemeSubtitle');
  String get tatkaalSchemeTitle => translate('tatkaalSchemeTitle');
  String get tatkaalSchemeSubtitle => translate('tatkaalSchemeSubtitle');
  String get ageCategoryLabel => translate('ageCategoryLabel');
  String get adultAgeTitle => translate('adultAgeTitle');
  String get adultAgeSubtitle => translate('adultAgeSubtitle');
  String get minorAgeTitle => translate('minorAgeTitle');
  String get minorAgeSubtitle => translate('minorAgeSubtitle');

  // Step 2
  String get step2Title => translate('step2Title');
  String get step2Subtitle => translate('step2Subtitle');
  String get nonEcrCriteriaLabel => translate('nonEcrCriteriaLabel');
  String get critMatriculation => translate('critMatriculation');
  String get critMatriculationSub => translate('critMatriculationSub');
  String get critTaxPayer => translate('critTaxPayer');
  String get critTaxPayerSub => translate('critTaxPayerSub');
  String get critAge50 => translate('critAge50');
  String get critAge50Sub => translate('critAge50Sub');
  String get critGovtServant => translate('critGovtServant');
  String get critGovtServantSub => translate('critGovtServantSub');
  String get critDiploma => translate('critDiploma');
  String get critDiplomaSub => translate('critDiplomaSub');
  String get critSpouse => translate('critSpouse');
  String get critSpouseSub => translate('critSpouseSub');
  String get critNone => translate('critNone');
  String get critNoneSub => translate('critNoneSub');

  // Step 3
  String get step3Title => translate('step3Title');
  String get step3Subtitle => translate('step3Subtitle');
  String get nameChangeQuestion => translate('nameChangeQuestion');
  String get nameChangeSub => translate('nameChangeSub');
  String get multipleAddressQuestion => translate('multipleAddressQuestion');
  String get multipleAddressSub => translate('multipleAddressSub');
  String get yesOption => translate('yesOption');
  String get noOption => translate('noOption');
  String get generateChecklistCta => translate('generateChecklistCta');
  String get unsupportedCategoryTitle => translate('unsupportedCategoryTitle');
  String get unsupportedCategoryAdvisorNotice =>
      translate('unsupportedCategoryAdvisorNotice');

  // Checklist
  String get checklistTitle => translate('checklistTitle');
  String get requiredDocumentsHeader => translate('requiredDocumentsHeader');
  String get nonEcrBadge => translate('nonEcrBadge');
  String get ecrBadge => translate('ecrBadge');
  String get sectionEveryoneNeeds => translate('sectionEveryoneNeeds');
  String get sectionAdditionalDocs => translate('sectionAdditionalDocs');
  String get sectionWhatToBring => translate('sectionWhatToBring');
  String get appointmentNotice => translate('appointmentNotice');
  String whatDocsAccepted(int count) =>
      translate('whatDocsAccepted', params: {'count': count.toString()});
  String get hideAcceptedDocs => translate('hideAcceptedDocs');
  String get acceptableOptionsHeader => translate('acceptableOptionsHeader');
  String get issuingAuthorityPrefix => translate('issuingAuthorityPrefix');
  String get officialAdvisorAction => translate('officialAdvisorAction');
  String sourceLinkTooltip(String title) =>
      translate('sourceLinkTooltip', params: {'title': title});
  String get couldNotOpenLink => translate('couldNotOpenLink');

  // Document items
  String get dobProofTitle => translate('dobProofTitle');
  String get dobProofExplanation => translate('dobProofExplanation');
  String get addressProofTitle => translate('addressProofTitle');
  String get addressProofExplanation => translate('addressProofExplanation');
  String get nonEcrEduTitle => translate('nonEcrEduTitle');
  String get nonEcrEduExplanation => translate('nonEcrEduExplanation');
  String get nameChangeTitle => translate('nameChangeTitle');
  String get nameChangeExplanation => translate('nameChangeExplanation');
  String get inPersonTitle => translate('inPersonTitle');
  String get inPersonExplanation => translate('inPersonExplanation');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (l) => l.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
