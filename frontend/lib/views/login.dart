import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/services/authentification.dart';
import 'package:frontend/themes/default.dart';
import 'package:frontend/views/home.dart';
import 'package:frontend/views/register.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String username = "";
  String password = "";

  bool loginError = false;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();

  Future<void> login() async {
    try {
      if (_loginFormKey.currentState!.validate()) {
        await Authentification.login();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomeView()));
      }
    } catch (error) {
      setState(() {
        loginError = true;
      });
      print(error);
    }
  }

  void switchToRegisterView() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const RegisterView()));
  }

  Widget addTextFields(field, textFieldController, validator,
      {obscureText = false,
      keyboardType = TextInputType.text,
      List<TextInputFormatter> inputFormatters = const []}) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(labelText: field),
      onChanged: (value) => {
        setState(() {
          if (field == "Password") {
            password = value;
          } else if (field == "Username") {
            username = value;
          }
        })
      },
      validator: validator,
      controller: textFieldController,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
    );
  }

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Field is empty";
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Field is empty";
    }
    return null;
  }

  List<Widget> loginForm() {
    List<Widget> loginForm = [
      addTextFields("Username", usernameController, usernameValidator,
          keyboardType: TextInputType.name,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
          ]),
      addTextFields("Password", passwordController, passwordValidator,
          obscureText: true),
    ];

    if (loginError) {
      loginForm.add(const Text(
        "Wrong credentials",
        style: inputErrorTextStyle,
      ));
    }

    loginForm.addAll([
      ElevatedButton(onPressed: login, child: const Text("Login")),
      ElevatedButton(
          onPressed: switchToRegisterView,
          child: const Text("Don't have an account ?")),
    ]);

    return loginForm;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Center(
                child: SizedBox(
                  height: 250,
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: loginForm(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
