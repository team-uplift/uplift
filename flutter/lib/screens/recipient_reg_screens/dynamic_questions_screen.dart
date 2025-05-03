/// dynamic_questions_screen.dart
///
/// this file is used to load the correct formstyle from registration
/// questions as the user progresses through the form
/// includes:
/// - _buildQuestionField widget
/// - _buildCompositeAddressFields
/// 

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:uplift/constants/constants.dart';

class DynamicQuestionScreen extends StatefulWidget {
  final Map<String, dynamic> formData;
  final List<Map<String, dynamic>> questions;
  final int questionIndex;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onGenerate;
  final bool returnToConfirmation;

  const DynamicQuestionScreen({
    required this.formData,
    required this.questions,
    required this.questionIndex,
    required this.onNext,
    required this.onBack,
    required this.onGenerate,
    required this.returnToConfirmation,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DynamicQuestionScreenState createState() => _DynamicQuestionScreenState();
}

class _DynamicQuestionScreenState extends State<DynamicQuestionScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> get question => widget.questions[widget.questionIndex];
  String get questionKey => question['key'];

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
              Text(
                question['q'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              _buildQuestionField(question),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.baseGreen,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                final isValid =
                    _formKey.currentState?.saveAndValidate() ?? false;
                if (isValid) {
                  widget.formData.addAll(_formKey.currentState!.value);
                  widget.onNext();
                }
              },
              child: Text(widget.returnToConfirmation
                  ? "Back to Confirmation"
                  : "Next"),
            ),
          ],
        ),
      ),
    ));
  }

  /// question type widget
  Widget _buildQuestionField(Map<String, dynamic> question) {
    switch (question['type'] as String) {
      case 'text':
        return FormBuilderTextField(
          key: ValueKey(question['key']),
          name: question['key'],
          maxLines: 4,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter your response...',
          ),
          validator: question['required'] == true
              ? FormBuilderValidators.required()
              : null,
        );
      case 'multipleChoice':
        return FormBuilderRadioGroup<String>(
          key: ValueKey(question['key']),
          name: question['key'],
          decoration: const InputDecoration(border: InputBorder.none),
          orientation: OptionsOrientation.vertical,
          options: (question['options'] as List<String>)
              .map(
                  (opt) => FormBuilderFieldOption(value: opt, child: Text(opt)))
              .toList(),
          validator: question['required'] == true
              ? FormBuilderValidators.required()
              : null,
        );
      case 'checkbox':
        return FormBuilderCheckboxGroup<String>(
          key: ValueKey(question['key']),
          name: question['key'],
          decoration: const InputDecoration(border: InputBorder.none),
          orientation: OptionsOrientation.vertical,
          options: (question['options'] as List<String>)
              .map(
                  (opt) => FormBuilderFieldOption(value: opt, child: Text(opt)))
              .toList(),
          validator: question['required'] == true
              ? FormBuilderValidators.minLength(1,
                  errorText: 'Please select at least one.')
              : null,
        );
      case 'compositeAddress':
        return _buildCompositeAddressFields();
      default:
        return const SizedBox.shrink();
    }
  }

  /// composite address widget builder
  Widget _buildCompositeAddressFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: FormBuilderTextField(
                key: const ValueKey('firstName'),
                name: 'firstName',
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: FormBuilderValidators.required(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FormBuilderTextField(
                key: const ValueKey('lastName'),
                name: 'lastName',
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: FormBuilderValidators.required(),
              ),
            ),
          ],
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
          decoration:
              const InputDecoration(labelText: 'Street Address 2 (optional)'),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: FormBuilderTextField(
                key: const ValueKey('city'),
                name: 'city',
                decoration: const InputDecoration(labelText: 'City'),
                validator: FormBuilderValidators.required(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: FormBuilderDropdown<String>(
                key: const ValueKey('state'),
                name: 'state',
                decoration: const InputDecoration(labelText: 'State'),
                items: FormVariables.usStates
                    .map((state) =>
                        DropdownMenuItem(value: state, child: Text(state)))
                    .toList(),
                validator: FormBuilderValidators.required(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        FormBuilderTextField(
          key: const ValueKey('zipCode'),
          name: 'zipCode',
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Zip Code'),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(),
            FormBuilderValidators.minLength(5,
                errorText: 'ZIP must be 5 digits'),
            FormBuilderValidators.maxLength(5,
                errorText: 'ZIP must be 5 digits'),
          ]),
        ),
      ],
    );
  }
}
