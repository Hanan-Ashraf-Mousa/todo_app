import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/features/auth/login/login_screen.dart';
import 'package:todo_app/features/auth/register/sign_up_screen.dart';
import 'package:todo_app/features/home/layout.dart';
import 'package:todo_app/generated/l10n.dart';
import 'package:todo_app/my_theme.dart';
import 'package:todo_app/provider/auth_providers.dart';
import 'package:todo_app/provider/list_provider.dart';
import 'package:todo_app/provider/locale_provider.dart';
import 'package:todo_app/provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /// store data offline
  // await FirebaseFirestore.instance.disableNetwork();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (BuildContext context) => ListProvider(),
      ),
      ChangeNotifierProvider(create: (context) => AuthProviders()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => LocaleProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context);
    var lang = Provider.of<LocaleProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyTheme.lightMode,
      darkTheme: MyTheme.darkMode,
      themeMode: theme.currentTheme,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: Locale(lang.currentLangCode),
      initialRoute: LoginScreen.routeName,
      routes: {
        SignUpScreen.routeName: (context) => SignUpScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        Layout.routeName: (context) => Layout(),
      },
    );
  }
}
