import 'package:flutter/material.dart';

import 'package:petitionsapp/src/views/home_page.dart';
import 'package:petitionsapp/src/views/json_view_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home'     : (BuildContext context) => HomePage(),
        'jsonView' : (BuildContext context) => JSONview(),
      },
      theme: ThemeData(
        primaryColor: Colors.pinkAccent
      ),
    );
  }
}