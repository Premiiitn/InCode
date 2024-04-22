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

class PlatformTile extends StatefulWidget {
  final String platformName;
  final String img;
  final int number;
  const PlatformTile(
      {Key? key,
      required this.platformName,
      required this.img,
      required this.number})
      : super(key: key);

  @override
  _PlatformTileState createState() => _PlatformTileState();
}

class _PlatformTileState extends State<PlatformTile>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  //late Map<String, dynamic> mp;
  String _username = '';
  int cf = 0;
  int cc = 0;
  int gfg = 0;
  String rank = '';
  int ovscore = 0;
  int numberOfStars = 0;
  Future<void> _fetchData(String username, int value) async {
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
    if (value == 1) {
      final response =
          await http.get(Uri.parse('https://codeforces.com/profile/$username'));
      if (response.statusCode == 200) {
        final document = parse(response.body);
        final rankElements = document.querySelectorAll('.user-rank');
        final solvedCountElements =
            document.querySelectorAll('._UserActivityFrame_counterValue');
        if (rankElements.isNotEmpty) {
          rank = rankElements.first.text;
        }

        for (var element in solvedCountElements) {
          final text = element.text;
          if (text.contains('problems')) {
            cf = int.parse(text.split(' ')[0]);
            break;
          }
        }

        mp = {'cf': cf, 'rank': rank};
        await FirebaseFirestore.instance
            .collection('Data')
            .doc(email)
            .set(mp, SetOptions(merge: true));
      }
    } else if (value == 2) {
      final response =
          await http.get(Uri.parse('https://www.codechef.com/users/$username'));
      if (response.statusCode == 200) {
        final document = parse(response.body);
        final solvedElement =
            document.querySelectorAll('.rating-data-section.problems-solved');
        final starsElement = document.querySelector('.rating');
        int solvedCountMatch = 0;
        int numberOfStars = 0;
        if (solvedElement.isNotEmpty) {
          for (var texty in solvedElement) {
            final solvedText = texty.text.split(':');
            //print(solvedText);
            for (var x in solvedText) {
              if (x.contains('Practice Problems') || x.contains('Contests')) {
                solvedCountMatch += int.parse(RegExp(r'\((\d+)\)')
                    .firstMatch(x)!
                    .group(0)!
                    .substring(
                        1,
                        RegExp(r'\((\d+)\)').firstMatch(x)!.group(0)!.length -
                            1));
              }
            }
          }
        }
        if (starsElement != null) {
          final element = starsElement.text.split(' ');
          for (var x in element) {
            var starMatch = RegExp(r'(\d+)\s?★').firstMatch(x);
            if (starMatch != null) {
              final starCount = int.parse(starMatch.group(1)!);
              numberOfStars = starCount;
              break;
            }
          }
        }
        cc = solvedCountMatch;

        mp = {'cc': cc, 'stars': numberOfStars};
        await FirebaseFirestore.instance
            .collection('Data')
            .doc(email)
            .set(mp, SetOptions(merge: true));
      }
    } else if (value == 3) {
      final response = await http.get(Uri.parse(
          'https://www.geeksforgeeks.org/user/$username/?utm_source=geeksforgeeks&utm_medium=my_profile&utm_campaign=auth_user'));
      if (response.statusCode == 200) {
        final document = parse(response.body);
        final solvedElement = document.querySelector('.scoreCards_head__G_uNQ');
        if (solvedElement != null) {
          int count = 0;
          int ovscor = (int.tryParse(
                  RegExp(r'(\d+)').firstMatch(solvedElement.text)!.group(0)!) ??
              0);
          final solved = solvedElement.text.split(' ');
          for (var txt in solved) {
            if (txt.contains('Solved')) {
              count =
                  (int.tryParse(RegExp(r'(\d+)').firstMatch(txt)!.group(0)!) ??
                      0);
              break;
            }
          }
          gfg = count;
          ovscore = ovscor;
          mp = {'gfg': gfg, 'ovs': ovscore};
          await FirebaseFirestore.instance
              .collection('Data')
              .doc(email)
              .set(mp, SetOptions(merge: true));
        }
      }
    } else {}
  }

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
              widget.img,
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
          initiallyExpanded: _isExpanded,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    onChanged: (value) {
                      _username = value;
                    },
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: border,
                      focusedBorder: border,
                      enabledBorder: border,
                      labelText: 'Enter Username',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 35, 35, 35)),
                        elevation: MaterialStatePropertyAll(2)),
                    onPressed: () {
                      _fetchData(_username, widget.number);
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
