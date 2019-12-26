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
        height: 270,
        child: Column(
          children: <Widget>[
            // TODO: Make this a Hero widget so we can transition to it
            Container(
                height: 180,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(restaurant.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: null),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            restaurant.name,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                        Text(
                          List.filled(restaurant.price, "\$").join(),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: 120,
                        alignment: Alignment.bottomLeft,
                        child: StarRating(
                          rating: restaurant.rating,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          '${restaurant.cuisine} ● ${restaurant.location}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
