import 'package:admin_app/shared/constants.dart';
import 'package:admin_app/shared/local_var.dart';
import 'package:admin_app/shared/reusables.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:admin_app/theme/custom_text_styles.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  String _emailInput = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: Form(
                child: Column(
              children: <Widget>[
                const SizedBox(height: 90),
                defaultTextTitle(_screenSize, LocalVar.eventAdmin.toUpperCase(),
                    _screenSize.width * 0.15),
                SizedBox(height: _screenSize.height * 0.01),
                SizedBox(
                  width: _screenSize.width * 0.7,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailCtrl,
                    decoration: InputDecoration(
                        hintText: LocalVar.emailInputHint,
                        hintStyle: CustomTextStyle.hintStyle,
                        errorStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    textAlign: TextAlign.left,
                    validator: (value) {
                      String pattern = Constants.emailRegex;
                      RegExp regex = RegExp(pattern);
                      if (value == null ||
                          value.isEmpty ||
                          !regex.hasMatch(value)) {
                        return LocalVar.invalidEmail;
                      } else {
                        return null;
                      }
                    },
                    style: CustomTextStyle.codeInputStyle,
                    onChanged: (value) {
                      setState(() {
                        _emailInput = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: _screenSize.height * 0.03),
                SizedBox(
                  width: _screenSize.width * 0.7,
                  child: TextFormField(
                    obscureText: true,
                    controller: _pwCtrl,
                    decoration: InputDecoration(
                        hintText: LocalVar.pwInputHint,
                        hintStyle: CustomTextStyle.hintStyle,
                        errorStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    validator: (value) =>
                        value!.length < 6 ? LocalVar.pwCriteria : null,
                    style: CustomTextStyle.codeInputStyle,
                    onChanged: (value) {
                      setState(() => password = value);
                    },
                  ),
                ),
                SizedBox(height: _screenSize.height * 0.05),
                defaultTextButton(context, LocalVar.logIn.toUpperCase(),
                    () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailInput.trim(),
                            password: password.trim());
                    //FocusScope.of(context).unfocus();
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      showAlertDialog(context, LocalVar.noSuchUser);
                    } else if (e.code == 'wrong-password') {
                      showAlertDialog(context, LocalVar.pwCriteria);
                    }
                  }
                })
              ],
            ))));
  }
}
