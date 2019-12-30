import 'package:flutter/material.dart';

import './model/review.dart';
import './restaurant_star_rating.dart';

class RestaurantReview extends StatelessWidget {
  RestaurantReview({
    this.review,
  });

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Colors.grey,
          width: 1,
          style: BorderStyle.solid,
        ))),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    review.userName,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                StarRating(rating: review.rating, size: 16),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Text(review.text ?? ''),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
