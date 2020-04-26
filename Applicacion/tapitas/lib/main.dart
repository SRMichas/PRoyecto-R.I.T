import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    home: Principal(),
    //debugShowCheckedModeBanner: false, <----- Descomentar una vez terminada la app
    routes: <String,WidgetBuilder>{
      '/login': (BuildContext context) => new Root(),
      //'/registro': (BuildContext context) => new Resgistro(),
      '/inicio': (BuildContext context) => new Inicio()
    },
  ));

  /*


  routes: <String,WidgetBuilder>{
            '/login': (BuildContext context) => new Root(),
            '/registro': (BuildContext context) => new Resgistro(),
            '/inicio': (BuildContext context) => new Inicio()
          },


   */
}


class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _revisaApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
          child: new Column(
            children: <Widget>[
              FlutterLogo(
                size: 400,
              ),
              Container(
                child: CircularProgressIndicator(

                ),
                margin: EdgeInsets.only(top: 25),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )
      ),
      backgroundColor: Colors.white,
    );
  }

  _revisaApp() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool  activo = (prefs.getBool("sesion")) != null,
        decideRuta = prefs.getBool("sesion");

    if( activo ){
      if( decideRuta ){
        Navigator.pushReplacementNamed(context, "/inicio");
      }else{
        Navigator.pushReplacementNamed(context, "/login");
      }
    }else{
      Navigator.pushReplacementNamed(context, "/login");
    }
  }
}



