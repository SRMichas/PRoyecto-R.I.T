import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/Constantes.dart';

class ListaPremios extends StatelessWidget {
  ListaPremios(this.cate, this.id);

  final String cate;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos Canjeables"),
      ),
      body: Cuerpo(
        categoria: cate,
        idCat: id,
      ),
    );
  }
}

class ModeloProducto extends StatelessWidget {
  final String nombre, descripcion, url;
  final int puntos;

  String display;

  ModeloProducto(this.nombre, this.descripcion, this.puntos, this.url);

  BuildContext context;

  TextStyle estilo1 = TextStyle(
    fontSize: 2.6 * SizeConfig.heightMultiplier, //20
  ),
      estilo2 = TextStyle(
          fontSize: 2.85 * SizeConfig.heightMultiplier //22
      ),
      estilo3 = TextStyle(
          fontSize: 3.1 * SizeConfig.heightMultiplier, //24
          color: Colors.pink
      );

  @override
  Widget build(BuildContext context) {
    this.context = context;

    controlaPuntos();

    return GestureDetector(
      onTap: (){
        _muestraDialogo(puntos,display);
      },
      child: cuerpoModelo(),
    );


  }

  void _muestraDialogo(int cantidad,String textoMuestra){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text("¿Desea canjear $textoMuestra?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancelar")
              ),
              FlatButton(
                  onPressed: () => print("si se pudo"),
                  child: Text("Aceptar")
              )
            ],
          );
        }
    );
  }

  Container cuerpoModelo(){
    double margen = MediaQuery.of(context).size.width / 35,
      porcentajeLogo = 0.2,
      porcentajeNombre = 0.485,
      porcentajePuntos = 0.285;
    return Container(
      width: double.infinity,
      //color: Colors.grey,
      //margin: EdgeInsets.symmetric(vertical: 15,horizontal: 2),
      child: Column(
        children: <Widget>[
          SizedBox(height: 5,),
          Row(
            children: <Widget>[
              Container(
                //color: Colors.red,
                  margin: EdgeInsets.only(right: 5),
                  width: MediaQuery.of(context).size.width * porcentajeLogo , // MediaQuery.of(context).size.width / 5
                  child: Container(
                    child:
                    /*Icon(
                      Icons.account_circle,
                      size: 70,
                    ),*/
                    Image.network(
                      url,
                      width: 80,
                      height: 80,
                      cacheWidth: 100,
                      cacheHeight: 100,
                    ),
                  )),
              Container(
                //color: Colors.blue,
                width: MediaQuery.of(context).size.width * porcentajeNombre, // /2.2
                margin: EdgeInsets.only(right: 5),
                child: Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(bottom: 5, top: 3),
                        //color: Colors.purple,
                        child: Text(
                          nombre.toUpperCase(),
                          style: estilo1,
                          softWrap: true,
                        )),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(descripcion, style: estilo2,softWrap: true,))
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                //color: Colors.green,
                width: MediaQuery.of(context).size.width * porcentajePuntos, // /4.2
                child: Container(
                    child: Text(
                      display,
                      style: estilo3,
                    )),
              )
            ],
          ),
        SizedBox(height: 5,),
          Divider(height: 5, color: Colors.grey),

        ],
      ),
    );
  }

  String controlaPuntos() {
    String resp = "";
    String aux = puntos.toString();
    String aux2 = "";
    int contador = 0;

    for (int i = aux.length - 1; i > -1; i--) {
      if (contador == 3) {
        contador = 0;
        aux2 += "," + aux[i];
      } else {
        aux2 += aux[i];
        contador++;
      }
    }
    for (int i = aux.length; i > -1; i--) resp += aux2[i];
    //resp = aux2;
    display = resp;
    //print(resp);
    return resp;
  }
}

class Cuerpo extends StatefulWidget {
  Cuerpo({Key key, this.categoria, this.idCat}) : super(key: key);

  final String categoria;
  final int idCat;

  @override
  _CuerpoState createState() => _CuerpoState();
}

class _CuerpoState extends State<Cuerpo> {
  BuildContext context;

  @override
  void initState() {
    super.initState();
    //getPremios();
  }

  Future<List> _getPremios() async {
    var cate = widget.idCat;
    var url = 'http://${Constantes.HOST}/RIT/Select/C-Premios.php?categoria=$cate';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    List premios = [];
    if (!data["fallo"]) {
      premios = data["premios"];
    } else {
      print("seguridad");
    }

    return premios;
  }



  @override
  Widget build(BuildContext context) {
    this.context = context;
    return LayoutBuilder(
      builder: (context,constraint){
        //SizeConfig().iniciar(constraints);
        return Container(
          child: FutureBuilder(
              future: _getPremios(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: SizedBox(
                        width: 42 * SizeConfig.widthMultiplier,
                        height: 42 * SizeConfig.widthMultiplier,
                        child: CircularProgressIndicator(strokeWidth: 4 * SizeConfig.widthMultiplier/*18*/,),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int idx) {
                                    //int costo = SizeConfig.heightMultiplier.toInt(); //int.parse(snapshot.data[idx]["costo"]
                                return ModeloProducto(
                                    snapshot.data[idx]["nombre"],
                                    snapshot.data[idx]["descripcion"],
                                    int.parse(snapshot.data[idx]["costo"]),
                                    snapshot.data[idx]["urlIcono"]);
                              }, childCount: snapshot.data.length),
                        )
                      ],
                    ),
                  );
                }
              }),
        );
      },
    );
  }
}

class Cuerpo2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int idx) {
              return ModeloProducto(
                  "Nombre #$idx", "Descripcion #$idx", idx, "");
            }, childCount: 12),
          )
        ],
      ),
    );
  }
}
