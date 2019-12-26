import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

import './restaurant_card.dart';

const double _kMinSpacingPx = 16;
const double _kCardWidth = 360;

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
      // ResponsiveGridList crashes if desiredItemWidth + 2*minSpacing > Device window on Android
      desiredItemWidth: math.min(_kCardWidth,
          MediaQuery.of(context).size.width - (2 * _kMinSpacingPx)),
      minSpacing: _kMinSpacingPx,
      children: _restaurants
          .map((restaurant) => RestaurantCard(
                name: restaurant,
                onRestaurantPressed: _onRestaurantPressed,
              ))
          .toList(),
    );
  }
}
