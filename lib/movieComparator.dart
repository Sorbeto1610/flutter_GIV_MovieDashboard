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
          child: const Text(
            ' Movie Comparator',
            style: TextStyle(
              fontSize:  20,
              color: Colors.white, // Couleur du texte en blanc
            ),
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
        padding: EdgeInsets.all(10.0), // Padding for the button
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: _selectedCount == count ? Colors.red : Colors.red[300],
        ),
        child: Center(
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
            ? Expanded(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedMovie.title ?? '',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  'Language: ${selectedMovie.originalLanguage ?? ''}',
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(
                  'Popularity: ${selectedMovie.popularity}',
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(
                  'Release Date: ${selectedMovie.releaseDate}',
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(
                  'Vote mean: ${selectedMovie.voteAverage}',
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(
                  'Vote number: ${selectedMovie.voteCount}',
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(height: 5.0),
                Container(
                  height: 100.0,
                  width: 150.0,
                  child: Stack(
                    children: [
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
            ),
          ),
        )
            : Container(
          height: 500, // Adjust the size if necessary
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF91180B),
                Color(0xFFB9220F),
                Color(0xFFE32D13),
                Color(0xFFF85138),
                Color(0xFFFF6666),
              ],
            ),
          ),
          child: Center(
            child: Text(
              'Drag your movie here',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 2,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
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



  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

}
