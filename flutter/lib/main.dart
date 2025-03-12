import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/screens/auth/login_screen.dart';
import 'package:uplift/screens/auth/registration_screen.dart';
import 'package:uplift/screens/home/home_screen.dart';
import 'package:uplift/screens/home/quiz_screen.dart';

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
