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
import 'LoginWithPhone.dart';
import 'PlatformTile.dart';
import 'PlatformGoal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class CircledIndicatorPainter extends CustomPainter {
  final strokeCircle = 21.0;
  double currentProgress;
  int ygoal;
  final double animationValue;
  CircledIndicatorPainter({
    required this.currentProgress,
    required this.ygoal,
    required this.animationValue,
  });

  @override
//   void paint(Canvas canvas, Size size) {
//     double scale = Curves.easeInOut.transform(animationValue);
//     Paint circle = Paint()
//       ..strokeWidth = strokeCircle
//       ..color = Colors.grey.withOpacity(0.5 * animationValue)
//       ..style = PaintingStyle.stroke;
//     // Offset center = Offset(size.width / 2, size.height / 2);
//     // double radius = 100;
//     Offset center = size.center(Offset.zero);
//     double radius = (size.shortestSide / 2 - strokeCircle / 2) * scale;
//     canvas.drawCircle(center, radius, circle);
//     List<Color> arcColors = [
//       Color.fromARGB(255, 255, 0, 0),
//       const Color.fromARGB(255, 0, 140, 255),
//       Color.fromARGB(255, 0, 255, 8),
//     ];

//     double startAngle = pi / 2;
//     for (int i = 0; i < arcColors.length; i++) {
//       Paint animationArc = Paint()
//         ..strokeWidth = 20
//         ..color = arcColors[i]
//         ..style = PaintingStyle.stroke
//         ..strokeCap = StrokeCap.round;
//       double sweepAngle = (2 * pi * (currentProgress / (ygoal * 1.0))) / 3;
//       // Create a gradient for the current arc
//       Gradient gradient = SweepGradient(
//         startAngle: startAngle,
//         endAngle: startAngle + sweepAngle,
//         colors: [arcColors[i], Colors.orange],
//       );
//       // Set the shader to the gradient
//       animationArc.shader = gradient.createShader(
//         Rect.fromCircle(center: center, radius: radius),
//       );
//       canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
//           startAngle, sweepAngle, false, animationArc);
//       startAngle += sweepAngle;
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
  void paint(Canvas canvas, Size size) {
    double scale = Curves.easeInOut.transform(animationValue);
    // double strokeCircle = 21.0;
    // double currentProgress = 0.5; // Replace with your actual progress value
    // int ygoal = 100; // Replace with your actual goal value

    Paint circle = Paint()
      ..strokeWidth = strokeCircle
      ..color = Colors.grey.withOpacity(0.5 * animationValue)
      ..style = PaintingStyle.stroke;

    Offset center = size.center(Offset.zero);
    double radius = (size.shortestSide / 2 - strokeCircle / 2) * scale;
    canvas.drawCircle(center, radius, circle);

    List<Color> arcColors = [
      Color.fromARGB(255, 255, 0, 0),
      const Color.fromARGB(255, 0, 140, 255),
      Color.fromARGB(255, 0, 255, 8),
    ];

    double startAngle = pi / 2;
    for (int i = 0; i < arcColors.length; i++) {
      Paint animationArc = Paint()
        ..strokeWidth = 20
        ..color = arcColors[i]
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      double sweepAngle = (2 * pi * (currentProgress / (ygoal * 1.0))) / 3;
      Gradient gradient = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: [arcColors[i], Colors.orange],
      );
      animationArc.shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      );
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        animationArc,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000), // Adjust duration as needed
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubicEmphasized,
    ));
    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startExitAnimation() {
    _controller.reverse();
  }

  final border = const OutlineInputBorder(
    borderSide: BorderSide(
        color: Color.fromARGB(255, 0, 255, 8),
        width: 1.0,
        strokeAlign: BorderSide.strokeAlignOutside),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  );
  void logout() async {
    _startExitAnimation();
    Future.delayed(Duration(seconds: 2), () async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return const LoginPage();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged Out Succesfully',
              style: TextStyle(color: Colors.black)),
          backgroundColor: Color.fromARGB(255, 0, 255, 8),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    late Map<String, dynamic> mp;
    int value = 1;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (UserInfo userInfo in user.providerData) {
        if (userInfo.providerId == 'password') {
          value = 1;
        } else if (userInfo.providerId == 'phone') {
          value = 2;
        }
      }
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 32, 32),
      appBar: AppBar(
        title: const Text(
          'Add Platforms',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 255, 8),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 33, 32, 32),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(
              Icons.exit_to_app,
              color: Color.fromARGB(255, 0, 255, 8),
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 250,
              child: Row(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                      stream: (value == 1)
                          ? FirebaseFirestore.instance
                              .collection('Data')
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection('Data')
                              .doc(FirebaseAuth
                                  .instance.currentUser!.phoneNumber)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic>? data =
                              snapshot.data!.data() as Map<String, dynamic>?;
                          // int f = 0;
                          // int Yourgoal = 0;
                          // if (data != null) {
                          //   data.forEach((key, value) {
                          //     if (key == 'yg') {
                          //       Yourgoal = value as int;
                          //     } else if (key == 'cc' ||
                          //         key == 'cf' ||
                          //         key == 'gfg') {
                          //       f += value as int;
                          //     }
                          //   });
                          // }
                          IconData ikon = Icons.block;
                          Color col = const Color.fromARGB(255, 7, 122, 11);
                          String chk = '';
                          int nos = 0;
                          int sc = 0;
                          if (data != null) {
                            if (data['ovs'] != null) {
                              sc = data!['ovs'];
                            } else {
                              sc = -1;
                            }
                            if (data['rank'] != null) {
                              chk = data!['rank'].trim();
                            } else {
                              chk = 'N/A';
                            }
                            if (data['stars'] != null) {
                              nos = data!['stars'];
                            } else {
                              nos = -1;
                            }
                          }
                          if (chk == 'Newbie') {
                            ikon = Icons.emoji_emotions;
                            col = Colors.pink;
                          } else if (chk == 'Pupil') {
                            ikon = Icons.boy;
                            col = const Color.fromARGB(255, 7, 122, 11);
                          } else if (chk == 'Specialist') {
                            ikon = Icons.colorize;
                            col = Color.fromARGB(255, 6, 209, 152);
                          } else if (chk == 'Expert') {
                            ikon = Icons.computer;
                            col = Color.fromARGB(255, 0, 3, 203);
                          } else {
                            ikon = Icons.add_moderator;
                            col = const Color.fromARGB(255, 255, 17, 0);
                          }
                          Color colo = Colors.white;
                          if (sc < 100) {
                            colo = Colors.pink;
                          } else if (sc >= 100 && sc < 1000) {
                            colo = Color.fromARGB(255, 0, 196, 36);
                          } else if (sc >= 1000 && sc < 10000) {
                            colo = Color.fromARGB(255, 0, 15, 185);
                          } else {
                            colo = const Color.fromARGB(255, 255, 17, 0);
                          }
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: (chk.length * 6.2 < 110)
                                              ? 110
                                              : chk.length * 6.2,
                                          child: Expanded(
                                            child: Text(
                                              chk,
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: col,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.2,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Icon(ikon, color: col),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          (nos == -1) ? 'N/A' : '$nos',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.8,
                                              color: Colors.white),
                                        ),
                                        const Icon(Icons.star,
                                            color: Color.fromARGB(
                                                255, 255, 230, 0)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          (sc == -1)
                                              ? 'Score: N/A'
                                              : 'Score: $sc',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: colo,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'N/A',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                Text(
                                  'N/A',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                Text(
                                  'N/A',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                    child: Center(
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: (value == 1)
                            ? FirebaseFirestore.instance
                                .collection('Data')
                                .doc(FirebaseAuth.instance.currentUser!.email)
                                .snapshots()
                            : FirebaseFirestore.instance
                                .collection('Data')
                                .doc(FirebaseAuth
                                    .instance.currentUser!.phoneNumber)
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Map<String, dynamic>? data =
                                snapshot.data!.data() as Map<String, dynamic>?;
                            int f = 0;
                            int Yourgoal = 0;
                            if (data != null) {
                              data.forEach((key, value) {
                                if (key == 'yg') {
                                  Yourgoal = value as int;
                                } else if (key == 'cc' ||
                                    key == 'cf' ||
                                    key == 'gfg') {
                                  f += value as int;
                                }
                              });
                            }

                            return Center(
                              child: AnimatedBuilder(
                                animation: _animation,
                                builder: (context, child) {
                                  return CustomPaint(
                                    foregroundPainter: CircledIndicatorPainter(
                                      currentProgress: f / 1.0,
                                      ygoal: Yourgoal,
                                      animationValue: _animation.value,
                                    ),
                                    child: SizedBox(
                                      width: 200,
                                      height: 200,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Total Solved:',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              '$f',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return const Text('0',
                                style: TextStyle(color: Colors.white));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const PlatformGoal(
              platformName: 'Your Goal',
            ),
            const PlatformTile(
                platformName: 'Codeforces',
                img: 'assets/images/cflogo.png',
                number: 1),
            const PlatformTile(
                platformName: 'Codechef',
                img: 'assets/images/cclogo.jpeg',
                number: 2),
            const PlatformTile(
                platformName: 'GeeksforGeeks',
                img: 'assets/images/gfglogo.png',
                number: 3),
          ],
        ),
      ),
    );
  }
}
