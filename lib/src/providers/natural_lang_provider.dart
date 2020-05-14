import 'dart:async';

import 'package:flutter/services.dart';

import 'package:googleapis/language/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

class NaturalLanguageProvider{
  
  final _scopes = [LanguageApi.CloudLanguageScope];

  final _natjsonController       = StreamController<Map<String, Object>>.broadcast();
  final _tokenResultController   = StreamController<List<Token>>.broadcast();

  Stream<Map<String, Object>> get natjsonStream       => _natjsonController.stream;
  Stream<List<Token>>         get tokenResultStream   => _tokenResultController.stream;
  
  Function(Map<String, Object>) get natjsonSink       => _natjsonController.sink.add;
  Function(List<Token>)         get tokenResultSink   => _tokenResultController.sink.add;

  AutoRefreshingAuthClient _httpClient;
  LanguageApi _language;

  void init(){
    rootBundle.loadString('assets/jsoncred.json').then((json){
      clientViaServiceAccount(ServiceAccountCredentials.fromJson(json), _scopes)
      .then((httpClient) {
        _httpClient=httpClient;
        _language = LanguageApi(_httpClient);
      }).catchError((error){
        print("Error de auth");
        print(error);
      });
    }).catchError((error) => print(error));
  }

  void naturalapi(String texto){
    
      final _json = {
        "document":{
          "type":"PLAIN_TEXT",
          "language":"ES",
          "content":"$texto"
        },
        "encodingType": "UTF8"
      };
     
      final _entitiesRequest = AnalyzeEntitiesRequest.fromJson(_json);

      _language.documents.analyzeEntities(_entitiesRequest).then((response){
        //natjsonSink(response.toJson());
        print("----------------llego aqui----------------");
      });    
            
  }
  
  void syntaxisApi(String texto){
    
      final _json2 = {
        "document":{
          "type":"PLAIN_TEXT",
          "content":"$texto"
        },
        "encodingType": "UTF8"
      };

      //SINTAXIS
      final _syntaxRequest = AnalyzeSyntaxRequest.fromJson(_json2);

      _language.documents.analyzeSyntax(_syntaxRequest).then((response){
        natjsonSink(response.toJson());
        var res=response.tokens;
        tokenResultSink(res);
        print("=====Token-Length=====");
        print(res.length);
        print("======================");
      });
  }
  
  dispose() {
    _httpClient?.close();
    _natjsonController?.close();
    _tokenResultController?.close();
  }
}