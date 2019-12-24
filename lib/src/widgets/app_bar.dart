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

import '../model/restaurant.dart';
import 'stars.dart';

class RestaurantAppBar extends StatelessWidget {
  static final double appBarHeight = 160;

  RestaurantAppBar({
    this.restaurant,
    CloseRestaurantPressedCallback onClosePressed,
  }) : _onPressed = onClosePressed;

  final Restaurant restaurant;

  final CloseRestaurantPressedCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        onPressed: _onPressed,
        icon: Icon(Icons.close),
        iconSize: 32,
      ),
      expandedHeight: appBarHeight,
      forceElevated: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        title: Wrap(
          children: <Widget>[
            Text(
              restaurant.name,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 80,
                  alignment: Alignment.bottomLeft,
                  child: StarRating(
                    rating: restaurant.avgRating,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Text(
                    '\$' * restaurant.price,
                    style: TextStyle(
                        fontSize: Theme.of(context).textTheme.caption.fontSize),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                '${restaurant.category} ● ${restaurant.city}',
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.caption.fontSize),
              ),
            ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              restaurant.photo,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0x00000000),
                    const Color(0xAA000000),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
