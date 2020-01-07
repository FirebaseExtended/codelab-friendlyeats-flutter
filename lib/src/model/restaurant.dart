import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import './values.dart';

class Restaurant {
  final String id;
  final String name;
  final String category;
  final String location;
  final double rating;
  final int numRatings;
  final int price;
  final String imageUrl;
  final DocumentReference reference;

  Restaurant._(
      {this.name, this.category, this.location, this.price, this.imageUrl})
      : id = null,
        numRatings = 0,
        rating = 0,
        reference = null;

  Restaurant.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.documentID,
        name = snapshot['name'],
        category = snapshot['category'],
        location = snapshot['city'],
        rating = snapshot['avgRating'].toDouble(),
        numRatings = snapshot['numRatings'],
        price = snapshot['price'],
        imageUrl = snapshot['photo'],
        reference = snapshot.reference;

  factory Restaurant.random() {
    return Restaurant._(
      category: getRandomCategory(),
      location: getMockCity(),
      name: getMockName(),
      price: Random().nextInt(3) + 1,
      imageUrl: getMockImageUrl(),
    );
  }
}
