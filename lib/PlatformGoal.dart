import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_tracker/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:coding_tracker/clickabletext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'clickabletext.dart';
import 'SignUpPage.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'SubmissionProvider.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'main.dart';

class PlatformGoal extends StatefulWidget {
  final String platformName;
  const PlatformGoal({
    Key? key,
    required this.platformName,
  }) : super(key: key);

  @override
  _PlatformGoalState createState() => _PlatformGoalState();
}

class _PlatformGoalState extends State<PlatformGoal> {
  TextEditingController _yg = TextEditingController();
  Future<void> fetchData() async {
    Map<String, dynamic> mp;
    User? user = FirebaseAuth.instance.currentUser;
    String email = '';
    if (user != null) {
      for (UserInfo userInfo in user.providerData) {
        if (userInfo.providerId == 'password') {
          email = FirebaseAuth.instance.currentUser!.email ?? '';
        } else if (userInfo.providerId == 'phone') {
          email = FirebaseAuth.instance.currentUser!.phoneNumber ?? '';
        }
      }
    }
    mp = {'yg': int.parse(_yg.text.trim())};
    await FirebaseFirestore.instance
        .collection('Data')
        .doc(email)
        .set(mp, SetOptions(merge: true));
  }

  late bool _isExpanded;
  //late Map<String, dynamic> mp;

  final border = const OutlineInputBorder(
    borderSide: BorderSide(
        color: Color.fromARGB(255, 0, 255, 8),
        width: 1.0,
        strokeAlign: BorderSide.strokeAlignOutside),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  );

  @override
  void initState() {
    super.initState();
    _isExpanded = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[300], // Adjust the color as needed
        borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
      ),
      child: Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          tilePadding: const EdgeInsets.all(20.0),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/goal.png',
              width: 40,
              height: 40,
            ),
          ),
          textColor: Colors.white,
          backgroundColor: Colors.black,
          collapsedBackgroundColor: Colors.black,
          title: Text(
            widget.platformName,
            style: const TextStyle(color: Color.fromARGB(255, 0, 255, 8)),
          ),
          onExpansionChanged: (value) {
            setState(() {
              _isExpanded = value;
            });
          },
          initiallyExpanded: false,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _yg,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    // onChanged: (value) {
                    //   _yg = value a;
                    // },
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.grey),
                      border: border,
                      focusedBorder: border,
                      enabledBorder: border,
                      labelText: 'Enter Goal',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 35, 35, 35)),
                        elevation: MaterialStatePropertyAll(2)),
                    onPressed: () {
                      fetchData();
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 0, 255, 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
