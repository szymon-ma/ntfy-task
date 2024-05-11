import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recruitment_task/injectable.dart';
import 'package:flutter_recruitment_task/models/movie.dart';
import 'package:flutter_recruitment_task/models/movie_details.dart';
import 'package:flutter_recruitment_task/pages/movie_details/movie_details_cubit.dart';

@RoutePage()
class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => getIt<MovieDetailsCubit>(param1: movie)..fetchMovieDetails(),
        child: const MovieDetailsLoader(),
      );
}

class MovieDetailsLoader extends StatelessWidget {
  const MovieDetailsLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              switch (state) {
                Loading() => 'Loading...',
                Data(:final movieDetails) => movieDetails.title,
                MovieDetailsState() => '',
              },
            ),
          ),
          body: switch (state) {
            Loading() => const CircularProgressIndicator(),
            Data(:final movieDetails, :final shouldWatchIt) => MovieDetailsContent(
                movieDetails: movieDetails,
                shouldWatchIt: shouldWatchIt,
              ),
            MovieDetailsState() => const SizedBox.shrink(),
          },
        );
      },
    );
  }
}

class MovieDetailsContent extends StatelessWidget {
  final MovieDetails movieDetails;
  final bool shouldWatchIt;

  const MovieDetailsContent({super.key, required this.movieDetails, required this.shouldWatchIt});

  @override
  Widget build(BuildContext context) {
    final details = <(String, dynamic)>[
      ('Budget', movieDetails.budget),
      ('Revenue', movieDetails.revenue),
      ('Should I watch it today?', shouldWatchIt ? 'Yes!' : 'No!')
    ];

    return ListView.separated(
      separatorBuilder: (context, index) => Container(
        height: 1.0,
        color: Colors.grey.shade300,
      ),
      itemCount: details.length,
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              details[index].$1,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            Text(
              details[index].$2.toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
