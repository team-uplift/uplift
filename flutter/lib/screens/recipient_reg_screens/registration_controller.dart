/// recipient_registration_controller.dart
///
/// used to control form and formdata and render the appropriate screens
/// during recipient registration
/// includes:
/// - _stepForward
/// - _steBack
/// - _submit
/// - _buildFormQuestions
/// - _createUser
/// - _updateUser
/// - _fetchTags
/// - _handleUserRegistrationAndTags
///

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/api/cognito_helper.dart';
import 'package:uplift/api/recipient_api.dart';
import 'package:uplift/api/tag_api.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/utils/logger.dart';
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
    // used to prefill if coming from edit as opposed to register
    formData = widget.initialFormData != null
        ? Map<String, dynamic>.from(widget.initialFormData!)
        : {};
  }

  /// increments form forwards
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
      } else {
        _submit();
      }
    });
  }

  /// steps backwards through form
  void _stepBack() {
    setState(() {
      if (_currentIndex == 0) {
        if (widget.isEditing) {
          // TODO --> this should go to settings page
          context.goNamed('/recipient_home');
        } else {
          context.goNamed('/donor_or_recipient');
        }
      } else {
        _currentIndex--;
      }
    });
  }

  /// submits all data from form including selected tags to update user on back
  /// end
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
        log.severe("Failed to update tags");
      }
    } catch (e) {
      log.severe("Error during tag update: $e");
      // Handle exception
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// maps formdata to format that rest api expects for submission
  List<Map<String, dynamic>> _buildFormQuestions(
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

  /// stores user on back end with formdata
  /// 
  /// returns user id on success, null on failure
  Future<int?> _createUser(Map<String, dynamic> attrMap) async {
    final formQuestions = _buildFormQuestions(formData, registrationQuestions);

    return await RecipientApi.createRecipientUser(
      formData,
      formQuestions,
      attrMap,
    );
  }

  /// updates user on back end
  /// 
  /// returns true on success, false on failure
  Future<bool> _updateUser(Map<String, dynamic> attrMap) async {
    final formQuestions = _buildFormQuestions(formData, registrationQuestions);

    return await RecipientApi.updateRecipientUserProfile(
      formData,
      formQuestions,
      attrMap,
    );
  }

  /// fetches tags from rest api using data entered by user
  /// 
  /// returns list of tag objects on success, empty list on failure
  Future<List<Tag>> _fetchTags(int userId) async {
    // TODO --> this is very close to my other formatting function --> abstract?
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

  /// executes process to register user and fetch tags at appropriate time
  /// in user registration process
  Future<void> _handleUserRegistrationAndTags() async {

    setState(() => _isLoading = true);

    try {
      final attrMap = await getCognitoAttributes();

      bool success = false;
      int? userId;

      if (widget.isEditing) {
        userId = formData['userId'];
        success = await _updateUser(attrMap!);
      } else {
        userId = await _createUser(attrMap!);
        success = userId != null;
        if (success) { 
          formData['userId'] = userId;
        }
      }

      if (!success || userId == null) {
        log.severe("User create/update failed");
        throw Exception("User create/update failed");
      }

      final tags = await _fetchTags(userId);
      setState(() {
        generatedTags = tags;
        _isLoading = false;
      });

      _stepForward();
    } catch (e) {
      log.severe("Error during registration: $e");
      setState(() => _isLoading = false);
    }
  }

  /// builds the box that the screens will live within to tie the look together
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.baseYellow,
          appBar: AppBar(
            title: SizedBox(
              height: 40,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset('assets/uplift_black.png'),
              ),
            ),
            centerTitle: true,
            backgroundColor: AppColors.baseGreen,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _stepBack,
            ),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    "Recipient Registration",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    "Step ${_currentIndex + 1} of ${registrationQuestions.length}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      color: AppColors.warmWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: AppColors.lavender, width: 1.5)
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                              );
                          },
                          child: _buildCurrentStep(),
                        )
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) / registrationQuestions.length,
                      backgroundColor: AppColors.warmWhite,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.baseOrange),
                      minHeight: 8.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withAlpha(140),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.baseRed),
              ),
            ),
          ),
      ],
    );
  }

  /// builds the step we are on for display
  Widget _buildCurrentStep() {
    final question = registrationQuestions[_currentIndex];

    if (question['type'] == 'confirmation') {
      return Confirmation(
        formData: formData,
        onBack: _stepBack,
        onGenerate: _handleUserRegistrationAndTags,
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
        onGenerate: _handleUserRegistrationAndTags,
        returnToConfirmation: returnToConfirmation,
      );
    }
  }
}