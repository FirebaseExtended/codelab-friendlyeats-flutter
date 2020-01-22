import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import './model/review.dart';

class RestaurantReviewDialog extends StatefulWidget {
  final String _userName;
  final String _userId;

  RestaurantReviewDialog({String userName, String userId, Key key})
      : this._userName = userName,
        this._userId = userId,
        super(key: key);

  @override
  _RestaurantReviewDialogState createState() =>
      _RestaurantReviewDialogState(userName: _userName, userId: _userId);
}

class _RestaurantReviewDialogState extends State<RestaurantReviewDialog> {
  _RestaurantReviewDialogState({this.userName, this.userId});

  final String userName;
  final String userId;

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
                  if (this.mounted) {
                    setState(() {
                      rating = value;
                    });
                  }
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
                  if (this.mounted) {
                    setState(() {
                      review = value;
                    });
                  }
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
                context,
                Review.fromUserInput(
                    rating: rating,
                    text: review,
                    userId: userId,
                    userName: userName))),
      ],
    );
  }
}
