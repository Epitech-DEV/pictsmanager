import 'package:flutter/material.dart';
import 'package:frontend/states/login_state.dart';
import 'package:frontend/states/theme_state.dart';
import 'package:frontend/views/home.dart';
import 'package:frontend/views/login.dart';
import 'package:provider/provider.dart';

class PictsManagerApp extends StatelessWidget {
  const PictsManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginState>(
          create: (_) => LoginState.instance,
        ),
        ChangeNotifierProvider<ThemeState>(
          create: (_) => ThemeState(useDarkTheme: true),
        ),
      ],
      builder: (context, _) => Consumer2<LoginState, ThemeState>(
        builder: (context, LoginState loginState, themeState, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PictsManager',
          themeMode: themeState.themeMode,
          theme: ThemeState.lightTheme,
          darkTheme: ThemeState.darkTheme,
          home: loginState.isLoggedIn ? const HomeView() : const LoginView(),
        ),
      )
    );
  }
}
