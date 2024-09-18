import 'package:flutter/material.dart';
import 'package:notepad/Home/Home.dart';
import 'package:notepad/Login/Login.dart';
import 'package:notepad/Register/Register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notepad',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/': (context) => const Home(),
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
      },
    );
  }
}
