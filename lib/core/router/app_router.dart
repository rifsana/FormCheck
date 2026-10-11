import 'package:go_router/go_router.dart';

import '../../features/welcome/presentation/welcome_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/checklist/presentation/checklist_screen.dart';
import '../../features/scanner/presentation/scanner_screen.dart';
import '../../features/readiness/presentation/readiness_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/checklist',
      builder: (context, state) => const ChecklistScreen(),
    ),
    GoRoute(
      path: '/scanner',
      builder: (context, state) => const ScannerScreen(),
    ),
    GoRoute(
      path: '/readiness',
      builder: (context, state) => const ReadinessScreen(),
    ),
  ],
);
