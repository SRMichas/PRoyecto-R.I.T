import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'inicio.dart';
import 'registro.dart';
import 'pruebaServicio.dart';

//void main() => runApp(MyApp());
void main(){
  runApp(MaterialApp(
    title: "Algo",
    home: Principal(),
    debugShowCheckedModeBanner: true,
    routes: <String,WidgetBuilder>{
      '/login': (BuildContext context) => new Login(),
      '/inicio': (BuildContext context) => new Inicio(),
      '/registro' : (BuildContext context) => new Registro()
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
    return Scaffold(
      body: new Center(
          child: new Column(
            children: <Widget>[
              FlutterLogo(
                size: 400,
              ),
              Container(
                child: CircularProgressIndicator(),
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



