import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'src/app.dart' deferred as app;

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final Future<void> loadedLibrary = await app.loadLibrary();
  runApp(
    FutureBuilder(
      future: loadedLibrary,
      builder: (snapshot, context) => app.FriendlyEatsApp(),
    ),
  );
}
