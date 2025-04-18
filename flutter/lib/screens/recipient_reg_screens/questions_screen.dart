import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class DynamicQuestionScreen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final List<Map<String, dynamic>> questions;
  final int questionIndex;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onGenerate;

  const DynamicQuestionScreen({
    required this.formData,
    required this.questions,
    required this.questionIndex,
    required this.onNext,
    required this.onBack,
    required this.onGenerate,
    super.key,
  });

  @override
  _DynamicQuestionScreenState createState() => _DynamicQuestionScreenState();
}

class _DynamicQuestionScreenState extends State<DynamicQuestionScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> get question => widget.questions[widget.questionIndex];
  String get questionKey => question['key'];

  final List<String> usStates = [
    'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
    'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD',
    'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ',
    'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC',
    'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY',
  ];




  // @override
  // void initState() {
  //   super.initState();
  //   _initializeQuestion();
  // }

  // @override
  // void didUpdateWidget(covariant DynamicQuestionScreen oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   // ✅ Reset state when switching to a new question
  //   if (oldWidget.questionIndex != widget.questionIndex) {
  //     _formKey.currentState?.reset();
  //   }
  // }

  // void _initializeQuestion() {
  //   final question = widget.questions[widget.questionIndex];

  //   // ✅ Load saved answer if available, otherwise start empty
  //   selectedAnswer = widget.formData.containsKey(question['key']) ? widget.formData[question['key']] : null;

  //   // ✅ Initialize text field if it's a text input question
  //   _textController = TextEditingController(text: selectedAnswer is String ? selectedAnswer : "");
  // }

  // @override
  // void dispose() {
  //   _textController.dispose(); // ✅ Prevent memory leaks
  //   super.dispose();
  // }

  // void _saveAnswer() {
  //   final question = widget.questions[widget.questionIndex];

  //   if (question['type'] == 'text') {
  //     widget.formData[question['key']] = _textController.text.trim();
  //   } else {
  //     widget.formData[question['key']] = selectedAnswer;
  //   }
  // }

  // // validation function from chatgpt
  // bool isAnswerValid(Map<String, dynamic> question, dynamic answer) {
  //   if (question['required'] != true) return true;

  //   switch (question['type']) {
  //     case 'text':
  //       return answer?.toString().trim().isNotEmpty ?? false;
  //     case 'multipleChoice':
  //       return answer != null;
  //     case 'checkbox':
  //       return answer is List && answer.isNotEmpty;
  //     default:
  //       return true;
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: FormBuilder(
            key: _formKey,
            initialValue: Map<String, dynamic>.from(widget.formData),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(question['q']),
                const SizedBox(height: 16),
                // ✅ TEXT INPUT (Ensures fresh controller per question)
                if (question['type'] == 'text')
                  FormBuilderTextField(
                    key: ValueKey(questionKey),
                    name: questionKey,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter your response...",
                    ),
                    validator: question['required'] == true
                      ? FormBuilderValidators.required()
                      : null,

                  ),

                // ✅ MULTIPLE CHOICE (Radio Buttons - Ensure state is saved)
                if (question['type'] == 'multipleChoice')
                  FormBuilderRadioGroup<String>(
                    key: ValueKey(questionKey),
                    name: questionKey, 
                    decoration: const InputDecoration(border: InputBorder.none),
                    orientation: OptionsOrientation.vertical,
                    options: (question['options'] as List<String>)
                      .map((opt) => FormBuilderFieldOption(value: opt, child: Text(opt)))
                      .toList(),
                    validator: question['required'] == true
                        ? FormBuilderValidators.required()
                        : null,
                  ),

                // CHECKBOX GROUP
                if (question['type'] == 'checkbox')
                  FormBuilderCheckboxGroup<String>(
                    key: ValueKey(questionKey),
                    name: questionKey,
                    decoration: const InputDecoration(border: InputBorder.none),
                    orientation: OptionsOrientation.vertical,
                    options: (question['options'] as List<String>)
                        .map((opt) => FormBuilderFieldOption(value: opt, child: Text(opt)))
                        .toList(),
                    validator: question['required'] == true
                        ? FormBuilderValidators.minLength(1, errorText: "Please select at least one.")
                        : null,
                  ),
                
                // Composite Address Fields
                if (question['type'] == 'compositeAddress')
                  Column(
                    children: [
                      FormBuilderTextField(
                        key: const ValueKey('firstName'),
                        name: 'firstName',
                        decoration: const InputDecoration(labelText: 'First Name'),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        key: const ValueKey('lastName'),
                        name: 'lastName',
                        decoration: const InputDecoration(labelText: 'Last Name'),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        key: const ValueKey('streetAddress1'),
                        name: 'streetAddress1',
                        decoration: const InputDecoration(labelText: 'Street Address 1'),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        key: const ValueKey('streetAddress2'),
                        name: 'streetAddress2',
                        decoration: const InputDecoration(labelText: 'Street Address 2 (optional)'),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderTextField(
                        key: const ValueKey('city'),
                        name: 'city',
                        decoration: const InputDecoration(labelText: 'City'),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 8),
                      FormBuilderDropdown<String>(
                        key: const ValueKey('state'),
                        name: 'state',
                        decoration: InputDecoration(labelText: 'State'),
                        items: usStates
                            .map((state) => DropdownMenuItem(
                                  value: state,
                                  child: Text(state),
                                ))
                            .toList(),
                        validator: FormBuilderValidators.required(),
                      )
                    ],
                  ),


                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    // this is for generating tags
                    if (question['type'] == 'confirmation') 
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Generate Tags?"),
                              content: const Text("Are you sure you want to generate tags? You will not be able to go back."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close dialog
                                    widget.onGenerate();    // Now trigger tag generation
                                  },
                                    child: const Text("Yes, Generate Tags"),
                                ),
                              ],
                            ),
                          );
                        },
                      child: const Text("Generate Tags"),
                      ),
                      
                    if (question['type'] != 'generateTags')  
                      ElevatedButton(
                        onPressed: () {
                          final isValid = _formKey.currentState?.saveAndValidate() ?? false;
                          if (isValid) {
                            widget.formData.addAll(_formKey.currentState!.value);
                            widget.onNext();
                          }
                        },
                        child: const Text("Next"),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}





// TODO design logo
// TODO comment code
