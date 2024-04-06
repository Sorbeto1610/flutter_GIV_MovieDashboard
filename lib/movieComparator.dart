import 'package:flutter/material.dart';
import 'movie.dart';

class MovieComparisonSelector extends StatefulWidget {
  @override
  _MovieComparisonSelectorState createState() => _MovieComparisonSelectorState();
}

class _MovieComparisonSelectorState extends State<MovieComparisonSelector> {
  int _selectedCount = 2;
  List<Movie?> _selectedMovies = List.filled(4, null);

  Widget _buildSelectionButton(int count, String buttonText) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedCount = count;
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (_selectedCount == count) {
                  return Colors.red[900]!;
                } else if (states.contains(MaterialState.pressed)) {
                  return Colors.red[900]!.withOpacity(0.5);
                }
                return Colors.red;
              },
            ),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionButtons() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSelectionButton(2, 'Compare 2 Movies'),
          _buildSelectionButton(3, 'Compare 3 Movies'),
          _buildSelectionButton(4, 'Compare 4 Movies'),
        ],
      ),
    );
  }

  Widget _buildMovieColumn(int index) {
    final selectedMovie = _selectedMovies[index];
    final backgroundColor = _getBackgroundColor(selectedMovie) ?? Colors.red;
    return Expanded(
      child: DragTarget<Movie>(
        builder: (BuildContext context, List<Movie?> candidateData, List<dynamic> rejectedData) {
          return Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
              color: backgroundColor,
            ),
            child: selectedMovie != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (selectedMovie.posterPath != null) // Vérifie s'il y a un posterUrl
                          Container(
                            margin: EdgeInsets.only(right: 8.0),
                            width: 40.0, // Largeur fixe du poster
                            height: 60.0, // Hauteur fixe du poster
                            child: Image.network(
                              _addHttpsPrefix(selectedMovie.posterPath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        Text(
                          selectedMovie.title ?? '',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          _selectedMovies[index] = null;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                _buildHighlightedText('Language:', selectedMovie.originalLanguage ?? ''),
                _buildHighlightedText('Popularity:', selectedMovie.popularity.toString()),
                _buildHighlightedText('Release Date:', selectedMovie.releaseDate),
                _buildHighlightedText('Vote mean:', selectedMovie.voteAverage.toString()),
                _buildHighlightedText('Vote number:', selectedMovie.voteCount.toString()),
              ],
            )
                : Center(
              child: Text(
                'Drag your movie here',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
        onWillAccept: (data) => true,
        onAccept: (data) {
          setState(() {
            _selectedMovies[index] = data;
          });
        },
      ),
    );
  }

  Color? _getBackgroundColor(Movie? movie) {
    if (movie == null) return null;
    double maxPopularity = _selectedMovies.map((e) => e?.popularity ?? double.negativeInfinity).reduce((value, element) => value > element ? value : element);
    double maxVoteAverage = _selectedMovies.map((e) => e?.voteAverage ?? double.negativeInfinity).reduce((value, element) => value > element ? value : element);
    if (movie.popularity == maxPopularity) {
      return Colors.yellow[100]; // Highlight for highest popularity
    } else if (movie.voteAverage == maxVoteAverage) {
      return Colors.blue[100]; // Highlight for highest vote average
    } else {
      return null;
    }
  }

  Widget _buildHighlightedText(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$label $value',
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          backgroundColor: Colors.yellow[100],
        ),
      ),
    );
  }

  String _addHttpsPrefix(String? url) {
    if (url == null || url.isEmpty) {
      return "";
    } else if (url.startsWith("http://") || url.startsWith("https://")) {
      return url;
    } else {
      return "https://$url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: const Text(
            'Movie Comparator',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        _buildSelectionButtons(),
        SizedBox(height: 20.0),
        Expanded(
          child: GridView.count(
            crossAxisCount: _selectedCount,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: List.generate(
              _selectedCount,
                  (index) => _buildMovieColumn(index),
            ),
          ),
        ),
      ],
    );
  }
}
