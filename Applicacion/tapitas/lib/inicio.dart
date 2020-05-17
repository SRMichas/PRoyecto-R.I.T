import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'lectorQr.dart';
import 'premios.dart';
import 'puntuacion.dart';
import 'historial.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'Extras/Constantes.dart';
import 'package:tapitas/Entidades/item.dart';
import 'perfil.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Inicio extends StatelessWidget {

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return WillPopScope(
      onWillPop: () => cierraApp(),
      child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Text("Home"),
              actions: <Widget>[
                PopupMenuButton<String>(
                  onSelected: manejoMenu,
                  itemBuilder: (context){
                    return Constantes.menuInicio.map((Item  accion,){
                      return PopupMenuItem<String>(
                        value: accion.codigo.toString(),
                        child: Text(accion.titulo),
                      );
                    }).toList();
                  },
                )
              ],
            ),
            body: new Cuerpo(),
          ),routes: <String,WidgetBuilder>{
        '/login': (BuildContext context) => new Login(),
      }
      ),
    );
  }

  void manejoMenu(String accion){
      switch(accion){
        case "1":
          Navigator.push(context,
              MaterialPageRoute(
                builder: (contexto) => Perfil(),
              ));
          break;
        default:
          resetShaPref();
          Navigator.pushReplacementNamed(context, "/login");
          break;
      }
  }

  void resetShaPref() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    await pref.setBool("sesion", false);
  }

  Future<bool> cierraApp() async{
    //SystemNavigator.pop();
    return true;
  }
}

class Cuerpo extends StatelessWidget {
  BuildContext contexto;

  double altoTarjeta = 125, tamanoIcono = 50, tamanoLetra = 32;
  int contador = 1;

  @override
  Widget build(BuildContext context) {
    contexto = context;
    
    return LayoutBuilder(
      builder: (context,constraints){
        SizeConfig().iniciar(constraints);
        return contenedorMaestro();
      },
    );
  }

  Widget contenedorMaestro(){
    return Container(
      height: double.infinity,
      //alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              carta(1,"Estadisticas", Icons.history),
              carta(2,"Lector", Icons.camera_alt),
            ],
          ),
          SizedBox(height: 30,),
          Row(
            children: <Widget>[
              carta(3,"Puntuación", Icons.score),
              carta(4,"Premios", Icons.card_giftcard)
            ],
          ),

          /*SizedBox(height: 20.0,),
        carta("historial", Icons.history),
        SizedBox(height: 20.0,),
        carta("Lector", Icons.camera_alt),
        SizedBox(height: 20.0,),
        carta("Puntuación", Icons.score),
        SizedBox(height: 20.0,),
        carta("Premios", Icons.card_giftcard)*/
        ],
      ),
    );
  }

  Card actividad(){
    return Card();
  }

  Container carta(int id,String nombre, IconData icono) {
    Card cartilla = new Card(
      elevation: 3,
      child: Column(
        children: <Widget>[
          Icon(
            icono,
            color: Colors.blueAccent,
            size: tamanoIcono,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            nombre,

            style: TextStyle(
              fontSize: nombre.length < 12 ? tamanoLetra : tamanoLetra - 3,
            ),
          )
        ],
      ),
    );

    return Container(
      width: MediaQuery.of(contexto).size.width / 2,
      height: altoTarjeta,
      //margin: EdgeInsets.only(left: 5,right: 5),
      child: GestureDetector(
        onTap: (){
            //Scaffold.of(contexto).showSnackBar(SnackBar(content: Text("Presionaste en: "+id.toString()),duration: Duration(seconds: 1),));
            var actividad;
            switch(id){
              case 1:
                actividad = (contexto) => Historial();
                break;
              case 2:
                actividad = (contexto) => LectorQR();
                break;
              case 3:
                actividad = (contexto) => Puntuacion();
                break;
              case 4:
                actividad = (contexto) => Premios();
                break;
            }

            //Navigator.pop(contexto);
            Navigator.push(contexto,
                MaterialPageRoute(
                  builder: actividad,
                ));


          },
        child: cartilla,
      ),
    );
  }
}


