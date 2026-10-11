import 'package:flutter_test/flutter_test.dart';
import 'package:form_check/features/profile/domain/applicant_profile.dart';
import 'package:form_check/features/checklist/domain/passport_rule.dart';
import 'package:form_check/features/checklist/domain/requirements_engine.dart';
import 'package:form_check/features/checklist/data/verified_requirements_data.dart';

void main() {
  group('RequirementsEngine Unit Tests', () {
    test('Resolves mandatory DOB and Address for standard adult fresh normal application', () {
      const profile = ApplicantProfile(
        applicationType: ApplicationType.fresh,
        scheme: PassportScheme.normal,
        ageCategory: AgeCategory.adult18Plus,
        nonEcrCriterion: NonEcrCriterion.matriculationOrAbove,
      );

      final resolution = RequirementsEngine.resolve(profile);

      expect(resolution.isSupported, isTrue);
      expect(resolution.isNonEcrEligible, isTrue);

      final ids = resolution.requirements.map((r) => r.id).toList();
      expect(ids, contains('req_proof_of_dob'));
      expect(ids, contains('req_proof_of_address'));
      expect(ids, contains('req_non_ecr_education'));
      expect(ids, contains('req_in_person_guidance'));

      // Check classification
      final dobReq = resolution.requirements.firstWhere(
        (r) => r.id == 'req_proof_of_dob',
      );
      expect(dobReq.classification, RequirementClassification.mandatory);
      expect(dobReq.isVerified, isTrue);
      expect(dobReq.source.url, isNotEmpty);
      expect(dobReq.source.verifiedDate, isNotEmpty);
      expect(dobReq.acceptedEvidence.isNotEmpty, isTrue);
    });

    test(
      'Resolves Non-ECR Income Tax proof when applicant qualifies as tax payer',
      () {
        const profile = ApplicantProfile(
          applicationType: ApplicationType.fresh,
          scheme: PassportScheme.normal,
          ageCategory: AgeCategory.adult18Plus,
          nonEcrCriterion: NonEcrCriterion.incomeTaxPayer,
        );

        final resolution = RequirementsEngine.resolve(profile);

        expect(resolution.isSupported, isTrue);
        expect(resolution.isNonEcrEligible, isTrue);
        expect(
          resolution.requirements.any((r) => r.id == 'req_non_ecr_taxpayer'),
          isTrue,
        );
        expect(
          resolution.requirements.any((r) => r.id == 'req_non_ecr_education'),
          isFalse,
        );
      },
    );

    test('Resolves Non-ECR Age 50+ proof when applicant is 50 or older', () {
      const profile = ApplicantProfile(
        applicationType: ApplicationType.fresh,
        scheme: PassportScheme.normal,
        ageCategory: AgeCategory.adult18Plus,
        nonEcrCriterion: NonEcrCriterion.age50Plus,
      );

      final resolution = RequirementsEngine.resolve(profile);

      expect(resolution.isSupported, isTrue);
      expect(resolution.isNonEcrEligible, isTrue);
      expect(
        resolution.requirements.any((r) => r.id == 'req_non_ecr_age50'),
        isTrue,
      );
    });

    test('Correctly identifies ECR status when applicant has no Non-ECR qualification', () {
      const profile = ApplicantProfile(
        applicationType: ApplicationType.fresh,
        scheme: PassportScheme.normal,
        ageCategory: AgeCategory.adult18Plus,
        nonEcrCriterion: NonEcrCriterion.none,
      );

      final resolution = RequirementsEngine.resolve(profile);

      expect(resolution.isSupported, isTrue);
      expect(resolution.isNonEcrEligible, isFalse);
      expect(resolution.nonEcrStatusDescription, contains('ECR Category'));

      // Does not contain educational or tax Non-ECR requirements
      expect(
        resolution.requirements.any((r) => r.id == 'req_non_ecr_education'),
        isFalse,
      );
      expect(
        resolution.requirements.any((r) => r.id == 'req_non_ecr_taxpayer'),
        isFalse,
      );
    });

    test('Includes Name Change Gazette proof when hasNameChange is true', () {
      const profile = ApplicantProfile(hasNameChange: true);

      final resolution = RequirementsEngine.resolve(profile);

      expect(
        resolution.requirements.any((r) => r.id == 'req_name_change'),
        isTrue,
      );
    });

    test('Rejects unsupported Minor application category', () {
      const profile = ApplicantProfile(ageCategory: AgeCategory.minorUnder18);

      final resolution = RequirementsEngine.resolve(profile);

      expect(resolution.isSupported, isFalse);
      expect(resolution.unsupportedReason, contains('adult applicants'));
      expect(resolution.requirements.isEmpty, isTrue);
    });

    test('Rejects unsupported Tatkaal scheme', () {
      const profile = ApplicantProfile(scheme: PassportScheme.tatkaal);

      final resolution = RequirementsEngine.resolve(profile);

      expect(resolution.isSupported, isFalse);
      expect(
        resolution.unsupportedReason,
        contains('Normal application scheme'),
      );
      expect(resolution.requirements.isEmpty, isTrue);
    });

    test('Rejects unsupported Reissue application type', () {
      const profile = ApplicantProfile(
        applicationType: ApplicationType.reissue,
      );

      final resolution = RequirementsEngine.resolve(profile);

      expect(resolution.isSupported, isFalse);
      expect(resolution.unsupportedReason, contains('First-Time'));
    });

    test('Ensures all static requirements have non-empty source URLs and verification dates', () {
      final all = [
        VerifiedRequirementsData.proofOfDob,
        VerifiedRequirementsData.proofOfAddress,
        VerifiedRequirementsData.nonEcrEducation,
        VerifiedRequirementsData.nonEcrTaxPayer,
        VerifiedRequirementsData.nonEcrAge50,
        VerifiedRequirementsData.nonEcrVocational,
        VerifiedRequirementsData.nameChangeProof,
        VerifiedRequirementsData.inPersonGuidance,
      ];

      for (final req in all) {
        expect(
          req.source.url,
          isNotEmpty,
          reason: '\${req.id} must have source URL',
        );
        expect(
          req.source.title,
          isNotEmpty,
          reason: '\${req.id} must have source title',
        );
        expect(
          req.source.verifiedDate,
          isNotEmpty,
          reason: '\${req.id} must have verification date',
        );
        expect(
          req.isVerified,
          isTrue,
          reason: '\${req.id} must be marked verified',
        );
      }
    });
  });
}
