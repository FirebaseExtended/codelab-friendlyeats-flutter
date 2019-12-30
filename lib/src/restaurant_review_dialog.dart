import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import './model/review.dart';

class RestaurantReviewDialog extends StatefulWidget {
  RestaurantReviewDialog({Key key}) : super(key: key);

  @override
  _RestaurantReviewDialogState createState() => _RestaurantReviewDialogState();
}

class _RestaurantReviewDialogState extends State<RestaurantReviewDialog> {
  double rating = 0;
  String review;

  @override
  Widget build(BuildContext context) {
    Color color = rating == 0 ? Colors.grey : Colors.amber;
    return AlertDialog(
      title: Text('Add a Review'),
      content: Container(
        width: math.min(MediaQuery.of(context).size.width, 740),
        height: math.min(MediaQuery.of(context).size.height, 180),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: SmoothStarRating(
                starCount: 5,
                rating: rating,
                color: color,
                borderColor: Colors.grey,
                size: 32,
                onRatingChanged: (double value) {
                  setState(() {
                    rating = value;
                  });
                },
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration.collapsed(
                    hintText: 'Type your review here.'),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (String value) {
                  setState(() {
                    review = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context, null),
        ),
        RaisedButton(
            child: Text('SAVE'),
            onPressed: () => Navigator.pop(
                context, Review.fromUserInput(rating: rating, text: review))),
      ],
    );
  }
}
