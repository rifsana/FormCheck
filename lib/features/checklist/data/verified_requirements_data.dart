import '../../../core/constants/official_sources.dart';
import '../domain/passport_rule.dart';

class VerifiedRequirementsData {
  // 1. Mandatory Proof of Date of Birth (DOB)
  static const DocumentRequirement proofOfDob = DocumentRequirement(
    id: 'req_proof_of_dob',
    title: 'Proof of your date of birth',
    category: DocumentCategory.dobProof,
    classification: RequirementClassification.mandatory,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'Bring any one official document that clearly shows your full date of birth (day, month, and year).',
    applicabilityCondition: 'Required for all adult applicants. (Adults born before Oct 1, 2023, can use any of the 8 approved documents below; a birth certificate is only strictly mandatory for those born on or after Oct 1, 2023).',
    source: OfficialSources.listDob,
    verificationNotes: 'Verified against MEA List of Acceptable Documents for Date of Birth (ListDOB). Rule relaxed Dec 2016 allowing 8 distinct identity documents.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'dob_birth_cert',
        name: 'Birth Certificate',
        issuingAuthority:
            'Registrar of Births & Deaths / Municipal Corporation',
        conditions: 'Must be issued under the RBD Act, 1969.',
      ),
      AcceptedEvidence(
        id: 'dob_school_cert',
        name: 'School Leaving / Matriculation Certificate',
        issuingAuthority: 'Recognized Educational Board or School',
        conditions: 'Must clearly state your full date of birth.',
      ),
      AcceptedEvidence(
        id: 'dob_pan_card',
        name: 'PAN Card / e-PAN',
        issuingAuthority: 'Income Tax Department',
      ),
      AcceptedEvidence(
        id: 'dob_aadhaar',
        name: 'Aadhaar Card / e-Aadhaar',
        issuingAuthority: 'UIDAI',
        conditions: 'Must show your full Date of Birth (DD/MM/YYYY). Cards showing only year of birth (YYYY) are not accepted.',
      ),
      AcceptedEvidence(
        id: 'dob_driving_license',
        name: 'Driving License',
        issuingAuthority: 'Regional Transport Authority (RTO)',
      ),
      AcceptedEvidence(
        id: 'dob_voter_id',
        name: 'Voter ID Card (EPIC)',
        issuingAuthority: 'Election Commission of India',
      ),
      AcceptedEvidence(
        id: 'dob_service_record',
        name: 'Service Record Extract / Pension Payment Order (PPO)',
        issuingAuthority: 'Government Department or PSU',
        conditions: 'For government employees and pensioners; certified by officer-in-charge.',
      ),
      AcceptedEvidence(
        id: 'dob_lic_bond',
        name: 'Life Insurance Policy Bond',
        issuingAuthority: 'Public Life Insurance Corporations',
        conditions: 'Must record your full date of birth.',
      ),
    ],
  );

  // 2. Mandatory Proof of Present Address
  static const DocumentRequirement proofOfAddress = DocumentRequirement(
    id: 'req_proof_of_address',
    title: 'Proof of your current address',
    category: DocumentCategory.addressProof,
    classification: RequirementClassification.mandatory,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'Bring any one document showing where you live right now. The address must match the one on your application.',
    applicabilityCondition: 'Required for all adult applicants. If you lived at more than one address in the past year, list all of them in your application for police verification.',
    source: OfficialSources.listDocuments,
    verificationNotes:
        'Verified against MEA ListDocuments and Attachment Advisor.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'addr_aadhaar',
        name: 'Aadhaar Card / e-Aadhaar',
        issuingAuthority: 'UIDAI',
        conditions: 'Must match your current place of stay.',
      ),
      AcceptedEvidence(
        id: 'addr_electricity_bill',
        name: 'Electricity Bill',
        issuingAuthority: 'Electricity Distribution Company',
        conditions: 'Must be recent (last 2-3 months). In your name or immediate family with relationship proof.',
      ),
      AcceptedEvidence(
        id: 'addr_water_bill',
        name: 'Water Bill',
        issuingAuthority: 'Municipal Water Board',
        conditions: 'Recent bill showing your current address.',
      ),
      AcceptedEvidence(
        id: 'addr_telephone_bill',
        name: 'Telephone Bill (Landline or Postpaid Mobile)',
        issuingAuthority: 'Telecom Service Provider',
        conditions: 'Recent bill matching your current address.',
      ),
      AcceptedEvidence(
        id: 'addr_gas_connection',
        name: 'Proof of Gas Connection',
        issuingAuthority: 'Oil / Gas Marketing Undertaking',
      ),
      AcceptedEvidence(
        id: 'addr_bank_passbook',
        name: 'Bank Passbook (with photo)',
        issuingAuthority:
            'Scheduled Public / Private Bank or Regional Rural Bank',
        conditions: 'Must be an active account. Photo must be stamped and signed by the bank manager.',
      ),
      AcceptedEvidence(
        id: 'addr_voter_id',
        name: 'Voter ID Card (EPIC)',
        issuingAuthority: 'Election Commission of India',
      ),
      AcceptedEvidence(
        id: 'addr_rent_agreement',
        name: 'Registered Rent Agreement',
        issuingAuthority: 'Sub-Registrar Office',
        conditions: 'Must be registered under Section 17 of the Registration Act. Regional offices usually require a tenure of 1 year or more.',
      ),
      AcceptedEvidence(
        id: 'addr_it_assessment',
        name: 'Income Tax Assessment Order',
        issuingAuthority: 'Income Tax Department',
        conditions: 'Recent order showing your current address.',
      ),
      AcceptedEvidence(
        id: 'addr_spouse_passport',
        name: 'Spouse\'s Valid Passport Copy',
        issuingAuthority: 'Ministry of External Affairs',
        conditions: 'First and last page mentioning your name as spouse and matching current address.',
      ),
      AcceptedEvidence(
        id: 'addr_employer_cert',
        name: 'Employer Certificate on Official Letterhead',
        issuingAuthority: 'Public Sector Undertaking or Reputed Firm',
        conditions: 'Subject to regional office acceptance; carry your employee ID card.',
      ),
    ],
  );

  // 3. Conditional: Non-ECR Proof (Matriculation or Higher)
  static const DocumentRequirement nonEcrEducation = DocumentRequirement(
    id: 'req_non_ecr_education',
    title: 'Non-ECR: 10th grade or higher certificate',
    category: DocumentCategory.nonEcrProof,
    classification: RequirementClassification.conditional,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'Anyone who has passed 10th standard (Matriculation) or higher qualifies for Non-ECR status.',
    applicabilityCondition:
        'Applies because you hold a 10th standard or higher qualification.',
    source: OfficialSources.nonEcrDocuments,
    verificationNotes: 'Verified against MEA NonEcrDocuments Category (e). Provisional certificates are accepted only with all semester marksheets.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'nonecr_matric_cert',
        name: '10th Standard (Matriculation) Pass Certificate',
        issuingAuthority:
            'Recognized Educational Board (CBSE, ICSE, State Boards)',
      ),
      AcceptedEvidence(
        id: 'nonecr_degree_cert',
        name: 'Higher Secondary / Degree / Post-Graduate Certificate',
        issuingAuthority: 'Recognized University / Educational Institution',
      ),
    ],
  );

  // 4. Conditional: Non-ECR Proof (Income Tax Payers)
  static const DocumentRequirement nonEcrTaxPayer = DocumentRequirement(
    id: 'req_non_ecr_taxpayer',
    title: 'Non-ECR: Income tax acknowledgement & PAN',
    category: DocumentCategory.nonEcrProof,
    classification: RequirementClassification.conditional,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'Individual income tax payers qualify for Non-ECR status.',
    applicabilityCondition:
        'Applies because you selected individual income tax payer.',
    source: OfficialSources.nonEcrDocuments,
    verificationNotes: 'Verified against MEA NonEcrDocuments Category (f). Requires proof of assessment/payment and PAN copy.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'nonecr_itr_v',
        name: 'ITR-V (Acknowledgement) or Tax Assessment Order',
        issuingAuthority: 'Income Tax Department',
        conditions:
            'For the last assessment year, showing actual payment of tax.',
      ),
      AcceptedEvidence(
        id: 'nonecr_pan_copy',
        name: 'PAN Card Copy',
        issuingAuthority: 'Income Tax Department',
      ),
    ],
  );

  // 5. Conditional: Non-ECR Proof (Age 50 or Older)
  static const DocumentRequirement nonEcrAge50 = DocumentRequirement(
    id: 'req_non_ecr_age50',
    title: 'Non-ECR: Proof of age (50 years or above)',
    category: DocumentCategory.nonEcrProof,
    classification: RequirementClassification.conditional,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation:
        'Anyone aged 50 and above qualifies automatically for Non-ECR status.',
    applicabilityCondition: 'Applies because your age is 50 years or older.',
    source: OfficialSources.nonEcrDocuments,
    verificationNotes: 'Verified against MEA NonEcrDocuments Category (c). Covered by your birth proof.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'nonecr_age_dob',
        name: 'Accepted Proof of Date of Birth establishing age 50+',
        issuingAuthority: 'Competent Authority issuing your birth proof',
      ),
    ],
  );

  // 6. Conditional: Non-ECR Proof (Government Servant / PSU)
  static const DocumentRequirement nonEcrGovtServant = DocumentRequirement(
    id: 'req_non_ecr_govt_servant',
    title: 'Non-ECR: Government servant identity proof',
    category: DocumentCategory.nonEcrProof,
    classification: RequirementClassification.conditional,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'Gazetted government servants and their immediate family members qualify for Non-ECR status.',
    applicabilityCondition:
        'Applies because you are a gazetted government servant or dependent.',
    source: OfficialSources.nonEcrDocuments,
    verificationNotes: 'Verified against MEA NonEcrDocuments Category (a).',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'nonecr_govt_id',
        name: 'Identity Certificate / Prior Intimation (Annexure A/H)',
        issuingAuthority: 'Head of Department / Cadre Controlling Authority',
      ),
    ],
  );

  // 7. Conditional: Non-ECR Proof (Vocational Diploma)
  static const DocumentRequirement nonEcrVocational = DocumentRequirement(
    id: 'req_non_ecr_vocational',
    title: 'Non-ECR: 2-year vocational diploma',
    category: DocumentCategory.nonEcrProof,
    classification: RequirementClassification.conditional,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'Holders of recognized two-year vocational diplomas qualify for Non-ECR status.',
    applicabilityCondition:
        'Applies because you hold a recognized 2-year vocational diploma.',
    source: OfficialSources.nonEcrDocuments,
    verificationNotes: 'Verified against MEA NonEcrDocuments Category (i).',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'nonecr_ncvt_cert',
        name: '2-Year Diploma Certificate',
        issuingAuthority: 'Institute recognized by NCVT or SCVT',
      ),
    ],
  );

  // 8. Conditional: Non-ECR Proof (Spouse of Eligible Person)
  static const DocumentRequirement nonEcrSpouseEligible = DocumentRequirement(
    id: 'req_non_ecr_spouse',
    title: 'Non-ECR: Spouse\'s qualifying document',
    category: DocumentCategory.nonEcrProof,
    classification: RequirementClassification.conditional,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'Spouses of people who qualify for Non-ECR (such as graduates, taxpayers, or govt officers) also qualify.',
    applicabilityCondition:
        'Applies because your spouse qualifies for Non-ECR status.',
    source: OfficialSources.nonEcrDocuments,
    verificationNotes: 'Verified against MEA NonEcrDocuments Category (d).',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'nonecr_spouse_marriage_cert',
        name: 'Marriage Certificate / Joint Affidavit',
        issuingAuthority: 'Registrar of Marriages',
      ),
      AcceptedEvidence(
        id: 'nonecr_spouse_proof',
        name: 'Spouse\'s Non-ECR Document (10th cert, ITR, or Govt ID)',
        issuingAuthority: 'Competent Authority',
      ),
    ],
  );

  // 9. Conditional: Name Change Requirements
  static const DocumentRequirement nameChangeMajor = DocumentRequirement(
    id: 'req_name_change_major',
    title: 'Proof of legal name change',
    category: DocumentCategory.nameChangeProof,
    classification: RequirementClassification.conditional,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'If your name differs substantially from your birth or school records, bring proof of the legal change.',
    applicabilityCondition:
        'Applies because you indicated your name has changed.',
    source: OfficialSources.docAdvisor,
    verificationNotes: 'Verified against MEA Document Advisor. Note: Changing surname after marriage follows a simpler process (marriage certificate / joint photo declaration).',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'name_gazette',
        name: 'Official Gazette Notification showing new name',
        issuingAuthority: 'Department of Publication / State Gazette',
      ),
      AcceptedEvidence(
        id: 'name_newspapers',
        name: 'Two original newspapers with name change notice',
        issuingAuthority:
            'Leading daily newspapers (one local, one permanent area)',
        conditions: 'Must be full original newspaper clippings with title and date clearly visible.',
      ),
      AcceptedEvidence(
        id: 'name_annexure_e',
        name: 'Deed Poll / Sworn Affidavit (Annexure E)',
        issuingAuthority: 'Notary Public / Judicial Magistrate',
      ),
    ],
  );

  // 10. Guidance: In-Person PSK Appointment Preparation
  static const DocumentRequirement inPersonGuidance = DocumentRequirement(
    id: 'req_in_person_guidance',
    title: 'What to bring to your appointment',
    category: DocumentCategory.inPersonGuidance,
    classification: RequirementClassification.guidance,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'Keep these official rules in mind when visiting the Passport Seva Kendra (PSK / POPSK).',
    applicabilityCondition: 'Applies to all applicants.',
    source: OfficialSources.applicationGuide,
    verificationNotes:
        'Verified against MEA Application Guide and PSK operations.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'guide_originals',
        name: 'Original documents',
        issuingAuthority: 'Applicant',
        conditions: 'Bring the original copies of all documents you chose. Officers inspect these in person at Counter A.',
      ),
      AcceptedEvidence(
        id: 'guide_photocopies',
        name: 'Self-attested photocopies',
        issuingAuthority: 'Applicant',
        conditions: 'Bring at least two clear photocopies of each original, signed by you with the current date.',
      ),
      AcceptedEvidence(
        id: 'guide_arn_receipt',
        name: 'Appointment SMS or ARN receipt',
        issuingAuthority: 'Passport Seva Online Portal',
        conditions: 'The appointment confirmation SMS on your phone is accepted at the gate.',
      ),
      AcceptedEvidence(
        id: 'guide_photos_digital',
        name: 'Digital photo taken at the center',
        issuingAuthority: 'PSK Counter A Operator',
        conditions: 'Your photo and fingerprints are taken digitally on site. Adult applicants do not need to bring paper passport photos.',
      ),
    ],
  );
}
