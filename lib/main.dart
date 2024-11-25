import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Auth/loginPage.dart';
import 'screens/onboardingScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme:
            const TextTheme(bodyMedium: TextStyle(color: Color(0xffF7F7F7))),
        scaffoldBackgroundColor: const Color(0xff232937),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: LoginPage(),
      ),
    );
  }
}
