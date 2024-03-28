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
            _buildSelectionButton(2), //choisir 2,3, ou 4 films a comparer
            _buildSelectionButton(3),
            _buildSelectionButton(4),
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
          color: _selectedCount == count ? Colors.blue : Colors.grey[300],
        ),
        child: Text(
          '$count',
          style: TextStyle(
            fontSize: 16.0,
            color: _selectedCount == count ? Colors.white : Colors.black,
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
          children: [
            Text(
              selectedMovie.title ?? '', // Display the title of the selected movie
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 5.0),
            Container(
              height: 100.0, // Adjust size as needed
              width: 100.0, // Adjust size as needed
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      selectedMovie.posterPath, // Assuming posterPath is a URL
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
          height: 100.0, // Adjust size as needed
          color: Colors.grey[200],
          child: Center(
            child: Text(
              'Drag a movie',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        );
      },
      onWillAccept: (data) {
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
