import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/utilidades.dart' as util;


class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {

  bool bandera = false;
  Widget _vista;
  String nombreCompleto,edad,correo,ciudad,estado;
  int puntos;


  TextStyle estNombre = TextStyle(
    color: Colors.white,
    fontSize: SizeConfig.conversionAlto(28, false),
    fontWeight: FontWeight.bold),
      txtTarj1 = TextStyle(
        fontSize: SizeConfig.conversionAlto(24, false),
            color: Colors.grey,
      ),
  txtTarj2 = TextStyle(
      fontSize: SizeConfig.conversionAlto(20, false),
      color: Colors.blue,
      fontWeight: FontWeight.bold
  ),
      txtFondo = TextStyle(
          fontSize: SizeConfig.conversionAlto(20, false),
          color: Colors.black,
          fontWeight: FontWeight.bold
      );

  Color col = Colors.blueAccent;

  Future<SharedPreferences> getData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  Future<bool> cierra() async{
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {

    if( !bandera )
      _vista = futureBuilder();

    return WillPopScope(
      onWillPop: () => cierra(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("INICIO"),
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: ()=> cierra()),
          //backgroundColor: Colors.transparent,
          elevation: 0.0,
          backgroundColor: Colors.blueAccent,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.minHeight),
                child: _vista,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget futureBuilder(){
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        Widget vista;
        if( snapshot.connectionState == ConnectionState.waiting){
          return Container(
            child: Center(
              child: SizedBox(
                width: 42 * SizeConfig.widthMultiplier,
                height: 42 * SizeConfig.widthMultiplier,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                  strokeWidth: 4 * SizeConfig.widthMultiplier /*18*/,
                ),
              ),
            ),
          );
        }

        if( snapshot.hasData){
          SharedPreferences sha = snapshot.data;
          /*Usuario user = Usuario.transforma(sha.getString("usuario"));
          print(user.toString());*/
          nombreCompleto = "${sha.getString("nombre")??"N/A"}  ${sha.getString("apellido")??"N/A"}";
          edad = sha.getString("edad") ?? "0";
          puntos = sha.getInt("puntos") ?? 0;
          correo = sha.getString("correo") ?? "N/A";
          ciudad = sha.getString("ciudad") ?? "N/A";
          estado = sha.getString("estado") ?? "N/A";
            vista = Container(
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      superior(),
                      inferior()
                    ],
                  ),
                  tarjeta(),

                ],
              ),
            );
        }else if( snapshot.hasError){

        }

        return vista;
      },
    );
  }

  Widget superior(){
    double redondeado = SizeConfig.conversionAlto(0, false);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(redondeado),
            //bottomRight: Radius.circular(90),
            topRight: Radius.circular(redondeado)
        ),
      color: Colors.blueAccent,
    ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: SizeConfig.conversionAlto(20, false),),
          Icon(Icons.account_circle,size: SizeConfig.conversionAlto(150, false),),
          Text(nombreCompleto,style: estNombre,),
          SizedBox(height: SizeConfig.conversionAlto(80, false),)
        ],
      ),
    );
  }

  Widget tarjeta(){
    return Card(
      elevation: SizeConfig.conversionAlto(5, false),
      margin: EdgeInsets.only(
        left: SizeConfig.conversionAncho(50, false),
        right: SizeConfig.conversionAncho(50, false),
        top: SizeConfig.conversionAncho(230, false),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Container(
        height: SizeConfig.conversionAlto(100, false),
        //alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.conversionAlto(15, false),
            horizontal: SizeConfig.conversionAncho(8, false)
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                //color: Colors.red,
                child: Column(
                  children: <Widget>[
                    Text("Edad",style: txtTarj1,),
                    SizedBox(height: SizeConfig.conversionAlto(15, false),),
                    Text(edad,style: txtTarj2,)
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                //color: Colors.green,
                child: Column(
                  children: <Widget>[
                    Text("Puntos",style: txtTarj1,),
                    SizedBox(height: SizeConfig.conversionAlto(15, false),),
                    Text(util.Impresiones.puntosBonitos(puntos.toDouble(),240),style: txtTarj2,)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget inferior(){
    double espaciado = SizeConfig.conversionAlto(20, false);
    return Container(
      //color: Colors.red,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          SizedBox(height: SizeConfig.conversionAlto(100, false),),
          Row(
            children: <Widget>[
              SizedBox(width: SizeConfig.conversionAncho(50, false),),
              Icon(Icons.email,size: SizeConfig.conversionAlto(35, false),color: col,),
              SizedBox(width: SizeConfig.conversionAlto(10, false),),
              Text(correo,style: txtFondo,)
            ],
          ),
          SizedBox(height: espaciado,),
          Row(
            children: <Widget>[
              SizedBox(width: SizeConfig.conversionAncho(50, false),),
              Icon(Icons.home,size: SizeConfig.conversionAlto(35, false),color: col),
              SizedBox(width: SizeConfig.conversionAlto(10, false),),
              Text(ciudad,style: txtFondo,)
            ],
          ),
          SizedBox(height: espaciado,),
          Row(
            children: <Widget>[
              SizedBox(width: SizeConfig.conversionAncho(50, false),),
              Icon(Icons.location_city,size: SizeConfig.conversionAlto(35, false),color: col),
              SizedBox(width: SizeConfig.conversionAlto(10, false),),
              Text(estado,style: txtFondo,)
            ],
          )
        ],
      ),
    );
  }

}
