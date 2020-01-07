import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import './values.dart';

// This is called "ratings" in the backend.
class Review {
  final String id;
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
        timestamp = snapshot['timestamp'],
        reference = snapshot.reference;

  Review.fromUserInput({this.rating, this.text})
      : id = null,
        userName = null,
        timestamp = Timestamp.now(),
        reference = null;

  factory Review.random() {
    int rating = Random().nextInt(4) + 1;
    String review = getRandomReviewText(rating);
    return Review.fromUserInput(rating: rating.toDouble(), text: review);
  }
}
