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

  Widget _buildMovieColumn(int index) {
    final selectedMovie = _selectedMovies[index];

    // Define margin and padding based on the selected count
    final double margin = _selectedCount == 2 ? 40.0 : 16.0;
    final double padding = _selectedCount == 2 ? 20.0 : 10.0;
    final double gaugeRadius = _selectedCount == 2 ? 100.0 : _selectedCount == 3 ? 80.0 : 60.0;

    return GestureDetector(
      onTap: () {
        // Toggle the visibility of the text for the clicked gauge
        setState(() {
          _showTextList[index] = !_showTextList[index];
        });
      },
      child: Container(
        margin: EdgeInsets.all(margin),
        padding: EdgeInsets.only(left: padding, right: padding),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.red, // Background color
        ),
        height: _selectedCount == 2 ? 400 : _selectedCount == 3 ? 300 : 250, // Adjust height based on the selected count
        child: Stack(
          children: [
            DragTarget<Movie>(
              builder: (BuildContext context, List<Movie?> candidateData, List<dynamic> rejectedData) {
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
                                width: _selectedCount == 2 ? 100 : _selectedCount == 3 ? 100 : 60, // Adjust poster width
                                height: _selectedCount == 2 ? 150 : _selectedCount == 3 ? 100 : 75, /// Adjust poster height
                                child: CachedNetworkImage(
                                  imageUrl: '${ApiConfig.imageBaseUrl}${selectedMovie.posterPath}',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Image.asset('assets/clap.gif'),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                            Flexible(
                              child: Text(
                                selectedMovie.title ?? '',
                                style: TextStyle(
                                  fontSize: _selectedCount == 2 ? 25.0 : _selectedCount == 3 ? 16.0 : 12.0, // Adjust title font size
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
                      _buildHighlightedText('Language:', selectedMovie.originalLanguage ?? ''),
                      _buildHighlightedText('Release Date:', selectedMovie.releaseDate),
                      _buildHighlightedText('Vote mean:'," ") ,
                      SizedBox(height: 8.0),
                      // Radial gauge
                      Center(
                        child: Container(
                          height: _selectedCount == 2 ? 300.0 : _selectedCount == 3 ? 120.0 : 80.0, // Adjust gauge height
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
                                  pointer: GaugePointer.needle(
                                    height: 10,
                                    width: 16,
                                    color: Color(0xFF8B0000),
                                  ),
                                  progressBar: GaugeProgressBar.rounded(
                                    color: _getGaugeColor(selectedMovie.voteAverage), // Set gauge color based on vote average
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
                              if (_showTextList[index]) // Show text only when _showText is true for the specific movie
                                Positioned(
                                  top: 20,
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                      'Vote Mean: ${selectedMovie?.voteAverage.toString()}',
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      // Other movie details
                      _buildHighlightedText('Popularity:', selectedMovie.popularity.toString()),
                      // Use AnimatedFlipCounter for 'Vote number'
                      _buildHighlightedText('Vote number:', selectedMovie.voteCount.toString()),
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

  Widget _buildHighlightedText(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (label == 'Vote number:') // Use AnimatedFlipCounter only for 'Vote number'
            AnimatedFlipCounter(
              value: int.tryParse(value) ?? 0, // Parse value to integer
              duration: Duration(seconds: 1), // Animation duration
              textStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            )
          else
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
        LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;
            final itemWidth = maxWidth / _selectedCount;
            return SizedBox(
              height: 650,
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
                    height: maxHeight,
                    width: itemWidth,
                    child: _buildMovieColumn(index),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
