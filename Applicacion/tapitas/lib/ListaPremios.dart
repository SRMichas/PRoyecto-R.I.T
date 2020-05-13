import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/Constantes.dart';
import 'package:tapitas/Entidades/Premio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapitas/MiDialogo.dart';
import 'package:tapitas/Extras/Utilidades.dart' as util;

class ListaPremios extends StatefulWidget {
  final String cate;
  final int id, puntos;
  final List<Premio> premios;

  ListaPremios({Key key, this.cate, this.id, this.premios, this.puntos})
      : super(key: key);

  @override
  _ListaPremiosState createState() => _ListaPremiosState();
}

class _ListaPremiosState extends State<ListaPremios> {
  String cate;
  int id;
  List<Premio> premios;
  int puntos;
  bool inicia = true;

  TextStyle estilo = TextStyle(color: Colors.blue);

  void _cambiaPuntos(int puntosMod) {
    setState(() {
      puntos = puntosMod;
      inicia = false;
    });
  }

  void Sale() {
    Navigator.pop(context, puntos);
  }

  @override
  Widget build(BuildContext context) {
    cate = widget.cate;
    id = widget.id;
    if (inicia) puntos = widget.puntos;
    premios = widget.premios;

    return WillPopScope(
      onWillPop: () { Sale(); },
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: SizeConfig.ancho() * 0.45,
                  child: Text("$cate"),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: SizeConfig.conversionAlto(3, false), horizontal: SizeConfig.conversionAncho(8, false)),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(SizeConfig.conversionAlto(12, false))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/coin.png'),
                        height: SizeConfig.conversionAlto(25,false),
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: SizeConfig.conversionAncho(5,false),
                      ),
                      Text(
                        "${util.Impresiones.puntosBonitos(puntos)}",
                        textAlign: TextAlign.end,
                        style: estilo,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () { Sale(); }),
        ),
        body: cuerpo(),
      ),
    );
  }

  Widget cuerpo() {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate( (BuildContext context, int idx) {
                    Premio premio = premios[idx];
                    return ModeloProducto(
                      premio: premio,
                      puntos: widget.puntos,
                      contexto: context,
                      funcion: _cambiaPuntos,
                    );
                  },
                  childCount: premios.length,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class ModeloProducto extends StatelessWidget {
  final String nombre, descripcion, url;
  final int puntos;
  final Premio premio;
  final BuildContext contexto;
  final Function funcion;
  int diferencia;
  String display;
  bool dialogoVisible = false;
  BuildContext context;

  ModeloProducto({this.nombre,this.descripcion,this.puntos,this.url,this.premio,this.contexto,this.funcion});

  TextStyle estilo1 = TextStyle(
    fontSize: 2.6 * SizeConfig.heightMultiplier, //20
  ),
      estilo2 = TextStyle(fontSize: 2.85 * SizeConfig.heightMultiplier //22
          ),
      estilo3 = TextStyle(
          fontSize: 3.1 * SizeConfig.heightMultiplier, //24
          color: Colors.pink);

  @override
  Widget build(BuildContext context) {
    this.context = context;

    display = util.Impresiones.puntosBonitos(premio.costo);

    return GestureDetector(
      onTap: () {
        _muestraDialogo(premio.costo, display);
      },
      child: cuerpoModelo(),
    );
  }

  void _muestraDialogo(int cantidad, String textoMuestra) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("¿Desea canjear $textoMuestra?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancelar")),
              FlatButton(
                  onPressed: () {
                    if (puntos >= cantidad) {
                      Navigator.of(context).pop();
                      _checkDialog();
                    } else {
                      Navigator.of(context).pop();
                      Scaffold.of(contexto).showSnackBar(SnackBar(
                        content: Text("No cuenta con suficientes puntos"),
                        duration: Duration(seconds: 1),
                      ));
                    }
                  },
                  child: Text("Aceptar"))
            ],
          );
        });
  }

  Future<Map<String, dynamic>> _dialogoTransaccion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = 'http://${Constantes.HOST + Constantes.RT_ISR}';
    url += "I-Premio.php";
    int id = int.parse(prefs.getString("id"));
    diferencia = puntos - premio.costo;

    Map parametros = {
      "idU": "$id",
      "idP": "${premio.id_premio}",
      "act": "$diferencia",
      "gas": "${premio.costo}"
    };

    http.Response res = await http.post(url, body: parametros);
    var data = jsonDecode(res.body);

    return data;
  }

  void _checkDialog() async {
    dialogoVisible = true;
    Map<String, Object> res = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return FutureBuilder(
              future: _dialogoTransaccion(),
              builder: (context, snapshot) {
                Widget vista;
                if (snapshot.hasData) {
                  bool fallo = snapshot.data["fallo"].toString() == "true";
                  int codigoError =
                          int.parse(snapshot.data["codigo"].toString()),
                      codigoTitulo;
                  String titulo;

                  if (!fallo) {
                    titulo = "Felicidades";
                    codigoTitulo = Constantes.C_EXITOSA;
                  } else
                    switch (codigoError) {
                      case 1:
                        titulo = Constantes.T_ERROR;
                        codigoTitulo = Constantes.C_ERROR;
                        break;
                      case 2:
                        titulo = Constantes.T_ADVERTENCIA;
                        codigoTitulo = Constantes.C_ADVERTENCIA;
                        break;
                      case 3:
                        titulo = Constantes.T_ERROR;
                        codigoTitulo = Constantes.C_ERROR;
                        break;
                    }
                  vista = MiDialogo(
                    titulo: titulo,
                    descripcion: snapshot.data["mensaje"].toString(),
                    tipoTitulo: 0,
                    datos: snapshot.data,
                  );
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

    if (!res["bandera"]) {
      dialogoVisible = false;
      funcion(res["nuevosPuntos"]);
    }
  }

  Container cuerpoModelo() {
    double margen = MediaQuery.of(context).size.width / 35,
        porcentajeLogo = 0.2,
        porcentajeNombre = 0.485,
        porcentajePuntos = 0.285;
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: SizeConfig.conversionAlto(5, false),
          ),
          Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(right: SizeConfig.conversionAncho(5, false)),
                  width: MediaQuery.of(context).size.width * porcentajeLogo,
                  child: Container(
                    child:
                    Image.network(
                      premio.url,
                      width: SizeConfig.conversionAncho(80, false),
                      height: SizeConfig.conversionAlto(80, false),
                      cacheWidth: SizeConfig.conversionAncho(100, true),
                      cacheHeight: SizeConfig.conversionAlto(100, true),
                    ),
                  )),
              Container(
                width: MediaQuery.of(context).size.width *
                    porcentajeNombre, // /2.2
                margin: EdgeInsets.only(right: SizeConfig.conversionAncho(5, false)),
                child: Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: SizeConfig.conversionAlto(5, false), top: SizeConfig.conversionAlto(3, false)),
                        child: Text(
                          premio.nombre.toUpperCase(),
                          style: estilo1,
                          softWrap: true,
                        )),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          premio.descripcion,
                          style: estilo2,
                          softWrap: true,
                        ))
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * porcentajePuntos, // /4.2
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/coin.png'),
                      height: SizeConfig.conversionAncho(25,false),
                      color: Colors.pink,
                    ),
                    SizedBox(
                      width: SizeConfig.conversionAncho(5,false),
                    ),
                    Text("$display",style: estilo3,)
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.conversionAlto(5, false),
          ),
          Divider(height: SizeConfig.conversionAlto(5, false), color: Colors.grey),
        ],
      ),
    );
  }
}