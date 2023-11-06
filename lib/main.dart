// ignore_for_file: prefer_const_constructors
import 'package:Daily_Report_DISKOMINFO/pages/auth_checker_page.dart';
import 'package:Daily_Report_DISKOMINFO/pages/unauth/login.dart';
import 'package:Daily_Report_DISKOMINFO/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => UserProvider()), // Tambahkan ini
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Report DISKOMINFO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: AuthCheckerPage(),
    );
  }
}
