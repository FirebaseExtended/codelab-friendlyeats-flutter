import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './model/restaurant.dart';
import './restaurant_star_rating.dart';

class RestaurantCard extends StatelessWidget {
  RestaurantCard({
    this.restaurant,
    @required Function onRestaurantPressed,
  }) : _onPressed = onRestaurantPressed;

  final Restaurant restaurant;

  final Function _onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: () => _onPressed(restaurant.id),
      splashColor: Colors.blue.withAlpha(30),
      child: Container(
        height: 250,
        child: Column(
          children: <Widget>[
            // TODO: Make this a Hero widget so we can transition to it?
            Expanded(
              child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(restaurant.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: null),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                      Text(
                        List.filled(restaurant.price, "\$").join(),
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, (kIsWeb ? 0 : 2), 0, 4),
                    alignment: Alignment.bottomLeft,
                    child: StarRating(
                      rating: restaurant.rating,
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      '${restaurant.category} ● ${restaurant.location}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
