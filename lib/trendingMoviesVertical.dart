import 'package:flutter/material.dart';
import 'package:giv/vertical_movie_carousel_view.dart';
import 'movie.dart';
import 'movie_list.dart';


class TrendingMoviesVerticalHomePage extends StatefulWidget {
  @override
  TrendingMoviesVerticalHomePageState createState() => TrendingMoviesVerticalHomePageState();
}

class TrendingMoviesVerticalHomePageState extends State<TrendingMoviesVerticalHomePage> {
  List<Movie> ml = [];

  @override
  void initState() {
    super.initState();
    fetchTrendingMovies(); // Appel de la fonction pour récupérer les films tendance
  }

  Future<void> fetchTrendingMovies() async {
    try {
      MovieList movieListInstance = MovieList();
      await movieListInstance.fetchMoviesTrend();
      setState(() {
        ml = movieListInstance.movieList;
      });
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Rendre le fond transparent
      body: Container(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            child: VerticalCarouselPoster(movieList: ml),
          ),
        ),
      ),
    );
  }

}