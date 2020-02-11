import 'package:flutter/material.dart';

import 'src/app.dart' deferred as app;

void main() {
  final Future<void> loadedLibrary = app.loadLibrary();
  runApp(
    FutureBuilder(
      future: loadedLibrary,
      builder: (snapshot, context) => app.FriendlyEatsApp(),
    ),
  );
}
