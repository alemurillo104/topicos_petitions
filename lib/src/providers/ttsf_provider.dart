import 'package:flutter_tts/flutter_tts.dart';

class TTSProvider{
  
  FlutterTts flutterTts;
  String language='es-BO';
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  initTts() =>  flutterTts = FlutterTts();
  
  Future speak(String texto) async {
    print('pasooo');
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    await flutterTts.setLanguage(language);

    if (texto != null) {
      if (texto.isNotEmpty) {
        var result = await flutterTts.speak(texto);
        print(result.toString());
      }
    }
  }

  void stop() => flutterTts.stop();
  
}