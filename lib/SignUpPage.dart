import 'package:flutter/foundation.dart';
import 'LoginPage.dart';
import 'clickabletext.dart';
import 'package:coding_tracker/clickabletext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';
import 'HomerPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final border = const OutlineInputBorder(
    borderSide: BorderSide(
        color: Color.fromARGB(255, 0, 255, 8),
        width: 1.0,
        strokeAlign: BorderSide.strokeAlignOutside),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  );
  TextEditingController mailid = TextEditingController();
  TextEditingController passid = TextEditingController();
  TextEditingController cpassid = TextEditingController();
  void OnSubmit() async {
    String email = mailid.text.trim();
    String password = passid.text.trim();
    String cpassword = cpassid.text.trim();
    if (email == "" || password == "" || cpassword == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Enter all the details'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else if (password != cpassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
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
            content: Text('Account Created and Logged In Succesfully',
                style: TextStyle(color: Colors.black)),
            backgroundColor: Color.fromARGB(255, 0, 255, 8),
            duration: Duration(seconds: 2),
          ),
        );
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
                    'SignUp',
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
                            labelText: 'Enter mail address',
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
                            labelText: 'Set Password',
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
                          controller: cpassid,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
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
                          'Create Account',
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
        ));
  }
}
