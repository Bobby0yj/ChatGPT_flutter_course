import 'package:chatgpt_course/homescreen.dart';
import 'package:chatgpt_course/registration/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController gmail = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool showpassword = true;

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  void showPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final isLoggedIn = snapshot.data;
          if (isLoggedIn!) {
            return const MyHomePage(title: 'title');
          } else {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 3, 34, 60),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      color: const Color.fromARGB(255, 18, 4, 53),
                      child: Center(
                        child: Container(
                          child: Lottie.network(
                            "https://assets2.lottiefiles.com/packages/lf20_jcikwtux.json",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      color: const Color.fromARGB(255, 18, 4, 53),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 51,
                                width: 50,
                                margin: const EdgeInsets.only(left: 27),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: FloatingActionButton(
                                  backgroundColor:
                                      const Color.fromARGB(151, 43, 25, 79),
                                  onPressed: () {},
                                  child: const Icon(
                                    Icons.person,
                                    color: Color.fromARGB(255, 6, 133, 40),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromARGB(151, 43, 25, 79),
                                ),
                                child: TextField(
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 229, 227, 227),
                                  ),
                                  controller: gmail,
                                  decoration: const InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(
                                      color: Color.fromARGB(147, 168, 170, 168),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                height: 51,
                                width: 50,
                                margin:
                                    const EdgeInsets.only(top: 27, left: 27),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: FloatingActionButton(
                                  backgroundColor:
                                      const Color.fromARGB(151, 43, 25, 79),
                                  onPressed: () {
                                    setState(() {
                                      showpassword = !showpassword;
                                    });
                                  },
                                  child: Icon(
                                    showpassword
                                        ? Icons.lock_outline
                                        : Icons.lock_open,
                                    color: const Color.fromARGB(255, 6, 133, 40),
                                  ),
                                ),
                              ),
                              Container(
                                height: 45,
                                width: MediaQuery.of(context).size.width * 0.7,
                                margin: const EdgeInsets.only(top: 27),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromARGB(151, 43, 25, 79),
                                ),
                                child: TextField(
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 229, 227, 227),
                                  ),
                                  controller: pass,
                                  obscureText: showpassword,
                                  decoration: const InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                      color: Color.fromARGB(147, 168, 170, 168),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 0.6,
                            margin: const EdgeInsets.only(top: 15, left: 15),
                            child: InkWell(
                              onTap: () {
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) => SignUp()));
                              },
                              child: const Text(
                                "Forgot Password ?",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 6, 133, 40),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                height: 51,
                                width: 50,
                                margin:
                                    const EdgeInsets.only(left: 27, top: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: FloatingActionButton(
                                  backgroundColor:
                                      const Color.fromARGB(151, 43, 25, 79),
                                  onPressed: () {},
                                  child: const Icon(
                                    Icons.arrow_right_alt_sharp,
                                    color: Color.fromARGB(255, 6, 133, 40),
                                  ),
                                ),
                              ),
                              Container(
                                height: 51,
                                width: MediaQuery.of(context).size.width * 0.7,
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color.fromARGB(147, 7, 142, 66),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    if (gmail.text.isEmpty ||
                                        pass.text.isEmpty) {
                                      showPopup(
                                          'Please enter email and password');
                                      return;
                                    }
                                    FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                      email: gmail.text,
                                      password: pass.text,
                                    )
                                        .then((value) async {
                                      print("successful");

                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setBool('isLoggedIn', true);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MyHomePage(title: 'title'),
                                        ),
                                      );
                                    }).catchError((error) {
                                      showPopup('Invalid email or password');
                                    });
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 248, 249, 249),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account ?",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Container(
                                height: 45,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Signup(),
                                        ),
                                      );
                                    });
                                  },
                                  child: const Text(
                                    "Signup here",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 1, 130, 35),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
