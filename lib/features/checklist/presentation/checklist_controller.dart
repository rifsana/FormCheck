import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profile/presentation/profile_controller.dart';
import '../domain/passport_rule.dart';
import '../domain/requirements_engine.dart';

final checklistResolutionProvider = Provider<ChecklistResolution>((ref) {
  final profile = ref.watch(profileProvider);
  return RequirementsEngine.resolve(profile);
});
