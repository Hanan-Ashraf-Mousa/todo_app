import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/features/auth/widgets/custom_text_form_field.dart';
import 'package:todo_app/features/home/layout.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/model/my_user.dart';
import 'package:todo_app/my_theme.dart';

import '../../../provider/auth_providers.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = "sign up";

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.fill),
            color: MyTheme.bgLight),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text('Create Account'),
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          label: 'Username',
                          controller: nameController,
                          validate: (value) {
                            if (value!.isEmpty || value == null) {
                              return 'Please, enter your name';
                            }
                            return null;
                          },
                        ),
                        CustomTextFormField(
                            label: 'Email',
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validate: (value) {
                              if (value!.isEmpty || value == null) {
                                return 'Please enter your email';
                              }
                              bool isValid = RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                  .hasMatch(value);
                              if (!isValid) {
                                return 'Invalid email address';
                              }
                              return null;
                            }),
                        CustomTextFormField(
                            label: 'Password',
                            controller: passwordController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            validate: (value) {
                              if (value!.isEmpty || value == null) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            }),
                        CustomTextFormField(
                            label: 'Confirm Password',
                            controller: confirmPasswordController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            validate: (value) {
                              if (value!.isEmpty || value == null) {
                                return 'Please confirm your password';
                              }
                              if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            }),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: MyTheme.primaryColor),
                            onPressed: () {
                              signUp();
                            },
                            child: Text(
                              'Create Account',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      fontSize: 16, color: MyTheme.whiteColor),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        DialogUtils.showLoading(context: context, message: 'Loading...');
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        var user = MyUser(
            id: credential.user?.uid,
            name: nameController.text,
            email: emailController.text);
        FirebaseUtils.addUserToFireStore(user);
        var authProvider = Provider.of<AuthProviders>(context, listen: false);
        authProvider.setCurrentUser(user);
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context: context,
            content: 'Account created Successfully',
            title: 'Success',
            posName: 'Ok',
            posAction: () {
              Navigator.pushReplacementNamed(context, Layout.routeName);
            });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context: context,
              content: 'Password is too weak',
              title: 'Error');
        } else if (e.code == 'email-already-in-use') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context: context,
              content: 'The account already exists for that email.',
              title: 'Error');
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
