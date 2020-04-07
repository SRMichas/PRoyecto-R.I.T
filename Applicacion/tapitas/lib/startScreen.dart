import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'resgistro.dart';
import 'dart:async';

/*void main(){
    runApp(MaterialApp(
        title: "Algo",
        home: startScreen(),
    ));
}*/

class startScreen extends StatefulWidget {
  _startScreenState createState() => _startScreenState();
}

class _startScreenState extends State<startScreen>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*Future.delayed(Duration(
        seconds: 2,
        (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Login(),

              ));
        }
    ));*/
    /*Future.delayed(
        Duration(seconds: 2),
        iniciaActividad
    );*/
    /*Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => Root(),
        ));*/
    iniciaActividad();
  }

  iniciaActividad(){
    Future.delayed(
        Duration(seconds: 1),
        /*(){
          Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => Root(),
              ));
        }*/
        _revisaLogin
    );


  }
  _revisaLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool  activo = (prefs.getBool("sesion")) != null,
          decideRuta = prefs.getBool("sesion");

    if( activo ){
      if( decideRuta ){
        Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => Resgistro(),
            ));
      }else{
        Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => Root(),
            ));
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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

            /*new Container(
              child: new Text(
                  "Pantallaso"),
              margin: EdgeInsets.only(top: 500.0),
            ),
            new RaisedButton(
                onPressed: mensajillo,
                child: new Text("Avanzar")
            )*/
      ),
      backgroundColor: Colors.white,
    );
  }

  mensajillo() {
    print("LE picaste al boton");
    iniciaActividad();
  }
}

