class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final List<dynamic> genreIds;
  final double voteAverage;
  final double popularity;

  Movie({
    this.id = 0, // Valeur par défaut pour id
    this.title = "", // Valeur par défaut pour title
    this.overview = "", // Valeur par défaut pour overview
    this.posterPath = "", // Valeur par défaut pour posterPath
    this.genreIds = const [], // Valeur par défaut pour genreIds
    this.voteAverage = 0.0, // Valeur par défaut pour voteAverage
    this.popularity = 0.0, // Valeur par défaut pour popularity
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      overview: json['overview'] ?? "",
      posterPath: json['poster_path'] ?? "",
      genreIds: json['genre_ids'] ?? [],
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
