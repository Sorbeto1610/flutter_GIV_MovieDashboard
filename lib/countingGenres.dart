import 'genre.dart';
import 'movie.dart';

Map<String, int> countingGenreDictionary(List<Movie> movieList, List<Genre> genreList) {
  Map<String, int> nbGenreDictionary = {};

  for (Movie movie in movieList) {
    for (int idGenre in movie.genreIds) {
      for (Genre genre in genreList) {
        if (idGenre == genre.id) {
          int? count = nbGenreDictionary[genre.name];
          if (count != null) {
            nbGenreDictionary[genre.name] = count + 1;
          } else {
            nbGenreDictionary[genre.name] = 1;
          }
        }
      }
    }
  }

  return nbGenreDictionary;
}

Map<String, double> calculateGenrePercentages(Map<String, int> genreCounts) {
  Map<String, double> percentages = {};
  int totalMovies = genreCounts.values.reduce((a, b) => a + b);

  genreCounts.forEach((genre, count) {
    double percentage = (count / totalMovies) * 100;
    percentages[genre] = percentage;
  });

  return percentages;
}

