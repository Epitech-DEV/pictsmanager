import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/services/authentification.dart';
import 'package:frontend/utils/custom_exception.dart';
import 'package:frontend/validators/validators.dart';
import 'package:frontend/views/home.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final _registerFormKey = GlobalKey<FormState>();

  Future<void> register() async {
    if (_registerFormKey.currentState!.validate()) {
      try {
        await Authentification.register(
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
        SnackBar snackBar = const SnackBar(content: Text('Failed to register'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  List<Widget> registerForm() {
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
