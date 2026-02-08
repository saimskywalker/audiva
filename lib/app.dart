import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_colors.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_screen.dart';
import 'screens/music/music_feed_screen.dart';
import 'screens/video/video_hub_screen.dart';
import 'screens/video/video_player_screen.dart';
import 'screens/merch/merch_store_screen.dart';
import 'screens/merch/product_details_screen.dart';
import 'screens/chat/fan_connect_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/profile/profile_screen.dart';

/// Main app widget
class AudivaApp extends StatefulWidget {
  const AudivaApp({super.key});

  @override
  State<AudivaApp> createState() => _AudivaAppState();
}

class _AudivaAppState extends State<AudivaApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      initialLocation: '/music',
      redirect: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final isLoggedIn = authProvider.isAuthenticated;
        final isAuthRoute = state.matchedLocation.startsWith('/auth');

        // Redirect to login if not authenticated and trying to access protected route
        if (!isLoggedIn && !isAuthRoute) {
          return '/auth/login';
        }

        // Redirect to music feed if authenticated and trying to access auth route
        if (isLoggedIn && isAuthRoute) {
          return '/music';
        }

        return null;
      },
      routes: [
        // Auth routes (not in bottom nav)
        GoRoute(
          path: '/auth/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/auth/register',
          builder: (context, state) => const RegisterScreen(),
        ),

        // Main app with bottom navigation
        ShellRoute(
          builder: (context, state, child) => MainScreen(child: child),
          routes: [
            GoRoute(
              path: '/music',
              builder: (context, state) => const MusicFeedScreen(),
            ),
            GoRoute(
              path: '/videos',
              builder: (context, state) => const VideoHubScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final videoId = state.pathParameters['id']!;
                    return VideoPlayerScreen(videoId: videoId);
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/merch',
              builder: (context, state) => const MerchStoreScreen(),
              routes: [
                GoRoute(
                  path: 'product/:id',
                  builder: (context, state) {
                    final productId = state.pathParameters['id']!;
                    return ProductDetailsScreen(productId: productId);
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/chat',
              builder: (context, state) => const FanConnectScreen(),
              routes: [
                GoRoute(
                  path: ':artistId',
                  builder: (context, state) {
                    final artistId = state.pathParameters['artistId']!;
                    return ChatScreen(artistId: artistId);
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Audiva',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
