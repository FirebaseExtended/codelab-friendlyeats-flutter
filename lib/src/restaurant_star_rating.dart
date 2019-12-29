import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class StarRating extends StatelessWidget {
  StarRating({
    this.rating,
    Color color = Colors.amber,
    double size = 24,
  }) : this.color = color, this.size = size;

  final double rating;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SmoothStarRating(
      starCount: 5,
      allowHalfRating: true,
      rating: rating,
      color: color,
      borderColor: color,
      size: size,
    );
  }
}
