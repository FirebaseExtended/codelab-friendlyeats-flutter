import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final double rating;
  final String text;
  final String userName;
  // final DateTime timestamp; // This is DateTime for web, but Timestamp for mobile!!!

  final DocumentReference reference;

  Review.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.documentID,
        rating = snapshot['rating'].toDouble(),
        text = snapshot['text'],
        userName = snapshot['userName'],
        reference = snapshot.reference;

  Review.fromUserInput({this.rating, this.text})
      : id = null,
        userName = null,
        reference = null;
}
