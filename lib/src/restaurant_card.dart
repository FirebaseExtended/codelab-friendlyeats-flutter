import 'package:flutter/material.dart';

import './model/restaurant.dart';

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
        height: 300,
        child: Column(
          children: <Widget>[
            // TODO: Make this a Hero widget so we can transition to it
            Container(
                height: 180,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://picsum.photos/seed/${restaurant.id}/1000'),
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
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                        Text('\$\$\$'),
                      ],
                    ),
                    Expanded(
                        child: Container(
                      color: Colors.blue,
                      alignment: Alignment.centerLeft,
                      child: Text('*****'),
                    )),
                    Expanded(
                        child: Container(
                            color: Colors.red,
                            child: Text('Thai ● Seattle'),
                            alignment: Alignment.bottomLeft)),
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
