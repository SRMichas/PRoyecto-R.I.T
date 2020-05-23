import 'package:flutter/material.dart';
import 'Extras/constantes.dart';
import 'package:http/http.dart' as http;

class Prueba extends StatelessWidget {

  String _resp="";

  Future<String> algo() async{
    var url = Constantes.PruebaCons;
    print(url);
    http.Response response = await http.post(url,);

    var data = response.body;

    print(data.toString());
    return data.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: (){ print("si te escuche morro"); algo();},
              child: Text("picale"),
              ),
              Text(_resp)
          ],
          ),
      ),
    );
  }
}