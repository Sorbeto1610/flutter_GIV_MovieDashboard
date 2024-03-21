import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'api-config.dart';

class MovieCarouselView extends StatelessWidget {
  final List<Movie> movies;

  const MovieCarouselView({required this.movies});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Container(
        // Return an empty container or some other placeholder widget
        child: Text('No movies available'),
      );
    }

    return CarouselSlider.builder(
      itemCount: movies.length,
      options: CarouselOptions(
        height: 300, // Adjust the height as needed
        viewportFraction: 0.2,
        enableInfiniteScroll: true,
        autoPlay: true,
      ),
      itemBuilder: (context, index, realIndex) {
        final movie = movies[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            alignment: Alignment.bottomCenter, // Align the title text at the bottom
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: '${ApiConfig.imageBaseUrl}${movie.posterPath}',
                  width: 200,
                  height: 300,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Text(
                  movie.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
