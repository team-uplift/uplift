import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;


/// Fetches the current user's Cognito ID (`sub` attribute)
Future<String?> getCognitoId() async {
  try {
    final attributes = await Amplify.Auth.fetchUserAttributes();
    final attrMap = {
      for (final attr in attributes) attr.userAttributeKey.key: attr.value,
    };

    final cognitoId = attrMap['sub'];
    print("Cognito ID: $cognitoId");
    return cognitoId;
  } catch (e) {
    print("Error fetching Cognito ID: $e");
    return null;
  }
}


// https://stackoverflow.com/questions/77218092/how-to-collect-the-jwt-token-and-store-it-in-amplify-flutter/77270880#77270880
// Fetches the current user's access token (for authenticated requests)
Future<void> fetchCognitoAuthSession() async {
  try {
    final cognitoPlugin = 
         Amplify.Auth.getPlugin(AmplifyAuthCognito.pluginKey);
    final result = await cognitoPlugin.fetchAuthSession();
    final identityId = result.identityIdResult.value;
    final accessToken = 
         result.userPoolTokensResult.value.accessToken.toJson();
    print("Current user's access token: $accessToken");
    print("Current user's identity ID: $identityId");
  } on AuthException catch (e) {
    print('Error retrieving auth session: ${e.message}');
  }
}
