import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:news_app/features/model/article_model.dart';
import 'package:news_app/features/screens/forgot_password_page.dart';
import 'package:news_app/features/screens/login_page.dart';
import 'package:news_app/features/screens/post_login/article_details_page.dart';
import 'package:news_app/features/screens/post_login/favourite_page.dart';
import 'package:news_app/features/screens/post_login/home_page.dart';
import 'package:news_app/features/screens/post_login/main_shell_page.dart';
import 'package:news_app/features/screens/post_login/search_page.dart';
import 'package:news_app/features/screens/register_page.dart';
import 'package:news_app/features/screens/splash/splash_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',

redirect: (context, state) {
      final box = Hive.box('authBox');
      final loggedIn = box.get('loggedIn', defaultValue: false) as bool;

      final location = state.matchedLocation;
      final isSplash = location == '/splash';
      final isAuthRoute =
          location == '/login' ||
          location == '/register' ||
          location == '/forgot';
      final isAppRoute = location.startsWith('/app');

if (isSplash) return null;

if (!loggedIn && isAppRoute) return '/login';

if (loggedIn && isAuthRoute) return '/app/home';

      return null;
    },

    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),

      GoRoute(path: '/login', builder: (context, state) => LoginPage()),

      GoRoute(path: '/register', builder: (context, state) => RegisterPage()),

      GoRoute(
        path: '/forgot',
        builder: (context, state) => ForgotPasswordPage(),
      ),

      GoRoute(
        path: '/app/details',
        builder: (context, state) {
          final article = state.extra as Article;
          return ArticleDetailsPage(article: article);
        },
      ),

      ShellRoute(
        builder: (context, state, child) {
          return MainShellPage(child: child);
        },
        routes: [
          GoRoute(path: '/app/home', builder: (_, __) => const HomePage()),
          GoRoute(path: '/app/search', builder: (_, __) => const SearchPage()),
          GoRoute(
            path: '/app/favourite',
            builder: (_, __) => const FavouritePage(),
          ),
        ],
      ),
    ],
  );
});
