import 'package:flutter/material.dart';
import 'package:flutter_json_widget/flutter_json_widget.dart';

class JSONview extends StatelessWidget {
  const JSONview({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final Map<String, Object> _json = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title:Text('JSON View')
      ),
      body:  Container(
        padding: EdgeInsets.all(12),
        child: Card(
          color: Color.fromRGBO(255, 251, 223,5),
          child: Container(
            child: SingleChildScrollView(
              child: JsonViewerWidget(_json)
            ),
            padding: EdgeInsets.all(15)
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8,
          margin: EdgeInsets.all(12),
        ),
      )
    );
  }
}