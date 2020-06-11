import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Entidades/item.dart';
import 'package:tapitas/CustomViews/drawer_item.dart';
import 'package:tapitas/CustomViews/drawer_header.dart';
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
          /*actions: <Widget>[
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
          ],*/
        ),
        body: new Cuerpo(),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              MyDrawerHeader(),
              seccion("usuario"),
              DrawerItem(
                titulo: "Estadisticas",
                icono: Icons.history,
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/estadistica');
                },
              ),
              DrawerItem(
                titulo: "Lector",
                icono: Icons.camera_alt,
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/lector');
                },
              ),
              DrawerItem(
                titulo: "Premios",
                icono: Icons.card_giftcard,
                onTap: () => Navigator.pushNamed(context, '/premios'),
              ),
              DrawerItem(
                titulo: "Perfil",
                icono: Icons.account_circle,
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/perfil');
                },
              ),
              DrawerItem(
                titulo: "Puntuacion",
                icono: Icons.score,
                onTap: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/puntuacion');
                },
              ),
              seccion("app"),
              DrawerItem(
                titulo: "Configuracion",
                icono: Icons.settings,
                //onTap: () => Navigator.pushNamed(context, '/lector'),
              ),
              DrawerItem(
                titulo: "Cerrar Sesion",
                icono: Icons.exit_to_app,
                onTap: (){
                  resetShaPref();
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, "/login");
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget seccion([String nombre]){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(thickness: SizeConfig.conversionAncho(1.4, false),color: Colores.DRAWER_SECTION,height: 2,),
          Container(
            padding: EdgeInsets.only(left:SizeConfig.conversionAncho(15, false)),
            child: Text(nombre ?? "",style: TextStyle(color: Colores.DRAWER_SECTION),),
          )
        ],
      ),
    );
  }

  /*void manejoMenu(String accion){
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
  }*/

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

    return Column(
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: SizeConfig.conversionAlto(30, false),),
        Align(
          alignment: Alignment.center,
          child: Icon(Icons.home,size: SizeConfig.conversionAlto(250, false),),
        ),
        Container(
          margin: EdgeInsets.only(top: SizeConfig.conversionAlto(50, false)),
          child: Text(
            "Bienvenido de nuevo",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: SizeConfig.conversionAlto(28, false)),
          ),
        )
      ],
    );
  }

 /* Widget contenedorMaestro(){
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
      child: InkWell(
        splashColor: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(SizeConfig.conversionAlto(3, false))),
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
        child:  Column(
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
      ),
    );

    return Container(
      width: MediaQuery.of(contexto).size.width / 2,
      height: altoTarjeta,
      child: cartilla/*InkWell(
        splashColor: Colors.blue,
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
      )*/,
    );
  }*/
}