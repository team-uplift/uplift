import 'dart:async';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'registration_questions.dart';
import 'questions_screen.dart';
import 'package:http/http.dart' as http;
import 'tag_selection_screen.dart';
import 'dart:convert';
import 'confirmation_screen.dart';
import 'package:go_router/go_router.dart';



class RegistrationController extends StatefulWidget {
  const RegistrationController({super.key});

  @override
  State<RegistrationController> createState() => _RegistrationControllerState();
}


class _RegistrationControllerState extends State<RegistrationController> {
  int _currentIndex = 0;
  final Map<String, dynamic> formData = {};
  List<String> generatedTags = [];


  void _stepForward() {
    setState(() {
      if (_currentIndex < registrationQuestions.length - 1) {
        if (registrationQuestions[_currentIndex]['type'] == 'generateTags') {
          _currentIndex++;
          
          // TODO actually fetch tags later
          // _fetchTags();
        } else {
          _currentIndex++;
        }
      } else {
        _submit();
      }
    });
  }

  void _stepBack() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      } 
      // else {
      //   Navigator.pop(context);
      // }
    });
  }

  void _submit() {
    setState(() {
      // TODO implement actually pushing to backend --> navigate to dashboard
      print("Reg completed");
      print(formData);
      context.goNamed('/recipient_home');
    });
  }

  Future<void> storeUserAndFetchTags() async {
    // get amplify user info
    final attributes = await Amplify.Auth.fetchUserAttributes();
    
    // map to easier to parse dict
    final attrMap = {
      for (final attr in attributes) attr.userAttributeKey.key: attr.value,
    };

    print('Amplify attributes: $attrMap');

    // reformat formdata for rest api
    final formQuestions = [
      for (var question in registrationQuestions)
        if (question['type'] != 'generateTags' &&
            question['type'] != 'showTags' &&
            question['type'] != 'confirmation' &&
            (formData[question['key']]?.toString().trim().isNotEmpty ?? false))
          {
            'question': question['q'],
            'answer': formData[question['key']]!,
          }
    ];


    print('Form questions: $formQuestions');

    final payload = {
        'cognitoId': attrMap['sub'],
        'email': attrMap['email'],
        'recipient': true,
        'recipientData': {
          // TODO pop these two questions off formdata response
          'lastAboutMe': "test",
          'lastReasonForHelp': "test",
          "formQuestions": formQuestions,        
        },
    };

    print('Payload being sent: ${jsonEncode(payload)}');

    http.Response? storeUserResponse;
    // TODO currently breaks here and i cant figure out why
    // store user
    try {
      storeUserResponse = await http.post(
        Uri.parse('http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/users'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          // build this out
          body: jsonEncode(payload),
      );
        print('Got response with code: ${storeUserResponse.statusCode}');
    } on TimeoutException catch (e) {
      print('Request timed out: $e');
    } on SocketException catch (e) {
      print('Socket exception: $e');
    } catch (e) {
      print('Other exception: $e');
    }

    
    print('am I getting here?');

    if (storeUserResponse != null) {
      print('Status code: ${storeUserResponse.statusCode}');
      print('Body: ${storeUserResponse.body}');
      final userData = jsonDecode(storeUserResponse.body);
      final userId = userData['id'];
      final qa = userData['recipientData']['formQuestions'];
      print("fomr questions: $qa");
      final getTagsResponse = await http.post(
        Uri.parse('http://ec2-54-162-45-38.compute-1.amazonaws.com/uplift/recipients/tagGeneration/$userId'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'session_id': '123'
          },
          // build this out
          body: jsonEncode(qa),
      );
      // Assume the response is a JSON array of strings.
      final tagsData = jsonDecode(getTagsResponse.body);
      print('Tags data: $tagsData');
    } else {
      print('No stored user');
    }
    // Assume the response is a JSON with an "id" field.
    
    
    // this will be id used to call generate tags
    

    // Second API call: get generated tags using the user id
    // final getTagsResponse = await http.get(
    //   Uri.parse('https://example.com/api/getTags?userId=$userId'),
    // );
    // Assume the response is a JSON array of strings.
    // final tagsData = jsonDecode(getTagsResponse.body);
    // print('Tags data: $tagsData');
    // setState(() {
    //   // TODO map these to a list of tags as opposed to a list of strings
    //   // tags = List<String>.from(tagsData);
    // });
  }

  @override
  Widget build(BuildContext context) {

    double progress = (_currentIndex + 1) / registrationQuestions.length;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipient Registration"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // TODO this should be decided where it leads based on context
            context.goNamed('/donor_or_recipient');
          }, 
        )
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
                child:  registrationQuestions[_currentIndex]['type'] == 'confirmation'
                            ? Confirmation(
                                formData: formData,
                                onBack: _stepBack,
                                onSubmit: _submit,
                              )
                              : DynamicQuestionScreen(
                                  formData: formData,
                                  questions: registrationQuestions,
                                  questionIndex: _currentIndex,
                                  onNext: _stepForward,
                                  onBack: _stepBack,
                                  // TODO implement tag generation here
                                  onGenerate: storeUserAndFetchTags,
                                ),
                )
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey, //TODO theme color this element
                color: Colors.blue, //TODO theme color this as well
              )
            ),
           ]
        ),
      )
    );
  }

   // ✅ Retry Mechanism in Case of API Failure
  Widget _errorRetryWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Failed to generate tags. Please try again."),
        const SizedBox(height: 16),
        ElevatedButton(
          // onPressed: _fetchTags,
          // TODO implement tag fetch
          onPressed: () => print("will implement when tag fetch happens"),
          child: Text("Retry"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              generatedTags = ["Community Support", "Financial Help", "Job Seeking", "Housing", "Education"];
              // tagFetchFailed = false;
              _currentIndex++; // Proceed with default tags
            });
          },
          child: Text("Use Default Tags"),
        ),
      ],
    );
  }
}



// TODO make all screens mobile friendly via wrapping everything in scroll view and safe areas