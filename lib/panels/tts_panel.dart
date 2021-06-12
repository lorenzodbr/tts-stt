import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../dialogs/floating_dialog.dart';

class TTSPanel extends StatefulWidget {
  const TTSPanel({Key? key}) : super(key: key);

  @override
  _TTSPanelState createState() => _TTSPanelState();
}

class _TTSPanelState extends State<TTSPanel> {
  bool _isPlaying = false;
  late FlutterTts _flutterTts;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text to Speech'),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isPlaying,
        glowColor: Colors.black,
        endRadius: 80,
        duration: Duration(milliseconds: 700),
        repeatPauseDuration: Duration(milliseconds: 70),
        repeat: true,
        child: Container(
          width: 80.0,
          height: 80.0,
          child: FloatingActionButton(
            onPressed: () => onSpeak(context, textEditingController.text),
            child: Icon(_isPlaying ? Icons.stop : Icons.play_arrow, size: 30.0),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(30),
        child: TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Inserisci il testo da leggere',
            labelStyle: TextStyle(fontSize: 20.0),
          ),
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

  @override
  void initState() {
    initializeTts();
    super.initState();
  }

  initializeTts() {
    _flutterTts = FlutterTts();

    //handler di inizio riproduzione
    _flutterTts.setStartHandler(() {
      setState(() {
        _isPlaying = true;
      });
    });

    //handler di completamento della riproduzione
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isPlaying = false;
      });
    });

    //handler di errore
    _flutterTts.setErrorHandler((err) {
      setState(() {
        print('an error occurred: ' + err);
        _isPlaying = false;
      });
    });
  }

  void onSpeak(BuildContext context, String text) async {
    if (!_isPlaying) {
      if (text.isNotEmpty) {
        await _flutterTts.setLanguage('it-IT');
        await _flutterTts.setPitch(1);

        var result = await _flutterTts.speak(text);

        if (result == 1) {
          setState(() {
            _isPlaying = true;
          });
        }
      } else {
        FloatingDialog.showMyDialog(
          context,
          "Avviso",
          "Non è stato inserito alcun testo.",
          'OK',
        );
      }
    } else {
      var result = await _flutterTts.stop();

      if (result == 1) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    textEditingController.dispose();
    super.dispose();
  }
}
