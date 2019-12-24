import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

import './restaurant_card.dart';

class RestaurantGrid extends StatelessWidget {
  RestaurantGrid({
    @required Function onRestaurantPressed,
    @required List<String> restaurants,
  })  : _onRestaurantPressed = onRestaurantPressed,
        _restaurants = restaurants;

  final Function _onRestaurantPressed;
  final List<String> _restaurants;

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridList(
      // TODO: desiredItemWidth + 2*minSpacing must be < device width, or it'll crash android
      desiredItemWidth: 360, 
      minSpacing: 16,
      children: _restaurants
          .map((restaurant) => RestaurantCard(
                name: restaurant,
                onRestaurantPressed: _onRestaurantPressed,
              ))
          .toList(),
    );
  }
}
