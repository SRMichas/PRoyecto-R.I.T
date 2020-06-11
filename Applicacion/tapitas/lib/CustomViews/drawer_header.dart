import 'package:flutter/material.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;
import 'package:tapitas/Extras/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawerHeader extends StatefulWidget {
  @override
  _MyDrawerHeaderState createState() => _MyDrawerHeaderState();
}

class _MyDrawerHeaderState extends State<MyDrawerHeader> {
  String nombreCompleto = "",correo = "";

  @override
  void initState(){
    obtenDatos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double tamano = SizeConfig.conversionAlto(60, false),
        borde = SizeConfig.conversionAlto(7,false);
    return Container(
      height: 120,
      child: DrawerHeader(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: conts.Colores.DRAWER_HEADER_BACKGROUND,
          ),
          child: ListTile(
            //color: conts.Colores.DRAWER_HEADER_BACKGROUND,
            title: InkWell(
              splashColor: Colors.green,
              //onLongPress: () => print("largo"),
              onTap: () => print("que show"),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: SizeConfig.conversionAncho(15, false)),
                    height: tamano+borde,
                    width: tamano+borde,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: conts.Colores.DRAWER_USER_BACKGROUND
                    ),
                    child: Icon(
                      Icons.account_circle,
                      color: conts.Colores.DRAWER_USER_COLOR,
                      size: tamano,
                    ),
                  ),
                  //SizedBox(height: SizeConfig.conversionAlto(10, false),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        nombreCompleto,
                        style: TextStyle(
                            fontSize: SizeConfig.conversionAlto(18, false),
                            color: conts.Colores.DRAWER_USER_BACKGROUND
                        ),
                      ),
                      Text(
                        correo,
                        style: TextStyle(
                            fontSize: SizeConfig.conversionAlto(14, false),
                            color: conts.Colores.DRAWER_USER_BACKGROUND,
                            fontStyle: FontStyle.italic
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  void obtenDatos() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      nombreCompleto = "${pref.getString("nombre")??"N/A"}  ${pref.getString("apellido")??"N/A"}";
      correo = pref.getString("correo") ?? "N/A";
    });
  }
}





/*class MyDrawerHeader extends StatelessWidget {

  String nombreCompleto,correo;
  @override
  Widget build(BuildContext context) {


    double tamano = SizeConfig.conversionAlto(60, false),
            borde = SizeConfig.conversionAlto(7,false);
    return Container(
      height: 120,
      child: DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: conts.Colores.DRAWER_HEADER_BACKGROUND,
        ),
        child: InkWell(
          onTap: () => print("que show"),
          child: ListTile(
              title:/*ren: <Widget>[*/Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.conversionAncho(15, false)),
                  height: tamano+borde,
                  width: tamano+borde,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: conts.Colores.DRAWER_USER_BACKGROUND
                  ),
                  child: Icon(
                    Icons.account_circle,
                    color: conts.Colores.DRAWER_USER_COLOR,
                    size: tamano,
                  ),
                ),
                //SizedBox(height: SizeConfig.conversionAlto(10, false),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      nombreCompleto,
                      style: TextStyle(
                        fontSize: SizeConfig.conversionAlto(18, false),
                        color: conts.Colores.DRAWER_USER_BACKGROUND 
                      ),
                    ),
                    Text(
                      correo,
                      style: TextStyle(
                        fontSize: SizeConfig.conversionAlto(14, false),
                        color: conts.Colores.DRAWER_USER_BACKGROUND,
                        fontStyle: FontStyle.italic 
                      ),
                    )
                  ],
                )
              ],
            ),//]
          ),
        )
      ),
    );
  }

  void obtenDatos() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
     nombreCompleto = "${pref.getString("nombre")??"N/A"}  ${pref.getString("apellido")??"N/A"}";
     correo = pref.getString("correo") ?? "N/A";
  }
}*/