import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'api-config.dart';

class MovieCarouselView extends StatelessWidget {
  final List<Movie> movieList;

  const MovieCarouselView({required this.movieList});

  @override
  Widget build(BuildContext context) {
    if (movieList.isEmpty) {
      return Container(
        // Return an empty container or some other placeholder widget
        child: Text('No movies available'),
      );
    }

    return CarouselSlider.builder(
      itemCount: movieList.length,
      options: CarouselOptions(
        height: 300, // Adjust the height as needed
        viewportFraction: 0.2,
        enableInfiniteScroll: true,
        autoPlay: true,
      ),
      itemBuilder: (context, index, realIndex) {
        final movie = movieList[index];
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
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
