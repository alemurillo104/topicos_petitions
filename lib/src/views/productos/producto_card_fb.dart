import 'package:flutter/material.dart';

import 'package:petitionsapp/src/models/product_model.dart';

class ProductoCardFB extends StatelessWidget {
  
  final Product producto;
  final String key2;
  
  ProductoCardFB({@required this.producto, @required this.key2 });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12.0,
      borderOnForeground: true,
      margin: EdgeInsets.all(14.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(124.0),
        child: Container(
          child: ListTile(
              leading: Icon(Icons.add_comment) ,
              title: Text(producto.nombre, style: TextStyle(fontSize: 20.0)),
              subtitle: contenido(producto),
              trailing: _inputButton(context,producto,key2),
              isThreeLine: true,
              contentPadding: EdgeInsets.symmetric(horizontal:12),
          ),
          margin: EdgeInsets.all(10.0),
        ),
      ),
    );
  }
  
  Widget contenido(Product producto) {
    if (producto.createdAt.toString()=='null') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Codigo: '+ producto.id.toString()),
          Text('Cantidad: '+ producto.cantidad.toString()),
          Text('Precio: '+ producto.precio.toString()),
          Text('Oferta: '+ producto.oferta.toString()),
        ],
      );
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Codigo: '+ producto.id.toString()),
          Text('Cantidad: '+ producto.cantidad.toString()),
          Text('Precio: '+ producto.precio.toString()),
          Text('Oferta: '+ producto.oferta.toString()),
          Text('Creado: '+ producto.createdAt.toString()),
        ],
      );
    }
  }

  Widget _inputButton(BuildContext context, Product producto, String key){
    return FlatButton(
      onPressed: (){},// _updateInput(context, producto,key), 
      child: Icon(Icons.arrow_drop_down));
  }
  
}