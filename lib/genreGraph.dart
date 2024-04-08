import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'fetchService.dart';
import 'genre.dart';
import 'movie.dart';

class BarChartSample1 extends StatefulWidget {
  BarChartSample1({Key? key}) : super(key: key);

  List<Color> get availableColors => const <Color>[
    Colors.purple,
    Colors.yellow,
    Colors.blue,
    Colors.orange,
    Colors.pink,
    Colors.red,
  ];

  final Color barBackgroundColor = Colors.white.withOpacity(0.3);
  final Color barColor = Colors.white;
  final Color touchedBarColor = Colors.red;

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  late Future<List<Movie>> _moviesFuture;
  late Future<List<Genre>> _genresFuture;
  List<Genre>? _genresList;
  Genre? _selectedGenre; // Genre sélectionné
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _genresFuture = FetchService.fetchMoviesListGenre();
    _moviesFuture = FetchService.fetchMoviesTrend();
    _selectedGenre = null; // Initialiser le genre sélectionné à null
  }

  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Movie Popularity Chart',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Sorted by genre',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildGenreDropdown(),
                      Expanded(
                        child: Center(
                          child: _isLoading
                              ? Image.asset('assets/clap.gif')
                              : FutureBuilder<List<Genre>>(
                            future: _genresFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Image.asset('assets/clap.gif');
                              } else if (snapshot.hasError) {
                                return Text(
                                    'Error: ${snapshot.error}');
                              } else {
                                _genresList = snapshot.data!;
                                return _buildBody();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 58,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                iconSize: 60,
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    isPlaying = !isPlaying;
                    if (isPlaying) {
                      refreshState();
                    }
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: FutureBuilder<List<Movie>>(
            future: _moviesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Image.asset('assets/clap.gif');
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return _buildGraph(snapshot.data!);
              }
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildGenreDropdown() {
    return FutureBuilder<List<Genre>>(
      future: _genresFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Image.asset('assets/clap.gif'); // Afficher une indication de chargement
        } else if (snapshot.hasError) {
          return Image.asset('assets/clap.gif');
        } else {
          // Construire la liste déroulante une fois que la liste des genres est récupérée
          _genresList = snapshot.data;
          return DropdownButtonFormField<Genre>(
            value: _selectedGenre,
            onChanged: (Genre? newValue) {
              setState(() {
                _selectedGenre = newValue;
                _isLoading = true;
                _moviesFuture = FetchService.fetchMoviesTrend();
                _isLoading = false;
              });
            },
            items: [
              const DropdownMenuItem<Genre>(
                value: null,
                child: Text('All'),
              ),
              if (_genresList != null)
                ..._genresList!.map<DropdownMenuItem<Genre>>((Genre genre) {
                  return DropdownMenuItem<Genre>(
                    value: genre,
                    child: Text(genre.name),
                  );
                }),
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.red),
              ),
              hintText: 'Select a genre',
            ),
          );
        }
      },
    );
  }


  Widget _buildGraph(List<Movie> movies) {
    final List<Movie> filteredMovies = _selectedGenre != null
        ? movies
        .where((movie) => movie.genreIds.contains(_selectedGenre!.id))
        .toList()
        : List.from(movies);

    if (filteredMovies.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/clap.gif',
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 20),
          const Text(
            'Movie in the making...',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      );
    }

    return BarChart(
      isPlaying ? randomData(filteredMovies) : mainBarData(filteredMovies),
      swapAnimationDuration: animDuration,
    );
  }

  BarChartGroupData makeGroupData(
      List<Movie> filteredMovies, int x, double y,
      {bool isTouched = false,
        Color? barColor,
        List<int> showTooltips = const []}) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 150 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: 30,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColor)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 4100,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(List<Movie> filteredMovies) {
    List<BarChartGroupData> groups = [];

    for (int i = 0; i < filteredMovies.length; i++) {
      Movie movie = filteredMovies[i];
      double y = movie.popularity.toDouble();

      groups.add(makeGroupData(filteredMovies, i, y,
          isTouched: i == touchedIndex));
    }

    return groups;
  }

  BarChartData mainBarData(List<Movie> filteredMovies) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.red[200],
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String movieName = filteredMovies[group.x].title;
            return BarTooltipItem(
              '$movieName\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return getTitles(value, filteredMovies);
            },
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(filteredMovies),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, List<Movie> filteredMovies) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String movieName = '';
    if (value.toInt() >= 0 && value.toInt() < filteredMovies.length) {
      movieName = filteredMovies[value.toInt()].title;
    }

    return Transform.rotate(
      angle: -28 * (pi / 180),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textWidth = TextPainter(
            text: TextSpan(text: movieName, style: style),
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: constraints.maxWidth);

          final horizontalOffset = -(textWidth.width / 2.2);
          final verticalOffset = sin(0 * pi / 180);

          return Transform.translate(
            offset: Offset(horizontalOffset, verticalOffset),
            child: Text(movieName, style: style),
          );
        },
      ),
    );
  }

  BarChartData randomData(List<Movie> filteredMovies) {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return getTitles(value, filteredMovies);
            },
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(filteredMovies.length, (i) {
        return makeGroupData(
          filteredMovies,
          i,
          Random().nextInt(3510).toDouble() + 600,
          barColor: widget.availableColors[
          Random().nextInt(widget.availableColors.length)],
        );
      }),

      gridData: const FlGridData(show: false),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}
