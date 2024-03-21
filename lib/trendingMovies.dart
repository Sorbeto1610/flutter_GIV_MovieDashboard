import 'package:flutter/material.dart';
import 'package:giv/movie_caroussel_view.dart';
import 'movie_list_view.dart';
import 'movie_service.dart';
import 'movie.dart';


class TrendingMoviesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trending Movies',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TrendingMoviesHomePage(),
    );
  }
}

class TrendingMoviesHomePage extends StatefulWidget {
  @override
   TrendingMoviesHomePageState createState() =>  TrendingMoviesHomePageState();
}

class  TrendingMoviesHomePageState extends State <TrendingMoviesHomePage> {
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
        title: Text('Trending Movies'),
      ),
      body: MovieCarouselView(movies: movies),
    );
  }
}

