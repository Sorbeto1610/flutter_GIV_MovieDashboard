import 'dart:ui';
import 'package:flutter/material.dart';
import 'movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'api-config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class MoviePopup extends StatelessWidget {
  final Movie movie;

  const MoviePopup({required this.movie});

  @override
  Widget build(BuildContext context) {
    double dialogWidth = MediaQuery.of(context).size.width * 0.7;
    double dialogHeight = MediaQuery.of(context).size.height * 0.7;
    double posterHeight = dialogHeight * 0.8;
    double posterWidth = posterHeight * 2 / 3;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded borders for the dialog box
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: dialogWidth,
        height: dialogHeight,
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  '${ApiConfig.imageBaseUrl}${movie.backdropPath}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Blur filter
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
                ),
              ),
            ),
            // Movie Poster
            Positioned(
              left: dialogWidth * 0.05,
              top: (dialogHeight - posterHeight) / 2,
              child: Container(
                width: posterWidth,
                height: posterHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: '${ApiConfig.imageBaseUrl}${movie.posterPath}',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset('assets/clap.gif'),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            // Text Content
            Positioned(
              left: dialogWidth * 0.4,
              top: dialogHeight * 0.275,
              child: SizedBox(
                width: dialogWidth * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Movie Title
                    Text(
                      movie.title,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Release Date
                    Text(
                      'Release Date: ${_formatReleaseDate(movie.releaseDate)}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    // Vote Average
                    Text(
                      'Vote Average:',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    _buildStarRating(movie.voteAverage),
                    SizedBox(height: 8),
                    // Overview
                    Text(
                      movie.overview,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            // Close Button
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white), // Red cross icon
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to format release date
  String _formatReleaseDate(String releaseDate) {
    final parsedDate = DateTime.parse(releaseDate);
    final formattedDate = DateFormat.yMMMMd('en_US').format(parsedDate);
    return formattedDate;
  }

  // Widget to build star rating
  Widget _buildStarRating(double voteAverage) {
    int numberOfStars = (voteAverage / 2).round();
    return Row(
      children: List.generate(
        5,
            (index) => Icon(
          index < numberOfStars ? Icons.star : Icons.star_border,
          color: Colors.yellow,
        ),
      ),
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
        height: 400,
        viewportFraction: 1 / numberOfItems.toDouble(),
        enableInfiniteScroll: true,
        autoPlay: true,
      ),
      itemBuilder: (context, index, realIndex) {
        final movie = widget.movieList[index];
        return Draggable<Movie>(
          data: movie,
          feedback: Container(
            width: 200, // Ajustez la taille selon vos besoins
            height: 300, // Ajustez la taille selon vos besoins
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: '${ApiConfig.imageBaseUrl}${movie.posterPath}',
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.asset('assets/clap.gif'),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MoviePopup(
                    movie: movie, // Passer l'objet Movie
                  );
                },
              );

            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              transform: Matrix4.identity()
                ..translate(-400.0 * (hoveredIndex == index ? 0.05 : 0.0), -400.0 * (hoveredIndex == index ? 0.05 : 0.0)),
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
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
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Image.asset('assets/clap.gif'),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
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
