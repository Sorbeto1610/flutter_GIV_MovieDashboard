import 'movie.dart';
import 'fetchService.dart';



class MovieList {
  List<Movie> movieList = [];


    Future<void> fetchMoviesTrend() async {
      try {
        final List<Movie> fetchedMoviesTrend = await FetchService.fetchMoviesTrend();
          movieList = fetchedMoviesTrend;
      } catch (e) {
        print('Error fetching movies: $e');
      }

  }
}