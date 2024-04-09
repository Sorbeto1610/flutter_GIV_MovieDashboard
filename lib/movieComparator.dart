import 'package:flutter/material.dart';
import 'movie.dart';
import 'api-config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart'; // Import animated_flip_counter package
import 'dart:math';

class MovieComparisonSelector extends StatefulWidget {
  @override
  _MovieComparisonSelectorState createState() => _MovieComparisonSelectorState();
}

class _MovieComparisonSelectorState extends State<MovieComparisonSelector> {
  int _selectedCount = 2;
  List<Movie?> _selectedMovies = List.filled(4, null);
  List<bool> _showTextList = List.filled(4, false); // List to track show text state for each movie
  List<bool> _showVoteMeanTextList = List.filled(4, false);


  List<Key> _flipCounterKeys = List.generate(4, (index) => GlobalKey()); // Generate unique keys for AnimatedFlipCounter

  Movie? movieWithMaxPopularity; // Déplacer la déclaration ici

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
                if (states.contains(MaterialState.pressed)) {
                  return Colors.red[900]!.withOpacity(0.5);
                }
                return _selectedCount == count ? Colors.red[900]! : Colors.red;
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

  Widget _buildGridView() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - 103, // 103 pixels de moins que la hauteur de l'écran
        ),
        child: GridView.builder(
          padding: EdgeInsets.only(bottom: 22.0),
          itemCount: _selectedCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _selectedCount,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (context, index) {
            return SizedBox(
              child: _buildMovieColumn(index),
            );
          },
          shrinkWrap: true,
        ),
      ),
    );
  }

  Widget _buildMovieColumn(int index) {
    final selectedMovie = _selectedMovies[index];

    // Define margin and padding based on the selected count
    final double margin = _selectedCount == 2 ? 40.0 : 16.0;
    final double padding = _selectedCount == 2 ? 20.0 : 10.0;
    final double gaugeRadius =
    _selectedCount == 2 ? 100.0 : _selectedCount == 3 ? 80.0 : 60.0;

    // Determine the movie with the highest popularity
    movieWithMaxPopularity = _selectedMovies.reduce((a, b) =>
    (a != null && b != null && a.popularity > b.popularity) ? a : b);

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(margin),
        padding: EdgeInsets.only(left: padding, right: padding),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.red,
        ),
        height: _selectedCount == 2 ? 400 : _selectedCount == 3 ? 330 : 275,
        child: Stack(
          children: [
            DragTarget<Movie>(
              builder: (BuildContext context, List<Movie?> candidateData,
                  List<dynamic> rejectedData) {
                if (selectedMovie != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie poster, title, and close button
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _selectedMovies[index] = null;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            if (selectedMovie.posterPath != null)
                              Container(
                                margin: EdgeInsets.only(right: 8.0),
                                width: _selectedCount == 2
                                    ? 100
                                    : _selectedCount == 3
                                    ? 100
                                    : 60,
                                height: _selectedCount == 2
                                    ? 150
                                    : _selectedCount == 3
                                    ? 100
                                    : 75,
                                child: CachedNetworkImage(
                                  imageUrl:
                                  '${ApiConfig.imageBaseUrl}${selectedMovie.posterPath}',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Image.asset('assets/clap.gif'),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            Flexible(
                              child: Text(
                                selectedMovie.title ?? '',
                                style: TextStyle(
                                  fontSize: _selectedCount == 2
                                      ? 25.0
                                      : _selectedCount == 3
                                      ? 16.0
                                      : 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.0),
                      // Other movie details
                      _buildHighlightedText(
                          'Language:', selectedMovie.originalLanguage ?? '', index),
                      _buildHighlightedText(
                          'Release Date:', selectedMovie.releaseDate, index),
                      _buildHighlightedText('Vote mean:', '', index),
                      SizedBox(height: 8.0),
// Radial gauge
                      Center(
                        child: Container(
                          height: _selectedCount == 2 ? 150.0 : _selectedCount == 3 ? 120.0 : 80.0,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedRadialGauge(
                                duration: const Duration(seconds: 1),
                                curve: Curves.elasticOut,
                                radius: gaugeRadius,
                                value: selectedMovie.voteAverage,
                                axis: GaugeAxis(
                                  min: 0,
                                  max: 10,
                                  degrees: 180,
                                  style: const GaugeAxisStyle(
                                    thickness: 20,
                                    background: Color(0x00000000),
                                    segmentSpacing: 4,
                                  ),
                                  progressBar: GaugeProgressBar.rounded(
                                    color: _getGaugeColor(selectedMovie.voteAverage),
                                  ),
                                  segments: List.generate(
                                    3,
                                        (_) => GaugeSegment(
                                      from: 0,
                                      to: 10,
                                      color: Colors.grey.withOpacity(0.5),
                                      cornerRadius: Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -30,
                                child: Text(
                                  ' ${selectedMovie.voteAverage.toString()}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),



                      // Other movie details
                      _buildHighlightedText(
                          'Popularity:',
                          selectedMovie.popularity.toString(),
                          index),
                      // Use AnimatedFlipCounter for 'Vote number'
                      _buildHighlightedText('Vote number:',
                          selectedMovie.voteCount.toString(), index),
                    ],
                  );
                } else {
                  return Center(
                    child: Text(
                      'Drag your movie here',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              },
              onWillAccept: (data) => true,
              onAccept: (data) {
                setState(() {
                  _selectedMovies[index] = data;
                  _flipCounterKeys[index] =
                      GlobalKey(); // Update the key to force rebuild AnimatedFlipCounter
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showVoteMeanDialog(BuildContext context, double voteAverage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vote Mean'),
          content: Text('Vote mean: $voteAverage'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }


  Color _getGaugeColor(double voteAverage) {
    if (voteAverage < 6) {
      return Color(0xFF8B0000);
    } else if (voteAverage >= 6 && voteAverage < 7) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  Widget _buildHighlightedText(String label, String value, int index) {
    final selectedMovie = _selectedMovies[index];

    // Déterminez la valeur maximale pour cet élément parmi tous les films sélectionnés
    final maxValues = {
      'popularity': _selectedMovies.map((movie) => movie?.popularity ?? 0).reduce(max),
      'voteCount': _selectedMovies.map((movie) => movie?.voteCount ?? 0).reduce(max),
      // Ajoutez d'autres éléments à comparer si nécessaire
    };

    // Vérifiez si la valeur actuelle est maximale pour cet élément
    bool isMaxValue = false;
    if (label == 'Popularity:') {
      isMaxValue = selectedMovie?.popularity == maxValues['popularity'];
    } else if (label == 'Vote number:') {
      isMaxValue = selectedMovie?.voteCount == maxValues['voteCount'];
    }
    // Ajoutez des conditions supplémentaires pour d'autres éléments si nécessaire

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: isMaxValue ? FontWeight.bold : FontWeight.normal,
              color: isMaxValue ?Color(0xFF8B0000): Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
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
            ),
          ),
        ),
        _buildSelectionButtons(),
        SizedBox(height: 20.0),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final itemWidth = maxWidth / _selectedCount; // Déplacer itemWidth à l'intérieur de LayoutBuilder
              return GridView.builder(
                padding: EdgeInsets.only(bottom: 22.0),
                itemCount: _selectedCount,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _selectedCount,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: itemWidth,
                    child: _buildMovieColumn(index),
                  );
                },
                shrinkWrap: true,
              );
            },
          ),
        ),
      ],
    );
  }
}

