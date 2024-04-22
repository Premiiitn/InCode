import 'package:coding_tracker/LoginWithPhone.dart';
import 'package:coding_tracker/VerifyOTPScreen.dart';
import 'package:coding_tracker/clickabletext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'clickabletext.dart';
import 'SignUpPage.dart';
import 'HomePage.dart';
import 'HomerPage.dart';
import 'VerifyOTPScreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isClicked = false;

  TextEditingController mailid = TextEditingController();
  TextEditingController passid = TextEditingController();
  void _toggleUnderline() {
    setState(() {
      isClicked = !isClicked;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return SignUpPage();
        },
      ),
    );
  }

  void OnSubmit() async {
    String email = mailid.text.trim();
    String password = passid.text.trim();
    if (email == "" || password == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Enter all the details'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return const HomerPage();
              },
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logged In Succesfully',
                  style: TextStyle(color: Colors.black)),
              backgroundColor: Color.fromARGB(255, 0, 255, 8),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } on FirebaseAuthException catch (ex) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ex.code.toString()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  bool _obstxt = false;
  final border = const OutlineInputBorder(
    borderSide: BorderSide(
        color: Color.fromARGB(255, 0, 255, 8),
        width: 1.0,
        strokeAlign: BorderSide.strokeAlignOutside),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 32, 32),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 40,
                      color: Color.fromARGB(255, 0, 255, 8),
                      fontWeight: FontWeight.bold),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: TextField(
                        controller: mailid,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          labelText: 'Enter mail address ',
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          focusedBorder: border,
                          border: border,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: TextField(
                        obscureText: _obstxt,
                        controller: passid,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obstxt = !_obstxt;
                                });
                              },
                              icon: _obstxt
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility)),
                          labelText: 'Enter Password',
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          focusedBorder: border,
                          border: border,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: OnSubmit,
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black),
                          elevation: MaterialStatePropertyAll(2)),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 255, 8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    OnHover(
                      builder: (isHovered) {
                        return GestureDetector(
                          onTap: _toggleUnderline,
                          child: Text(
                            'New User?Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 0, 255, 8),
                              decoration: (isHovered || isClicked)
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                              decorationThickness: 2.0,
                              decorationColor: Color.fromARGB(255, 0, 255, 8),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'or',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 255, 8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return const LoginWithPhone();
                            },
                          ),
                        );
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black),
                          elevation: MaterialStatePropertyAll(2)),
                      child: const Text(
                        'Login with Phone Number',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 255, 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
