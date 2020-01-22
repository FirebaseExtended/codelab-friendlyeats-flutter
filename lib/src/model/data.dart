import 'package:cloud_firestore/cloud_firestore.dart';

import './filter.dart';
import './restaurant.dart';
import './review.dart';

// This is the file that Codelab users will primarily work on.

Future<void> addRestaurant(Restaurant restaurant) async {
  CollectionReference restaurants =
      Firestore.instance.collection('restaurants');
  return restaurants.add({
    'avgRating': restaurant.avgRating,
    'category': restaurant.category,
    'city': restaurant.city,
    'name': restaurant.name,
    'numRatings': restaurant.numRatings,
    'photo': restaurant.photo,
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

List<Restaurant> getRestaurantsFromQuery(QuerySnapshot snapshot) {
  return snapshot.documents.map((DocumentSnapshot doc) {
    return Restaurant.fromSnapshot(doc);
  }).toList();
}

Future<void> addRestaurantsBatch(List<Restaurant> restaurants) async {
  // TODO: Make this faster by using a write batch.
  // restaurants.forEach((Restaurant restaurant) async {
  //   await addRestaurant(restaurant);
  // });
  CollectionReference collection = Firestore.instance.collection('restaurants');
  WriteBatch batch = Firestore.instance.batch();
  // Add each restaurant to the batch, and commit all of them at the same time.
  restaurants.forEach((Restaurant restaurant) {
    batch.setData(collection.document(), {
      'avgRating': restaurant.avgRating,
      'category': restaurant.category,
      'city': restaurant.city,
      'name': restaurant.name,
      'numRatings': restaurant.numRatings,
      'photo': restaurant.photo,
      'price': restaurant.price,
    });
  });
  return batch.commit();
}

Future<Restaurant> getRestaurant(String restaurantId) {
  return Firestore.instance
      .collection('restaurants')
      .document(restaurantId)
      .get()
      .then((DocumentSnapshot doc) => Restaurant.fromSnapshot(doc));
}

Future<void> addReview({String restaurantId, Review review}) {
  DocumentReference restaurant =
      Firestore.instance.collection('restaurants').document(restaurantId);
  DocumentReference newReview = restaurant.collection('ratings').document();

  return Firestore.instance.runTransaction((Transaction transaction) {
    return transaction
        .get(restaurant)
        .then((DocumentSnapshot doc) => Restaurant.fromSnapshot(doc))
        .then((Restaurant fresh) {
      int newRatings = fresh.numRatings + 1;
      double newAverage =
          ((fresh.numRatings * fresh.avgRating) + review.rating) / newRatings;

      transaction.update(restaurant, {
        'numRatings': newRatings,
        'avgRating': newAverage,
      });

      return transaction.set(newReview, {
        'rating': review.rating,
        'text': review.text,
        'userName': review.userName,
        'timestamp': review.timestamp ?? FieldValue.serverTimestamp(),
        'userId': review.userId,
      });
    });
  });
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
