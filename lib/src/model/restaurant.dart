import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String id;
  final String name;
  final String cuisine;
  final String location;
  final double rating;
  final int numRatings;
  final int price;
  final String imageUrl;
  final DocumentReference reference;

  Restaurant.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.documentID,
        name = snapshot['name'],
        cuisine = snapshot['category'],
        location = snapshot['city'],
        rating = snapshot['avgRating'].toDouble(),
        numRatings = snapshot['numRatings'],
        price = snapshot['price'],
        imageUrl = snapshot['photo'],
        reference = snapshot.reference;
}
