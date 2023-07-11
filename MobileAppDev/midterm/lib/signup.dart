import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var _password;
    var _letter = 0;
    var _num = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[
              const SizedBox(height: 12.0),
              TextFormField(
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Username',
                ),
                validator: (value) {
                  var val = value.toString();
                  for (var i = 0; i < val.length; i++) {
                    val[i].contains(RegExp(r'[0-9]')) ? _num = _num + 1 : null;
                    val[i].contains(RegExp(r'[a-zA-Z]'))
                        ? _letter = _letter + 1
                        : null;
                  }
                  if (_num >= 3 && _letter >= 3) {
                    return null;
                  } else {
                    return 'Username is invalid';
                  }
                },
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                validator: (value) {
                  _password = value;
                  if (value!.isEmpty) {
                    return 'Please enter Password';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm Password';
                  } else if (value != _password) {
                    return 'Confirm Password doesn\'t match password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Email Address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Email Address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Successfully signed up')),
                        );
                        Navigator.pop(context);
                      }
                      ;
                    },
                    child: const Text("SIGN UP"),
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
