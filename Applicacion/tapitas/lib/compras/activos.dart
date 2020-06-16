import 'package:flutter/material.dart';
import 'package:tapitas/CustomViews/mi_dialogo.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;
import 'package:tapitas/Extras/size_config.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapitas/Entidades/mi_excepcion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Entidades/compra.dart';

class Activo extends StatefulWidget {
  @override
  _ActivoState createState() => _ActivoState();
}

class _ActivoState extends State<Activo> {

  BuildContext context;
  Future<Map<String, dynamic>> _futuro;
  bool bandera = false;
  SharedPreferences prefs;
  int _status;
  Widget _vista;

  bool dialogoVisible;

  @override
  void initState() {
    _futuro = getCategorias();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //super.build(context);
    this.context = context;

    if( !bandera ){
      _vista = futureBuilder();
    }

    return Container(
      child: _vista,
    );
  }

  Future<Map<String, dynamic>> getCategorias() async{
    prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    var url = '${conts.Constantes.HOST+conts.Constantes.RT_SLT}';
    url += "C-Compra.php";

    Map parametros = {"usId" : id, "rt" : "2"};

    try{
      http.Response response = await http.post(url,body: parametros);
      _status = response.statusCode;

      if( _status == 200) {
        var data = jsonDecode(response.body);
        bandera = false;
        return data;
      }else{
        throw MiExcepcion("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",0,Icons.print);
      }
    } on FormatException catch (e){
      bandera = false;
      throw MiExcepcion("Error al conectar con el servidor \n${e.toString()}",2,Icons.info,e);
    } on Exception catch (e){
      //el servidor esta apagado -> a rechazado la conexion
      bandera = false;
      throw MiExcepcion("Se ha rechazado la conexión",1,Icons.signal_wifi_off,e);
    } on TypeError catch (e){
      bandera = false;
      throw MiExcepcion(e.toString(),1,Icons.signal_wifi_off,e);
    }
  }
  Future<Map<String, dynamic>> _dialogoTransaccion(int s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = await prefs.getString("id");
    var url = '${conts.Constantes.HOST + conts.Constantes.RT_UDT}';
    url += "U-Premio.php";

    Map parametros = { "usId": id, "idS": "$s"};

    http.Response res = await http.post(url, body: parametros).timeout(Duration(seconds: 5));
    var data = jsonDecode(res.body);
    print(data.toString());
    return data;
  }

  Widget futureBuilder(){
    return FutureBuilder(
        future: _futuro,
        builder:(BuildContext context,AsyncSnapshot snapshot){
          Widget vista;

          if( snapshot.connectionState == ConnectionState.waiting){
            return Container(
              child: Center(
                child: SizedBox(
                  width: SizeConfig.conversionAncho(190, false) ,//* SizeConfig.widthMultiplier,
                  height: SizeConfig.conversionAncho(190, false) ,//* SizeConfig.widthMultiplier,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                    strokeWidth: SizeConfig.conversionAncho(18, false) ,
                  ),
                ),
              ),
            );
          }

          if( snapshot.hasData){
            bool error = snapshot.data["fallo"].toString() == "true";
            //int codigo = snapshot.data["codigo"];

            if( !error ){
              vista = _Lista(size: 10,lista: snapshot.data["lista"],funcion: _muestraDialogo,);
            }else{
              vista = Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                        Icons.error,
                        color: Colors.red,
                        size:SizeConfig.conversionAlto(200, false),/*(200 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier*/),
                    Text(
                      snapshot.data["mensaje"].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle( fontSize: SizeConfig.conversionAlto(28, false)),
                    ),
                    SizedBox(height:SizeConfig.conversionAlto(30, false)),
                    FlatButton(
                      onPressed: () => setState(() {
                        bandera = false;
                        try {
                          _futuro = getCategorias();
                        }catch(e){
                          print("ESTE EST EL ERROR =====> ${e.toString()}");
                        }
                      }),
                      child: Text("Reintentar",style: conts.Estilo.estiloPre1,),
                      textColor: Colors.blue,
                    )
                  ],
                ),
              );
            }

          }else if( snapshot.hasError){
            MiExcepcion e = snapshot.error;

            vista = Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(e.icono,size:SizeConfig.conversionAlto(100, false),),
                  Text("${e.mensaje}",style: conts.Estilo.estiloError,),
                  SizedBox(height: SizeConfig.conversionAlto(30, false)),
                  FlatButton(
                    onPressed: () => setState(() {
                      bandera = false;
                      try {
                        _futuro = getCategorias();
                      }catch(e){
                        print("ESTE EST EL ERROR =====> ${e.toString()}");
                      }
                    }),
                    child: Text("Reintentar",style: conts.Estilo.estiloPre1,),
                    textColor: Colors.blue,
                  )
                ],
              ),
            );
          }
          return vista;
        }
    );
  }

  void _muestraDialogo(int srv) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("¿Quires canjear este premio?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancelar")),
              FlatButton(
                  onPressed: () {
                      Navigator.of(context).pop();
                      _checkDialog(srv);
                  },
                  child: Text("Aceptar"))
            ],
          );
        });
  }

  void _checkDialog(int id) async {
    dialogoVisible = true;
    Map<String, Object> res = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return FutureBuilder(
              future: _dialogoTransaccion(id),
              builder: (context, snapshot) {
                Widget vista;
                if (snapshot.hasData) {
                  bool fallo = snapshot.data["fallo"].toString() == "true";
                  int codigoError =
                  int.parse(snapshot.data["codigo"].toString());
                  String titulo;

                  if (!fallo) {
                    titulo = "Felicidades";
                  } else
                    switch (codigoError) {
                      case 1:
                        titulo = conts.Constantes.T_ERROR;
                        break;
                      case 2:
                        titulo = conts.Constantes.T_ADVERTENCIA;
                        break;
                      case 3:
                        titulo = conts.Constantes.T_ERROR;
                        break;
                    }
                  vista = MiDialogo(
                    titulo: titulo,
                    descripcion: snapshot.data["mensaje"].toString(),
                    tipoTitulo: conts.Constantes.C_EXITOSA_COMPRA,
                    datos: snapshot.data,
                    soloCarga: false,
                  );
                }else if( snapshot.hasError ){
                  Navigator.pop(context);
                } else {
                  vista = SimpleDialog(
                    children: <Widget>[
                      Center(
                        child: SizedBox(
                          height: SizeConfig.conversionAlto(100, false),
                          width: SizeConfig.conversionAncho(100, false),
                          child: CircularProgressIndicator(
                            strokeWidth: SizeConfig.conversionAncho(10, false),
                          ),
                        ),
                      )
                    ],
                  );
                }

                return vista;
              });
        });
    print(res.toString());
    if (!res["bandera"]) {
      dialogoVisible = false;
      print("llega aqui estoy chido");
      setState(() {
        bandera = false;
        _futuro = getCategorias();
      });
    }
  }
}

class _Lista extends StatelessWidget {

  final int size;
  final List lista;
  final Function funcion;

  _Lista({this.size,this.lista,this.funcion});

  @override
  Widget build(BuildContext context) {
    List<Activos> compras = lista.map((valor) => Activos.fromJson(valor)).toList();
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
            delegate:SliverChildBuilderDelegate((context, index){

                return _ModeloActivo(activo: compras[index],funcion: funcion,);
              },childCount:lista.length ?? size),
        ),
      ],
    );
  }
}


class _ModeloActivo extends StatelessWidget {

  String url="http://192.168.1.111/RIT/img/telcel_icon.png";
  Activos activo;
  Function funcion;

  _ModeloActivo({this.activo,this.funcion});

  @override
  Widget build(BuildContext context) {
    double tamano = SizeConfig.conversionAlto(70, false),
      divisor = SizeConfig.conversionAlto(2, false),
      cache = 2000;
    return Column(
      children: <Widget>[
        Container(
          //color: Colors.red,
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.conversionAncho(10, false),
                vertical: SizeConfig.conversionAlto(5, false)
            ),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(right: SizeConfig.conversionAlto(30, false)),
                child: Text(activo.fecha ?? "00/00/0000",style: conts.Estilo.estiloFecha,),
              ),
              Row(
                children: <Widget>[
                  Image.network(
                    activo.urlFoto ?? url,
                    width: tamano,
                    height: tamano,
                    cacheHeight: cache.toInt(),
                    cacheWidth: cache.toInt(),
                  ),
                  SizedBox(width: SizeConfig.conversionAncho(20, false),),
                  Expanded(
                    child: Container(
                      //color: Colors.green,
                      child: Text(activo.descripcion ?? "Descripcion",style:conts.Estilo.estiloDescripcion,),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  //Text("${activo.id ?? 0}"),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: SizeConfig.conversionAncho(10, false)),
                    child: RaisedButton(
                      onPressed: () => funcion(activo.id) ??print("hola"),
                      elevation: 0.0,
                      color: conts.Colores.BOTON,
                      shape: RoundedRectangleBorder(
                          borderRadius:BorderRadius.circular(20),
                          side: BorderSide(color: Colors.blue)
                      ),
                      child: Text("Canjear",style: conts.Estilo.ESTILO_TEXTO_BOTON,),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Divider(thickness: divisor,height: divisor,color: Colors.black,)
      ],
    );
  }
}
