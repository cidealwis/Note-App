import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:your_project_name/services/api_service.dart'; // Replace with your actual API service file
import 'package:your_project_name/utils/validation_helper.dart'; // Replace with your actual validation helper file
import 'package:your_project_name/redux/user/user_actions.dart'; // Replace with your actual redux actions
import 'package:your_project_name/redux/store.dart'; // Replace with your actual redux store setup file
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String error = "";

  void handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() {
      error = "";
    });

    try {
      // Dispatch login start action
      context.read<UserActions>().signInStart();

      final res = await ApiService.signIn(email, password);

      if (res['success'] == false) {
        Fluttertoast.showToast(msg: res['message']);
        setState(() {
          error = res['message'];
        });
        context.read<UserActions>().signInFailure(res['message']);
        return;
      }

      Fluttertoast.showToast(msg: res['message']);
      context.read<UserActions>().signInSuccess(res);
      Navigator.pushReplacementNamed(context, '/');
    } catch (error) {
      Fluttertoast.showToast(msg: error.toString());
      context.read<UserActions>().signInFailure(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!validateEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  if (error.isNotEmpty)
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: handleLogin,
                    child: Text('LOGIN'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF2B85FF),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      'Not registered yet? Create an account',
                      style: TextStyle(color: Color(0xFF2B85FF)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
