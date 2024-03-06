
import 'package:flutter/material.dart';//un truc qu'on installe par defaut
//le package pour pouvoir avoir a grid
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(
      MaterialApp(
          debugShowCheckedModeBanner: false,//pour enlever le truc en mode debug
          home:BasicGridWidget()//trouve le code dans BASIC GRID WIDGET
      ),
  );
}


class BasicGridWidget extends StatelessWidget {
  const BasicGridWidget();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text("GIV SUPERBOWL WEBSITE"),
  ),


      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10, //le spacing entre deux lignes
          crossAxisSpacing: 10, //le spacing entre colonne
          crossAxisCount: 4, //le nombre de colonne

        ),
        itemCount: 50, //nombre de item que je veux dans ma grid view
        itemBuilder: (context, index) =>
            buildImageCard(index), //ici c'est pour fill les grid avec ces elements
      )
  );

  }

  Widget buildImageCard(int index) =>
      Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child:Directionality(
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