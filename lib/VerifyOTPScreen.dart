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
import 'HomerPage.dart';

class VerifyOTP extends StatefulWidget {
  final String verificationId;
  const VerifyOTP({super.key, required this.verificationId});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final border = const OutlineInputBorder(
    borderSide: BorderSide(
        color: Color.fromARGB(255, 0, 255, 8),
        width: 1.0,
        strokeAlign: BorderSide.strokeAlignOutside),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  );
  TextEditingController otpid = TextEditingController();
  void OTPVerification() async {
    String otp = otpid.text.trim();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
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
                  'OTP Verification',
                  style: TextStyle(
                      fontSize: 30,
                      color: Color.fromARGB(255, 0, 255, 8),
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    maxLength: 6,
                    controller: otpid,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      counterText: "",
                      labelText: 'Enter 6-Digit-OTP',
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
                  onPressed: OTPVerification,
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black),
                      elevation: MaterialStatePropertyAll(2)),
                  child: const Text(
                    'Verify OTP',
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
