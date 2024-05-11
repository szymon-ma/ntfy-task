import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/app_router.dart';
import 'package:flutter_recruitment_task/injectable.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Movie Browser',
        theme: ThemeData(primarySwatch: Colors.amber),
        routerConfig: getIt<AppRouter>().config(),
      );
}
