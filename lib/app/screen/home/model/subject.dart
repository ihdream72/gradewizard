import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../controllers/home_controller.dart';

enum SubjectType { korean, english, mathematics, history, science, social }

class Subject {

  SubjectType? type;
  //String get name => HomeController.subjectName[type]!;
  int? unit;
  double? score;
  int? grade;

  Subject(
      {this.type, this.unit, this.score, this.grade});

  Subject.fromString(String str) {
    Map<String, dynamic> json = jsonDecode(str);

    if(json['type'] != null) {
      type = SubjectType.values.byName(json['type']!);
    } else {
      type = null;
    }

    unit = json['unit'];
    score = json['score'];
    grade = json['grade'];
  }

  Subject.fromJson(Map<String, dynamic> json) {

    if(json['type'] != null) {
      type = SubjectType.values.byName(json['type']!);
    } else {
      type = null;
    }

    unit = json['unit'];
    score = json['score'];
    grade = json['grade'];
  }

  @override
  String toString() {
    Map<String, dynamic> json = toJson();

    return jsonEncode(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(type != null) {
      data['type'] = describeEnum(type!);
    } else {
      data['type'] = null;
    }

    data['unit'] = unit;
    data['score'] = score;
    data['grade'] = grade;

    return data;
  }


}