import 'package:flutter/material.dart';
import 'package:giv/piechartPage.dart';
import 'package:giv/piechartPage2.dart';
import 'movie.dart';
import 'fetchService.dart';
import 'countingGenres.dart';
import 'genre.dart';

class PiechartHolderPage extends StatefulWidget {
  @override
  _PiechartHolderPageState createState() => _PiechartHolderPageState();
}

class _PiechartHolderPageState extends State<PiechartHolderPage> {
  late Future<List<Movie>> _moviesFuture;
  late Future<List<Genre>> _genresFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = FetchService.fetchMoviesTrend();
    _genresFuture = FetchService.fetchMoviesListGenre();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
          future: Future.wait([_moviesFuture, _genresFuture]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Image.asset('assets/clap.gif'));
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else {
              final List<Movie> movies = snapshot.data![0] as List<Movie>;
              final List<Genre> genres = snapshot.data![1] as List<Genre>;

              final Map<String, int> genreCounts =
              countingGenreDictionary(movies, genres);
              final Map<String, double> genrePercentages =
              calculateGenrePercentages(genreCounts);

              // Trier les sections du pie chart par ordre alphabétique des genres
              final sortedGenreCounts = genreCounts.entries.toList()
                ..sort((a, b) => a.key.compareTo(b.key));

              // Créer une liste de couleurs primaires triées par ordre alphabétique des genres
              final sortedPrimaryColors = sortedGenreCounts.map((entry) {
                final genreIndex =
                genres.indexWhere((genre) => genre.name == entry.key);
                final colorIndex = genreIndex % Colors.primaries.length;
                return Colors.primaries[colorIndex];
              }).toList();

              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(20.0), // Coins arrondis
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.8,
                                child: PiechartPage(),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.8,
                                child: PiechartPage2(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20), // Ajuster l'espacement si nécessaire
                      Container(
                        width: MediaQuery.of(context).size.width * 0.975,
                        height: MediaQuery.of(context).size.height * 0.15,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(
                              alignment: WrapAlignment.center, // Center the content horizontally
                              spacing: 5,
                              runSpacing: 5,
                              children: sortedGenreCounts.map((entry) {
                                final title = '${entry.key}';
                                final color =
                                sortedPrimaryColors[sortedGenreCounts.indexOf(entry)];

                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center, // Horizontally center the row content
                                        crossAxisAlignment: CrossAxisAlignment.center, // Vertically center the row content
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            color: color,
                                            child: Icon(Icons.add),
                                          ),
                                          SizedBox(width: 5),
                                          Container(
                                            width: MediaQuery.of(context).size.width *
                                                0.05, // Modify width as needed
                                            child: Text(
                                              title,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
