import 'package:flutter/material.dart';
import 'ResponsiveText.dart';
import 'movie.dart';
import 'api-config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'dart:math';

class MovieComparisonSelector extends StatefulWidget {
  @override
  _MovieComparisonSelectorState createState() => _MovieComparisonSelectorState();
}

class _MovieComparisonSelectorState extends State<MovieComparisonSelector> {
  int _selectedCount = 2;
  List<Movie?> _selectedMovies = List.filled(4, null);

  Movie? movieWithMaxPopularity;
  Movie? movieWithMaxVoteMean;
  Movie? movieWithMaxVoteNumber;

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
          child: ResponsiveText(
            text: buttonText,
            fontSize: 10.0,
            textColor: Colors.white,
            shadowColor: Colors.red,
            shadowOffset: Offset(0.0, 0.0),
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
      child: Row(
        children: List.generate(
          _selectedCount,
              (index) =>
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: _buildMovieColumn(index),
                ),
              ),
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

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(margin),
        padding: EdgeInsets.only(left: padding, right: padding),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.red,
        ),
        child: Stack(
          children: [
            DragTarget<Movie>(
              builder: (BuildContext context, List<Movie?> candidateData,
                  List<dynamic> rejectedData) {
                if (selectedMovie != null) {
                  // Filtrer les films non null
                  final List<Movie> selectedMoviesNonNull =
                  _selectedMovies.where((movie) => movie != null).cast<Movie>().toList();

                  // Déterminer le film avec la popularité maximale parmi les films non null
                  movieWithMaxPopularity = selectedMoviesNonNull.reduce((a, b) =>
                  (a.popularity > b.popularity) ? a : b);


                  // Determine the movie with the highest Vote mean
                  Movie? movieWithMaxVoteMean = selectedMoviesNonNull.reduce((a, b) =>
                  ( a.voteAverage > b.voteAverage)
                      ? a
                      : b);

                  // Determine the movie with the highest vote number
                  Movie? movieWithMaxVoteNumber = selectedMoviesNonNull.reduce((a, b) =>
                  (a.voteCount > b.voteCount)
                      ? a
                      : b);

                  // Determine if the current movie has the highest popularity among all selected movies
                  final bool hasMaxPopularity =
                      selectedMovie == movieWithMaxPopularity;

                  // Determine if the current movie has the highest vote mean among all selected movies
                  final bool hasMaxVoteMean =
                      selectedMovie == movieWithMaxVoteMean;

                  // Determine if the current movie has the highest vote number among all selected movies
                  final bool hasMaxVoteNumber =
                      selectedMovie == movieWithMaxVoteNumber;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0),
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
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 8.0),
                                  width: _selectedCount == 2
                                      ? MediaQuery.of(context).size.width*0.05
                                      : _selectedCount == 3
                                      ? MediaQuery.of(context).size.width*0.03
                                      : MediaQuery.of(context).size.width*0.02,
                                  height: _selectedCount == 2
                                      ? MediaQuery.of(context).size.width*0.1
                                      : _selectedCount == 3
                                      ? MediaQuery.of(context).size.width*0.06
                                      : MediaQuery.of(context).size.width*0.04,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                      '${ApiConfig.imageBaseUrl}${selectedMovie.posterPath}',
                                      placeholder: (context, url) =>
                                          Image.asset('assets/clap.gif'),
                                      errorWidget: (context, url, error) =>
                                          Image.asset('assets/clap.gif'),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    selectedMovie.title,
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
                            SizedBox(height: 8.0),
                            // Other movie details
                            _buildHighlightedText(
                                'Language:',
                                selectedMovie.originalLanguage,
                                index),
                            _buildHighlightedText(
                                'Release Date:', selectedMovie.releaseDate, index),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Center(
                        child: ResponsiveText(
                          text: "Vote Mean",
                          fontSize: 10.0,
                          textColor: Colors.white,
                          shadowColor: Colors.red,
                          shadowOffset: Offset(0.0, 0.0),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          color: hasMaxVoteMean
                              ? const Color.fromRGBO(255, 215, 0, 1)
                              : Colors.grey[900],
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: Colors.white,
                            width: hasMaxVoteMean ? 5.0 : 0.0,
                          ),
                        ),
                        height: _selectedCount == 2
                            ? 150.0
                            : _selectedCount == 3
                            ? 120.0
                            : 100.0,
                        width: MediaQuery.of(context).size.width,
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
                              top: _selectedCount == 2 ? 75.0 : _selectedCount == 3 ? 60.0 : 50.0,
                              child: ResponsiveText(
                                text: ' ${selectedMovie.voteAverage.toString()}',
                                fontSize: _selectedCount == 2 ? 13.0 : _selectedCount == 3 ? 10.0 : 7.0,
                                textColor: Colors.white,
                                shadowColor: Colors.red,
                                shadowOffset: Offset(0.0, 0.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Other movie details
                      Center(
                        child: ResponsiveText(
                          text: "Popularity",
                          fontSize: 10,
                          textColor: Colors.white,
                          shadowColor: Colors.black,
                          shadowOffset: Offset(0.0, 0.0),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          color: hasMaxPopularity ? const Color.fromRGBO(255, 215, 0, 1): Colors.grey[900],
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: Colors.white,
                            width: hasMaxPopularity ? 5.0 : 0.0,
                          ),
                        ),
                        height: _selectedCount == 2
                            ? 150.0
                            : _selectedCount == 3
                            ? 120.0
                            : 100.0,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: ResponsiveText(
                              text: selectedMovie.popularity.toString(),
                              fontSize: _selectedCount == 2 ? 17.0 : _selectedCount == 3 ? 13.0 : 10.0,
                              textColor: Colors.white,
                              shadowColor: Colors.black,
                              shadowOffset: Offset(0.0, 0.0)
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      // Other movie details
                      Center(
                        child: ResponsiveText(
                            text: "Vote number",
                            fontSize: 10,
                            textColor: Colors.white,
                            shadowColor: Colors.black,
                            shadowOffset: Offset(0.0, 0.0)
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        decoration: BoxDecoration(
                          color: hasMaxVoteNumber ? const Color.fromRGBO(255, 215, 0, 1): Colors.grey[900],
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: Colors.white,
                            width: hasMaxVoteNumber ? 5.0 : 0.0,
                          ),
                        ),
                        height: _selectedCount == 2 ? 150.0 : _selectedCount == 3 ? 120.0 : 100.0,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: ResponsiveText(
                              text: selectedMovie.voteCount.toString(),
                              fontSize: _selectedCount == 2 ? 17.0 : _selectedCount == 3 ? 13.0 : 10.0,
                              textColor: Colors.white,
                              shadowColor: Colors.black,
                              shadowOffset: Offset(0.0, 0.0)
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  );
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height*0.8,
                    child: Center(
                      child: Text(
                        'Drag your movie here',
                        style: TextStyle(
                          fontSize: _selectedCount == 2 ? (50.0*MediaQuery.of(context).size.width+MediaQuery.of(context).size.height)/(MediaQuery.of(context).size.width+MediaQuery.of(context).size.height) : _selectedCount == 3 ? (40.0*MediaQuery.of(context).size.width+MediaQuery.of(context).size.height)/(MediaQuery.of(context).size.width+MediaQuery.of(context).size.height) : (30.0*MediaQuery.of(context).size.width+MediaQuery.of(context).size.height)/(MediaQuery.of(context).size.width+MediaQuery.of(context).size.height),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
              },
              onWillAccept: (data) => true,
              onAccept: (data) {
                setState(() {
                  _selectedMovies[index] = data;
                });
              },
            ),
          ],
        ),
      ),
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

    // Determine the maximum value for this item among all selected movies
    final maxValues = {
      'popularity': _selectedMovies.map((movie) => movie?.popularity ?? 0).reduce(max),
      'voteCount': _selectedMovies.map((movie) => movie?.voteCount ?? 0).reduce(max),
      // Add other items to compare if needed
    };

    // Check if the current value is maximum for this item
    bool isMaxValue = false;
    if (label == 'Popularity:') {
      isMaxValue = selectedMovie?.popularity == maxValues['popularity'];
    } else if (label == 'Vote number:') {
      isMaxValue = selectedMovie?.voteCount == maxValues['voteCount'];
    }
    // Add additional conditions for other items if needed

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontSize: (20.0*MediaQuery.of(context).size.width+MediaQuery.of(context).size.height)/(MediaQuery.of(context).size.width+MediaQuery.of(context).size.height),
              fontWeight: isMaxValue ? FontWeight.bold : FontWeight.normal,
              color: isMaxValue ? Color(0xFF8B0000) : Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: (20.0*MediaQuery.of(context).size.width+MediaQuery.of(context).size.height)/(MediaQuery.of(context).size.width+MediaQuery.of(context).size.height),
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
          child: ResponsiveText(
            text: "Movie comparator",
            fontSize: 17.0,
            textColor: Colors.white,
            shadowColor: Colors.red,
            shadowOffset: Offset(0.0, 0.0),
          ),
        ),
        _buildSelectionButtons(),
        SizedBox(height: 20.0),
        Expanded(
          child: _buildGridView(),
        ),
      ],
    );
  }
}
