import 'package:flutter/material.dart';
import 'package:giv/ResponsiveText.dart';
import 'package:intl/intl.dart';
import 'fetchService.dart';
import 'genre.dart';
import 'piechartPage.dart';
import 'piechartPage2.dart';

class PiechartHolderPage extends StatefulWidget {
  @override
  _PiechartHolderPageState createState() => _PiechartHolderPageState();
}

class _PiechartHolderPageState extends State<PiechartHolderPage> {
  late Future<List<Genre>> _genresFuture;
  List<Genre> genres = [];
  Map<String, double> _selectedGenresPercentages1 = {};
  Map<String, double> _selectedGenresPercentages2 = {};
  String _selectedGenreInfo = ""; // Ajout d'une nouvelle variable pour stocker l'info sélectionnée

  @override
  void initState() {
    super.initState();
    _genresFuture = FetchService.fetchMoviesListGenre().then((value) {
      genres = value;
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Genre Popularity"),
      ),
      body: FutureBuilder<List<Genre>>(
        future: _genresFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final genreCounts = Map.fromIterable(snapshot.data!, key: (item) => item.name, value: (item) => 0);
            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: PiechartPage(onGenreSelected1: (Map<String, double> percentages) {
                                  setState(() {
                                    _selectedGenresPercentages1 = percentages;
                                  });
                                }),
                              ),
                              Expanded(
                                child: PiechartPage2(onGenreSelected: (Map<String, double> percentages) {
                                  setState(() {
                                    _selectedGenresPercentages2 = percentages;
                                  });
                                }),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                           child: Column(
                               children: [ResponsiveText(
                                 text: _selectedGenreInfo,
                                 fontSize: 10, textColor: Colors.white, shadowColor: Colors.white, shadowOffset: Offset(0.0, 0.0),
                               ),
                                 SizedBox(height: 10),
                                 SingleChildScrollView(
                                   scrollDirection: Axis.horizontal,
                                   child: Row(
                                     children: genreCounts.keys.map((genre) {
                                       final color = Colors.primaries[genres.indexWhere((g) => g.name == genre) % Colors.primaries.length];
                                       return Padding(
                                         padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                         child: GestureDetector(
                                           onTap: () {
                                             final selectedPercentage1 = _selectedGenresPercentages1[genre];
                                             final percentageString1 = selectedPercentage1 != null ? "${NumberFormat("0.00").format(selectedPercentage1)}%" : "N/A";
                                             final selectedPercentage2 = _selectedGenresPercentages2[genre];
                                             final percentageString2 = selectedPercentage2 != null ? "${NumberFormat("0.00").format(selectedPercentage2)}%" : "N/A";
                                             setState(() {
                                               _selectedGenreInfo = '$genre: Percentage of movies per genre: $percentageString1, Percentage popularity of this genre: $percentageString2'; // Mettre à jour l'info sélectionnée


                                             });
                                           },
                                           child: Chip(
                                             label: Text(genre),
                                             backgroundColor: color,
                                           ),
                                         ),
                                       );
                                     }).toList(),
                                   ),
                                 ),
                                 SizedBox(height: 20),
                               ]
                           ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text("No data"));
          }
        },
      ),
    );
  }
}
