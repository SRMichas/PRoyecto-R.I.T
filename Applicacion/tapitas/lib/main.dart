import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'login.dart';
import 'inicio.dart';
import 'registro.dart';
import 'estadisticas.dart';
import 'lector_qr.dart';
import 'puntuacion.dart';
import 'premios.dart';
import 'perfil.dart';
import 'compras.dart';
import 'maquinas.dart';

void main(){
  runApp(MaterialApp(
    title: "Algo",
    home: Principal(),
    debugShowCheckedModeBanner: false,
    routes: <String,WidgetBuilder>{
      '/login': (BuildContext context) => new Login(),
      '/inicio': (BuildContext context) => new Inicio(),
      '/registro' : (BuildContext context) => new Registro(),
      '/estadistica' : (BuildContext context) => new Historial(),
      '/lector' : (BuildContext context) => new LectorQR(),
      '/puntuacion' : (BuildContext context) => new Puntuacion(),
      '/premios' : (BuildContext context) => new Premios(),
      '/perfil' : (BuildContext context) => new Perfil(),
      '/compras' : (BuildContext context) => new Compras(),
      '/maquinas' : (BuildContext context) => new Maquinas(),
    },
  ));
}


class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = new Timer(const Duration(seconds: 2), () {
      setState(() {
        _revisaApp();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints){
        SizeConfig().iniciar(constraints,MediaQuery.of(context));
        return cuerpo();
      },
    );
  }

  Widget cuerpo(){
    double alto = SizeConfig.conversionAlto(300, false),
      ancho = alto/*SizeConfig.conversionAncho(400, false)*/;
    return Scaffold(
      body: new Center(
          child: new Column(
            children: <Widget>[
              /*FlutterLogo(
                size: 400,
              )*/
              Image.asset(
                'assets/img/logo.png',
                width: ancho,
                height: alto,
              ),
              Container(
                child: CircularProgressIndicator(),
                margin: EdgeInsets.only(top: SizeConfig.conversionAlto(25, false)),
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



