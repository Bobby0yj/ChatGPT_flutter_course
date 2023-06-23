import 'dart:convert';

import 'package:chatgpt_course/homescreen.dart';
import 'package:chatgpt_course/registration/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController fName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController gmail = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController cpass = TextEditingController();
  bool showpassword = true;

  userDetails(fName, phone, gmail, pass, cpass) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Create a Map to store the signup details
    Map<String, dynamic> user = {
      "name": fName,
      "phone": phone,
      "gmail": gmail,
      "password": pass,
      "cpass": cpass,
    };

    // Save the signup details as a JSON-encoded string
    prefs.setString("userDetails", jsonEncode(user));
  }

  void Submit(fName, phone, gmail, pass, cpass) {
    RegExp firstname = RegExp(r'^[A-Z]+[a-z]');
    RegExp phoneNumber = RegExp(r'^[0-9]{10}$');
    RegExp emailid = RegExp(r'^[a-z]+[0-9]+[@]+[a-z]+[.]');
    RegExp password = RegExp(r'^[A-Z]+[a-z]+[!@#$%^&]+[0-9]');

    if (firstname.hasMatch(fName)) {
      print(fName);
      if (emailid.hasMatch(gmail)) {
        print(gmail);
        if (phoneNumber.hasMatch(phone)) {
          phone = "+91 " + phone;
          print(phone);

          if (password.hasMatch(pass)) {
            print(pass);
            if (pass == cpass) {
              print(cpass);
              FirebaseAuth.instance
                  .createUserWithEmailAndPassword(email: gmail, password: pass)
                  .then((value) {
                print('created account');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Account Created'),
                      content: const Text(
                          'Your account has been created successfully!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyHomePage(
                                  title: '',
                                ),
                              ),
                            );
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }).onError((error, stackTrace) {
                print('error ${error.toString()}');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: const Text(
                          'An account with this email already exists.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              });
            } else {
              print("Password Doesn't Match");
            }
          } else {
            print("Invalid Password");
          }
        } else {
          print("Invalid Phone No");
        }
      } else {
        print("Invalid Mail");
      }
    } else {
      print("Invalid Name");
    }
  }

  void displaySignupDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the signup details as a JSON-encoded string
    String userDetailsString = prefs.getString("userDetails") ?? "";

    if (userDetailsString.isNotEmpty) {
      // Decode the JSON-encoded string back into a Map
      Map<String, dynamic> userDetails = jsonDecode(userDetailsString);

      // Access the signup details using the corresponding keys
      String name = userDetails["name"];
      String phone = userDetails["phone"];
      String email = userDetails["gmail"];
      String password = userDetails["password"];
      String confirmPassword = userDetails["cpass"];

      // Display the signup details
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Signup Details'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Name: $name'),
                Text('Phone: $phone'),
                Text('Email: $email'),
                Text('Password: $password'),
                Text('Confirm Password: $confirmPassword'),
              ],
            ),
            actions: [
              ElevatedButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      print('Signup details not found.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 27, 28, 28),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 40),
              Lottie.network(
                "https://assets2.lottiefiles.com/packages/lf20_jcikwtux.json",
                height: 180,
                width: 180,
              ),
              const SizedBox(height: 20),
              Container(
                child: const Text(
                  'WELCOME ',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 35),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                child: const Text(
                  'Lets Create Here.....! ',
                  style: TextStyle(
                      color: Color.fromARGB(255, 124, 124, 124), fontSize: 15),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: 300,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: fName,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 113, 113, 113)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 99, 99, 99)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: gmail,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 123, 123, 123)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 225, 225, 225)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: pass,
                      obscureText: showpassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 106, 106, 106)),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            showpassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: showpassword
                                ? Color.fromARGB(255, 108, 108, 108)
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              showpassword = !showpassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: cpass,
                      obscureText: showpassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 127, 127, 127)),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 128, 128, 128)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            showpassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: showpassword
                                ? const Color.fromARGB(255, 120, 120, 120)
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              showpassword = !showpassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    MaterialButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      onPressed: () {
                        userDetails(fName.text, phone.text, gmail.text,
                            pass.text, cpass.text);
                        Submit(
                          fName.text,
                          phone.text,
                          gmail.text,
                          pass.text,
                          cpass.text,
                        );
                      },
                      child: const Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      color: Color.fromARGB(255, 6, 71, 28),
                      minWidth: 300,
                      height: 45,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(
                                key: Key('value'),
                                title: '',
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Already Have Account?    Login',
                          style: TextStyle(
                            color: Color.fromARGB(255, 177, 177, 177),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 20),
                    // Container(
                    //   child: InkWell(
                    //     onTap: () {
                    //       displaySignupDetails();
                    //     },
                    //     child: const Text(
                    //       'Display Signup Details',
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 15,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
