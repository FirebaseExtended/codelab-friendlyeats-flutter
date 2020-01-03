import 'dart:math' as math;

import 'package:flutter/material.dart';

import './model/data.dart' as data;
import './model/filter.dart';

class FilterDialog extends StatefulWidget {
  FilterDialog({Key key, Filter filter})
      : _filter = filter,
        super(key: key);

  final Filter _filter;

  @override
  _FilterDialogState createState() => _FilterDialogState(filter: _filter);
}

class _FilterDialogState extends State<FilterDialog> {
  _FilterDialogState({Filter filter}) {
    if (filter != null && !filter.isDefault) {
      _cuisine = filter.cuisine;
      _location = filter.location;
      _price = filter.price;
      _sort = filter.sort;
    }
  }

  String _cuisine;
  String _location;
  int _price;
  String _sort;

  Widget _buildDropdown<T>(
      List labels, List values, dynamic selected, Function onChanged) {
    List<DropdownMenuItem<T>> items = [];
    for (int i = 0; i < values.length; i++) {
      items.add(DropdownMenuItem<T>(value: values[i], child: Text(labels[i])));
    }
    return DropdownButton<T>(
      items: items,
      isExpanded: true,
      value: selected,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownRow<T>(
      {List<T> values,
      List<String> labels,
      T selected,
      IconData icon,
      Function onChanged}) {
    return Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Icon(icon),
      Expanded(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
          child: _buildDropdown<T>(labels, values, selected, onChanged),
        ),
      ),
    ]);
  }

  Widget _buildCuisineDropdown({String selected, Function onChanged}) {
    List<String> values = [null, ...data.cuisines];
    List<String> labels = ['Any Cuisine', ...data.cuisines];
    return _buildDropdownRow<String>(
      labels: labels,
      values: values,
      selected: selected,
      icon: Icons.fastfood,
      onChanged: onChanged,
    );
  }

  Widget _buildLocationDropdown({String selected, Function onChanged}) {
    List<String> values = [null, ...data.locations];
    List<String> labels = ['Any Location', ...data.locations];
    return _buildDropdownRow<String>(
      labels: labels,
      values: values,
      selected: selected,
      icon: Icons.location_on,
      onChanged: onChanged,
    );
  }

  Widget _buildPriceDropdown({int selected, Function onChanged}) {
    List<int> values = [null, 1, 2, 3, 4];
    List<String> labels = ['Any Price', '\$', '\$\$', '\$\$\$', '\$\$\$\$'];
    return _buildDropdownRow<int>(
      labels: labels,
      values: values,
      selected: selected,
      icon: Icons.monetization_on,
      onChanged: onChanged,
    );
  }

  Widget _buildSortDropdown({String selected, Function onChanged}) {
    List<String> values = ['avgRating', 'numRatings'];
    List<String> labels = ['Rating', 'Reviews'];
    return _buildDropdownRow<String>(
      labels: labels,
      values: values,
      selected: selected,
      icon: Icons.sort,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.filter_list),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
            child: Text('Filter'),
          ),
        ],
      ),
      content: Container(
        width: math.min(MediaQuery.of(context).size.width, 740),
        height: math.min(MediaQuery.of(context).size.height, 200),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildCuisineDropdown(
                selected: _cuisine,
                onChanged: (String value) {
                  setState(() {
                    _cuisine = value;
                  });
                }),
            _buildLocationDropdown(
                selected: _location,
                onChanged: (String value) {
                  setState(() {
                    _location = value;
                  });
                }),
            _buildPriceDropdown(
                selected: _price,
                onChanged: (int value) {
                  setState(() {
                    _price = value;
                  });
                }),
            _buildSortDropdown(
                selected: _sort ?? 'avgRating',
                onChanged: (String value) {
                  setState(() {
                    _sort = value;
                  });
                }),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CLEAR ALL'),
          onPressed: () => Navigator.pop(context, Filter()),
        ),
        RaisedButton(
          child: Text('ACCEPT'),
          onPressed: () => Navigator.pop(
              context,
              Filter(
                cuisine: _cuisine,
                location: _location,
                price: _price,
                sort: _sort,
              )),
        ),
      ],
    );
  }
}
