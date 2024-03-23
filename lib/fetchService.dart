import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api-config.dart';
import 'movie.dart';
import 'genre.dart';

class FetchService {
  static Future<List<Movie>> fetchMoviesTrend() async {
    final response = await http.get(Uri.parse(
      '${ApiConfig.baseUrl}/trending/movie/week?api_key=${ApiConfig.apiKey}',
    ));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch movies 1');
    }
  }
  static Future<List<Genre>> fetchMoviesListGenre() async {
    final response = await http.get(Uri.parse(
      '${ApiConfig.baseUrl}genre/movie/list?api_key=${ApiConfig.apiKey}',
    ));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> genres = data['genres'];
      return genres.map((json) => Genre.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch movies 1');
    }
  }
}