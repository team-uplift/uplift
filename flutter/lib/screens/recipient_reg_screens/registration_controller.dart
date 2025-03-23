import 'package:flutter/material.dart';
import 'user_info_screen.dart';
import 'about_me_screen.dart';
import 'reason_for_need_screen.dart';
import 'tag_selection_screen.dart';


class RegistrationController extends StatefulWidget {
  const RegistrationController({super.key});

  @override
  State<RegistrationController> createState() => _RegistrationControllerState();
}

class _RegistrationControllerState extends State<RegistrationController> {
  int _currentIndex = 0;

  Map<String, dynamic> formData = {
    "first": "",
    "last": "",
    "email": "",
    "password": "",
    "aboutMe": "",
    "reasonForNeed": "",
    "tags": [],
  };

  void _stepForward() {
    setState(() {
      if (_currentIndex < 3) _currentIndex++;
    });
  }

  void _stepBack() {
    setState(() {
      if (_currentIndex > 0) _currentIndex--;
    });
  }

  void _submit() {
    setState(() {
      // TODO implement actually puishing to backend
      print("Reg completed");
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen;

    switch (_currentIndex) {
      case 0:
        currentScreen = UserInfo(
          formData: formData,
          onNext: _stepForward,
        );
        break;
      case 1:
        currentScreen = AboutMe(
          formData: formData,
          onNext: _stepForward,
          onBack: _stepBack,
        );
        break;
      case 2:
        currentScreen = ReasonForNeed(
          formData: formData,
          // TODO if changed this needs to regen tags. Maybe not allowed to go back after submitting this?
          onNext: _stepForward,
          onBack: _stepBack,
        );
        break;
      case 3:
        currentScreen = TagSelection(
          formData: formData,
          onSubmit: _submit,
          onBack: _stepBack,
        );
        break;
      default:
        currentScreen = const Center(child: Text("Unknown step"));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Recipient Registration")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: currentScreen,
      )
    );
  }
}



// TODO make all screens mobile friendly via wrapping everything in scroll view and safe areas