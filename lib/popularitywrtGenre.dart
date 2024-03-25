import 'package:flutter/material.dart';
import 'movie.dart';
import 'genre.dart';
import 'fetchService.dart';



Future<double> calculateGenrePopularity(List<Movie> movies, int genreId) async {
  double totalPopularity = 0;
  double genrePopularity = 0;

  for (var movie in movies) {
    totalPopularity += movie.popularity;
    if (movie.genreIds.contains(genreId)) {
      genrePopularity += movie.popularity;
    }
  }

  if (totalPopularity == 0) {
    return 0; // Pour éviter une division par zéro
  }

  return (genrePopularity / totalPopularity) * 100;
}

