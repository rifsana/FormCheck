import '../../../core/constants/official_sources.dart';
import '../domain/passport_rule.dart';

class VerifiedRequirementsData {
  // 1. Mandatory Proof of Date of Birth (DOB)
  static const DocumentRequirement proofOfDob = DocumentRequirement(
    id: 'req_proof_of_dob',
    title: 'Proof of Date of Birth (DOB)',
    category: DocumentCategory.dobProof,
    classification: RequirementClassification.mandatory,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'Submit any one valid document issued by a competent authority recording your full date of birth.',
    applicabilityCondition: 'Mandatory for all adult applicants. (Note: Under the 2023 Amendment to Registration of Births and Deaths Act, Birth Certificate is mandatory only for persons born on or after Oct 1, 2023; adult applicants born prior can furnish any of the 8 approved proofs).',
    source: OfficialSources.listDob,
    verificationNotes: 'Verified against MEA List of Acceptable Documents for Date of Birth (ListDOB). Rule relaxed Dec 2016 allowing 8 distinct identity documents.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'dob_birth_cert',
        name: 'Birth Certificate',
        issuingAuthority:
            'Registrar of Births & Deaths / Municipal Corporation',
        conditions:
            'Must be issued by designated local authority under RBD Act, 1969.',
      ),
      AcceptedEvidence(
        id: 'dob_school_cert',
        name: 'Transfer / School Leaving / Matriculation Certificate',
        issuingAuthority: 'Recognized Educational Board or School',
        conditions: 'Must clearly state applicant\'s date of birth.',
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
        conditions: 'Must contain complete Date of Birth (DD/MM/YYYY). If card reflects only Year of Birth (YYYY), it will not be accepted as DOB proof.',
      ),
      AcceptedEvidence(
        id: 'dob_driving_license',
        name: 'Driving License',
        issuingAuthority: 'Regional Transport Authority (RTO)',
      ),
      AcceptedEvidence(
        id: 'dob_voter_id',
        name: 'Election Photo Identity Card (Voter ID - EPIC)',
        issuingAuthority: 'Election Commission of India',
      ),
      AcceptedEvidence(
        id: 'dob_service_record',
        name: 'Service Record Extract / Pay Pension Order (PPO)',
        issuingAuthority: 'Government Ministry / Department / PSU',
        conditions: 'For government employees and pensioners; duly certified by officer-in-charge.',
      ),
      AcceptedEvidence(
        id: 'dob_lic_bond',
        name: 'Policy Bond',
        issuingAuthority: 'Public Life Insurance Corporations / Companies',
        conditions: 'Must record applicant\'s full date of birth.',
      ),
    ],
  );

  // 2. Mandatory Proof of Present Address
  static const DocumentRequirement proofOfAddress = DocumentRequirement(
    id: 'req_proof_of_address',
    title: 'Proof of Present Residential Address',
    category: DocumentCategory.addressProof,
    classification: RequirementClassification.mandatory,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'Submit any one valid document evidencing your continuous stay at your present residential address.',
    applicabilityCondition: 'Mandatory for all adult applicants. Must match the present address stated in the online application form.',
    source: OfficialSources.listDocuments,
    verificationNotes: 'Verified against MEA ListDocuments and Attachment Advisor. If applicant resided at multiple addresses within the previous 1 calendar year, all places must be declared for police verification.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'addr_aadhaar',
        name: 'Aadhaar Card / e-Aadhaar',
        issuingAuthority: 'UIDAI',
        conditions: 'Address must match current place of residence.',
      ),
      AcceptedEvidence(
        id: 'addr_electricity_bill',
        name: 'Electricity Bill',
        issuingAuthority: 'Electricity Distribution Company',
        conditions: 'Recent bill (last 2-3 months). In applicant\'s name or immediate family with relation proof.',
      ),
      AcceptedEvidence(
        id: 'addr_water_bill',
        name: 'Water Bill',
        issuingAuthority: 'Municipal Water Board',
        conditions: 'Recent bill evidencing present residential address.',
      ),
      AcceptedEvidence(
        id: 'addr_telephone_bill',
        name: 'Telephone Bill (Landline or Postpaid Mobile)',
        issuingAuthority: 'Telecom Service Provider',
        conditions: 'Recent bill matching present address.',
      ),
      AcceptedEvidence(
        id: 'addr_gas_connection',
        name: 'Proof of Gas Connection',
        issuingAuthority: 'Oil / Gas Marketing Undertaking',
      ),
      AcceptedEvidence(
        id: 'addr_bank_passbook',
        name: 'Bank Account Passbook (with photograph)',
        issuingAuthority: 'Scheduled Public / Private Sector Bank or RRB',
        conditions: 'Must be actively operational with photo stamped and signed by branch manager.',
      ),
      AcceptedEvidence(
        id: 'addr_voter_id',
        name: 'Election Photo Identity Card (Voter ID)',
        issuingAuthority: 'Election Commission of India',
      ),
      AcceptedEvidence(
        id: 'addr_rent_agreement',
        name: 'Registered Rent Agreement',
        issuingAuthority: 'Sub-Registrar Office',
        conditions: 'Must be registered under Section 17 of Registration Act. Note: Jurisdictional RPOs require tenure of 1 year or more.',
      ),
      AcceptedEvidence(
        id: 'addr_it_assessment',
        name: 'Income Tax Assessment Order',
        issuingAuthority: 'Income Tax Department',
        conditions: 'Assessment order for recent financial year showing present address.',
      ),
      AcceptedEvidence(
        id: 'addr_spouse_passport',
        name: 'Spouse\'s Valid Passport Copy',
        issuingAuthority: 'Ministry of External Affairs',
        conditions: 'First and last page mentioning applicant\'s name as spouse and matching present address.',
      ),
      AcceptedEvidence(
        id: 'addr_employer_cert',
        name: 'Certificate from Employer on Letterhead',
        issuingAuthority: 'Public Sector Undertaking or Reputed Private Firm',
        conditions: 'Subject to jurisdictional RPO discretion; requires supporting company ID card.',
      ),
    ],
  );

  // 3. Conditional: Non-ECR Proof (Matriculation or Higher)
  static const DocumentRequirement nonEcrEducation = DocumentRequirement(
    id: 'req_non_ecr_education',
    title: 'Non-ECR Proof: Matriculation / Educational Certificate',
    category: DocumentCategory.nonEcrProof,
    classification: RequirementClassification.conditional,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'All persons holding educational qualification of matriculation (10th standard pass) and above are eligible for Non-ECR status.',
    applicabilityCondition: 'Applicable because you stated you hold a 10th standard or higher qualification.',
    source: OfficialSources.nonEcrDocuments,
    verificationNotes: 'Verified against MEA NonEcrDocuments Category (e). Provisional certificates are accepted only if accompanied by mark sheets of all semesters/years.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'nonecr_matric_cert',
        name: 'Matriculation (10th Standard) Pass Certificate',
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
    title: 'Non-ECR Proof: Income Tax Assessment & PAN',
    category: DocumentCategory.nonEcrProof,
    classification: RequirementClassification.conditional,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'All income-tax payers (in their individual capacity) are eligible for Non-ECR passport status.',
    applicabilityCondition: 'Applicable because you qualified under the individual Income Tax Payer criteria.',
    source: OfficialSources.nonEcrDocuments,
    verificationNotes: 'Verified against MEA NonEcrDocuments Category (f). Requires proof of assessment and actual tax payment, along with PAN copy.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'nonecr_itr_v',
        name: 'ITR-V (Acknowledgement) or Income Tax Assessment Order',
        issuingAuthority: 'Income Tax Department',
        conditions: 'For the last financial assessment year showing actual payment of tax.',
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
    title: 'Non-ECR Proof: Proof of Age (50 Years or Above)',
    category: DocumentCategory.nonEcrProof,
    classification: RequirementClassification.conditional,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'All persons aged 50 years and above qualify automatically for Non-ECR status based on their verified proof of age.',
    applicabilityCondition: 'Applicable because your age is 50 years or above.',
    source: OfficialSources.nonEcrDocuments,
    verificationNotes: 'Verified against MEA NonEcrDocuments Category (c). Covered by verified DOB proof.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'nonecr_age_dob',
        name: 'Accepted Proof of Date of Birth establishing age 50+',
        issuingAuthority: 'Competent Authority issuing DOB proof',
      ),
    ],
  );

  // 6. Conditional: Non-ECR Proof (Government Servant / PSU)
  static const DocumentRequirement nonEcrGovtServant = DocumentRequirement(
    id: 'req_non_ecr_govt_servant',
    title: 'Non-ECR Proof: Government Servant / Gazetted Officer',
    category: DocumentCategory.nonEcrProof,
    classification: RequirementClassification.conditional,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'All gazetted government servants, their spouses, and dependent children qualify for Non-ECR status.',
    applicabilityCondition: 'Applicable because you are a gazetted government servant or immediate family member.',
    source: OfficialSources.nonEcrDocuments,
    verificationNotes: 'Verified against MEA NonEcrDocuments Category (a). Requires identity certificate / NOC or PPO.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'nonecr_govt_id',
        name: 'Identity Certificate / Prior Intimation Letter (Annexure A/H)',
        issuingAuthority: 'Cadre Controlling Authority / Head of Department',
      ),
    ],
  );

  // 7. Conditional: Non-ECR Proof (Vocational Diploma)
  static const DocumentRequirement nonEcrVocational = DocumentRequirement(
    id: 'req_non_ecr_vocational',
    title: 'Non-ECR Proof: 2-Year Recognized Vocational Diploma',
    category: DocumentCategory.nonEcrProof,
    classification: RequirementClassification.conditional,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'Persons possessing two years diploma from any institute recognized by NCVT or SCVT qualify for Non-ECR.',
    applicabilityCondition:
        'Applicable because you hold a recognized 2-year vocational diploma.',
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
    title: 'Non-ECR Proof: Spouse of Non-ECR Eligible Person',
    category: DocumentCategory.nonEcrProof,
    classification: RequirementClassification.conditional,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'Spouses of persons eligible for Non-ECR (e.g., income taxpayers, matriculates, or gazetted officers) qualify for Non-ECR.',
    applicabilityCondition:
        'Applicable because your spouse qualifies for Non-ECR status.',
    source: OfficialSources.nonEcrDocuments,
    verificationNotes: 'Verified against MEA NonEcrDocuments Category (d). Requires marriage proof and spouse\'s eligibility evidence.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'nonecr_spouse_marriage_cert',
        name: 'Marriage Certificate / Joint Affidavit',
        issuingAuthority: 'Registrar of Marriages',
      ),
      AcceptedEvidence(
        id: 'nonecr_spouse_proof',
        name: 'Spouse\'s Non-ECR Proof (Matriculation cert, ITR, or Govt ID)',
        issuingAuthority: 'Competent Authority',
      ),
    ],
  );

  // 9. Conditional: Name Change Requirements
  static const DocumentRequirement nameChangeMajor = DocumentRequirement(
    id: 'req_name_change_major',
    title: 'Proof of Legal Name Change (Deed Poll & Newspapers)',
    category: DocumentCategory.nameChangeProof,
    classification: RequirementClassification.conditional,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'If you have changed your name or surname substantially from your school/birth records, you must furnish formal notification.',
    applicabilityCondition:
        'Applicable because you indicated a legal change of name.',
    source: OfficialSources.docAdvisor,
    verificationNotes: 'Verified against MEA Document Advisor and Passport Rules. Note: For change of surname following marriage, a simplified joint declaration/marriage certificate applies instead.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'name_gazette',
        name: 'Gazette Notification reflecting name change',
        issuingAuthority: 'Department of Publication / Official State Gazette',
      ),
      AcceptedEvidence(
        id: 'name_newspapers',
        name: 'Two original newspapers containing change of name advertisement',
        issuingAuthority:
            'Leading daily newspapers (one local, one permanent area)',
        conditions: 'Must furnish original cuttings with date and newspaper title visible.',
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
    title: 'In-Person PSK Appointment Guidance',
    category: DocumentCategory.inPersonGuidance,
    classification: RequirementClassification.guidance,
    verificationStatus: VerificationStatus.verifiedOfficial,
    explanation: 'Key operational guidelines for your physical appointment at the Passport Seva Kendra (PSK / POPSK).',
    applicabilityCondition: 'Applicable to all applicants.',
    source: OfficialSources.applicationGuide,
    verificationNotes:
        'Verified against MEA Application Guide and PSK operations.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'guide_originals',
        name: 'Original Documents',
        issuingAuthority: 'Applicant',
        conditions: 'All submitted documents must be produced in ORIGINAL for physical verification at Counter A.',
      ),
      AcceptedEvidence(
        id: 'guide_photocopies',
        name: 'Self-Attested Photocopies',
        issuingAuthority: 'Applicant',
        conditions: 'Carry at least two sets of clear, legible self-attested photocopies of each original document.',
      ),
      AcceptedEvidence(
        id: 'guide_arn_receipt',
        name: 'Application Reference Number (ARN) Receipt / SMS',
        issuingAuthority: 'Passport Seva Online Portal',
        conditions: 'Appointment confirmation SMS on your mobile phone is accepted as proof for entry at PSK gate.',
      ),
      AcceptedEvidence(
        id: 'guide_photos_digital',
        name: 'Digital Photography at PSK (No physical photo needed)',
        issuingAuthority: 'PSK Counter A Operator',
        conditions: 'Photographs and biometric fingerprints are captured digitally on-site for adult applicants.',
      ),
    ],
  );
}
