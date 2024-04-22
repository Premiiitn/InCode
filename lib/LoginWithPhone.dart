import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'LoginPage.dart';
import 'clickabletext.dart';
import 'package:coding_tracker/clickabletext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';
import 'SignUpPage.dart';
import 'VerifyOTPScreen.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  TextEditingController phid = TextEditingController();
  void SignInPhone() async {
    String phone = "+91" + phid.text.trim();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      codeSent: (verificationId, resendToken) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return VerifyOTP(
              verificationId: verificationId,
            );
          }),
        );
      },
      verificationCompleted: (credential) {},
      verificationFailed: (ex) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ex.code.toString()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: const Duration(seconds: 30),
    );
  }

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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    controller: phid,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      prefixText: '+91 ',
                      prefixStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      labelText: 'Enter Phone Number',
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
                  onPressed: SignInPhone,
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black),
                      elevation: MaterialStatePropertyAll(2)),
                  child: const Text(
                    'Login with OTP',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 0, 255, 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
