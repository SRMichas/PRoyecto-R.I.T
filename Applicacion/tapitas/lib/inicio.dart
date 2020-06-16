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

//GlobalKey<Lector> globalKey = GlobalKey();

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
    _vista = Cuerpo();
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
                titulo: "Inicio",
                icono: Icons.home,
                seleccionado: _idx == 0 ? true : false,
                onTap: (){
                  Navigator.pop(context);
                  setState(() {
                    _idx = 0;
                    _titulo = "Home";
                    _mainAppBar = retApp(true,null);
                    _vista = Cuerpo();
                  });
                },
              ),
              DrawerItem(
                titulo: "Compras",
                icono: Icons.shopping_cart,
                seleccionado: _idx == 1 ? true : false,
                onTap: (){
                  Navigator.pop(context);
                  //Navigator.pushNamed(context, '/estadistica');
                  setState(() {
                    _idx = 1;
                    _titulo = "Compras";
                    _mainAppBar = retApp(true,null);
                    _vista = Compras();
                  });
                },
              ),
              DrawerItem(
                titulo: "Estadisticas",
                icono: Icons.history,
                seleccionado: _idx == 2 ? true : false,
                onTap: (){
                  Navigator.pop(context);
                  //Navigator.pushNamed(context, '/estadistica');
                  setState(() {
                    _idx = 2;
                    _titulo = "Estadisticas";
                    _mainAppBar = retApp(true,null);
                    _vista = Historial();
                  });
                },
              ),
              DrawerItem(
                titulo: "Lector",
                icono: Icons.camera_alt,
                seleccionado: _idx == 3 ? true : false,
                onTap: (){
                  Navigator.pop(context);
                  setState(() {
                    _idx = 3;
                    LectorQR lector = new LectorQR();
                    _titulo = "Lector";
                    _vista = lector;
                    _mainAppBar = retApp(false,lector.muestraDialogo);
                  });
                },
              ),
              DrawerItem(
                titulo: "Premios",
                icono: Icons.card_giftcard,
                seleccionado: _idx == 4 ? true : false,
                onTap: (){
                  Navigator.pop(context);
                  setState(() {
                    _idx = 4;
                    _titulo = "Premios";
                    _mainAppBar = retApp(true,null);
                    _vista = Premios();
                  });
                },
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
                seleccionado: _idx == 6 ? true : false,
                onTap: (){
                  Navigator.pop(context);
                  setState(() {
                    _idx = 6;
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
    appbar2;
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
}