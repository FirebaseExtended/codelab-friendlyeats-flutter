// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:cloud_firestore/cloud_firestore.dart';

import './filter.dart';
import './restaurant.dart';
import './review.dart';

// This is the file that Codelab users will primarily work on.

Future<void> addRestaurant(Restaurant restaurant) {
  // TODO: Complete the "Add restaurants to Firestore" step.
  return Future.value();
}

Stream<QuerySnapshot> loadAllRestaurants() {
  // TODO: Complete the "Display data from Cloud Firestore" step.
  return Stream<QuerySnapshot>.value(null);
}

List<Restaurant> getRestaurantsFromQuery(QuerySnapshot snapshot) {
  // TODO: Complete the "Display data from Cloud Firestore" step.
  return [];
}

Future<Restaurant> getRestaurant(String restaurantId) {
  // TODO: Complete the "Get data" step.
  return Future.value(null);
}

Future<void> addReview({String restaurantId, Review review}) {
  // TODO: Complete the "Write data in a transaction" step.
  return Future.value();
}

Stream<QuerySnapshot> loadFilteredRestaurants(Filter filter) {
  // TODO: Complete the "Sorting and filtering data" step.
  return Stream<QuerySnapshot>.value(null);
}

void addRestaurantsBatch(List<Restaurant> restaurants) {
  restaurants.forEach((Restaurant restaurant) {
    addRestaurant(restaurant);
  });
}
