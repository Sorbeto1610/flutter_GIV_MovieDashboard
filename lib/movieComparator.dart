import 'package:flutter/material.dart';
import 'movie.dart';

class MovieComparisonSelector extends StatefulWidget {
  @override
  _MovieComparisonSelectorState createState() => _MovieComparisonSelectorState();
}

class _MovieComparisonSelectorState extends State<MovieComparisonSelector> {
  int _selectedCount = 2; // Nombre de films sélectionnés //le minimum de film a comparer est deux
  List<Movie?> _selectedMovies = List.filled(4, null); // Liste des films sélectionnés

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Sélectionnez le nombre de films à comparer:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          children: [
            SizedBox(width: MediaQuery.of(context).size.width/5),
            Expanded(
              child: _buildSelectionButton(2), //choisir 2,3, ou 4 films a comparer
            ),
            SizedBox(width: MediaQuery.of(context).size.width/5),
            Expanded(
              child: _buildSelectionButton(3),
            ),
            SizedBox(width: MediaQuery.of(context).size.width/5),
            Expanded(
              child: _buildSelectionButton(4),
            ),
            SizedBox(width: MediaQuery.of(context).size.width/5),
          ],
        ),
        SizedBox(height: 20.0),
        Text(
          'Films sélectionnés:',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        Row(
          children: List.generate(
            _selectedCount,
                (index) => Expanded(
              child: _buildMovieColumn(index),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionButton(int count) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCount = count;
        });
      },
      child: Container(
        padding: EdgeInsets.all(10.0), //les boutons ou on clique 2/3 ou 4
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: _selectedCount == count ? Colors.red : Colors.red[300],
        ),
        child: Center( // Ajout du widget Center
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 16.0,
              color: _selectedCount == count ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),

    );
  }

  Widget _buildMovieColumn(int columnIndex) {
    return DragTarget<Movie>(
      builder: (BuildContext context, List<Movie?> candidateData, List<dynamic> rejectedData) {
        final selectedMovie = _selectedMovies[columnIndex];
        return selectedMovie != null
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedMovie.title ?? '', // Afficher le titre du film
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 5.0),
            Text(
              'Langue: ${selectedMovie.originalLanguage ?? ''}', // Afficher la langue
              style: TextStyle(fontSize: 14.0),
            ),
            Text(
              'Popularité: ${selectedMovie.popularity}', // Afficher la popularité
              style: TextStyle(fontSize: 14.0),
            ),
            Text(
              'Date de sortie: ${selectedMovie.releaseDate}', // Afficher la date de sortie
              style: TextStyle(fontSize: 14.0),
            ),
            Text(
              'Moyenne des votes: ${selectedMovie.voteAverage}', // Afficher la moyenne des votes
              style: TextStyle(fontSize: 14.0),
            ),
            Text(
              'Nombre de votes: ${selectedMovie.voteCount}', // Afficher le nombre de votes
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(height: 5.0),
            Container(
              height: 100.0, // Ajuster la taille si nécessaire
              width: 150.0, // Ajuster la taille si nécessaire
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      selectedMovie.posterPath, // Supposant que posterPath est une URL
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _selectedMovies[columnIndex] = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
            : Container(
          height: 100.0, // Ajuster la taille si nécessaire
          color: Colors.red[600],
          child: Center(
            child: Text(
              'Glissez un film',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        );
      },
      onWillAccept:  (data) {
        return _selectedMovies[columnIndex] == null;
      },
      onAccept: (data) {
        setState(() {
          _selectedMovies[columnIndex] = data;
        });
      },
    );
  }

}
