import 'package:flutter/material.dart';

import 'src/filter_bar.dart';
import 'src/model/restaurant.dart';
import 'src/restaurant_grid.dart';

void main() => runApp(FriendlyEatsApp());

class FriendlyEatsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FriendlyEats',
      home: FriendlyEatsHomePage(),
    );
  }
}

class FriendlyEatsHomePage extends StatefulWidget {
  FriendlyEatsHomePage({Key key}) : super(key: key);

  // Store the selected filter and sort configuration for firestore

  @override
  _FriendlyEatsHomePageState createState() => _FriendlyEatsHomePageState();
}

class _FriendlyEatsHomePageState extends State<FriendlyEatsHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.restaurant),
        title: Text('FriendlyEats'),
        bottom: PreferredSize(
          preferredSize: Size(100, 36),
          child: FilterBar(
            onPressed: () {
              print('TODO: Select filters');
            },
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1280),
          child: RestaurantGrid(
            restaurants: List<int>.generate(50, (i) => i)
                .map(
                  (i) => Restaurant(
                      id: (i + 1).toString(),
                      name: 'Restaurant#$i',
                      cuisine: "Thai",
                      location: "Seattle",
                      rating: 3.6,
                      price: 2,
                      imageUrl: 'https://picsum.photos/seed/${(i + 1)}/1000'),
                )
                .toList(),
            onRestaurantPressed: (name) =>
                print('Pressed on restaurant: $name'),
          ),
        ),
      ),
    );
  }
}
