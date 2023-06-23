import 'package:chatgpt_course/homescreen.dart';
import 'package:chatgpt_course/providers/models_provider.dart';
import 'package:chatgpt_course/registration/login.dart';
import 'package:chatgpt_course/registration/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/constants.dart';
import 'providers/chats_provider.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      child: MaterialApp(
        title: '',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(
            color: cardColor,
          ),
        ),
        home: isLoggedIn
            ? const MyHomePage(title: '')
            : LoginScreen(
                key: Key('login_screen'),
                title: '',
              ),
        routes: {
          '/signup': (context) => Signup(),
        },
      ),
    );
  }
}

class MyImtr extends StatefulWidget {
  const MyImtr({Key? key}) : super(key: key);

  @override
  State<MyImtr> createState() => _MyImtrState();
}

class _MyImtrState extends State<MyImtr> {
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  void navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context)?.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(
            key: Key('login_screen'),
            title: '',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 4, 53),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Lottie.network(
                  'https://assets5.lottiefiles.com/private_files/lf30_2j9ehnd2.json',
                  width: 150,
                  height: 150,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 9,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: const Text(
                    'I T T R',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(25),
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: const Text(
              'Powered By\n\nBIJY-World',
              style: TextStyle(
                color: Color.fromARGB(255, 193, 192, 192),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
