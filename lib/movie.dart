class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final List<dynamic> genreIds;
  final double voteAverage;




  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.genreIds,
    required this.voteAverage

  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        id: json['id'],
        title: json['title'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        genreIds: json['genre_ids'],
        voteAverage: json['vote_average'].toDouble()
    );
  }
}