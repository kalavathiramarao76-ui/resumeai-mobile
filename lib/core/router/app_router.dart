import 'package:go_router/go_router.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/resume_analysis/screens/analysis_screen.dart';
import '../../features/resume_editor/screens/editor_screen.dart';
import '../../features/job_match/screens/job_match_screen.dart';
import '../../features/subscription/screens/paywall_screen.dart';
import '../../features/career_feed/screens/career_feed_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/auth', builder: (_, __) => const AuthScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/analysis/:id', builder: (_, state) => AnalysisScreen(resumeId: state.pathParameters['id']!)),
      GoRoute(path: '/editor/:id', builder: (_, state) => EditorScreen(resumeId: state.pathParameters['id']!)),
      GoRoute(path: '/job-match', builder: (_, __) => const JobMatchScreen()),
      GoRoute(path: '/paywall', builder: (_, __) => const PaywallScreen()),
      GoRoute(path: '/career-feed', builder: (_, __) => const CareerFeedScreen()),
    ],
  );
}
