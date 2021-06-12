import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../dialogs/floating_dialog.dart';

class STTPanel extends StatefulWidget {
  const STTPanel({Key? key}) : super(key: key);

  @override
  _STTPanelState createState() => _STTPanelState();
}

class _STTPanelState extends State<STTPanel> {
  late stt.SpeechToText _speech;
  bool _isListening = false;

  String _textSpeech = 'Premi sul microfono e comincia a parlare';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText(); //inizializzo lo STT
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Speech to Text'),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () {
                  FloatingDialog.showMyDialog(
                    context,
                    'Avviso',
                    "Il riconoscimento vocale di Android ha un timeout di disattivazione abbastanza breve dal momento in cui non rileva più una voce. Questo timeout varia da dispositivo a dispositivo, e da versione a versione di Android.\n\nPrestare dunque attenzione a questo aspetto.",
                    'Capito',
                  );
                }),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          //effetto glow attorno al Button
          animate: _isListening,
          glowColor: Colors.black,
          endRadius: 80,
          duration: Duration(milliseconds: 700),
          repeatPauseDuration: Duration(milliseconds: 70),
          repeat: true,
          child: Container(
            width: 80.0,
            height: 80.0,
            child: FloatingActionButton(
              onPressed: () => onListen(),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                size: 30.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
            padding: EdgeInsets.fromLTRB(25, 25, 25, 160),
            child: Text(
              _textSpeech,
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ));
  }

  void onListen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
        },
        onError: (val) {
          print('onerror: $val');
          setState(() {
            _isListening = false;
            _speech.stop();
          });
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
        });

        _speech.listen(
          onResult: (val) => setState(() {
            _textSpeech = val.recognizedWords;
            if (!_speech.isListening) {
              setState(() {
                _isListening = false;
                _speech.stop();
              });
            }
          }),
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _speech.stop();
      });
    }
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }
}
