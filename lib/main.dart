import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BasicGridWidget(),
    ),
  );
}
class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List<Map<String, dynamic>> titlesAndPosters = [];

  @override
  void initState() {
    super.initState();
    fetchMovieData();
  }

  Future<void> fetchMovieData() async {
    final response = await http.get(Uri.parse('http://localhost:3000'));
    if (response.statusCode == 200) {
      setState(() {
        titlesAndPosters = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load movie data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: titlesAndPosters.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(titlesAndPosters[index]['original_title']),
          leading: Image.network(titlesAndPosters[index]['poster_path']),
        );
      },
    );
  }
}

class BasicGridWidget extends StatelessWidget {
  const BasicGridWidget({super.key});
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
              /*child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  crossAxisCount: 5,
                ),
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) => buildImageCard(index),
              ),*/


              height: MediaQuery.of(context).size.height * 0.25,
              child: Container(
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 20.0,
                    ),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ImageCarouselSlider();
                    }
                ),
              ),

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
            top: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: ModernCarousel(),
            ),
          ),
//   LE GROS CARRE BLANC FAIT PAR IRENE (en vrai faudra juste le revoir donc je l'ai mis en commentaire)
/*
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
*/
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




class BasicWhiteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Card Title',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Card Content goes here.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class ImageCarouselSlider extends StatelessWidget {
  const ImageCarouselSlider({Key? key}) : super(key: key);

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
            8,
                (index) => buildImageCard(index), // Use buildImageCard function to create items
          ),
        ),
      ),
    );
  }
}

class ModernCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height / 2,
        autoPlay: true,
        enlargeCenterPage: true,
      ),
      items: [
        {
          'image': 'https://example.com/image1.jpg',
          'title': 'Movie 1',
        },
        {
          'image': 'https://example.com/image2.jpg',
          'title': 'Movie 2',
        }
      ].map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Movie Title', // Add your movie title here
                    style: TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(height: 10.0),
                  Image.network(
                    item['image']!, // Use item['image'] as image URL
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
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
