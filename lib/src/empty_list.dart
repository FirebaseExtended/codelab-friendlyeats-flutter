import 'package:flutter/material.dart';

class EmptyListView extends StatelessWidget {
  EmptyListView({
    this.child,
    this.onPressed,
  });

  final Widget child;
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = 600;
    if (screenWidth < 640) {
      imageSize = screenWidth * .66;
    }
    return Center(child: Column(
      mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(width: imageSize, height: imageSize, child: Image.asset('assets/friendlyeater.png',),),
          child,
         RaisedButton(
              child: Text('ADD SOME'),
              onPressed: onPressed
            ),

        ],
    ),);
  }
}
