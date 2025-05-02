/// cognito_helper.dart
///
/// Provides helper methods for retrieving information from Amplify to be used in API calls
/// Includes:
/// - getting user attributes from cognito
/// - getting the auth session and
library;

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:uplift/utils/logger.dart';

/// fetches current authenticated users cognitoID from amplify
///
/// returns map of attributes on success, null on failure
Future<Map<String, dynamic>?> getCognitoAttributes() async {
  try {
    // get all of the attributes and pick out the email address
    final attributes = await Amplify.Auth.fetchUserAttributes();
    final attrMap = {
      for (final attr in attributes) attr.userAttributeKey.key: attr.value,
    };

    log.info("Successfully fetched Cognito attributes.");
    return attrMap;
  } catch (e) {
    log.severe("Error fetching Cognito ID: $e");
    return null;
  }
}

/// https://stackoverflow.com/questions/77218092/how-to-collect-the-jwt-token-and-store-it-in-amplify-flutter/77270880#77270880
/// fetches the current users access token from amplify to pass JWT to api
///
/// returns json web token on success, null on failure
Future<JsonWebToken?> fetchCognitoAuthSession() async {
  try {
    final cognitoPlugin = Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
    final result = await cognitoPlugin.fetchAuthSession();
    final accessToken = result.userPoolTokensResult.value.accessToken;
    log.info("Successfully fetched auth session.");
    return accessToken;
  } on AuthException catch (e) {
    log.severe('Error retrieving auth session: ${e.message}');
    return null;
  }
}
