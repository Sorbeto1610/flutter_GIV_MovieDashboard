import 'genre.dart';
import 'movie.dart';



Map<String, int>  countingGenreDictionary(List<Movie> movieList,List<Genre> genreList) {
  Map<String, int> nbGenreDictionary = {};



  for (Movie movie in movieList) {

    for (int idGenre in movie.genreIds ){
      for (Genre genre in genreList){
        if (idGenre == genre.id){
          nbGenreDictionary[genre.name] = 1;
        }
      }

    }


  }


  return nbGenreDictionary;
}

void main () {
print('coucou');

}


