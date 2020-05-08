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

import '../model/filter.dart';

const _kBold = TextStyle(fontWeight: FontWeight.bold);

class FilterBar extends StatelessWidget {
  FilterBar({@required VoidCallback onPressed, Filter filter})
      : _onPressed = onPressed,
        _filter = filter;

  final VoidCallback _onPressed;
  final Filter _filter;

  List<InlineSpan> _buildCategorySpans(Filter filter) {
    final widgets = <InlineSpan>[];
    if (filter == null || filter.isDefault || filter.category == null) {
      widgets.add(TextSpan(text: 'All Restaurants', style: _kBold));
    } else {
      widgets.add(TextSpan(text: '${filter.category}', style: _kBold));
      widgets.add(TextSpan(text: ' places'));
    }
    return widgets;
  }

  List<InlineSpan> _buildPriceSpans(Filter filter) {
    final widgets = <InlineSpan>[];
    if (filter.price != null) {
      widgets.add(TextSpan(text: ' of '));
      widgets.add(TextSpan(text: '\$' * filter.price, style: _kBold));
    }
    return widgets;
  }

  List<InlineSpan> _buildTitleSpans(Filter filter) {
    final widgets = <InlineSpan>[];
    widgets.addAll(_buildCategorySpans(filter));
    if (filter != null && !filter.isDefault) {
      widgets.addAll(_buildPriceSpans(filter));
    }
    return widgets;
  }

  List<InlineSpan> _buildCitySpans(Filter filter) {
    final widgets = <InlineSpan>[];
    if (filter.city != null) {
      widgets.add(TextSpan(text: 'in '));
      widgets.add(TextSpan(text: '${filter.city} ', style: _kBold));
    }
    return widgets;
  }

  List<InlineSpan> _buildSubtitleSpans(Filter filter) {
    final widgets = <InlineSpan>[];
    if (filter != null) {
      widgets.addAll(_buildCitySpans(filter));
    }
    if (filter == null || filter.sort == null || filter.sort == 'avgRating') {
      widgets.add(TextSpan(text: 'by rating'));
    } else {
      widgets.add(TextSpan(text: 'by # reviews'));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.white,
      padding: EdgeInsets.all(6),
      onPressed: _onPressed,
      child: Row(
        children: <Widget>[
          Icon(Icons.filter_list),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText2,
                      children: _buildTitleSpans(_filter),
                    ),
                  ),
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.caption,
                      children: _buildSubtitleSpans(_filter),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
