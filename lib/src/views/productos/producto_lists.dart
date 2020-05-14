import 'dart:convert';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:petitionsapp/src/models/product_model.dart';
import 'package:petitionsapp/src/providers/productos_provider.dart';
import 'package:petitionsapp/src/views/productos/producto_card_fb.dart';

class ListaProd extends StatefulWidget {
  @override
  _ListaProdState createState() => _ListaProdState();
}

class _ListaProdState extends State<ListaProd> {

  ProductosProvider prodProvider = new ProductosProvider();

  final globalKey = GlobalKey<ScaffoldState>(); 

  @override
  Widget build(BuildContext context) {
     return FirebaseAnimatedList(
      query: prodProvider.productosRef.orderByKey(),
      itemBuilder: (_, snapshot, Animation<double> animation,int x){
        Map dar=snapshot.value;
        final prod2=productFromJson3(json.encode(dar));
        final item=snapshot.key;
        return Dismissible(
          background: Container(color: Colors.red),
          key: UniqueKey(),
          child: ProductoCardFB(producto: prod2, key2: item),
          onDismissed: (direction){
              prodProvider.delProduct(item);
              final snackBar = SnackBar(content:Text(prod2.nombre.toString() +" ha sido eliminado"));
              globalKey.currentState.showSnackBar(snackBar);
          }
        );
      },
      defaultChild: Center(child: CircularProgressIndicator()),
    );
  }
}


class OfertaProd extends StatefulWidget {
  @override
  _OfertaProdState createState() => _OfertaProdState();
}

class _OfertaProdState extends State<OfertaProd> {

  ProductosProvider prodProvider = new ProductosProvider();

  final globalKey = GlobalKey<ScaffoldState>(); 

  @override
  Widget build(BuildContext context) {
     return FirebaseAnimatedList(
      query: prodProvider.productosRef.orderByChild('oferta').equalTo(true),
      itemBuilder: (_, snapshot, Animation<double> animation,int x){
        Map dar=snapshot.value;
        final prod2=productFromJson3(json.encode(dar));
        final item=snapshot.key;
        return Dismissible(
          background: Container(color: Colors.red),
          key: UniqueKey(),
          child: ProductoCardFB(producto: prod2, key2: item),
          onDismissed: (direction){
              prodProvider.delProduct(item);
              final snackBar = SnackBar(content:Text(prod2.nombre.toString() +" ha sido eliminado"));
              globalKey.currentState.showSnackBar(snackBar);
          }
        );
      },
      defaultChild: Center(child: CircularProgressIndicator()),
    );
  }
}