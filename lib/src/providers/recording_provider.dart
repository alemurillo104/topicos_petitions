import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';

import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

class RecordingProvider{
  
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  FlutterAudioRecorder get getRecorder =>_recorder;
  Recording get getCurrent =>_current;
  RecordingStatus get getCurrentStatus => _currentStatus;

  //====================SAVING-GETTERS==========================
  String _pathS;
  String get localpathSS => _pathS;

  Future<String> get _localPath3S async {

    String customPath = '/flutter_tts_';
    io.Directory appDocDirectory;

    appDocDirectory=(io.Platform.isIOS)
    ? await getApplicationDocumentsDirectory()
    : await getExternalStorageDirectory();

    customPath = appDocDirectory.path +
        customPath +
        DateTime.now().millisecondsSinceEpoch.toString()+".wav";
    final pathnuevo= customPath;
    _pathS=customPath;
    print("=============PATH================");
    print(_pathS);
    print("=================================");
    return pathnuevo;
  }

  Future<File> get _localFile2S async {
    final path = await _localPath3S;
    return File('$path');
  }

//==============================================================

  init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;

        appDocDirectory=(io.Platform.isIOS)
        ? await getApplicationDocumentsDirectory()
        : await getExternalStorageDirectory();

        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();
        
        _recorder = FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        
        var current = await _recorder.current(channel: 0);
        print(current);

        _current = current;
        _currentStatus = current.status;
        print(_currentStatus);
        
      } else {
        print("You must accept permissions");
      //  Scaffold.of(context).showSnackBar(
       //     new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);
      _current = recording;
     
      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }
        var current = await _recorder.current(channel: 0);
        _current = current;
        _currentStatus = _current.status;
      });

    } catch (e) {
      print(e);
    }
  }

  Future<String> stop2() async {
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    _current = result;
    _currentStatus = _current.status;
    return result.path;
  }
  
  String base64Encode(List<int> bytes) => base64.encode(bytes);

  String readCounter3(String path){
    final file = File(path);
    List contents3=file.readAsBytesSync();
    String datitos= base64Encode(contents3);
    print(datitos+" supuestamente esto es lo que me sirve");
    //aqui ya puedo eliminar el archivo de audio
    file.delete();
    return datitos;
  }
  
  RecordingStatus sRecStatus(String status){
    RecordingStatus statusD;
    switch (status) {
      case "unset"      : statusD=RecordingStatus.Unset;       break;
      case "inicialized": statusD=RecordingStatus.Initialized; break;
      case "stopped"    : statusD=RecordingStatus.Stopped;     break;
      default:  break;
    }
    return statusD;
  }

  //==============SAVING-FUNC======================

  List<int> base64Decode(String data) => base64.decode(data);

  void writeContent(String datos) async {
    List<int> bytes= base64Decode(datos);
    final file = await _localFile2S;
    // Write the file
    file.writeAsBytesSync(bytes);
    final filePath=file.path;

    print("===========ACTUALIZADO===========");
    print("============FILE PATH============");
    print(filePath);
    print("=================================");
  }

  void deleteFile(String path){
    final file = File(path);
    file.delete();
    print("============FILE DELETED============");
  }
  //==========================================
}