import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/auth_screen.dart';
import '../features/auth/otp_screen.dart';
import '../features/auth/verify_identity_screen.dart';
import '../features/home/home_shell.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/onboarding/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final loggedIn = session != null;
      final publicRoutes = {
        '/splash',
        '/onboarding',
        '/login',
        '/signup',
        '/otp',
      };
      final onPublic = publicRoutes.contains(state.matchedLocation);
      if (!loggedIn && !onPublic) return '/login';
      if (loggedIn && onPublic && state.matchedLocation != '/splash')
        return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const AuthScreen(initialMode: AuthMode.login),
      ),
      GoRoute(
        path: '/signup',
        builder: (_, __) => const AuthScreen(initialMode: AuthMode.signup),
      ),
      GoRoute(
        path: '/otp',
        builder: (_, state) => OtpScreen(
          phone: state.uri.queryParameters['phone'],
          email: state.uri.queryParameters['email'],
        ),
      ),
      GoRoute(
        path: '/verify-identity',
        builder: (_, __) => const VerifyIdentityScreen(),
      ),
      GoRoute(path: '/home', builder: (_, __) => const HomeShell()),
    ],
  );
});
