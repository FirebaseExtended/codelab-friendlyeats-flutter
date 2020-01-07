import 'package:cloud_firestore/cloud_firestore.dart';

import './filter.dart';
import './restaurant.dart';
import './review.dart';

// This is the file that Codelab users will primarily work on.

Future<void> addRestaurant(Restaurant restaurant) async {
  CollectionReference restaurants =
      Firestore.instance.collection('restaurants');
  return restaurants.add({
    'avgRating': restaurant.rating,
    'category': restaurant.category,
    'city': restaurant.city,
    'name': restaurant.name,
    'numRatings': restaurant.numRatings,
    'photo': restaurant.imageUrl,
    'price': restaurant.price,
  });
}

Stream<QuerySnapshot> loadAllRestaurants() {
  return Firestore.instance
      .collection('restaurants')
      .orderBy('avgRating', descending: true)
      .limit(50)
      .snapshots();
}

Stream<QuerySnapshot> loadFilteredRestaurants(Filter filter) {
  Query collection = Firestore.instance.collection('restaurants');
  if (filter.category != null) {
    collection = collection.where('category', isEqualTo: filter.category);
  }
  if (filter.city != null) {
    collection = collection.where('city', isEqualTo: filter.city);
  }
  if (filter.price != null) {
    collection = collection.where('price', isEqualTo: filter.price);
  }
  return collection
      .orderBy(filter.sort ?? 'avgRating', descending: true)
      .limit(50)
      .snapshots();
}

List<Restaurant> getRestaurantsFromQuery(QuerySnapshot snapshot) {
  return snapshot.documents.map((DocumentSnapshot doc) {
    return Restaurant.fromSnapshot(doc);
  }).toList();
}

Stream<DocumentSnapshot> getRestaurant(String restaurantId) {
  return Firestore.instance
      .collection('restaurants')
      .document(restaurantId)
      .snapshots();
}

Future<void> addReview(
    {String restaurantId, String userId, String userName, Review review}) {
  CollectionReference collection = Firestore.instance.collection('restaurants');
  DocumentReference restaurant = collection.document(restaurantId);
  DocumentReference newReview = restaurant.collection('ratings').document();

  return Firestore.instance.runTransaction((Transaction transaction) {
    return transaction
        .get(restaurant)
        .then((DocumentSnapshot freshRestaurantSnapshot) {
      Restaurant freshRestaurant =
          Restaurant.fromSnapshot(freshRestaurantSnapshot);
      double newAverage =
          ((freshRestaurant.numRatings * freshRestaurant.rating) +
                  review.rating) /
              (freshRestaurant.numRatings + 1);
      transaction.update(restaurant, {
        'numRatings': freshRestaurant.numRatings + 1,
        'avgRating': newAverage,
      });

      return transaction.set(newReview, {
        'rating': review.rating,
        'text': review.text,
        'userName': userName,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': userId,
      });
    });
  });
}
