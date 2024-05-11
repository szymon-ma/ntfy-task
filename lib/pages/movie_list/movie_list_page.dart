import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recruitment_task/app_router.dart';
import 'package:flutter_recruitment_task/injectable.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_card.dart';
import 'package:flutter_recruitment_task/pages/movie_list/movie_list_cubit.dart';
import 'package:flutter_recruitment_task/pages/movie_list/search_box.dart';

@RoutePage()
class MovieListPage extends StatelessWidget {
  const MovieListPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => getIt<MovieListCubit>(),
        child: const MovieListContent(),
      );
}

class MovieListContent extends StatelessWidget {
  const MovieListContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.movie_creation_outlined),
            onPressed: () {
              //TODO implement navigation
            },
          ),
        ],
        title: const Text('Movie Browser'),
      ),
      body: Column(
        children: <Widget>[
          SearchBox(onSubmitted: context.read<MovieListCubit>().searchMovies),
          const Expanded(child: MovieListLoader()),
        ],
      ),
    );
  }
}

class MovieListLoader extends StatelessWidget {
  const MovieListLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieListCubit, MovieListState>(
      builder: (context, state) {
        return switch (state) {
          Loading() => const Center(child: CircularProgressIndicator(color: Colors.blue,)),
          Data(:final movies) => MovieListView(movies: movies),
          MovieListState() => const SizedBox.shrink(),
        };
      },
    );
  }
}

class MovieListView extends StatelessWidget {
  final List<Movie> movies;

  const MovieListView({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => Container(
        height: 1.0,
        color: Colors.grey.shade300,
      ),
      itemBuilder: (context, index) => MovieCard(
        title: movies[index].title,
        rating: '${(movies[index].voteAverage * 10).toInt()}%',
        onTap: () => context.router.push(MovieDetailsRoute(movie: movies[index])),
      ),
      itemCount: movies.length,
    );
  }
}
