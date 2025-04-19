import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:uplift/api/recipient_api.dart';
import 'package:uplift/api/tag_api.dart';
import 'package:uplift/api/user_api.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/models/recipient_model.dart';

import 'tag_selection_screen.dart';
import 'registration_questions.dart';
import 'dynamic_questions_screen.dart';
import 'confirmation_screen.dart';
// import 'package:http/http.dart' as http;







class RegistrationController extends StatefulWidget {
  const RegistrationController({super.key});

  @override
  State<RegistrationController> createState() => _RegistrationControllerState();
}


class _RegistrationControllerState extends State<RegistrationController> {
  int _currentIndex = 0;
  final Map<String, dynamic> formData = {};
  late List<Tag> generatedTags; 
  bool _isLoading = false;
  bool returnToConfirmation = false;




  void _stepForward() {
    setState(() {
      if (returnToConfirmation) {
        final confirmationIndex = registrationQuestions.indexWhere((q) => q['type'] == 'confirmation');
        if (confirmationIndex != -1) {
          _currentIndex = confirmationIndex;
          returnToConfirmation = false; // reset after use
        }
      }
      else if (_currentIndex < registrationQuestions.length - 1) {
        _currentIndex++;
      } 

      else {
        _submit();
      }
    });
  }


  void _stepBack() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      } 
    });
  }


  // void _submit() async {
  //   setState(() => _isLoading = true);

  //   final userId = formData['userId']; // make sure this is stored earlier!
  //   print("userid: $userId");

  //   final selectedTags = (formData['tags'] as List<Tag>)
  //       .map((tag) => tag.tagName)
  //       .toList();
      
  //   print('selected tags: $selectedTags');

  //   // final tagUpdatePayload = {
  //   //   'selectedTags': selectedTags,
  //   // };

  //   try {
  //     final response = await http.put(
  //       Uri.parse('http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/recipients/tagSelection/$userId'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(selectedTags),
  //     );

  //     print('put_response: ${response.body}');

  //     if (response.statusCode == 204) {
  //       context.goNamed('/recipient_home');
  //     } else {
  //       print("Failed to update tags: ${response.statusCode}");
  //       // Optionally show a dialog or retry button
  //     }
  //   } catch (e) {
  //     print("Error during tag update: $e");
  //     // Handle exception
  //   } finally {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  void _submit() async {
    setState(() => _isLoading = true);

    final userId = formData['userId']; // make sure this is stored earlier!
    final selectedTags = (formData['tags'] as List<Tag>)
        .map((tag) => tag.tagName)
        .toList();
      
    try {
      final success = await RecipientApi.updateTags(userId, selectedTags);

      if (success) {
        context.goNamed('/recipient_home');
      } else {
        print("Failed to update tags");
      }
    } catch (e) {
      print("Error during tag update: $e");
      // Handle exception
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Future<void> storeUserAndFetchTags() async {
  //   setState(() => _isLoading = true);
    
  //   // get amplify user info
  //   final attributes = await Amplify.Auth.fetchUserAttributes();
    
  //   // map to easier to parse dict
  //   final attrMap = {
  //     for (final attr in attributes) attr.userAttributeKey.key: attr.value,
  //   };

  //   print('Amplify attributes: $attrMap');

  //   // reformat formdata for rest api
  //   final formQuestions = [
  //     for (var question in registrationQuestions)
  //       if (question['type'] != 'generateTags' &&
  //           question['type'] != 'showTags' &&
  //           question['type'] != 'confirmation' &&
  //           (formData[question['key']]?.toString().trim().isNotEmpty ?? false))
  //         {
  //           'question': question['q'],
  //           'answer': formData[question['key']] is List
  //               ? (formData[question['key']] as List).join(', ')
  //               : formData[question['key']],
  //         }
  //   ];


  //   print('FormData: $formData');
  //   print(formData['lastAboutMe']);
  //   print('Form questions: $formQuestions');
  //   // print('About Me: {$registrationQuestions['key']}')

  //   final payload = {
  //       'cognitoId': attrMap['sub'],
  //       'email': attrMap['email'],
  //       'recipient': true,
  //       'recipientData': {
  //         'firstName': attrMap['given_name'],
  //         'lastName': attrMap['family_name'],
  //         // TODO pop these two questions off formdata response
  //         'lastAboutMe': formData['lastAboutMe'],
  //         'lastReasonForHelp': formData['lastReasonForHelp'],
  //         "formQuestions": formQuestions,        
  //       },
  //   };

  //   print('Payload being sent: ${jsonEncode(payload)}');

  //   http.Response? storeUserResponse;

  //   // store user
  //   try {
  //     storeUserResponse = await http.post(
  //       Uri.parse('http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/users'),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           // 'Accept': 'application/json',
  //         },
  //         // build this out
  //         body: jsonEncode(payload),
  //     );
  //       print('Got response with code: ${storeUserResponse.statusCode}');
  //   } on TimeoutException catch (e) {
  //     print('Request timed out: $e');
  //   } on SocketException catch (e) {
  //     print('Socket exception: $e');
  //   } catch (e) {
  //     print('Other exception: $e');
  //   }


  //   print('am I getting here?');

  //   if (storeUserResponse != null) {
  //     print('Status code: ${storeUserResponse.statusCode}');
  //     print('Body: ${storeUserResponse.body}');
  //     final userData = jsonDecode(storeUserResponse.body);
  //     final userId = userData['id'];
  //     formData['userId'] = userId; // storing user id from backend for later
  //     final qa = userData['recipientData']['formQuestions'];
  //     print("form questions: $qa");

  //     final getTagsResponse = await http.post(
  //       Uri.parse('http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/recipients/tagGeneration/$userId'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'session_id': '123'
  //       },
  //       body: jsonEncode(qa),
  //     );

  //     final tagsData = jsonDecode(getTagsResponse.body);
  //     print('Tags data: $tagsData');

  //     generatedTags = (tagsData as List)
  //         .map((tagJson) => Tag.fromJson(tagJson))
  //         .toList();

  //     setState(() {
  //       _isLoading = false;
        
  //     });
  //     _stepForward();

  //   } else {
  //     print('No stored user');
  //   }
  //   // Assume the response is a JSON with an "id" field.
    
    
  //   // this will be id used to call generate tags
    

  //   // Second API call: get generated tags using the user id
  //   // final getTagsResponse = await http.get(
  //   //   Uri.parse('https://example.com/api/getTags?userId=$userId'),
  //   // );
  //   // Assume the response is a JSON array of strings.
  //   // final tagsData = jsonDecode(getTagsResponse.body);
  //   // print('Tags data: $tagsData');
  //   // setState(() {
  //   //   // TODO map these to a list of tags as opposed to a list of strings
  //   //   // tags = List<String>.from(tagsData);
  //   // });
  // }

  // // THIS ONE IS V2 --> MOVING TO V3
  // Future<void> storeUserAndFetchTags() async {
  //   setState(() => _isLoading = true);
    
  //   // get amplify user info
  //   try {
  //     final attributes = await Amplify.Auth.fetchUserAttributes();
    
  //     // map to easier to parse dict
  //     final attrMap = {
  //       for (final attr in attributes) attr.userAttributeKey.key: attr.value,
  //     };

  //     // reformat formdata for rest api
  //     final formQuestions = [
  //       for (var question in registrationQuestions)
  //         if (question['type'] != 'generateTags' &&
  //             question['type'] != 'showTags' &&
  //             question['type'] != 'confirmation' &&
  //             (formData[question['key']]?.toString().trim().isNotEmpty ?? false))
  //           {
  //             'question': question['q'],
  //             'answer': formData[question['key']] is List
  //                 ? (formData[question['key']] as List).join(', ')
  //                 : formData[question['key']],
  //           }
  //     ];

  //     final userId = await RecipientApi.createRecipientUser(
  //       formData, 
  //       formQuestions, 
  //       attrMap
  //     );

  //     if (userId == null) throw Exception("failed to create user");

  //     formData['userId = userId'];

  //     final generatedTags = await TagApi.generateTags(
  //       userId, 
  //       formQuestions
  //     );

  //     setState(() => _isLoading = false);
  //     _stepForward();
  //   } catch (e) {
  //     print("Error in storeUserAndFetchTags: $e");
  //     setState(() => _isLoading = false);
  //   }
  // }

  Future<String?> storeUser(Map<String, dynamic> attrMap) async {
    final formQuestions = [
      for (var q in registrationQuestions)
        if (
          q['type'] != 'compositeAddress' &&
            q['type'] != 'showTags' &&
            q['type'] != 'confirmation' &&
            (formData[q['key']]?.toString().trim().isNotEmpty ?? false))
          {
            'question': q['q'],
            'answer': formData[q['key']] is List
                ? (formData[q['key']] as List).join(', ')
                : formData[q['key']],
          }
    ];
    print("form questions storeUser: $formQuestions");

    return await RecipientApi.createRecipientUser(
      formData,
      formQuestions,
      attrMap,
    );
  }

  Future<List<Tag>> fetchTags(String userId) async {
    final questions = [
      for (var q in registrationQuestions)
        if (formData[q['key']] != null)
          {
            'question': q['q'],
            'answer': formData[q['key']] is List
                ? (formData[q['key']] as List).join(', ')
                : formData[q['key']],
          }
    ];

    return await TagApi.generateTags(userId, questions);
  }

  Future<void> handleUserRegistrationAndTags() async {
    setState(() => _isLoading = true);

    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final attrMap = {
        for (final attr in attributes) attr.userAttributeKey.key: attr.value,
      };

      final userId = await storeUser(attrMap);
      if (userId == null) throw Exception("User creation failed");

      formData['userId'] = userId;

      final tags = await fetchTags(userId);
      setState(() {
        generatedTags = tags;
        _isLoading = false;
      });

      _stepForward();
    } catch (e) {
      print("Error during registration: $e");
      setState(() => _isLoading = false);
    }
  }
    
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Recipient Registration"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _stepBack,
            ),
            actions: [
              TextButton(
                onPressed: () => context.goNamed('/donor_or_recipient'),
                child: const Text("Exit"),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text("Step ${_currentIndex + 1} of ${registrationQuestions.length}"),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildCurrentStep(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / registrationQuestions.length,
                    backgroundColor: Colors.grey,
                    color: Colors.blue,
                    minHeight: 7.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
          ),
      ],
    );
  }

  Widget _buildCurrentStep() {
    final question = registrationQuestions[_currentIndex];

    if (question['type'] == 'confirmation') {
      return Confirmation(
        formData: formData,
        onBack: _stepBack,
        onGenerate: handleUserRegistrationAndTags,
        onJumpToQuestion: (key) {
          final index = registrationQuestions.indexWhere((q) => q['key'] == key);
          if (index != -1) {
            setState(() {
              _currentIndex = index;
              returnToConfirmation = true;
            });
          }
        },
      );
    } else if (question['type'] == 'showTags') {
      return TagSelection(
        formData: formData,
        availableTags: generatedTags,
        onBack: _stepBack,
        onSubmit: _stepForward,
      );
    } else {
      return DynamicQuestionScreen(
        formData: formData,
        questions: registrationQuestions,
        questionIndex: _currentIndex,
        onNext: _stepForward,
        onBack: _stepBack,
        onGenerate: handleUserRegistrationAndTags,
        returnToConfirmation: returnToConfirmation,
      );
    }
  }
}



// TODO make all screens mobile friendly via wrapping everything in scroll view and safe areas



// TODO add address to user registration