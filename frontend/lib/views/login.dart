import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/services/auth.dart';
import 'package:frontend/shared/error.dart';
import 'package:frontend/shared/validators.dart';
import 'package:frontend/views/register.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late AuthService authService;

  final _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authService = AuthService.instance;
  }

  Future<void> login() async {
    if (_loginFormKey.currentState!.validate()) {
      try {
        await authService.login(
          usernameController.text,
          passwordController.text,
        );
      } on ApiError catch (error) {
        SnackBar snackBar = SnackBar(content: Text(error.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } on Error catch (_) {
        SnackBar snackBar = const SnackBar(content: Text('Failed to login'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        SnackBar snackBar = const SnackBar(content: Text('No connecion available'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      SnackBar snackBar = const SnackBar(content: Text('Invalid username or password format. Please enter valid data!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  List<Widget> loginForm() {
    return [
      Text(
        'Login',
        style: Theme.of(context).textTheme.headline3,
      ),
      const SizedBox(height: 16),
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
        validator: Validators.loginPasswordValidator,
        controller: passwordController,
      ),
      const SizedBox(height: 8),
      ElevatedButton(onPressed: () {
          login();
        }, 
        child: const Text("Login")
        ),
      const SizedBox(height: 8),
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
              child: LayoutBuilder(
                builder: (context, constraints) => Form(
                  key: _loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
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