import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  FilterBar({@required VoidCallback onPressed}) : _onPressed = onPressed;

  final VoidCallback _onPressed;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontWeight: FontWeight.bold);
    // TODO: How to left-align this?
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
        child: FlatButton.icon(
          color: Colors.white,
          icon: Icon(Icons.filter_list),
          label: RichText(
              text: TextSpan(
            style: Theme.of(context).textTheme.body1,
            children: [
              TextSpan(text: 'You\'re seeing '),
              TextSpan(text: 'Some Selected Filters', style: style),
            ],
          )),
          onPressed: _onPressed,
        ),
      ),
    );
  }
}
