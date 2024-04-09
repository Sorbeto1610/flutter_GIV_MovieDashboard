import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'ResponsiveText.dart';
import 'fetchService.dart';
import 'genre.dart';
import 'main.dart';
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
  bool _showContainer = true;

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

  void _handleGenreChange(Genre? newValue) {
    setState(() {
      _selectedGenre = newValue;
      _isLoading = true;
      _moviesFuture = FetchService.fetchMoviesTrend();
      _isLoading = false;
    });
    // Activer temporairement le bouton play/pause pendant 3 secondes
    setState(() {
      isPlaying = true;
      if (isPlaying) {
        refreshState();
      }
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        isPlaying = false;
      });
    });
  }

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
                const SizedBox(
                  height: 10,
                ),
                Center(
                    child: ResponsiveText(
                      text: "Bar chart of popularity sorted by genre",
                      fontSize: 20.0,
                      textColor: Colors.white,
                      shadowColor: Colors.red,
                      shadowOffset: Offset(0.0, 0.0),
                    ),
                  ),
                 SizedBox(
                  height: (MediaQuery.of(context).size.height*100 + MediaQuery.of(context).size.width)/(MediaQuery.of(context).size.height*0.2 + MediaQuery.of(context).size.width),
                ),
                ResponsiveText(
                  text: "Select genre :",
                  fontSize: 12.0,
                  textColor: Colors.white,
                  shadowColor: Colors.red,
                  shadowOffset: Offset(0.0, 0.0),
                ),
                const SizedBox(
                  height: 15,
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
          ),
          _showContainer
              ? Positioned(
            top: 110,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context)
                  .size
                  .height - 110, // Hauteur ajustable
              decoration: const BoxDecoration(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/clap.gif',
                    width: 600,
                    height: 400,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showContainer = false;
                        isPlaying = true;
                        if (isPlaying) {
                          refreshState();
                        }
                      });
                      Timer(Duration(seconds: 3), () {
                        setState(() {
                          isPlaying = false;
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white60, // Background color
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Button border radius
                      ),
                    ),
                    child: ResponsiveTitle(
                      text: "Click here !",
                      fontSize: 17.5,
                      textColor: Colors.white,
                      shadowColor1: Colors.red,
                      shadowOffset1: Offset(1.5, 1.5),
                      shadowColor2: Colors.redAccent,
                      shadowOffset2: Offset(0.75, 0.75),
                      ),
                    ),
                ],
              ),
            ),
          )
              : SizedBox(),
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
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Construire la liste déroulante une fois que la liste des genres est récupérée
          _genresList = snapshot.data;
          return DropdownButtonFormField<Genre>(
            value: _selectedGenre,
            onChanged: _handleGenreChange,
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
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xFF4F0404),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/clap.gif',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Movie in the making...',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }


    return BarChart(
      isPlaying ? randomData(filteredMovies) : mainBarData(filteredMovies),
      swapAnimationDuration: animDuration,
    );
  }

  BarChartGroupData makeGroupData(List<Movie> filteredMovies, int x, double y,
      {bool isTouched = false,
        Color? barColor,
        List<int> showTooltips = const []}) {
    double barWidth = MediaQuery.of(context).size.width / filteredMovies.length;
    if (MediaQuery.of(context).size.width < MediaQuery.of(context).size.height) {
      // Si la largeur de l'écran est plus petite que la hauteur
      barWidth = MediaQuery.of(context).size.width / (filteredMovies.length+5);
    } else {
      // Utilisez une largeur fixe lorsque la largeur de l'écran est plus grande que la hauteur
      barWidth = 30; // Vous pouvez modifier cette valeur en fonction de vos besoins
    }
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 150 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: barWidth,
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
