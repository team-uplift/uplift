import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/api/cognito_helper.dart';

import 'package:uplift/api/recipient_api.dart';
import 'package:uplift/api/tag_api.dart';
import 'package:uplift/models/tag_model.dart';

import 'tag_selection_screen.dart';
import 'registration_questions.dart';
import 'dynamic_questions_screen.dart';
import 'confirmation_screen.dart';

class RegistrationController extends StatefulWidget {
  final Map<String, dynamic>? initialFormData;
  final bool isEditing;

  const RegistrationController({
    super.key,
    this.initialFormData,
    this.isEditing = false,
  });

  @override
  State<RegistrationController> createState() => _RegistrationControllerState();
}

class _RegistrationControllerState extends State<RegistrationController> {
  int _currentIndex = 0;
  late Map<String, dynamic> formData = {};
  late List<Tag> generatedTags;
  bool _isLoading = false;
  bool returnToConfirmation = false;

  @override
  void initState() {
    super.initState();
    print("widget passed formdata: ${widget.initialFormData}");

    formData = widget.initialFormData != null
        ? Map<String, dynamic>.from(widget.initialFormData!)
        : {};

    print("reg controller formdata: $formData");
  }

  void _stepForward() {
    setState(() {
      if (returnToConfirmation) {
        final confirmationIndex = registrationQuestions
            .indexWhere((q) => q['type'] == 'confirmation');
        if (confirmationIndex != -1) {
          _currentIndex = confirmationIndex;
          returnToConfirmation = false; // reset after use
        }
      } else if (_currentIndex < registrationQuestions.length - 1) {
        _currentIndex++;
        print("form data: $formData");
      } else {
        _submit();
      }
    });
  }

  void _stepBack() {
    setState(() {
      if (_currentIndex == 0) {
        if (widget.isEditing) {
          context.goNamed('/recipient_home');
        } else {
          context.goNamed('donor_or_recipient');
        }
      } else {
        _currentIndex--;
      }
    });
  }

  void _submit() async {
    setState(() => _isLoading = true);

    final userId = formData['userId']; // make sure this is stored earlier!
    final selectedTags =
        (formData['tags'] as List<Tag>).map((tag) => tag.tagName).toList();

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

  List<Map<String, dynamic>> buildFormQuestions(
      Map<String, dynamic> formData, List<Map<String, dynamic>> questions) {
    return [
      for (var q in questions)
        if (q['type'] != 'compositeAddress' &&
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
  }

  Future<String?> storeUser(Map<String, dynamic> attrMap) async {
    print("store user");
    final formQuestions = buildFormQuestions(formData, registrationQuestions);
    print("form questions storeUser: $formQuestions");

    return await RecipientApi.createRecipientUser(
      formData,
      formQuestions,
      attrMap,
    );
  }

  Future<bool> updateUser(Map<String, dynamic> attrMap) async {
    print("update user");
    final formQuestions = buildFormQuestions(formData, registrationQuestions);

    return await RecipientApi.updateRecipientUserProfile(
      formData,
      formQuestions,
      attrMap,
    );
  }

  Future<List<Tag>> fetchTags(int userId) async {
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
      final attrMap = await getCognitoAttributes();

      bool success = false;
      dynamic userId;

      print("isEditing: ${widget.isEditing}");

      if (widget.isEditing) {
        userId = formData['userId'];
        print('update user id: $userId');
        success = await updateUser(attrMap!);
      } else {
        userId = await storeUser(attrMap!);
        if (userId != null) formData['userId'] = userId;
      }

      if (!success || userId == null)
        throw Exception("User create/update failed");

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
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                      "Step ${_currentIndex + 1} of ${registrationQuestions.length}"),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildCurrentStep(),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              child: const Center(
                  child: CircularProgressIndicator(color: Colors.white)),
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
          final index =
              registrationQuestions.indexWhere((q) => q['key'] == key);
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
