import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_tracker/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
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
import 'HomePage.dart';
import 'POTD.dart';

class HomerPage extends StatefulWidget {
  const HomerPage({super.key});

  @override
  State<HomerPage> createState() => _HomerPageState();
}

class _HomerPageState extends State<HomerPage> {
  List<Widget> pages = const [HomePage(), POTD()];
  int currentpage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentpage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10.0,
        backgroundColor: Color.fromARGB(255, 33, 32, 32),
        iconSize: 30,
        //selectedIconTheme: IconThemeData(color: Color.fromARGB(255, 0, 255, 8)),
        selectedFontSize: 0,
        unselectedFontSize: 0,
        onTap: (value) {
          setState(() {
            currentpage = value;
          });
        },
        currentIndex: currentpage,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Color.fromARGB(255, 0, 255, 8),
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.code, color: Color.fromARGB(255, 0, 255, 8)),
              label: ''),
        ],
      ),
    );
  }
}
