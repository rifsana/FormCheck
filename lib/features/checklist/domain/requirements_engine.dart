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
            'This application is outside the supported first-time adult scope.',
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
        nonEcrDesc = 'Non-ECR qualified (10th standard or higher education)';
        resolved.add(VerifiedRequirementsData.nonEcrEducation);
        break;

      case NonEcrCriterion.incomeTaxPayer:
        nonEcrEligible = true;
        nonEcrDesc = 'Non-ECR qualified (Individual income tax payer)';
        resolved.add(VerifiedRequirementsData.nonEcrTaxPayer);
        break;

      case NonEcrCriterion.age50Plus:
        nonEcrEligible = true;
        nonEcrDesc = 'Non-ECR qualified (50 years of age or older)';
        resolved.add(VerifiedRequirementsData.nonEcrAge50);
        break;

      case NonEcrCriterion.govtServant:
        nonEcrEligible = true;
        nonEcrDesc = 'Non-ECR qualified (Gazetted government servant)';
        resolved.add(VerifiedRequirementsData.nonEcrGovtServant);
        break;

      case NonEcrCriterion.vocationalDiploma2Year:
        nonEcrEligible = true;
        nonEcrDesc = 'Non-ECR qualified (2-year recognized vocational diploma)';
        resolved.add(VerifiedRequirementsData.nonEcrVocational);
        break;

      case NonEcrCriterion.spouseOfEligiblePerson:
        nonEcrEligible = true;
        nonEcrDesc = 'Non-ECR qualified (Spouse of a qualified person)';
        resolved.add(VerifiedRequirementsData.nonEcrSpouseEligible);
        break;

      case NonEcrCriterion.none:
        nonEcrEligible = false;
        nonEcrDesc = 'ECR Category. You do not need educational or tax proof; your passport will be printed with "Emigration Check Required" (clearance is needed only when taking up employment in 18 notified countries).';
        break;
    }

    // 4. Conditional: Name Change
    if (profile.hasNameChange) {
      resolved.add(VerifiedRequirementsData.nameChangeMajor);
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
