import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget with PreferredSizeWidget{
  String? title;
  final PreferredSizeWidget? bottom;

  SimpleAppBar({this.bottom,this.title});

  @override
  Size get preferredSize => bottom==null? Size(56, AppBar().preferredSize.height): Size(56,AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
      ),
      centerTitle: true,
      title: const Text(
          "HungerUp",
          style: TextStyle(fontSize: 45.0,
              letterSpacing: 3,
              color: Colors.white,
              fontFamily: "Signatra")
      ),
    );
  }
}