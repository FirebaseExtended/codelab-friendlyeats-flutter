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

import 'dart:math' as math;

import 'package:flutter/material.dart';

import './model/values.dart' as hardcoded;
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
      _category = filter.category;
      _city = filter.city;
      _price = filter.price;
      _sort = filter.sort;
    }
  }

  String _category;
  String _city;
  int _price;
  String _sort;

  Widget _buildDropdown<T>(
      List labels, List values, dynamic selected, Function onChanged) {
    final items = [];
    for (var i = 0; i < values.length; i++) {
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

  Widget _buildCategoryDropdown({String selected, Function onChanged}) {
    final values = [null, ...hardcoded.categories];
    final labels = ['Any Cuisine', ...hardcoded.categories];
    return _buildDropdownRow<String>(
      labels: labels,
      values: values,
      selected: selected,
      icon: Icons.fastfood,
      onChanged: onChanged,
    );
  }

  Widget _buildCityDropdown({String selected, Function onChanged}) {
    final values = [null, ...hardcoded.cities];
    final labels = ['Any Location', ...hardcoded.cities];
    return _buildDropdownRow<String>(
      labels: labels,
      values: values,
      selected: selected,
      icon: Icons.location_on,
      onChanged: onChanged,
    );
  }

  Widget _buildPriceDropdown({int selected, Function onChanged}) {
    final values = [null, 1, 2, 3, 4];
    final labels = ['Any Price', '\$', '\$\$', '\$\$\$', '\$\$\$\$'];
    return _buildDropdownRow<int>(
      labels: labels,
      values: values,
      selected: selected,
      icon: Icons.monetization_on,
      onChanged: onChanged,
    );
  }

  Widget _buildSortDropdown({String selected, Function onChanged}) {
    final values = ['avgRating', 'numRatings'];
    final labels = ['Rating', 'Reviews'];
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
            _buildCategoryDropdown(
                selected: _category,
                onChanged: (String value) {
                  setState(() {
                    _category = value;
                  });
                }),
            _buildCityDropdown(
                selected: _city,
                onChanged: (String value) {
                  setState(() {
                    _city = value;
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
                category: _category,
                city: _city,
                price: _price,
                sort: _sort,
              )),
        ),
      ],
    );
  }
}
