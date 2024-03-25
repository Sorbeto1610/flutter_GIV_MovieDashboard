import 'package:flutter/material.dart';
import 'movie_carousel_view.dart';
import 'movie.dart';
import 'movie_list.dart';


class TrendingMoviesHomePage extends StatefulWidget {
  @override
  TrendingMoviesHomePageState createState() => TrendingMoviesHomePageState();
}

class TrendingMoviesHomePageState extends State<TrendingMoviesHomePage> {
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF91180B),
              Color(0xFFB9220F),
              Color(0xFFE32D13),
              Color(0xFFF85138),
              Color(0xFFFF6666),
              Color(0xFFF85138),
              Color(0xFFE32D13),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + kToolbarHeight),
            child: MovieCarouselView(movieList: ml),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Rendre la barre d'app bar transparente
        elevation: 0, // Supprimer l'ombre de l'app bar
        title: const Text(
          'Trending Movies',
          style: TextStyle(
            color: Colors.white, // Couleur du texte en blanc
          ),
        ),
      ),
    );
  }

}