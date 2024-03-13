import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:carousel_slider/carousel_slider.dart';



void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BasicGridWidget(),
    ),
  );
}

class BasicGridWidget extends StatelessWidget {
  const BasicGridWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(

        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
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
                boxShadow:  [
                  BoxShadow(
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  crossAxisCount: 5,
                ),
                itemCount: 50,
                itemBuilder: (context, index) => buildImageCard(index),
              ),
              height: MediaQuery.of(context).size.height * 0.25,
            ),
          ),
          Positioned(
            top:  MediaQuery.of(context).size.height / 4,
            left: MediaQuery.of(context).size.width / 3,
            child: ResponsiveText(
              text: "The Movie Database",
              fontSize: 24.0,
              textColor: Colors.white,
              shadowColor: Colors.grey,
              shadowOffset: Offset(2.0, 2.0),

            ),
          ),

          Positioned(
            height: MediaQuery.of(context).size.height/2,
            width: MediaQuery.of(context).size.width/3,
            top:  MediaQuery.of(context).size.height/2,
            left: 20,
            child: CarouselSlider(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.5,
              ),
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width/3,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                      ),
                      child: Text('text $i', style: TextStyle(fontSize: 16.0)),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          Positioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width/3,
            top:  MediaQuery.of(context).size.height/2,
            right: 20,
            child:Container(
              transform: Matrix4.translationValues(0, -90, 0),
              width: MediaQuery.of(context).size.width/3,
              height: MediaQuery.of(context).size.width/3,
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 22.0),
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),




        ],
      ),
    );
  }

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
}


class ResponsiveText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final Color shadowColor;
  final Offset shadowOffset;


  ResponsiveText({
    required this.text,
    required this.fontSize,
    required this.textColor,
    required this.shadowColor,
    required this.shadowOffset,

  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double responsiveFontSize = screenWidth * fontSize / 375.0;

    return Text(
      text,
      style: TextStyle(
        fontSize: responsiveFontSize,
        color: textColor,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.bold,

        shadows: [
          Shadow(
            color: shadowColor,
            offset: shadowOffset,

          ),
        ],
      ),
    );
  }
}




