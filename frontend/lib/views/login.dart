import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/services/authentification.dart';
import 'package:frontend/views/home.dart';
import 'package:frontend/views/register.dart';
import 'package:frontend/validators/validators.dart';

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
    }
  }

  List<Widget> loginForm() {
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
        validator: Validators.loginPasswordValidator,
        controller: passwordController,
      ),
      ElevatedButton(onPressed: login, child: const Text("Login")),
      ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RegisterView()));
          },
          child: const Text("Don't have an account yet ?")),
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
