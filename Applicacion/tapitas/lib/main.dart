import 'package:flutter/material.dart';
import 'startScreen.dart';
import 'login.dart';
import 'resgistro.dart';
import 'inicio.dart';
import 'puntuacion.dart';
import 'historial.dart';
import 'premios.dart';
import 'ListaPremios.dart';

//void main() => runApp(MyApp());
void main(){
  runApp(MaterialApp(
    title: "Algo",
    home: Root(),
    //debugShowCheckedModeBanner: false, <----- Descomentar una vez terminada la app
    /*routes: <String,WidgetBuilder>{
      '/login': (BuildContext context) => new Root(),
      '/registro': (BuildContext context) => new Resgistro(),
      '/inicio': (BuildContext context) => new Inicio()
    },*/
  ));
}



