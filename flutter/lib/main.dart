import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/screens/auth/login_screen.dart';
import 'package:uplift/screens/auth/registration_screen.dart';
import 'package:uplift/screens/home/dashboard_screen.dart';
import 'package:uplift/screens/home/home_screen.dart';
import 'package:uplift/screens/home/profile_screen.dart';
import 'package:uplift/screens/home/quiz_screen.dart';
import 'package:uplift/recipients/recipient_home.dart';

void main() {
  runApp(const MyApp());
}

/// The route configuration.
final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      name: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
      
    ),
    GoRoute(
        path: '/registration',
        name: '/registration',
        builder: (BuildContext context, GoRouterState state) {
          return const RegistrationPage();
        }),
    GoRoute(
      path: '/home',
      name: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/quiz',
      name: '/quiz',
      builder: (BuildContext context, GoRouterState state) {
        return const QuizPage();
      },
    ),
    GoRoute(
      path: '/profile',
      name: '/profile',
      builder: (BuildContext context, GoRouterState state) {
        return const ProfilePage();
      },
    ),
    GoRoute(
      path: '/dashboard',
      name: '/dashboard',
      builder: (BuildContext context, GoRouterState state) {
        return const DashboardPage();
      },
    ),
    GoRoute(
      path: '/recipient_home',
      name: '/recipient_home',
      builder: (BuildContext context, GoRouterState state) {
        return const RecipientHome();
      },
    ),
    // GoRoute(
    //   path: '/recipient_tags',
    //   name: '/recipient_tags',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const RecipientTags();
    //   },
    // ),
    // GoRoute(
    //   path: '/recipient_history',
    //   name: '/recipient_history',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const RecipientHistory();
    //   },
    // ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
