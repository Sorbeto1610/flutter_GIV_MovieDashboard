import 'package:flutter/material.dart';
import 'dart:math';
import 'movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'api-config.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MoviePopup extends StatelessWidget {
  final String randomText;

  const MoviePopup({required this.randomText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Titre du film'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Description: $randomText'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Fermer'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class MovieCarouselView extends StatefulWidget {
  final List<Movie> movieList;

  const MovieCarouselView({required this.movieList});

  @override
  _MovieCarouselViewState createState() => _MovieCarouselViewState();
}

class _MovieCarouselViewState extends State<MovieCarouselView> {
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.movieList.isEmpty) {
      return Container(
        child: Text('Aucun film disponible'),
      );
    }

    int numberOfItems = (MediaQuery.of(context).size.width / 200).floor();

    return CarouselSlider.builder(
      itemCount: widget.movieList.length,
      options: CarouselOptions(
        height: 300,
        viewportFraction: 1 / numberOfItems.toDouble(),
        enableInfiniteScroll: true,
        autoPlay: true,
      ),
      itemBuilder: (context, index, realIndex) {
        final movie = widget.movieList[index];
        return GestureDetector(
          onTap: () {
            final random = Random();
            final randomText = 'Texte aléatoire ${random.nextInt(100)}';
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return MoviePopup(randomText: randomText);
              },
            );
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            transform: Matrix4.identity()
              ..translate(-400.0 * (hoveredIndex == index ? 0.05 : 0.0), -400.0 * (hoveredIndex == index ? 0.05 : 0.0)) // Translate to the center
              ..scale(1.0 + (hoveredIndex == index ? 0.2 : 0.0)), // Apply scale transformation
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 40), // Ajout du padding en bas
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      hoveredIndex = index;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      hoveredIndex = null;
                    });
                  },
                  child: CachedNetworkImage(
                    imageUrl: '${ApiConfig.imageBaseUrl}${movie.posterPath}',
                    fit: BoxFit.cover, // Utilisation de BoxFit.cover pour adapter l'image
                    placeholder: (context, url) => Image.asset('assets/clap.gif'),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),


          ),


        );
      },
    );
  }
}
