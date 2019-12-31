import 'dart:math' as math;

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
    double imageSize = math.min(600, MediaQuery.of(context).size.width);
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
