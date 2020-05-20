import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Entidades/item.dart';
import 'Extras/constantes.dart';
import 'lector_qr.dart';
import 'premios.dart';
import 'puntuacion.dart';
import 'estadisticas.dart';
import 'perfil.dart';

class Inicio extends StatelessWidget {

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return WillPopScope(
      onWillPop: () => cierraApp(),
      child: Scaffold(
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
        SizeConfig().iniciar(constraints,MediaQuery.of(context));
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
        ],
      ),
    );
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
          SizedBox( height: 5.0, ),
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
      child: GestureDetector(
        onTap: (){
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