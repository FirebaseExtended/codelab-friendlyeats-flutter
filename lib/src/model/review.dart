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
        id = snapshot.id,
        rating = snapshot.data()['rating'].toDouble(),
        text = snapshot.data()['text'],
        userName = snapshot.data()['userName'],
        userId = snapshot.data()['userId'],
        timestamp = snapshot.data()['timestamp'],
        reference = snapshot.reference;

  Review.fromUserInput({this.rating, this.text, this.userName, this.userId})
      : id = null,
        timestamp = null,
        reference = null;

  factory Review.random({String userName, String userId}) {
    final rating = Random().nextInt(4) + 1;
    final review = getRandomReviewText(rating);
    return Review.fromUserInput(
        rating: rating.toDouble(),
        text: review,
        userName: userName,
        userId: userId);
  }
}
