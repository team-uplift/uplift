import 'package:flutter/material.dart';

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
  late TextEditingController _textController;
  dynamic selectedAnswer; // Stores user selection

  @override
  void initState() {
    super.initState();
    _initializeQuestion();
  }

  @override
  void didUpdateWidget(covariant DynamicQuestionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ Reset state when switching to a new question
    if (oldWidget.questionIndex != widget.questionIndex) {
      _initializeQuestion();
    }
  }

  void _initializeQuestion() {
    final question = widget.questions[widget.questionIndex];

    // ✅ Load saved answer if available, otherwise start empty
    selectedAnswer = widget.formData.containsKey(question['key']) ? widget.formData[question['key']] : null;

    // ✅ Initialize text field if it's a text input question
    _textController = TextEditingController(text: selectedAnswer is String ? selectedAnswer : "");
  }

  @override
  void dispose() {
    _textController.dispose(); // ✅ Prevent memory leaks
    super.dispose();
  }

  void _saveAnswer() {
    final question = widget.questions[widget.questionIndex];

    if (question['type'] == 'text') {
      widget.formData[question['key']] = _textController.text.trim();
    } else {
      widget.formData[question['key']] = selectedAnswer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[widget.questionIndex];

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(question['q']),

              const SizedBox(height: 16),

              // ✅ TEXT INPUT (Ensures fresh controller per question)
              if (question['type'] == 'text')
                TextField(
                  controller: _textController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your response...",
                  ),
                ),

              // ✅ MULTIPLE CHOICE (Radio Buttons - Ensure state is saved)
              if (question['type'] == 'multipleChoice')
                Column(
                  children: (question['options'] as List<String>).map((option) {
                    return RadioListTile(
                      title: Text(option),
                      value: option,
                      groupValue: selectedAnswer, // ✅ Keeps the selected value
                      onChanged: (val) {
                        setState(() => selectedAnswer = val);
                      },
                    );
                  }).toList(),
                ),

              // ✅ CHECKBOX MULTI-SELECT (Ensures state is saved)
              if (question['type'] == 'checkbox')
                Column(
                  children: (question['options'] as List<String>).map((option) {
                    final isSelected = (selectedAnswer ?? []).contains(option);

                    return CheckboxListTile(
                      title: Text(option),
                      value: isSelected,
                      onChanged: (selected) {
                        setState(() {
                          if (selectedAnswer == null || selectedAnswer is! List) {
                            selectedAnswer = []; // ✅ Ensure it's a list
                          }

                          if (selected == true) {
                            selectedAnswer.add(option);
                          } else {
                            selectedAnswer.remove(option);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible: widget.questionIndex > 0,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: OutlinedButton(
                      onPressed: widget.onBack,
                      child: const Text("Back"),
                    ),
                  ),
                                      
                  if (question['type'] == 'generateTags')  
                    Center(
                      child: ElevatedButton(
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
                                    _saveAnswer();
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
                    ),
                    
                  if (question['type'] != 'generateTags')  
                    ElevatedButton(
                      onPressed: () {
                        _saveAnswer(); // ✅ Saves input before moving forward
                        widget.onNext();
                      },
                      child: const Text("Next"),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}





// TODO design logo
// TODO add navbar for donors
// TODO im sure theres more and more
// TODO comment code