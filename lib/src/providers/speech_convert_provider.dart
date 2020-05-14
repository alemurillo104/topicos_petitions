import 'dart:async';

import 'package:flutter/services.dart';

import 'package:googleapis/speech/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class SpeechConvertProvider{
 
  String resultado='';

  final _scopes = [SpeechApi.CloudPlatformScope];

  final _speechResultController = StreamController<String>.broadcast();

  Stream<String> get speechResultStream => _speechResultController.stream;
  
  Function(String) get speechResultSink => _speechResultController.sink.add;
  
  AutoRefreshingAuthClient _httpClient;
  SpeechApi _speech;

  void init(){
     rootBundle.loadString('assets/jsoncred.json').then((json){
       clientViaServiceAccount(ServiceAccountCredentials.fromJson(json), _scopes)
         .then((httpClient) {
         _httpClient=httpClient;
         _speech = SpeechApi(_httpClient);
       }).catchError((error){
         print("Error de auth");
         print(error);
       });
     }).catchError((error) => print(error));
  }

  void convert(String data) {
 
      final _json = {
        "audio":{
          "content":"$data"
        },
        "config": {
          "encoding": "LINEAR16",
          "sampleRateHertz": 16000,
          "languageCode": "es-ES",
          "enableAutomaticPunctuation" : true,
          "speechContexts": [
            { "phrases": ["Sí por favor"], "boost" : 10 },
            { "phrases": ["Si"], "boost" : 5 }
          ]
        }
      };
      
      final _recognizeRequest = RecognizeRequest.fromJson(_json);

      _speech.speech.recognize(_recognizeRequest).then((response) {
        
        if(response.results!=null){

          for (var result in response.results) {
            var resultadoDatos=result.alternatives[0].toJson();
            var transcript= resultadoDatos["transcript"];
            print("TResult= $transcript");
            resultado=transcript.toString();
            speechResultSink(transcript.toString());
            print(result.toJson());
          }
        }else{
          speechResultSink("NULL");
          print("response es NULL");
        }
      });
    
  }

  void clearText(){
    resultado = "";
    speechResultSink("");
  }

  dispose(){
    _speechResultController?.close();
    _httpClient?.close();
  }
}
  
