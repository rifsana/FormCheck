import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/applicant_profile.dart';

class ProfileNotifier extends Notifier<ApplicantProfile> {
  @override
  ApplicantProfile build() {
    return const ApplicantProfile();
  }

  void updateApplicationType(ApplicationType type) {
    state = state.copyWith(applicationType: type);
  }

  void updateScheme(PassportScheme scheme) {
    state = state.copyWith(scheme: scheme);
  }

  void updateAgeCategory(AgeCategory age) {
    state = state.copyWith(ageCategory: age);
  }

  void updateNonEcrCriterion(NonEcrCriterion criterion) {
    state = state.copyWith(nonEcrCriterion: criterion);
  }

  void updateHasNameChange(bool hasNameChange) {
    state = state.copyWith(hasNameChange: hasNameChange);
  }

  void reset() {
    state = const ApplicantProfile();
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ApplicantProfile>(
  ProfileNotifier.new,
);
