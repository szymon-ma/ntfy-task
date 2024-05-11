import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/injectable.dart';
import 'package:flutter_recruitment_task/movie_app.dart';

void main() {
  configureDependencies();
  runApp(const MovieApp());
}
