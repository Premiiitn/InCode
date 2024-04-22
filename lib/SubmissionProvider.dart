import 'package:flutter/material.dart';

class SubmissionProvider with ChangeNotifier {
  final List<Map<String, dynamic>> sub = [];
  void addSubmissionValue(Map<String, dynamic> value) {
    sub.add(value);
    notifyListeners();
  }
}
