import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/services/authentification.dart';
import 'package:frontend/validators/validators.dart';
import 'package:frontend/views/home.dart';

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

  List<Widget> registerForm() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: "Username"),
        onChanged: (value) => {
          setState(() {
            username = value;
          })
        },
        validator: Validators.usernameValidator,
        controller: usernameController,
        keyboardType: TextInputType.name,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
        ],
      ),
      TextFormField(
        obscureText: true,
        decoration: const InputDecoration(labelText: "Password"),
        onChanged: (value) => {
          setState(() {
            password = value;
          })
        },
        validator: Validators.registerPasswordValidator,
        controller: passwordController,
      ),
      ElevatedButton(onPressed: register, child: const Text("Register")),
      ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Already registered ?")),
    ];
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
