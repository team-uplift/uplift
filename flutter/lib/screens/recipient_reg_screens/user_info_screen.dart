import 'package:flutter/material.dart';


// TODO entirely chatgpt for starting point

class UserInfo extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onNext;

  UserInfo({required this.formData, required this.onNext});

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _email;
  late TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _firstName = TextEditingController(text: widget.formData["firstName"]);
    _lastName = TextEditingController(text: widget.formData["lastName"]);
    _email = TextEditingController(text: widget.formData["email"]);
    _password = TextEditingController(text: widget.formData["password"]);
  }

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      widget.formData["first"] = _firstName.text;
      widget.formData["last"] = _lastName.text;
      widget.formData["email"] = _email.text;
      widget.formData["password"] = _password.text;
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _firstName,
            decoration: InputDecoration(labelText: "First Name"),
            validator: (value) => value!.isEmpty ? "Required" : null,
          ),
          TextFormField(
            controller: _lastName,
            decoration: InputDecoration(labelText: "Last Name"),
            validator: (value) => value!.isEmpty ? "Required" : null,
          ),
          TextFormField(
            controller: _email,
            decoration: InputDecoration(labelText: "Email"),
            validator: (value) => value!.isEmpty ? "Required" : null,
          ),
          TextFormField(
            controller: _password,
            decoration: InputDecoration(labelText: "Password"),
            obscureText: true,
            validator: (value) => value!.length < 6 ? "Min 6 characters" : null,
          ),
          Spacer(),
          ElevatedButton(
            onPressed: _saveAndContinue,
            child: Text("Next"),
          )
        ],
      ),
    );
  }
}