import 'package:flutter/material.dart';
import 'movie_carousel_view.dart';
import 'movie.dart';
import 'movie_list.dart';


class TrendingMoviesHomePage extends StatefulWidget {
  @override
   TrendingMoviesHomePageState createState() =>  TrendingMoviesHomePageState();
}

class  TrendingMoviesHomePageState extends State <TrendingMoviesHomePage> {
  List<Movie> ml = [];

  @override
  void initState() {
    super.initState();
    () async { //definition d'une fonction asyncrone pour éviter problem avec Initstate PS Résoudre avec Riverpod
      await MovieList().fetchMoviesTrend();
      ml = MovieList().movieList;
    }
    ();
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
