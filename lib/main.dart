import 'package:flutter/material.dart';

import 'panels/main_panel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riconoscimento Vocale',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPanel(), //creo il pannello principale contenente STT e TTS
    );
  }
}
