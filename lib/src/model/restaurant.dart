import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import './random.dart';

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

  Restaurant._(
      {this.name, this.cuisine, this.location, this.price, this.imageUrl})
      : id = null,
        numRatings = 0,
        rating = 0,
        reference = null;

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

  factory Restaurant.random() {
    return Restaurant._(
      cuisine: getMockCuisine(),
      location: getMockCity(),
      name: getMockName(),
      price: Random().nextInt(3) + 1,
      imageUrl: getMockImageUrl(),
    );
  }
}
