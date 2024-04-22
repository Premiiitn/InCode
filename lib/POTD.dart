import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_tracker/LoginPage.dart';
import 'package:coding_tracker/Tile.dart';
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
import 'LoginWithPhone.dart';
import 'PlatformTile.dart';
import 'PlatformGoal.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class POTD extends StatefulWidget {
  const POTD({super.key});

  @override
  State<POTD> createState() => _POTDState();
}

class _POTDState extends State<POTD> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 33, 32, 32),
        appBar: AppBar(
          title: const Text(
            'Problem of The Day',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 255, 8),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 33, 32, 32),
        ),
        body: Column(
          children: [
            const Tile(
                platformname: 'GeeksforGeeks',
                imgurl: 'assets/images/gfglogo.png',
                site: 'https://www.geeksforgeeks.org/problem-of-the-day'),
            const Tile(
                platformname: 'LeetCode',
                imgurl: 'assets/images/lclogo.png',
                site: 'https://leetcode.com/problemset/'),
            const Tile(
                platformname: 'HackerEarth',
                imgurl: 'assets/images/HackerEarth_logo.png',
                site: 'https://www.hackerearth.com/practice/'),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                launcher.launchUrl(
                    Uri.parse('https://leetcode.com/playground/new/empty'));
              },
              child: const Text(
                'Click here for LeetCode Compiler',
                style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                    decorationColor: Color.fromARGB(255, 0, 255, 8),
                    color: Color.fromARGB(255, 0, 255, 8)),
              ),
            )
          ],
        ));
  }
}
