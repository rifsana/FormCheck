import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profile/presentation/profile_controller.dart';
import '../domain/passport_rule.dart';
import '../domain/requirements_engine.dart';

enum ItemCollectionStatus { pending, collected }

class ChecklistProgressNotifier
    extends Notifier<Map<String, ItemCollectionStatus>> {
  @override
  Map<String, ItemCollectionStatus> build() {
    return {};
  }

  void toggleStatus(String requirementId) {
    final current = state[requirementId] ?? ItemCollectionStatus.pending;
    final next = current == ItemCollectionStatus.pending
        ? ItemCollectionStatus.collected
        : ItemCollectionStatus.pending;
    state = {...state, requirementId: next};
  }

  void markCollected(String requirementId) {
    state = {...state, requirementId: ItemCollectionStatus.collected};
  }

  void markPending(String requirementId) {
    state = {...state, requirementId: ItemCollectionStatus.pending};
  }

  void reset() {
    state = {};
  }
}

final checklistResolutionProvider = Provider<ChecklistResolution>((ref) {
  final profile = ref.watch(profileProvider);
  return RequirementsEngine.resolve(profile);
});

final checklistProgressProvider =
    NotifierProvider<
      ChecklistProgressNotifier,
      Map<String, ItemCollectionStatus>
    >(ChecklistProgressNotifier.new);
