import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'stt_panel.dart';
import 'tts_panel.dart';

class MainPanel extends StatefulWidget {
  MainPanel({Key? key}) : super(key: key);

  @override
  _MainPanelState createState() => _MainPanelState();
}

class _MainPanelState extends State<MainPanel> {
  int _selectedIndex = 0; //selezione della BottomBar

  static const List<Widget> _options = <Widget>[
    STTPanel(), //pannelli/selezioni disponibili
    TTSPanel(),
  ];

  @override
  void initState() {
    //fisso la rotazione dello schermo in verticale
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _options.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                label: 'STT',
                icon: Icon(Icons.mic),
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
              label: 'TTS',
              icon: Icon(Icons.volume_up),
              backgroundColor: Colors.white,
            ),
          ],
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12.0,
          unselectedFontSize: 12.0,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          iconSize: 30.0,
          onTap: _onItemTap,
          elevation: 5),
    );
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index; //al Tap cambio la selezione nella BottomBar
    });
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }
}
