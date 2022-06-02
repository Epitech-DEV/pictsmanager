import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/services/auth.dart';
import 'package:frontend/shared/error.dart';
import 'package:frontend/shared/validators.dart';
import 'package:frontend/views/home.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late AuthService authService;

  final _registerFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authService = AuthService.instance;
  }

  Future<void> register() async {
    if (_registerFormKey.currentState!.validate()) {
      try {
        await authService.register(
          usernameController.text,
          passwordController.text,
        );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomeView()));
      } on ApiError catch (error) {
        SnackBar snackBar = SnackBar(content: Text(error.message));
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
      const SizedBox(height: 8),
      TextFormField(
        obscureText: true,
        decoration: const InputDecoration(labelText: "Password"),
        validator: Validators.registerPasswordValidator,
        controller: passwordController,
      ),
      const SizedBox(height: 8),
      ElevatedButton(onPressed: register, child: const Text("Register")),
      const SizedBox(height: 8),
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
                child: LayoutBuilder(
                  builder: (context, constraints) => Form(
                    key: _registerFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
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