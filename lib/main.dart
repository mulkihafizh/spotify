import 'package:flutter/material.dart';
import 'package:spotify/screen/menu_screen.dart';
import 'screen/login_screen.dart';
import 'screen/splash_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Gotham",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/splash",
      routes: {
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const MenuScreen(),
        '/splash': (context) => const SplashScreen(),
      },
    );
  }
}
