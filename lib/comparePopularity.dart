import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'movie.dart';



  // Fonction pour comparer la popularité des films
  List<charts.Series<Movie, String>> comparePopularityList(List<Movie> movieList) {
    final data = movieList.map((movie) => Movie(
      title: movie.title,
      popularity: movie.popularity,
      posterPath: movie.posterPath,
    )).toList();

    return [
      charts.Series<Movie, String>(
        id: 'Popularity',
        data: data,
        domainFn: (Movie movie, _) => movie.title,
        measureFn: (Movie movie, _) => movie.popularity.toInt(),
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (Movie movie, _) => '${movie.title}: ${movie.popularity}',
      ),
    ];
  }
