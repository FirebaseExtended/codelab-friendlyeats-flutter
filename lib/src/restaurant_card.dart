import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  RestaurantCard({
    this.id, // For the Hero image and tap link
    this.name,
    this.cuisine,
    this.location,
    this.rating,
    this.price,
    this.imageUrl,
    @required Function onRestaurantPressed,
  }) : _onPressed = onRestaurantPressed;

  final String id;
  final String name;
  final String cuisine;
  final String location;
  final double rating;
  final int price;
  final String imageUrl;

  final Function _onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onPressed(name),
      child: Container(
        height: 200,
        alignment: Alignment(0, 0),
        // color: Colors.cyan,
        child: Text(name),
      ),
    );
  }
}
