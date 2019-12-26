import 'package:flutter/material.dart';
import 'package:rating_bar/rating_bar.dart';

class StarRating extends StatelessWidget {
  StarRating({
    this.rating,
    small = false,
  }) : this.small = small;

  final double rating;
  final bool small;

  @override
  Widget build(BuildContext context) {
    Color widgetColor = small ? Colors.white : Colors.amber;
    double size = small ? 16 : 24;

    return RatingBar.readOnly(
      maxRating: 5,
      initialRating: rating,
      isHalfAllowed: true,
      halfFilledIcon: Icons.star_half,
      filledIcon: Icons.star,
      emptyIcon: Icons.star_border,
      filledColor: widgetColor,
      emptyColor: widgetColor,
      halfFilledColor: widgetColor,
      size: size,
    );
  }
}
