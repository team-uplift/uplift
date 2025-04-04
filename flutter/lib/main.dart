import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/models/recipient_model.dart';
// import 'package:uplift/models/transaction_model.dart';
import 'package:uplift/screens/auth/donor_or_recipient.dart';
import 'package:uplift/screens/auth/login_screen.dart';
import 'package:uplift/screens/auth/donor_registration_screen.dart';
import 'package:uplift/screens/auth/splash_redirect.dart';
// import 'package:uplift/screens/auth/recipient_registration_screen.dart';
import 'package:uplift/screens/home/dashboard_screen.dart';
import 'package:uplift/screens/home/donate_screen.dart';
import 'package:uplift/screens/home/home_screen.dart';
import 'package:uplift/screens/home/profile_screen.dart';
import 'package:uplift/screens/home/quiz_screen.dart';
import 'package:uplift/recipients/recipient_home_controller.dart';
import 'package:uplift/screens/home/recipient_detail_screen.dart';
import 'package:uplift/screens/home/recipient_list_screen.dart';
import 'package:uplift/screens/recipient_reg_screens/registration_controller.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';


import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureAmplify();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _configureAmplify() async {
  try {
    // Create the API plugin.
    //
    // If `ModelProvider.instance` is not available, try running
    // `amplify codegen models` from the root of your project.
    final api = AmplifyAPI(options: APIPluginOptions(modelProvider: ModelProvider.instance));

    // Create the Auth plugin.
    final auth = AmplifyAuthCognito();

    // Add the plugins and configure Amplify for your app.
    await Amplify.addPlugins([api, auth]);
    await Amplify.configure(amplifyconfig);

    safePrint('Successfully configured');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

/// The route configuration.
final GoRouter _router = GoRouter(
  initialLocation: '/redirect',
  routes: <RouteBase>[
    GoRoute(
      path: '/login',
      name: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/donor_registration',
      name: '/donor_registration',
      builder: (BuildContext context, GoRouterState state) {
        return const DonorRegistrationPage();
      }
    ),
    GoRoute(
      path: '/recipient_registration',
      name: '/recipient_registration',
      builder: (BuildContext context, GoRouterState state) {
        return const RegistrationController();
      }
    ),
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
    GoRoute(
      path: '/donor_or_recipient',
      name: '/donor_or_recipient',
      builder: (BuildContext context, GoRouterState state) {
        return const DonorOrRecipient();
      },
    ),
    GoRoute(
      path: '/recipient_list',
      name: '/recipient_list',
      builder: (BuildContext context, GoRouterState state) {
        return RecipientList();
      },
    ),
    GoRoute(
      path: '/recipient_detail',
      name: '/recipient_detail',
      builder: (BuildContext context, GoRouterState state) {
        final recipient = state.extra as Recipient; 
        return RecipientDetailPage(recipient: recipient);
      },
    ),
    GoRoute(
      path: '/donate',
      name: '/donate',
      builder: (BuildContext context, GoRouterState state) {
        final recipient = state.extra as Recipient;
        return DonatePage(recipient: recipient);
      },
    ),
    GoRoute(
      path: '/redirect',
      name: '/redirect',
      builder: (BuildContext context, GoRouterState state) {
        return SplashRedirector();
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Authenticator(
      signUpForm: SignUpForm.custom(
        fields: [
          SignUpFormField.givenName(),
          SignUpFormField.familyName(),
          SignUpFormField.username(),
          SignUpFormField.email(required: true),
          SignUpFormField.password(),
        ]
      ),
           child: MaterialApp.router(
             routerConfig: _router,
             debugShowCheckedModeBanner: false,
             builder: Authenticator.builder(),
       ),
     );
    // return MaterialApp.router(
    //   routerConfig: _router,
    //   debugShowCheckedModeBanner: false,
    // );
  }
}
