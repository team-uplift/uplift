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
  bool isFetchingTags = false;
  bool tagFetchFailed = false;
  List<String> generatedTags = [];


  // TODO edit to work with our API --> this should be fine to return tags for selection
  Future<void> _fetchTags() async {
    setState(() {
      isFetchingTags = true;
      tagFetchFailed = false;
    });

    try {
      final response = await http.post(
        Uri.parse('https://your-api-url.com/generate-tags'), // Replace with actual API URL
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(formData),
      );

      if (response.statusCode == 200) {
        final List<String> tags = List<String>.from(jsonDecode(response.body)['tags']);

        setState(() {
          generatedTags = tags;
          isFetchingTags = false;
          _currentIndex++; // Move to the Tag Selection screen
        });
      } else {
        throw Exception("Failed to generate tags");
      }
    } catch (e) {
      print("Error fetching tags: $e");
      setState(() {
        isFetchingTags = false;
        tagFetchFailed = true;
      });
    }
  }

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
              child: Text(
                isFetchingTags
                ? "Generating tags..."
                : "Step ${_currentIndex + 1} of ${registrationQuestions.length}"),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: isFetchingTags
                    ? Center(child: CircularProgressIndicator()) // ✅ Show loading indicator
                    : tagFetchFailed
                        ? _errorRetryWidget()
                        : registrationQuestions[_currentIndex]['type'] == 'confirmation'
                            ? Confirmation(
                                formData: formData,
                                onBack: _stepBack,
                                onSubmit: _submit,
                              )
                            : registrationQuestions[_currentIndex]['type'] == 'generateTags'
                                ? TagSelection(
                                    formData: formData,
                                    onBack: _stepBack,
                                    onSubmit: _stepForward,
                                  )
                                : DynamicQuestionScreen(
                                    formData: formData,
                                    questions: registrationQuestions,
                                    questionIndex: _currentIndex,
                                    onNext: _stepForward,
                                    onBack: _stepBack,
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
          onPressed: _fetchTags,
          child: Text("Retry"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              generatedTags = ["Community Support", "Financial Help", "Job Seeking", "Housing", "Education"];
              tagFetchFailed = false;
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