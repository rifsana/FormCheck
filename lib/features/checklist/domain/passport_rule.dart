import '../../../core/constants/official_sources.dart';

enum DocumentCategory {
  dobProof,
  addressProof,
  nonEcrProof,
  nameChangeProof,
  inPersonGuidance,
}

enum RequirementClassification { mandatory, conditional, guidance, unverified }

enum VerificationStatus {
  verifiedOfficial,
  regionalJurisdictionDiscretion,
  unverified,
}

class AcceptedEvidence {
  final String id;
  final String name;
  final String issuingAuthority;
  final String? conditions;
  final bool requiresOriginal;

  const AcceptedEvidence({
    required this.id,
    required this.name,
    required this.issuingAuthority,
    this.conditions,
    this.requiresOriginal = true,
  });
}

class DocumentRequirement {
  final String id;
  final String title;
  final DocumentCategory category;
  final RequirementClassification classification;
  final VerificationStatus verificationStatus;
  final String explanation;
  final String? applicabilityCondition;
  final List<AcceptedEvidence> acceptedEvidence;
  final OfficialSource source;
  final String? verificationNotes;

  const DocumentRequirement({
    required this.id,
    required this.title,
    required this.category,
    required this.classification,
    required this.verificationStatus,
    required this.explanation,
    this.applicabilityCondition,
    required this.acceptedEvidence,
    required this.source,
    this.verificationNotes,
  });

  bool get isVerified =>
      verificationStatus == VerificationStatus.verifiedOfficial;
  bool get hasRegionalDiscretion =>
      verificationStatus == VerificationStatus.regionalJurisdictionDiscretion;
}

class ChecklistResolution {
  final bool isSupported;
  final String? unsupportedReason;
  final List<DocumentRequirement> requirements;
  final bool isNonEcrEligible;
  final String nonEcrStatusDescription;
  final List<String> unverifiedNotes;

  const ChecklistResolution({
    required this.isSupported,
    this.unsupportedReason,
    required this.requirements,
    required this.isNonEcrEligible,
    required this.nonEcrStatusDescription,
    this.unverifiedNotes = const [],
  });

  List<DocumentRequirement> get mandatoryRequirements => requirements
      .where((r) => r.classification == RequirementClassification.mandatory)
      .toList();

  List<DocumentRequirement> get conditionalRequirements => requirements
      .where((r) => r.classification == RequirementClassification.conditional)
      .toList();

  List<DocumentRequirement> get guidanceNotes => requirements
      .where((r) => r.classification == RequirementClassification.guidance)
      .toList();
}
