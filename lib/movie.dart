class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final List<dynamic> genreIds;
  final double voteAverage;
  final double popularity;
  final String originalLanguage;
  final String releaseDate;
  final int voteCount;
  final String backdropPath;

  Movie({
    this.id = 0, // Valeur par défaut pour id
    this.title = "", // Valeur par défaut pour title
    this.overview = "", // Valeur par défaut pour overview
    this.posterPath = "", // Valeur par défaut pour posterPath
    this.releaseDate="",
    this.voteCount=0,
    this.originalLanguage="",
    this.genreIds = const [], // Valeur par défaut pour genreIds
    this.voteAverage = 0.0, // Valeur par défaut pour voteAverage
    this.popularity = 0.0, // Valeur par défaut pour popularity
    this.backdropPath = "",
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      overview: json['overview'] ?? "",
      originalLanguage:json['original_language'] ?? "" ,
      releaseDate:json['release_date'] ?? "" ,
      posterPath: json['poster_path'] ?? "",
      genreIds: json['genre_ids'] ?? [],
      voteCount: json['vote_count'] ?? 0,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      backdropPath: json['backdrop_path'] ?? "",
    );
  }
}
