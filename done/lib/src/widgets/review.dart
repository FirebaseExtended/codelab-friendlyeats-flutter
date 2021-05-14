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

import 'package:flutter/material.dart';

import '../model/review.dart';
import 'stars.dart';

class RestaurantReview extends StatelessWidget {
  RestaurantReview({
    this.review,
  });

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
        padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Colors.grey,
          width: 1,
          style: BorderStyle.solid,
        ))),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    review.userName,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                StarRating(rating: review.rating, size: 16),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Text(review.text ?? ''),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
