
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/services/auth.dart';
import 'package:frontend/shared/error.dart';
import 'package:frontend/shared/validators.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late AuthService authService;
  bool isProcessing = false;

  final _registerFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authService = AuthService.instance;
  }

  Future<void> register() async {
    setState(() {
      isProcessing = true;
    });
    
    if (_registerFormKey.currentState!.validate()) {
      try {
        await authService.register(
          usernameController.text,
          passwordController.text,
        );
      } on ApiError catch (error) {
        SnackBar snackBar = SnackBar(content: Text(error.message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } on Error catch (_) {
        SnackBar snackBar = const SnackBar(content: Text('Failed to register'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        SnackBar snackBar = const SnackBar(content: Text('No connecion available'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      SnackBar snackBar = const SnackBar(content: Text('Invalid username or password format. Please enter valid data!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    setState(() {
      isProcessing = false;
    });
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
                    children: [
                      Text(
                        'Register',
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
                        validator: Validators.registerPasswordValidator,
                        controller: passwordController,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: isProcessing ? null : register, 
                        child: const Text("Register")
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: isProcessing ? null : () {
                          Navigator.pop(context);
                        },
                        child: const Text("Already registered ?")
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}