import 'package:flutter/material.dart';
import 'package:giv/movie_caroussel_view.dart';
import 'movie_list_view.dart';
import 'movie_service.dart';
import 'movie.dart';


class MovieExplorerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Explorer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MovieExplorerHomePage(),
    );
  }
}

class MovieExplorerHomePage extends StatefulWidget {
  @override
  _MovieExplorerHomePageState createState() => _MovieExplorerHomePageState();
}

class _MovieExplorerHomePageState extends State<MovieExplorerHomePage> {
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMoviesTrend();
  }



  Future<void> fetchMoviesTrend() async {
    try {
      final List<Movie> fetchedMoviesTrend = await MovieService.fetchMoviesTrend();
      setState(() {
        movies = fetchedMoviesTrend;
      });
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Explorer'),
      ),
      body: MovieCarouselView(movies: movies),
    );
  }
}

