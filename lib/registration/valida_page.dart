import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValidPage extends StatefulWidget {
  const ValidPage({Key? key}) : super(key: key);

  @override
  _ValidPageState createState() => _ValidPageState();
}

class _ValidPageState extends State<ValidPage> {
  String? userdata;

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userdata = prefs.getString("listUsers");
      print("getting data $userdata");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome RUDRARAPU VEERABHADRAM"),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black,
            child: TextButton(
              onPressed: () {
                getUser();
              },
              child: Text("Run"),
            ),
          ),
          Container(
            child: Text(userdata ?? ""),
          )
        ],
      ),
    );
  }
}
