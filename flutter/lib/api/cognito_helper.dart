import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;


// fetches current authenticated users cognitoID from amplify
Future<Map<String, dynamic>?> getCognitoAttributes() async {
  // get all of the attributes and pick out the email address
  try {
    final attributes = await Amplify.Auth.fetchUserAttributes();
    final attrMap = {
      for (final attr in attributes) attr.userAttributeKey.key: attr.value,
    };
    return attrMap;

  } catch (e) {
    print("Error fetching Cognito ID: $e");
    return null;
  }
}


// https://stackoverflow.com/questions/77218092/how-to-collect-the-jwt-token-and-store-it-in-amplify-flutter/77270880#77270880
// fetches the current users access token from amplify to pass JWT to api
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
