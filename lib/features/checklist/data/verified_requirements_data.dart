import '../../../core/constants/official_sources.dart';
import '../domain/passport_rule.dart';

class VerifiedRequirementsData {
  // 1. Mandatory Proof of Date of Birth (DOB)
  static const DocumentRequirement proofOfDob = DocumentRequirement(
    id: 'req_proof_of_dob',
    title: 'Proof of Date of Birth (DOB)',
    category: DocumentCategory.dobProof,
    classification: RequirementClassification.mandatory,
    explanation: 'Submit any one valid document issued by a competent authority showing your full date of birth.',
    applicabilityCondition: 'Mandatory for all adult applicants.',
    source: OfficialSources.listDob,
    isVerified: true,
    verificationNotes: 'Verified against MEA List of Acceptable Documents for Date of Birth (ListDOB). Ministry relaxed rules in Dec 2016 to allow multiple government-issued documents beyond birth certificates.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'dob_birth_cert',
        name: 'Birth Certificate',
        issuingAuthority:
            'Registrar of Births & Deaths / Municipal Corporation',
        conditions: 'Must be issued by the designated local authority.',
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
        conditions: 'Must have full date of birth (DD/MM/YYYY), not merely year of birth.',
      ),
      AcceptedEvidence(
        id: 'dob_driving_license',
        name: 'Driving License',
        issuingAuthority: 'Regional Transport Authority (RTO)',
      ),
      AcceptedEvidence(
        id: 'dob_voter_id',
        name: 'Voter ID (Election Photo Identity Card - EPIC)',
        issuingAuthority: 'Election Commission of India',
      ),
      AcceptedEvidence(
        id: 'dob_lic_bond',
        name: 'Policy Bond',
        issuingAuthority: 'Public Life Insurance Corporations / Companies',
        conditions: 'Must record applicant\'s date of birth.',
      ),
    ],
  );

  // 2. Mandatory Proof of Present Address
  static const DocumentRequirement proofOfAddress = DocumentRequirement(
    id: 'req_proof_of_address',
    title: 'Proof of Present Residential Address',
    category: DocumentCategory.addressProof,
    classification: RequirementClassification.mandatory,
    explanation: 'Submit any one valid document evidencing your continuous stay at your present residential address.',
    applicabilityCondition: 'Mandatory for all adult applicants.',
    source: OfficialSources.listDocuments,
    isVerified: true,
    verificationNotes: 'Verified against MEA Attachment Advisor and List of Acceptable Documents (ListDocuments). Address on the document must exactly match the application form.',
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
        conditions: 'Recent bill (must be in applicant\'s name or immediate relative with relation proof).',
      ),
      AcceptedEvidence(
        id: 'addr_water_bill',
        name: 'Water Bill',
        issuingAuthority: 'Municipal Water Board',
        conditions: 'Recent bill evidencing present address.',
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
        conditions:
            'Account must be currently operational with photo stamped by bank.',
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
        conditions: 'Must be formally registered under Section 17 of Registration Act (tenure > 1 year).',
      ),
      AcceptedEvidence(
        id: 'addr_spouse_passport',
        name: 'Spouse\'s Valid Passport Copy',
        issuingAuthority: 'Ministry of External Affairs',
        conditions: 'First and last page mentioning applicant\'s name as spouse and matching address.',
      ),
    ],
  );

  // 3. Conditional: Non-ECR Proof (Matriculation or Higher)
  static const DocumentRequirement nonEcrEducation = DocumentRequirement(
    id: 'req_non_ecr_education',
    title: 'Non-ECR Proof: Matriculation / Educational Certificate',
    category: DocumentCategory.nonEcrProof,
    classification: RequirementClassification.conditional,
    explanation: 'All persons having educational qualification of matriculation (10th standard pass) and above are eligible for Non-ECR passport status.',
    applicabilityCondition: 'Applicable because you stated you hold a 10th standard or higher qualification.',
    source: OfficialSources.nonEcrDocuments,
    isVerified: true,
    verificationNotes:
        'Verified against MEA onlineHtml/NonEcrDocuments Category (e).',
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
    explanation: 'All income-tax payers (in their individual capacity) are eligible for Non-ECR passport status.',
    applicabilityCondition:
        'Applicable because you qualified under the Income Tax Payer criteria.',
    source: OfficialSources.nonEcrDocuments,
    isVerified: true,
    verificationNotes: 'Verified against MEA onlineHtml/NonEcrDocuments Category (f). Requires proof of assessment and PAN.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'nonecr_itr_v',
        name: 'ITR-V (Acknowledgement) or Income Tax Assessment Order',
        issuingAuthority: 'Income Tax Department',
        conditions: 'For the last financial assessment year.',
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
    explanation: 'All persons aged 50 years and above qualify automatically for Non-ECR status based on their verified proof of age.',
    applicabilityCondition: 'Applicable because your age is 50 years or above.',
    source: OfficialSources.nonEcrDocuments,
    isVerified: true,
    verificationNotes: 'Verified against MEA onlineHtml/NonEcrDocuments Category (c). Covered by verified DOB proof.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'nonecr_age_dob',
        name: 'Accepted Proof of Date of Birth establishing age 50+',
        issuingAuthority: 'Competent Authority issuing DOB proof',
      ),
    ],
  );

  // 6. Conditional: Non-ECR Proof (Vocational Diploma)
  static const DocumentRequirement nonEcrVocational = DocumentRequirement(
    id: 'req_non_ecr_vocational',
    title: 'Non-ECR Proof: 2-Year Recognized Vocational Diploma',
    category: DocumentCategory.nonEcrProof,
    classification: RequirementClassification.conditional,
    explanation: 'Persons possessing two years diploma from any institute recognized by NCVT or SCVT qualify for Non-ECR.',
    applicabilityCondition:
        'Applicable because you hold a recognized 2-year vocational diploma.',
    source: OfficialSources.nonEcrDocuments,
    isVerified: true,
    verificationNotes:
        'Verified against MEA onlineHtml/NonEcrDocuments Category (i).',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'nonecr_ncvt_cert',
        name: '2-Year Diploma Certificate',
        issuingAuthority: 'Institute recognized by NCVT or SCVT',
      ),
    ],
  );

  // 7. Conditional: Name Change Gazette Notification
  static const DocumentRequirement nameChangeProof = DocumentRequirement(
    id: 'req_name_change',
    title: 'Proof of Name Change / Deed Poll',
    category: DocumentCategory.nameChangeProof,
    classification: RequirementClassification.conditional,
    explanation: 'If you have changed your name or surname from what is recorded on your primary evidence, you must provide supporting documentation.',
    applicabilityCondition:
        'Applicable because you indicated a change in your name.',
    source: OfficialSources.docAdvisor,
    isVerified: true,
    verificationNotes:
        'Verified against MEA Document Advisor guidance for name change.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'name_gazette',
        name: 'Gazette Notification reflecting name change',
        issuingAuthority: 'Department of Publication / State Gazette',
      ),
      AcceptedEvidence(
        id: 'name_newspaper',
        name: 'Two original newspapers containing change of name advertisement',
        issuingAuthority: 'Leading daily newspapers (one local, one English)',
      ),
      AcceptedEvidence(
        id: 'name_marriage_cert',
        name: 'Marriage Certificate / Joint photo affidavit (for change of surname after marriage)',
        issuingAuthority: 'Registrar of Marriages',
      ),
    ],
  );

  // 8. Guidance: In-Person PSK Appointment Preparation
  static const DocumentRequirement inPersonGuidance = DocumentRequirement(
    id: 'req_in_person_guidance',
    title: 'In-Person PSK Appointment Guidance',
    category: DocumentCategory.inPersonGuidance,
    classification: RequirementClassification.guidance,
    explanation: 'Key preparation rules for your physical appointment at the Passport Seva Kendra (PSK / POPSK).',
    applicabilityCondition: 'Applicable to all applicants.',
    source: OfficialSources.applicationGuide,
    isVerified: true,
    verificationNotes:
        'Verified against MEA Application Guide and PSK operations.',
    acceptedEvidence: [
      AcceptedEvidence(
        id: 'guide_originals',
        name: 'Original Documents',
        issuingAuthority: 'Applicant',
        conditions: 'All submitted documents must be produced in original for physical verification at Counter A.',
      ),
      AcceptedEvidence(
        id: 'guide_photocopies',
        name: 'Self-Attested Photocopies',
        issuingAuthority: 'Applicant',
        conditions: 'Carry at least two sets of self-attested photocopies of each original document.',
      ),
      AcceptedEvidence(
        id: 'guide_arn_receipt',
        name: 'Application Reference Number (ARN) Receipt / SMS',
        issuingAuthority: 'Passport Seva Online Portal',
        conditions: 'Appointment SMS on your mobile phone is accepted as entry proof at PSK.',
      ),
      AcceptedEvidence(
        id: 'guide_photos_digital',
        name: 'Digital Photography at PSK (No physical photo needed)',
        issuingAuthority: 'PSK Counter A Operator',
        conditions: 'Photographs and fingerprints are captured digitally on-site for adult applicants.',
      ),
    ],
  );
}
