// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:chatgpt_course/main.dart';
import 'package:chatgpt_course/myapp.dart';
import 'package:chatgpt_course/registration/login.dart';
import 'package:chatgpt_course/registration/signup.dart';
import 'package:chatgpt_course/screens%20copy/notes.dart';
import 'package:chatgpt_course/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  get context => Signup();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  get name => null;

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
      // String password = userDetails["password"];
      // String confirmPassword = userDetails["cpass"];

      // Display the signup details
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Your Profile'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Name: $name'),
                Text('Phone: $phone'),
                Text('Email: $email'),
                // Text('Password: $password'),
                // Text('Confirm Password: $confirmPassword'),
              ],
            ),
            actions: [
              ElevatedButton(
                child: Text('Close'),
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

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Clear user session or perform any required logout logic
    await prefs.clear();
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreen(
                key: Key('login screen'),
                title: '',
              )),
      (Route<dynamic> route) => false, // Clear the navigation stack
    );
  }

  final ScrollController _scrollController = ScrollController();
  bool textScanning = false;
  File? imageFile;
  String scannedText = '';
  String? userdata;

  void _copyText() {
    final String text = scannedText;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      const SnackBar(content: Text('Text copied')),
    );
  }

  void _refreshText() {
    setState(() {
      scannedText = '';
    });
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  get pickedImage => imageFile!.path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image to Text Recognition'),
          backgroundColor: Color.fromARGB(234, 26, 25, 27),
          actions: [
            Container(
              child: PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: 'Option 1',
                      child: TextButton(
                          onPressed: null,
                          child: Text(
                            'FeedBack',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          )),
                    ),
                    const PopupMenuItem(
                      value: 'Option 2',
                      child: TextButton(
                          onPressed: null,
                          child: Text(
                            'Share The App',
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                          )),
                    ),
                    const PopupMenuItem(
                      value: 'Option 3',
                      child: TextButton(
                          onPressed: null,
                          child: Text('Help',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)))),
                    ),
                  ];
                },
              ),
            )
          ],
        ),
        drawer: Drawer(
          backgroundColor: Color.fromARGB(255, 22, 21, 22),
          child: Column(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 148,
                        width: 140,
                        padding: EdgeInsets.all(3),
                        margin: EdgeInsets.only(top: 22, bottom: 18),
                        child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAHoAAAB6CAMAAABHh7fWAAAAYFBMVEVVYIDn7O3///9MWHvt8vJTXn9PW3ykq7lJVXnq7+9DUHWepbTz9PZfaYd7gppFUnaPlqnb3eOEjaBpco61ucWDiqC+wczQ09rn6OxueJHHytN0fZassr/g5efV29+Vna2U7++XAAAFvElEQVRogcWb67aqOgxGi6UVuQgsEBVv7/+Wp4C6Fdrkq9Zx8mePvQYySZqmSZuKlbfkdd9m1bYphJGi2VZZ29e5/3uEJ7XdFXIQrZQYRSk9/qHYtZ58D/ShM9jkyXwX8wWJwXeH8Oi826pS26Cvoku1bVHdMXRdSZ77oOuqDobujinIvdPTYxcE3arUOrqUmJ+0X6N7kXiDR3ii+q/Q9ekz8AQ/0mNOofNMe43xXLTOKG8n0Pvmc5Ufijf7T9Brf++ywNPMG50fy+/Bg5RHl9Ed6L38apRfRUuH0e3oVgYw9kNUYp/jVnSWhAMPktxQdBVomP9JWWHoKuXfpfS0Sg8rtwYGJ7Wwl2iWrGSSFqcqW5/b9rzOqlORJqxvWPReoDmyTJusj+I3ifqsSaWv3nP0jRxnlYjsGsebaCabOL5mzEJTzoPLDN2Svm2C8mXJfdAvTMifz7F39J4ky+Ya27mTxNeGtPostryhc9Jb5C5yaPzUPNpRbCVzJ/pIGUzuGPAIJ9n66EJnlIvpE0A2bPLzy7UdvSenlbpi6Cvp5unehs4b6kfJmfSwfxKvKVdVTW5B02tGccHIUXShXiOSbImuyVAsM1Bpo/aN9HJdL9AnMhyk2EgPsqF9Rp/m6J5eojWstFGbTnCSfoa2149P8tYHvSXZSryj6dgt9M0HfWPU7t7QtNJCrn3QGb1+PtSe/um4RdoLveaW7u4FfWSSDI+5xWst1PEfuuZyorBokdZPdMXl+4HRunqgIzapC4wWOr+jWzbvDo0uuzuaDgE/0Xo7oQ98Ch8aLcRhRHd8nRMcPVjcoHd8PRscrXcDOi/YB39g8CI36Bp4MDxa1gbNLFo/QptSRCBDjSeFI/oM1Of6z6ALfm7pnQfZsAFtVLESdLEzPQbm4A/ZXPlq3xRBAvAyr/RoVJuPj8bPRM+jvRKFEQ04muxFyz+VeKO5PGVAtwL4wA/Q/ISVmWDThB+hdSW2/Nz6CVptBVlf/hJ9FMDi8RM0Av4VGpL/Ee0fUoB5jYmufNHAjDVjDYy2KrxWD7N+AKuhAQOTy9fikL3N5AJCilBJ75Mq9MghlQkpyLAMuxCozTcXzMdMIEUSKWNy2NMuDTaxzPIBLJpi2GpDle6B44sR3SKpwiDo7hWSl03oHkmQxifBdPiKgccECUgLBwEtHqNHZENaiCTDg6SQj1/At43JMFQCiCEtBdDxGQ3eYwmAFD6DyD3AFuhZ6Fj4gH6GZONQtXVXpAaL3OlpfrTBOS3uRS462MYzGLWRouMuU2mPbGhMwixgMfyi54bGAX1elVRI28DRZJADunl1F32itMbN/dy8wi0uSrfJ45tHKvjcsstx7/hzo+nDk9l7cnh7FkH72LvCN6UDo182pVcnMP6FQb9uxa/Q1CIMOu1fj13AsB8E/X7ssuqwmREEPTtsAtUOgZ4fsXEHi3chMjSozhpkcbCIRVMiS4rBlGN5nLqqAbRqiOUDTMssh8hIu1VK5UjQrqz16JxpGBi+V7b0eg0sIPaGASacqrLZc1lKm7DnetY2iaGR0f2bsuhcLUAv7CjTpOau5hCiaSAR7QaqueJoLdxwd0vMKrceYyupsgveJXFZFw441Qi0ulrGSuuK7nqC4VT7kyWWa7nd84O8gGdiqQTd9GVc7W1yqqTpvcF3uJzBF320iwa/1x6opGg/Ao/w6B2eLho6l22Nt8cUS8QZc2snfK2e44e0NT7aC6XOuM42Hv50OKyZc7S5kp5u7YYPDre0tgNtfK34zLus8D+ZWDu17e3KfRCVJ9nEZ492ZSPByEYcCGdXfCB7G61dBHdDfh6G7L6IQN2ACKC4U2UG/b3i5E0j5rbLV4pTKvPob1ydu1zFXy/60Or8rS7kUlXubfYNcp0MvMXml6Zg74Tv7qGqQwr7oUc6h4997iz6XZY0eHep6XtV0xc98fM8flhgs4nNfz95y3/5olpPgi07CgAAAABJRU5ErkJggg==')),
                      ),
                      Positioned(
                          height: 30,
                          top: 130,
                          left: 90,
                          child: FloatingActionButton(
                            backgroundColor: Color.fromARGB(198, 255, 255, 255),
                            onPressed: () {},
                            child: Icon(
                              Icons.add,
                              size: 18,
                            ),
                          ))
                    ],
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent)),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 25),
                          alignment: Alignment.centerLeft,
                          height: 50,
                          child: Text(
                            'HELLO ',
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.transparent,
                    )),
                    onPressed: () {
                      displaySignupDetails();
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Icon(
                            Icons.person,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Text(
                            'Profile',
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent)),
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChatScreen()));
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Icon(
                            Icons.chat,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Text(
                            'Minnie-AI',
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent)),
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Notesapp(
                                      key: Key(''),
                                    )));
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Icon(
                            Icons.note_add,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Text(
                            'Notes',
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent)),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Icon(
                            Icons.picture_as_pdf,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Text(
                            'Pdf Maker',
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent)),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Icon(
                            Icons.history_edu_outlined,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Text(
                            'History',
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent)),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Icon(
                            Icons.dashboard,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Text(
                            'Dashboard',
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent)),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Icon(
                            Icons.settings,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Text(
                            'Settings',
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent)),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Icon(
                            Icons.help_center,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Text(
                            'Help & Support',
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent)),
                    onPressed: () {},
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Icon(
                            Icons.account_box,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: MediaQuery.sizeOf(context).height / 14.9,
                          child: Text(
                            'Admin Portfolio',
                            style: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: MediaQuery.sizeOf(context).height / 14.9,
                      width: MediaQuery.sizeOf(context).width,
                      color: Color.fromARGB(255, 29, 29, 31),
                      child: Container(
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromARGB(0, 4, 2, 117))),
                          onPressed: logout, // Call the logout function
                          child: Text('LogOut'),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                // if (textScanning) const CircularProgressIndicator(),
                if (textScanning)
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.sizeOf(context).width,
                    // Set the desired background color
                    child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 255, 255, 255))),
                  ),
                if (!textScanning && imageFile == null)
                  if (imageFile != null) Image.file(File(imageFile!.path)),
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.sizeOf(context).height / 7,
                          width: MediaQuery.sizeOf(context).width,
                          color: Color.fromARGB(255, 21, 21, 21),
                          padding: const EdgeInsets.all(25),
                          child: Center(
                              child: const Text(
                            'Pick -> Scan -> Find....!',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        Container(
                          height: MediaQuery.sizeOf(context).height / 5,
                          width: MediaQuery.sizeOf(context).width,
                          color: Color.fromARGB(255, 21, 21, 21),
                          padding: EdgeInsets.all(30),
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    'THE NEW',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Container(
                                    child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.transparent)),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ChatScreen()));
                                    });
                                  },
                                  child: Lottie.network(
                                    'https://lottie.host/de3aaf0c-2811-4f40-a3f9-48c823065098/RusFq5sBAH.json',
                                  ),
                                )),
                                Container(
                                  child: Text(
                                    'MINNIE-AI',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              color: Color.fromARGB(255, 21, 21, 21),
                              height: MediaQuery.of(context).size.height / 4,
                              width: MediaQuery.of(context).size.width / 2,
                              padding: const EdgeInsets.all(25),
                              child: FloatingActionButton(
                                backgroundColor:
                                    Color.fromARGB(117, 30, 30, 33),
                                onPressed: () {
                                  getImage(ImageSource.camera);
                                },
                                child: const Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 45,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              color: Color.fromARGB(255, 21, 21, 21),
                              height: MediaQuery.of(context).size.height / 4,
                              width: MediaQuery.of(context).size.width / 2,
                              padding: const EdgeInsets.all(25),
                              child: FloatingActionButton(
                                  backgroundColor:
                                      Color.fromARGB(117, 30, 30, 33),
                                  onPressed: () {
                                    getImage(ImageSource.gallery);
                                  },
                                  child: const Icon(
                                    Icons.image_outlined,
                                    size: 45,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              color: Color.fromARGB(255, 21, 21, 21),
                              height: MediaQuery.of(context).size.height / 8,
                              width: MediaQuery.of(context).size.width / 5,
                            ),
                            Container(
                              color: Color.fromARGB(255, 21, 21, 21),
                              height: MediaQuery.of(context).size.height / 8,
                              width: MediaQuery.of(context).size.width / 5,
                              padding: const EdgeInsets.all(10),
                              child: FloatingActionButton(
                                  backgroundColor:
                                      Color.fromARGB(117, 30, 30, 33),
                                  onPressed: () {},
                                  child: const Icon(
                                    Icons.crop,
                                    size: 25,
                                    color: Colors.white,
                                  )),
                            ),
                            Container(
                              color: Color.fromARGB(255, 21, 21, 21),
                              height: MediaQuery.of(context).size.height / 8,
                              width: MediaQuery.of(context).size.width / 5,
                              padding: const EdgeInsets.all(10),
                              child: FloatingActionButton(
                                  backgroundColor:
                                      Color.fromARGB(117, 30, 30, 33),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Notesapp(
                                                    key: Key(''),
                                                  )));
                                    });
                                  },
                                  child: Icon(
                                    Icons.note,
                                    size: 25,
                                    color: Colors.white,
                                  )),
                            ),
                            Container(
                              color: Color.fromARGB(255, 21, 21, 21),
                              height: MediaQuery.of(context).size.height / 8,
                              width: MediaQuery.of(context).size.width / 5,
                              padding: const EdgeInsets.all(10),
                              child: FloatingActionButton(
                                  backgroundColor:
                                      Color.fromARGB(117, 30, 30, 33),
                                  onPressed: () {},
                                  child: const Icon(
                                    Icons.mic,
                                    size: 25,
                                    color: Colors.white,
                                  )),
                            ),
                            Container(
                              color: Color.fromARGB(255, 21, 21, 21),
                              height: MediaQuery.of(context).size.height / 8,
                              width: MediaQuery.of(context).size.width / 5,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              color: Color.fromARGB(255, 21, 21, 21),
                              height: MediaQuery.of(context).size.height / 8,
                              width: MediaQuery.of(context).size.width / 5,
                            ),
                            Container(
                              color: Color.fromARGB(255, 21, 21, 21),
                              height: MediaQuery.of(context).size.height / 8,
                              width: MediaQuery.of(context).size.width / 5,
                              padding: const EdgeInsets.all(10),
                            ),
                            Container(
                              color: Color.fromARGB(255, 21, 21, 21),
                              height: MediaQuery.of(context).size.height / 8,
                              width: MediaQuery.of(context).size.width / 5,
                              padding: const EdgeInsets.all(10),
                              child: FloatingActionButton(
                                  backgroundColor:
                                      Color.fromARGB(117, 30, 30, 33),
                                  onPressed: () {},
                                  child: const Icon(
                                    Icons.history,
                                    size: 25,
                                    color: Colors.white,
                                  )),
                            ),
                            Container(
                              color: Color.fromARGB(255, 21, 21, 21),
                              height: MediaQuery.of(context).size.height / 8,
                              width: MediaQuery.of(context).size.width / 5,
                              padding: const EdgeInsets.all(10),
                            ),
                            Container(
                              color: Color.fromARGB(255, 21, 21, 21),
                              height: MediaQuery.of(context).size.height / 8,
                              width: MediaQuery.of(context).size.width / 5,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(17),
                                  color: Color.fromARGB(255, 21, 21, 21),
                                  width: MediaQuery.sizeOf(context).width / 1,
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  if (scannedText.isNotEmpty)
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(17),
                                            color:
                                                Color.fromARGB(255, 21, 21, 21),
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            child: const Text(
                                              "Result",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: Colors.white,
                                            child: SelectableText(
                                              scannedText.toString(),
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            color: Color.fromARGB(255, 21, 21, 21),
            shape: const CircularNotchedRectangle(),
            child: Container(
              height: 58,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.copy,
                        color: Colors.white,
                      ),
                      onPressed: _copyText,
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.notes, color: Colors.white),
                    //   onPressed: () {
                    //     setState(() {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => Notesapp(
                    //                     key: Key(''),
                    //                   )));
                    //     });
                    //   },
                    // ),
                    const IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      onPressed: null,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onPressed: _refreshText,
                    ),
                  ]),
            )));
  }

  void getImage(ImageSource source) async {
    print(source);
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      print(pickedImage);
      if (pickedImage != null) {
        print("pickedImage");
        setState(() {
          textScanning = true;
          imageFile = File(pickedImage.path);
          getRecognisedText(imageFile!);
        });
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      setState(() {
        scannedText = "Error while scanning";
      });
    }
  }

  void getRecognisedText(File image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();

    RecognizedText recognizedText = await textDetector.processImage(inputImage);

    await textDetector.close();
    scannedText = '';
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + '\n';
      }
    }
    textScanning = false;
    setState(() {});
  }
}
