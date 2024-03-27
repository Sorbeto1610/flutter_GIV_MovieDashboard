import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'movie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'api-config.dart';

class VerticalCarouselPoster extends StatelessWidget {
  final List<Movie> movieList;

  const VerticalCarouselPoster({required this.movieList});

  @override
  Widget build(BuildContext context) {
    if (movieList.isEmpty) {
      return Container(
        // Return an empty container or some other placeholder widget
        child: Text(' '),
      );
    }

    // Mélanger la liste de films
    movieList.shuffle();

    return SizedBox(
      height: MediaQuery.of(context).size.height,

        child: ShaderMask(
    shaderCallback: (Rect bounds) {
    return LinearGradient(
    colors: [Colors.black, Colors.transparent,Colors.transparent, Colors.black],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    ).createShader(bounds);
    },
    blendMode: BlendMode.dstOut, // Use dstOut blend mode for transparency
    child: CarouselSlider.builder(
      itemCount: movieList.length,
      options: CarouselOptions(
        scrollDirection: Axis.vertical,
        height: MediaQuery.of(context).size.height,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 2),
        autoPlayAnimationDuration: Duration(milliseconds: 2000),
        autoPlayCurve: Curves.linear,
        enlargeCenterPage: true,
      ),
      itemBuilder: (context, index, realIndex) {
        final movie = movieList[index];
        return Container(

          child: Stack(
            alignment: Alignment.bottomCenter, // Align the title text at the bottom
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: '${ApiConfig.imageBaseUrl}${movie.posterPath}',
                  placeholder: (context, url) => Image.asset('assets/clap.gif'),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),

            ],
          ),
        );
      },
    ),
    ),
    );

  }
}