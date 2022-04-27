import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/services/authentification.dart';
import 'package:frontend/themes/default.dart';
import 'package:frontend/views/home.dart';
import 'package:frontend/views/register.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String username = "";
  String password = "";

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final _registerFormKey = GlobalKey<FormState>();

  Future<void> register() async {
    try {
      if (_registerFormKey.currentState!.validate()) {
        await Authentification.register();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomeView()));
      }
    } catch (error) {
      print(error);
    }
  }

  void switchToRegisterView() {
    Navigator.pop(context);
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
    if (value.length < 8) {
      return "Password isn't long enough";
    }
    return null;
  }

  List<Widget> registerForm() {
    List<Widget> registerForm = [
      addTextFields("Username", usernameController, usernameValidator,
          keyboardType: TextInputType.name,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
          ]),
      addTextFields("Password", passwordController, passwordValidator,
          obscureText: true),
    ];

    registerForm.addAll([
      ElevatedButton(onPressed: register, child: const Text("Register")),
      ElevatedButton(
          onPressed: switchToRegisterView,
          child: const Text("Already registered ?")),
    ]);

    return registerForm;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                    key: _registerFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: registerForm(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
