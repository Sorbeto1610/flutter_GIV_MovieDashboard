import 'package:flutter/material.dart';
import 'package:giv/piechartHolderPage.dart';
import 'package:giv/trendingMoviesVertical.dart';
import 'trendingMovies.dart';
import 'genreGraph.dart';
import 'movieComparator.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red, // Décors en rouge
          backgroundColor: Colors.black, // Fond en noir
          brightness: Brightness.dark, // Thème sombre pour le contraste
        ),
      ),
      title: "Project GIV",
      debugShowCheckedModeBanner: false,
      home: BasicGridWidget(),
    ),
  );
}

class BasicGridWidget extends StatefulWidget {
  @override
  _BasicGridWidgetState createState() => _BasicGridWidgetState();
}

class _BasicGridWidgetState extends State<BasicGridWidget> {
  bool _showGif = true;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    // Définir un délai avant de masquer le GIF
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _showGif = false;
        _showContent = true; // Afficher le contenu après la fin du GIF
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: _showGif
            ? Stack(
          children: [
            Container(
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
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset('assets/clap.gif'),
            ),

          ],
        )
            : _showContent
            ? Column(
          children: <Widget>[
            Container(
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
              height: MediaQuery.of(context).size.height *
                  MediaQuery.of(context).size.width /
                  (2.7*MediaQuery.of(context).size.width + 1.7*MediaQuery.of(context).size.height),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double screenWidth = constraints.maxWidth;
                    final int crossAxisCount = (screenWidth / (200 + 10)).floor()
                        .floor(); // Adjust itemWidth and crossAxisSpacing according to your needs
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 0.0,
                        crossAxisSpacing: 30.0,
                      ),
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return TrendingMoviesVerticalHomePage();
                      },
                    );
                  },
                ),
            ),
            SizedBox(height: 20),
            ResponsiveTitle(
              text: "The Movie Database",
              fontSize: 50.0,
              textColor: Colors.white,
              shadowColor1: Colors.red,
              shadowOffset1: Offset(2.0, 2.0),
              shadowColor2: Colors.redAccent,
              shadowOffset2: Offset(1.0, 1.0),
            ),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height / 1.55,
              child: TrendingMoviesHomePage(),
            ),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height,
              child: MovieComparisonSelector(),
            ),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height,

              child: PiechartHolderPage(),
            ),
            SizedBox(height: 20),
            Container(
              height: MediaQuery.of(context).size.height,
              child: BarChartSample1(),
            ),
          ],
        )
            : Container(), // Si _showGif et _showContent sont faux, ne rien afficher
      ),
    );
  }
}

class ResponsiveTitle extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final Color shadowColor1;
  final Color shadowColor2;
  final Offset shadowOffset1;
  final Offset shadowOffset2;

  ResponsiveTitle({
    required this.text,
    required this.fontSize,
    required this.textColor,
    required this.shadowColor1,
    required this.shadowColor2,
    required this.shadowOffset1,
    required this.shadowOffset2,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double responsiveFontSize = screenWidth * fontSize / 1000.0;
    Offset responsiveShadowOffset1 = shadowOffset1*responsiveFontSize/20;
    Offset responsiveShadowOffset2 = shadowOffset2*responsiveFontSize/20;

    return Text(
      text,
      style: TextStyle(
        fontSize: responsiveFontSize,
        color: textColor,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            color: shadowColor1,
            offset: responsiveShadowOffset1,
          ),
          Shadow(
            color: shadowColor2,
            offset: responsiveShadowOffset2,
          ),
        ],
      ),
    );
  }
}
