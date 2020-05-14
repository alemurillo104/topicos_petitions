import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:petitionsapp/src/models/product_model.dart';

class ProductosProvider {

   String _getProdAsString, _getOfertasAsString;
   
   String get productosAsString => _getProdAsString;
   String get ofertasAsString   => _getOfertasAsString;

   List<Product> _productos = new List();

   final _swStreamController  = StreamController<bool>.broadcast();

   Stream<bool>   get swStream => _swStreamController.stream;
   Function(bool) get swSink   => _swStreamController.sink.add;

   final database     = FirebaseDatabase.instance.reference();
   final productosRef = FirebaseDatabase.instance.reference().child('productos'); 

   Future<List<Product>> getProductos() async { 
      DataSnapshot snap = await database.once();
      if(snap.value == null){
        _getProdAsString    = "La lista de productos está vacia.";
        _getOfertasAsString = "No hay ofertas disponibles.";
        return [];
      } 
      Map<dynamic,dynamic> dataS = snap.value['productos'];
      
      final list = new Productos.fromJsonMap(dataS);

      final products = list.items;

      _productos.addAll(products);

      _getProdAsString    = getProductosAsString(list.items);
      _getOfertasAsString = getOfertasAsString(list.items);
      print("=============================");
      print(_getProdAsString);
      print("=============================");

      return list.items;
 
   }
   
  String getProductosAsString(List<Product> items){

    String stLargo = 'Los productos en lista son: ';
    for (var item in items) {
      String dato = "${item.cantidad} ${item.nombre} a ${item.precio} bolivianos la unidad, ";
      stLargo+=dato;
    }
    return stLargo;
  }

  String getOfertasAsString(List<Product> items){

    String stLargo ='Los productos ofertados son: ';
    for (var item in items) {
      if(item.oferta){
        String dato = "${item.cantidad} ${item.nombre} a ${item.precio} bolivianos la unidad, ";
        stLargo+=dato;
      }
    }
    
    if(stLargo.length == 29) stLargo = "No hay ofertas aún."; //no hubo inserción

    return stLargo;
  }

  void setProducto(Product producto){
    final json = productToJson(producto);
    database.child('productos').push().set(json);
  } 

  void updateProducto(String key,Product producto){
    database.child('productos/'+key).update(productToJson(producto));
  }
  void delProduct(String key){
    database.child('productos/'+key).remove();
  }
  
  void disposeStreams() => _swStreamController?.close();

}