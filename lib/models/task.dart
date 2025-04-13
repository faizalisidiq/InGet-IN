import 'package:flutter/cupertino.dart';

class Task {
  final int status, id;
  final String content;

  Task({
    required this.id,
    required this.status,
    required this.content,
  });
}