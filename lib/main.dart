import 'package:flutter/material.dart';
import 'package:todo_app/features/home/layout.dart';
import 'package:todo_app/my_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyTheme.lightMode,
      darkTheme: MyTheme.darkMode,
      initialRoute: Layout.routeName,
      routes: {
        Layout.routeName: (context) => Layout(),
      },
    );
  }
}
