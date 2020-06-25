import 'package:flutter/material.dart';
import 'package:tapitas/CustomViews/mi_drop_down.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Entidades/estados.dart';
import 'Entidades/mi_excepcion.dart';
import 'package:tapitas/CustomViews/machine_list_model.dart';
import 'package:tapitas/Extras/utilidades.dart' as util;
import 'package:tapitas/Entidades/ciudad.dart';
import 'package:tapitas/Extras/my_flutter_app_icons.dart';

class Maquinas extends StatefulWidget {
  @override
  _MaquinasState createState() => _MaquinasState();
}

class _MaquinasState extends State<Maquinas> {

  double divisor = SizeConfig.conversionAlto(2, false);
  Widget _vistaHolder;
  Future<Map<String, dynamic>> _futuro;
  List<Object> _estados;
  String _dropTextHolder = "Nada Seleccionado";
  int _indice = -1;


  bool bandera = false,_indice2;
  int _status,_id;
  
  @override
  void initState() {
    estadosAsincronico();
    _vistaHolder = holder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            Container(
              //color: Colors.red,
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.conversionAncho(15, false),
                  vertical: SizeConfig.conversionAlto(20, false)
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: SizeConfig.conversionAlto(0, false),),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: SizeConfig.conversionAlto(20,false)),
                    child: Text("Seleccione un estado: ",style: conts.Estilo.ESTILO_TITULO_MAQUINA,),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: SizeConfig.conversionAncho(0, false)),
                    child: MiDrop(
                      hintValue: _dropTextHolder,
                      listValues: _estados,
                      function: cambiaDatos,
                      widgetRoute: conts.Constantes.MAQUINA_ROUTE,
                    ),
                  ),
                  SizedBox(height: SizeConfig.conversionAlto(10, false),),
                ],
              ),
            ),
            Divider(height: divisor,thickness: divisor,),
            Expanded(
              child: Container(
                //color: Colors.green,
                child: _vistaHolder,
              ),
            )
          ],
        ),
    );
  }

  void cambiaDatos(EstadoMin nombre){
    setState(() {
      _id = nombre.id;
      _dropTextHolder = nombre.nombre;
      _futuro = getMachines();
      _vistaHolder = futureBuilder();
    });
  }

  Widget holder(){
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Icon(Icons.accessibility,size: SizeConfig.conversionAlto(200, false),),
            Text("Nada que cargar",style: conts.Estilo.HOLDER,),
          ],
        ),
      ),
    );
  }

  Widget loadingHolder(){
    double size = SizeConfig.conversionAlto(55, false);
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              //color: Colors.yellow,
              margin: EdgeInsets.only(bottom: SizeConfig.conversionAlto(20, false)),
              child: Icon(conts.Otro.dato[_dropTextHolder],size: SizeConfig.conversionAlto(220, false),),
            ),
            SizedBox(
              height: size,
              width: size,
              child: CircularProgressIndicator(
                strokeWidth: SizeConfig.conversionAncho(8, false),
              ),
            ),
          ],
        ),
    );
  }
  
  Widget listView(List lista,{int size}){
    List<CiudadMin> cities = lista.map((valor) =>CiudadMin.fromJson(valor)).toList();
    bool expido;
    int algo;

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:SliverChildBuilderDelegate((context, index){
            CiudadMin city = cities[index];
            if( _indice == index){
              /*if( _indice == _indice2) {
                expido = false;
                algo = -1;
              }else{
                expido = true;
                algo = _indice;
              }*/
              expido = !_indice2;
            }else{
              expido = false;
              algo = _indice;
            }
            return MachineModel(city: city,machines: city.machines,idx: index,expanded: expido,funcion:(value,value2){
              cambiaLista(value,lista,value2);
            },);
          },childCount:lista.length ?? size),
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> getEstados() async{
    var url = '${conts.Constantes.HOST+conts.Constantes.RT_SLT}';
    url += "C-Estados2.php";
    await Future.delayed(Duration(seconds: 3));
    try{
      http.Response response = await http.post(url,);
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

  Future<Map<String, dynamic>> getMachines() async{
    var url = '${conts.Constantes.HOST+conts.Constantes.RT_SLT}';
    url += "C-Maquinas.php";

    Map parametros = {"edo" : "$_id"};

    await Future.delayed(Duration(seconds: 1));
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
            return loadingHolder();
          }

          if( snapshot.hasData){
            bool error = snapshot.data["fallo"].toString() == "true";
            //int codigo = snapshot.data["codigo"];

            if( !error ){
              //vista = _Lista(lista: snapshot.data["lista"],);
              vista = listView(snapshot.data["lista"],size: 25);
              //vista = listView(util.DataGenerator.stringList,size: 25);
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
                          _futuro = getMachines();
                          _vistaHolder = futureBuilder();
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
                        _futuro = getEstados();
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

  void estadosAsincronico() async{
    var data = await getEstados();
    List lista = data["lista"];
    _estados = lista.map((valor) => EstadoMin.fromJson(valor)).toList();
    setState(() {});
  }

  void cambiaLista(int idx,List lista,bool xp){
    setState(() {
      _indice2 = xp;
      _indice = idx;
      _vistaHolder = listView(lista);
      //listView(lista);
    });
  }
}
