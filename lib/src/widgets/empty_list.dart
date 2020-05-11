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

typedef EmptyListActionButtonCallback = void Function();

class EmptyListView extends StatelessWidget {
  EmptyListView({
    this.child,
    this.onPressed,
  });

  final Widget child;
  final EmptyListActionButtonCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var imageSize = 600.0;
    if (screenWidth < 640 || screenHeight < 820) {
      imageSize = 300;
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: imageSize,
            height: imageSize,
            child: Image.asset(
              'assets/friendlyeater.png',
            ),
          ),
          child,
          RaisedButton(child: Text('ADD SOME'), onPressed: onPressed),
        ],
      ),
    );
  }
}
