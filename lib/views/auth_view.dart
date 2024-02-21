import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:todo/views/task_list.dart';

import '../viewmodels/user_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserViewModel userViewModel = UserViewModel();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(
                        top: height * 0.15, bottom: height * 0.05),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Text(
                      'ToDo',
                      style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: height * 0.05),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                      maxLines: 1,
                      controller: emailController,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Email is required'),
                        EmailValidator(errorText: 'Enter a valid email address')
                      ]),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Enter your email',
                        prefix: Icon(Icons.email),
                      )),
                ),
                SizedBox(height: height * 0.02),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    maxLines: 1,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Password is required'),
                      MinLengthValidator(6,
                          errorText: 'Password must be at least 6 digits long')
                    ]),
                    controller: passwordController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Enter your password',
                      prefix: Icon(Icons.lock),
                      suffix: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.1),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        User? user = await userViewModel.signIn(
                            emailController.text, passwordController.text);
                        if (user != null) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => TaskList()),
                            (route) => false,
                          );
                        } else {
                          // Show login failed message
                        }
                      }
                    },
                    child: Text('Login'),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationScreen()),
                        );
                      },
                      child: Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final UserViewModel userViewModel = UserViewModel();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obsecureText = true;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: height * 0.05, top: height * 0.05),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Text(
                      'ToDo',
                      style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                Text(
                  'Create an account to get started',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: height * 0.05),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Email is required'),
                      EmailValidator(errorText: 'Enter a valid email address')
                    ]),
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Enter your email',
                      prefix: Icon(Icons.email),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Password is required'),
                      MinLengthValidator(6,
                          errorText: 'Password must be at least 6 digits long')
                    ]),
                    controller: passwordController,
                    obscureText: obsecureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Enter your password',
                      prefix: Icon(Icons.lock),
                      suffix: IconButton(
                        icon: Icon(
                          obsecureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obsecureText = !obsecureText;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    validator: (val) {
                      [
                        MultiValidator(
                          [
                            RequiredValidator(
                                errorText: 'Password is required'),
                            MinLengthValidator(6,
                                errorText:
                                    'Password must be at least 6 digits long')
                          ],
                        )
                      ];
                      if (val != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      hintText: 'Confirm your password',
                      prefix: Icon(Icons.lock),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.1),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        User? user = await userViewModel.register(
                            emailController.text, passwordController.text);
                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => TaskList()),
                          );
                        } else {
                          // Show registration failed message
                        }
                      }
                    },
                    child: Text('Register'),
                  ),
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
