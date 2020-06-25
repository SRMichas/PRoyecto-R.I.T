import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/CustomViews/drawer_item.dart';
import 'package:tapitas/CustomViews/drawer_header.dart';
import 'Extras/constantes.dart' as conts;
import 'estadisticas.dart';
import 'lector_qr.dart';
import 'puntuacion.dart';
import 'premios.dart';
import 'compras.dart';
import 'maquinas.dart';
//import 'package:tapitas/Extras/my_flutter_app_icons.dart';
import 'noticias.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  Widget _vista;
  BuildContext context;
  final _app = GlobalKey<State<Inicio>>();
  String _titulo = "Home";
  int _idx = 0;
  AppBar _mainAppBar;
  AppBar appBar1 ,
      appbar2;

  @override
  void initState() {
    _vista = Noticias();
    _mainAppBar = retApp(true,null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return WillPopScope(
      onWillPop: () => cierraApp(),
      child: Scaffold(
        appBar: _mainAppBar,
        body: _vista,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              MyDrawerHeader(),
              seccion("usuario"),
              DrawerItem(
                id: 1,
                titulo: "Inicio",
                icono: Icons.home,
                currentIndex: _idx,
                onTap: (value){
                  Navigator.pop(context);
                  setState(() {
                    _idx = value;
                    _titulo = "Home";
                    _mainAppBar = retApp(true,null);
                    _vista = Noticias();
                  });
                },
              ),
              DrawerItem(
                id: 2,
                titulo: "Compras",
                icono: Icons.shopping_cart,
                currentIndex: _idx,
                onTap: (value){
                  Navigator.pop(context);
                  //Navigator.pushNamed(context, '/estadistica');
                  setState(() {
                    _idx = value;
                    _titulo = "Compras";
                    _mainAppBar = retApp(true,null);
                    _vista = Compras();
                  });
                },
              ),
              DrawerItem(
                id: 3,
                titulo: "Estadisticas",
                icono: Icons.history,
                currentIndex: _idx,
                onTap: (value){
                  Navigator.pop(context);
                  //Navigator.pushNamed(context, '/estadistica');
                  setState(() {
                    _idx = value;
                    _titulo = "Estadisticas";
                    _mainAppBar = retApp(true,null);
                    _vista = Historial();
                  });
                },
              ),
              DrawerItem(
                id: 4,
                titulo: "Lector",
                icono: Icons.camera_alt,
                currentIndex: _idx,
                onTap: (value){
                  Navigator.pop(context);
                  setState(() {
                    _idx = value;
                    LectorQR lector = new LectorQR();
                    _titulo = "Lector";
                    _vista = lector;
                    _mainAppBar = retApp(false,lector.muestraDialogo);
                  });
                },
              ),
              DrawerItem(
                id: 5,
                titulo: "Maquinas",
                icono: Icons.print,
                currentIndex: _idx,
                onTap: (value){
                  Navigator.pop(context);
                  setState(() {
                    _idx = value;
                    _titulo = "Maquinas";
                    _mainAppBar = retApp(true,null);
                    _vista = Maquinas();
                  });
                },
              ),
              DrawerItem(
                id: 6,
                titulo: "Premios",
                icono: Icons.card_giftcard,
                currentIndex: _idx,
                onTap: (value){
                  Navigator.pop(context);
                  setState(() {
                    _idx = value;
                    _titulo = "Premios";
                    _mainAppBar = retApp(true,null);
                    _vista = Premios();
                  });
                },
              ),
              DrawerItem(
                id: 7,
                currentIndex: _idx,
                titulo: "Perfil",
                icono: Icons.account_circle,
                onTap: (value){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/perfil');
                },
              ),
              DrawerItem(
                id: 8,
                titulo: "Puntuacion",
                icono: Icons.score,
                currentIndex: _idx,
                onTap: (value){
                  Navigator.pop(context);
                  setState(() {
                    _idx = value;
                    _titulo = "Puntuacion";
                    _mainAppBar = retApp(true,null);
                    _vista = Puntuacion();
                  });
                },
              ),
              seccion("app"),
              /*DrawerItem(
                titulo: "Configuracion",
                icono: Icons.settings,
                //onTap: () => Navigator.pushNamed(context, '/lector'),
              ),*/
              DrawerItem(
                id: 9,
                currentIndex: _idx,
                titulo: "Cerrar Sesion",
                icono: Icons.exit_to_app,
                onTap: (value){
                  resetShaPref();
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, "/login");
                },
              ),
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
          Divider(thickness: SizeConfig.conversionAncho(1.4, false),color: conts.Colores.DRAWER_SECTION,height: 2,),
          Container(
            padding: EdgeInsets.only(left:SizeConfig.conversionAncho(15, false)),
            child: Text(nombre ?? "",style: TextStyle(color: conts.Colores.DRAWER_SECTION),),
          )
        ],
      ),
    );
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

  AppBar retApp(bool tipo,Function f){
    if( tipo ){
      return AppBar(
        elevation: 0,
        title: Text(_titulo),
      );
    }else{
      return AppBar(
        backgroundColor: conts.Colores.APP_BAR_BACKGROUND_COLOR,
        elevation: 0,
        title: Text(_titulo),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: SizeConfig.conversionAlto(10, false)),
              child: IconButton(
                onPressed: () => f.call()/*_dialogo()*/,
                icon: Icon(Icons.edit,color: conts.Colores.APP_BAR_WIDGET_COLOR,),
              ),
            )
          ]
      );
    }
  }

}

class Cuerpo extends StatefulWidget {
  @override
  _CuerpoState createState() => _CuerpoState();
}

class _CuerpoState extends State<Cuerpo> {

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Column(
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: SizeConfig.conversionAlto(30, false),),
        Align(
          alignment: Alignment.center,
          child: Container(
            //color: Colors.red,
            child: Icon(Icons.home,size: SizeConfig.conversionAlto(250, false),),
          ),
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
}