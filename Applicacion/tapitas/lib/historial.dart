import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Historial extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Historial"),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                SystemNavigator.pop();
              }
            },
          )
      ),
      body: new Cuerpo2(),
    );
  }

}

class Cuerpo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Icon(
          Icons.history,
        size: 250,
        color: Colors.blueAccent,
      ),
    );
  }
}

class Cuerpo2 extends StatelessWidget{
  Cuerpo2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  // A fixed-height child.
                  color: const Color(0xff808000), // Yellow
                  height: 1020.0,
                ),
                Container(
                  // Another fixed-height child.
                  color: const Color(0xff008000), // Green
                  height: 320.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}