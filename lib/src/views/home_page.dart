import 'package:flutter/material.dart';

import 'package:petitionsapp/src/providers/natural_lang_provider.dart';
import 'package:petitionsapp/src/providers/productos_provider.dart';
import 'package:petitionsapp/src/providers/recording_provider.dart';
import 'package:petitionsapp/src/providers/respuestas.dart';
import 'package:petitionsapp/src/providers/speech_convert_provider.dart';
import 'package:petitionsapp/src/providers/ttsf_provider.dart';
import 'package:petitionsapp/src/views/productos/producto_lists.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  TTSProvider ttsProvider  = new TTSProvider();
  Respuestas respuestas    = new Respuestas();
  ProductosProvider prodProvider = new ProductosProvider();

  SpeechConvertProvider   speechConvertProvider = new SpeechConvertProvider();
  RecordingProvider       recordingProvider     = new RecordingProvider();
  NaturalLanguageProvider naturalProvider       = new NaturalLanguageProvider();

  String textotitle="Init";
  Color colorS=Colors.pinkAccent; 

  @override
  void initState() { 
    super.initState();
    //recording-speech-natural api
    speechConvertProvider.init();
    recordingProvider.init();
    naturalProvider.init();
    speechConvertProvider.speechResultStream.listen((texto){
      naturalProvider.naturalapi(texto);      
      naturalProvider.syntaxisApi(texto);
    });
      
    ttsProvider.initTts();
    ttsProvider.speak('Bienvenido, ¿puedo ayudarlo?'); 

    naturalProvider.tokenResultStream.listen((items){
      respuestas.respuestas(items,ttsProvider,prodProvider);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    //prodProvider.getProductos();
    return Scaffold(
      appBar: AppBar(
        title:Text('Petitions - Products'),
        actions: <Widget>[ jsonV() ],
      ),
     body: StreamBuilder(
        stream: prodProvider.swStream ,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
          if (snapshot.hasData) {
            return (!snapshot.data)
            ? ListaProd()
            : OfertaProd() ;
          }else{
            return Center(child: Text('Pulse el boton sostenido para hablar.'));
          }
        },
      ),
      floatingActionButton: speechButton()
    );
  }

  //utilities para el recording-speech-natural api
    
  Widget speechButton(){
    return GestureDetector(
      child:ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: _speechButtonStyle()
      ),
      onTapDown: _ontapdownFunc,
      onTapUp: _ontapupFunc
    );
  }

  void _ontapdownFunc(TapDownDetails details){
    setState(() => colorS=Colors.pink[300]);
    if (recordingProvider.getCurrentStatus==recordingProvider.sRecStatus("inicialized")) {
      setState(() => textotitle="Start");
      recordingProvider.start();
    }
    print('tapdown');
  }

  void _ontapupFunc (TapUpDetails details) async {
    
    setState(() => colorS=Colors.pinkAccent);
    if(recordingProvider.getCurrentStatus != recordingProvider.sRecStatus("unset")){
      String path= await recordingProvider.stop2();
      String datos3= recordingProvider.readCounter3(path);
      speechConvertProvider.convert(datos3);
    }
  
    //aqui reinicio
    if (recordingProvider.getCurrentStatus==recordingProvider.sRecStatus("stopped")){
      recordingProvider.init();
      setState(() => textotitle="Start");
    }
    print('tapup'); 
  }

  Widget _speechButtonStyle(){
    return Container(
      color: colorS,
      width: 60.0,
      height: 60.0,
      child: Icon(Icons.mic)
    );
  }
  

  //JSON VIEW Natural Api 

  Widget jsonV(){
    return  StreamBuilder(
    stream: naturalProvider.natjsonStream,
    builder: (_, AsyncSnapshot<Map<String, Object>> snapshot) {
      return snapshot.hasData
          ? IconButton(iconSize: 40,
            onPressed: () => Navigator.pushNamed(context, 'jsonView',arguments: snapshot.data),
            icon:_title(text: "JSON{}", size:10, color: Colors.white))
          : Container();
    });
  }

  Widget _title({String text, double size, Color color}){
    return Text(text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize:size,
        color: color
      )
    );
  }
 
  @override
  void dispose() {
    ttsProvider.stop();
    prodProvider.disposeStreams();
    speechConvertProvider.dispose();
    naturalProvider.dispose();
    super.dispose();
  }

}