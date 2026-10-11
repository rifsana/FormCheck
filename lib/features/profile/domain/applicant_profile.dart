enum ApplicationType { fresh, reissue }

enum PassportScheme { normal, tatkaal }

enum AgeCategory { adult18Plus, minorUnder18 }

enum NonEcrCriterion {
  matriculationOrAbove,
  incomeTaxPayer,
  age50Plus,
  govtServant,
  vocationalDiploma2Year,
  spouseOfEligiblePerson,
  none,
}

class ApplicantProfile {
  final ApplicationType applicationType;
  final PassportScheme scheme;
  final AgeCategory ageCategory;
  final NonEcrCriterion nonEcrCriterion;
  final bool hasNameChange;
  final bool hasResidedMultipleAddressesPastYear;

  const ApplicantProfile({
    this.applicationType = ApplicationType.fresh,
    this.scheme = PassportScheme.normal,
    this.ageCategory = AgeCategory.adult18Plus,
    this.nonEcrCriterion = NonEcrCriterion.matriculationOrAbove,
    this.hasNameChange = false,
    this.hasResidedMultipleAddressesPastYear = false,
  });

  bool get isSupported {
    return applicationType == ApplicationType.fresh &&
        scheme == PassportScheme.normal &&
        ageCategory == AgeCategory.adult18Plus;
  }

  String? get unsupportedReason {
    if (applicationType != ApplicationType.fresh) {
      return 'FormCheck MVP currently supports only First-Time (Fresh) Passport applications. Re-issue applications require previous passport verification.';
    }
    if (scheme != PassportScheme.normal) {
      return 'FormCheck MVP currently supports only the Normal application scheme. Tatkaal applications require verification of Annexure F and specific urgent criteria.';
    }
    if (ageCategory != AgeCategory.adult18Plus) {
      return 'FormCheck MVP currently supports only adult applicants aged 18 and older. Minor applications require Annexures C/D and parents\' passport proofs.';
    }
    return null;
  }

  bool get isNonEcrEligible => nonEcrCriterion != NonEcrCriterion.none;

  ApplicantProfile copyWith({
    ApplicationType? applicationType,
    PassportScheme? scheme,
    AgeCategory? ageCategory,
    NonEcrCriterion? nonEcrCriterion,
    bool? hasNameChange,
    bool? hasResidedMultipleAddressesPastYear,
  }) {
    return ApplicantProfile(
      applicationType: applicationType ?? this.applicationType,
      scheme: scheme ?? this.scheme,
      ageCategory: ageCategory ?? this.ageCategory,
      nonEcrCriterion: nonEcrCriterion ?? this.nonEcrCriterion,
      hasNameChange: hasNameChange ?? this.hasNameChange,
      hasResidedMultipleAddressesPastYear:
          hasResidedMultipleAddressesPastYear ??
          this.hasResidedMultipleAddressesPastYear,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplicantProfile &&
          runtimeType == other.runtimeType &&
          applicationType == other.applicationType &&
          scheme == other.scheme &&
          ageCategory == other.ageCategory &&
          nonEcrCriterion == other.nonEcrCriterion &&
          hasNameChange == other.hasNameChange &&
          hasResidedMultipleAddressesPastYear ==
              other.hasResidedMultipleAddressesPastYear;

  @override
  int get hashCode =>
      applicationType.hashCode ^
      scheme.hashCode ^
      ageCategory.hashCode ^
      nonEcrCriterion.hashCode ^
      hasNameChange.hashCode ^
      hasResidedMultipleAddressesPastYear.hashCode;
}
