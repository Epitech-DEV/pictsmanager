import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/services/authentification.dart';
import 'package:frontend/utils/custom_exception.dart';
import 'package:frontend/views/home.dart';
import 'package:frontend/views/register.dart';
import 'package:frontend/validators/validators.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (_loginFormKey.currentState!.validate()) {
      try {
        await Authentification.login(
          usernameController.text,
          passwordController.text,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
          (Route<dynamic> route) => false,
        );
      } on CustomException catch (error) {
        SnackBar snackBar = SnackBar(content: Text(error.getMessage));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (error) {
        SnackBar snackBar = const SnackBar(content: Text('Failed to login'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  List<Widget> loginForm() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: "Username"),
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
      ),
    );
  }
}
