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

class Tile extends StatefulWidget {
  final String platformname;
  final String imgurl;
  final String site;
  const Tile(
      {super.key,
      required this.platformname,
      required this.imgurl,
      required this.site});

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  List<Color> val = [
    Color.fromARGB(255, 255, 17, 0),
    Color.fromARGB(255, 0, 81, 255),
    Color.fromARGB(255, 255, 106, 0),
  ];
  // List<Color> val = [
  //   Colors.black,
  //   Color.fromARGB(255, 0, 255, 8),
  //   Colors.black,
  // ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: val),
          color: Colors.black, // Adjust the color as needed
          borderRadius:
              BorderRadius.circular(20), // Adjust the radius as needed
        ),
        child: Center(
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              widget.platformname,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: const Icon(
              Icons.arrow_circle_right,
              color: Colors.white,
              size: 25,
            ),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                widget.imgurl,
                width: 40,
                height: 40,
              ),
            ),
            onTap: () {
              launcher.launchUrl(Uri.parse(widget.site));
            },
          ),
        ),
      ),
    );
  }
}
