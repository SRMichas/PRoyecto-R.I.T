import 'package:flutter/material.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;
import 'package:tapitas/Extras/size_config.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapitas/Entidades/mi_excepcion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Entidades/compra.dart';

class Gasto extends StatefulWidget {
  @override
  _GastoState createState() => _GastoState();
}

class _GastoState extends State<Gasto> {

  BuildContext context;
  Future<Map<String, dynamic>> _futuro;
  bool bandera = false;
  SharedPreferences prefs;
  int _status;
  Widget _vista;

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

    Map parametros = {"usId" : id, "rt" : "12"};

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

  Widget futureBuilder(){
    return FutureBuilder(
        future: _futuro,
        builder:(BuildContext context,AsyncSnapshot snapshot){
          Widget vista;

          if( snapshot.connectionState == ConnectionState.waiting){
            return Container(
              child: Center(
                child: SizedBox(
                  width: SizeConfig.conversionAncho(190, false),
                  height: SizeConfig.conversionAncho(190, false),
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                    strokeWidth: SizeConfig.conversionAncho(4, false) ,
                  ),
                ),
              ),
            );
          }

          if( snapshot.hasData){
            bool error = snapshot.data["fallo"].toString() == "true";
            //int codigo = snapshot.data["codigo"];

            if( !error ){
              vista = _Lista(lista: snapshot.data["lista"],);
            }else{
              vista = Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                        Icons.error,
                        color: Colors.red,
                        size:SizeConfig.conversionAlto(200, false)),
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
}

class _Lista extends StatelessWidget {

  int size = 10;
  final List lista;

  _Lista({this.lista});

  @override
  Widget build(BuildContext context) {
    List<Gastado> compras = lista.map((valor) => Gastado.fromJson(valor)).toList();
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:SliverChildBuilderDelegate((context, index){
            return _ModeloGasto(gastado: compras[index],);
          },childCount:lista.length ?? size),
        ),
      ],
    );
  }
}

class _ModeloGasto extends StatelessWidget {


  String url="http://192.168.1.111/RIT/img/telcel_icon.png";
  final Gastado gastado;
  _ModeloGasto({this.gastado});


  @override
  Widget build(BuildContext context) {
    double tamano = SizeConfig.conversionAlto(70, false),
    divisor = SizeConfig.conversionAlto(2, false),
    cache = 1000;
    return Column(
      children: <Widget>[
        Container(
          //color: Colors.red ,
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.conversionAncho(10, false),
              vertical: SizeConfig.conversionAlto(5, false)
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.network(
                    gastado.urlFoto ?? url,
                    width: tamano,
                    height: tamano,
                    cacheHeight: cache.toInt(),
                    cacheWidth: cache.toInt(),
                  ),
                  SizedBox(width: SizeConfig.conversionAncho(5, false),),
                  Container(
                    //color:Colors.blue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(gastado.nombre ?? "Nombre",style: conts.Estilo.estiloTitulo,),
                        SizedBox(height: SizeConfig.conversionAlto(30, false),),
                        Text(gastado.descripcion ?? "Descripcion",style: conts.Estilo.estiloDescripcion),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: SizeConfig.conversionAlto(5, false),),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: SizeConfig.conversionAncho(10, false)),
                    child: Text("Usados: ${gastado.conteo ?? 0}",style: conts.Estilo.estiloUsado,),
                  ),
                  Text(gastado.fecha ?? "00/00/0000",style: conts.Estilo.estiloFecha,)
                ],
              ),
            ],
          ),
        ),
        Divider(thickness: divisor,height: divisor,color: Colors.black,)
      ],
    );
  }
}


class Gasto1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Icon(Icons.access_time,size: 300),
      ),
    );
  }
}
