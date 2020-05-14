import 'package:googleapis/language/v1.dart';

import 'package:petitionsapp/src/models/product_model.dart';
import 'package:petitionsapp/src/providers/productos_provider.dart';
import 'package:petitionsapp/src/providers/ttsf_provider.dart';

class Respuestas{

  void respuestas(List<Token> items, TTSProvider ttsProvider, ProductosProvider prodProvider) async{
    String productos;
    List<Product> prods= new List();
    for (var item in items) {
      var textoS=item.text.content;
      switch (textoS) {
        case "productos" :
            print("========RES-Sink-False==========");
            prodProvider.swSink(false);
            //aqui hacer la funcion async para que lea los prods justo es este momnto, c
            prods= await prodProvider.getProductos();
            print("============================");
            productos= prodProvider.productosAsString;
            break;
        case "producto" :
            print("========RES-Sink-False==========");
            prodProvider.swSink(false);
            prods= await prodProvider.getProductos();
            print("============================");
            productos= prodProvider.productosAsString;
            break;
        case "ofertas"   : 
            print("========RES-Sink-True==========");
            prodProvider.swSink(true);
            prods= await prodProvider.getProductos();
            print("============================");
            productos= prodProvider.ofertasAsString;
            break;
      }

      if (productos!=null) break;
    }
    
    if (productos != null ){
      ttsProvider.speak(productos) ;
    }else{
      ttsProvider.speak("No te entendí. Por favor repítelo.") ;
    }
  }

  
  bool estaPalabra(List<Token> items, String texto){

    for (var item in items) {
      var textoS=item.text.content;
      if (textoS.compareTo(texto) == 0) { //true creo 
        return true;
      }
    }
    return false;
  }
}