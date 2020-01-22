import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import './values.dart';

// This is called "ratings" in the backend.
class Review {
  final String id;
  final String userId;
  final double rating;
  final String text;
  final String userName;
  final Timestamp timestamp;

  final DocumentReference reference;

  Review.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.documentID,
        rating = snapshot['rating'].toDouble(),
        text = snapshot['text'],
        userName = snapshot['userName'],
        userId = snapshot['userId'],
        timestamp = snapshot['timestamp'],
        reference = snapshot.reference;

  Review.fromUserInput({this.rating, this.text, this.userName, this.userId})
      : id = null,
        timestamp = null,
        reference = null;

  factory Review.random({String userName, String userId}) {
    int rating = Random().nextInt(4) + 1;
    String review = getRandomReviewText(rating);
    return Review.fromUserInput(
        rating: rating.toDouble(),
        text: review,
        userName: userName,
        userId: userId);
  }
}
