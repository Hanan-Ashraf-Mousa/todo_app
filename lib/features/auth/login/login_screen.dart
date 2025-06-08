import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/features/auth/register/sign_up_screen.dart';
import 'package:todo_app/features/auth/widgets/custom_text_form_field.dart';
import 'package:todo_app/features/home/layout.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/my_theme.dart';
import 'package:todo_app/provider/auth_providers.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "log in";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

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
            title: Text('Log in'),
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
                            label: 'Email',
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validate: (value) {
                              if (value!.isEmpty) {
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
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            }),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: MyTheme.primaryColor),
                            onPressed: () {
                              login();
                            },
                            child: Text(
                              'Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      fontSize: 16, color: MyTheme.whiteColor),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, SignUpScreen.routeName);
                            },
                            child: Text('Don\'t have an account. Register'))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      try {
        DialogUtils.showLoading(context: context, message: 'Loading...');
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        if (credential.user != null) {
          var user =
              await FirebaseUtils.readUserFromFireStore(credential.user!.uid);
          var authProvider = Provider.of<AuthProviders>(context, listen: false);
          authProvider.setCurrentUser(user!);
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context: context,
              content: 'Log in Successfully',
              title: 'Success',
              posName: 'Ok',
              posAction: () {
                Navigator.pushReplacementNamed(context, Layout.routeName);
              });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context: context, content: '', title: 'Error');
        }
      } catch (e) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context: context, content: e.toString(), title: 'Error');
        debugPrint(e.toString());
      }
    }
  }
}
