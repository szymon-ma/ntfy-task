import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/pages/movie_details/movie_details_page.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_list_page.dart';
import 'package:flutter_recruitment_task/pages/two_buttons/two_buttons_page.dart';
import 'package:injectable/injectable.dart';

part 'app_router.gr.dart';

@injectable
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: MovieListRoute.page, initial: true),
        AutoRoute(page: MovieDetailsRoute.page),
        AutoRoute(page: TwoButtonsRoute.page),
      ];
}
