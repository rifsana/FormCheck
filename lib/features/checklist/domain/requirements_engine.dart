import '../../profile/domain/applicant_profile.dart';
import '../data/verified_requirements_data.dart';
import 'passport_rule.dart';

class RequirementsEngine {
  /// Deterministically resolves the official document checklist for an applicant profile.
  static ChecklistResolution resolve(ApplicantProfile profile) {
    if (!profile.isSupported) {
      return ChecklistResolution(
        isSupported: false,
        unsupportedReason: profile.unsupportedReason,
        requirements: const [],
        isNonEcrEligible: false,
        nonEcrStatusDescription:
            'Application profile is outside supported MVP scope.',
      );
    }

    final List<DocumentRequirement> resolved = [];
    final List<String> unverified = [];

    // 1. Mandatory Proof of Date of Birth
    resolved.add(VerifiedRequirementsData.proofOfDob);

    // 2. Mandatory Proof of Present Address
    resolved.add(VerifiedRequirementsData.proofOfAddress);

    // 3. Conditional: Non-ECR status logic
    bool nonEcrEligible = false;
    String nonEcrDesc = '';

    switch (profile.nonEcrCriterion) {
      case NonEcrCriterion.matriculationOrAbove:
        nonEcrEligible = true;
        nonEcrDesc =
            'Eligible for Non-ECR (10th Standard / Matriculation or higher)';
        resolved.add(VerifiedRequirementsData.nonEcrEducation);
        break;

      case NonEcrCriterion.incomeTaxPayer:
        nonEcrEligible = true;
        nonEcrDesc =
            'Eligible for Non-ECR (Income Tax Payer in individual capacity)';
        resolved.add(VerifiedRequirementsData.nonEcrTaxPayer);
        break;

      case NonEcrCriterion.age50Plus:
        nonEcrEligible = true;
        nonEcrDesc =
            'Eligible for Non-ECR (Applicant is 50 years of age or older)';
        resolved.add(VerifiedRequirementsData.nonEcrAge50);
        break;

      case NonEcrCriterion.vocationalDiploma2Year:
        nonEcrEligible = true;
        nonEcrDesc = 'Eligible for Non-ECR (2-Year NCVT/SCVT Recognized Vocational Diploma)';
        resolved.add(VerifiedRequirementsData.nonEcrVocational);
        break;

      case NonEcrCriterion.none:
        nonEcrEligible = false;
        nonEcrDesc = 'ECR Category (Emigration Check Required). No additional educational/tax certificate needed; passport will be stamped ECR.';
        break;
    }

    // 4. Conditional: Name Change
    if (profile.hasNameChange) {
      resolved.add(VerifiedRequirementsData.nameChangeProof);
    }

    // 5. General in-person guidance notes
    resolved.add(VerifiedRequirementsData.inPersonGuidance);

    return ChecklistResolution(
      isSupported: true,
      requirements: List.unmodifiable(resolved),
      isNonEcrEligible: nonEcrEligible,
      nonEcrStatusDescription: nonEcrDesc,
      unverifiedNotes: List.unmodifiable(unverified),
    );
  }
}
