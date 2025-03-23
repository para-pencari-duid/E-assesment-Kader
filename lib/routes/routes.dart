import 'package:e_assesment_kader_app/pages/home_page.dart';
import 'package:e_assesment_kader_app/pages/list_kader_page.dart';
import 'package:e_assesment_kader_app/pages/login_page.dart';
import 'package:e_assesment_kader_app/pages/modul_page.dart';
import 'package:e_assesment_kader_app/pages/sign_up_kader_page.dart';
import 'package:e_assesment_kader_app/pages/sign_up_page.dart';
import 'package:e_assesment_kader_app/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/submodul_page.dart';

GoRouter routerConfig(BuildContext context, PreferencesProvider provider) {
  return GoRouter(
    refreshListenable: provider,
    initialLocation: provider.userToken != null ? '/' : '/login',
    routes: [
      GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => LoginPage(),
          routes: [
            GoRoute(
              path: 'register',
              name: 'register',
              builder: (context, state) => const SignUpPage(),
            ),
          ]),
      // Home Page
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => HomePage(),
        pageBuilder: (context, state) => CustomTransitionPage(
          transitionDuration: Duration(seconds: 1),
          key: state.pageKey,
          child: HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
                position: animation.drive(tween), child: child);
          },
        ),
        routes: [
          GoRoute(
              path: 'kader',
              name: 'kader',
              builder: (context, state) => ListKaderPage(),
              pageBuilder: (context, state) => CustomTransitionPage(
                    transitionDuration: Duration(seconds: 1),
                    key: state.pageKey,
                    child: ListKaderPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                          position: animation.drive(tween), child: child);
                    },
                  ),
              routes: [
                // SignUp Kader Page (Child dari Kader)
                GoRoute(
                  path: 'register-kader',
                  name: 'register-kader',
                  builder: (context, state) => const SignUpKaderPage(),
                ),
                // Modul Page
                GoRoute(
                    path: 'modul/:kaderId',
                    name: 'modul',
                    builder: (context, state) {
                      final kaderId = int.tryParse(
                              state.pathParameters['kaderId'] ?? '0') ??
                          0;
                      return ModulPage(kaderId: kaderId);
                    },
                    routes: [
                      GoRoute(
                        path: 'submodul/:modulId',
                        name: 'submodul',
                        builder: (context, state) {
                          final kaderId = int.tryParse(
                                  state.pathParameters['kaderId'] ?? '0') ??
                              0;
                          final modulId = int.tryParse(
                                  state.pathParameters['modulId'] ?? '0') ??
                              0;
                          return SubmodulPage(
                              kaderId: kaderId, modulId: modulId);
                        },
                      ),
                    ]),
              ]),
        ],
        redirect: (context, state) {
          final isAuthenticated = provider.userToken != null;
          final isLoggingIn = state.uri.toString() == '/login';

          if (!isAuthenticated && !isLoggingIn) {
            return '/login';
          }
          if (isAuthenticated && isLoggingIn) {
            return '/';
          }
          return null; // Tidak ada perubahan rute
        },
      ),
    ],
  );
}
