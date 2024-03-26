import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageCarouselSlider extends StatelessWidget {
  const ImageCarouselSlider({super.key});

  Widget buildImageCard(int index) => Card(
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        margin: EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://source.unsplash.com/random?sig=$index',
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double widgetHeight = screenHeight / 20; // 1/20 of the screen width

    return SizedBox(
      height: widgetHeight,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [Colors.black, Colors.transparent, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstOut, // Use dstOut blend mode for transparency
        child: CarouselSlider(
          options: CarouselOptions(
            scrollDirection: Axis.vertical,
            height: widgetHeight, // Set the height of the carousel
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 3000),
            autoPlayCurve: Curves.linear,
            enlargeCenterPage: true,
          ),
          items: List.generate(
            10,
                (index) {
              int index = Random().nextInt(15);
              return buildImageCard(index);
            },// Use buildImageCard function to create items
          ),
        ),
      ),
    );
  }
}