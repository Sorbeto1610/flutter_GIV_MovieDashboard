import 'package:flutter/material.dart';
import 'package:giv/movie_caroussel_view.dart';
import 'movie_list_view.dart';
import 'movie_service.dart';
import 'genre.dart';
import 'movie.dart';




Map<String, int>  countingGenreDictionary(List<Movie> movies,List<Genre> genres) {
  Map<String, int> nbGenreDictionary = {};


  for (Movie movie in movies) {

    for (int id_genre in movie.genreIds ){
      for (Genre genre in genres){
        if (id_genre == genre.id){
          nbGenreDictionary[genre.name] = 1;
        }
      }

    }


  }


  return nbGenreDictionary;
}

