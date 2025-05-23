import 'package:expense_tracker/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Expense Tracker",
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          // ignore: deprecated_member_use
          background: Colors.grey.shade100,
          // ignore: deprecated_member_use
          onBackground: Colors.black,
          primary:Color(0xFF00B2E7),
          secondary: Color(0xFFE064F7),
          tertiary: Color(0xFFFF8D6C),
          outline: Colors.grey.shade400

        ),
      ),
      home: HomeScreen(),
    );
  }
}