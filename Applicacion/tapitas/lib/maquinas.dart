import 'package:flutter/material.dart';
import 'package:tapitas/CustomViews/mi_drop_down.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Entidades/mi_excepcion.dart';

class Maquinas extends StatefulWidget {
  @override
  _MaquinasState createState() => _MaquinasState();
}

class _MaquinasState extends State<Maquinas> {

  double divisor = 2;//SizeConfig.conversionAlto(2, false);
  Widget _vistaHolder;
  Future<Map<String, dynamic>> _futuro;

  bool bandera = false;
  int _status;
  
  @override
  void initState() {
    _futuro = getEstados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 0,),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text("Seleccione un estado: ",style: conts.Estilo.ESTILO_TITULO_MAQUINA,),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 0),
                    child: MiDrop(hintValue: "Nada Seleccionado",),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            Divider(height: divisor,thickness: divisor,),
            Expanded(
              child: Container(
                color: Colors.green,
                child: _vistaHolder,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> getEstados() async{
    var url = '${conts.Constantes.HOST+conts.Constantes.RT_SLT}';
    url += "C-Estados2.php";

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
              //vista = _Lista(lista: snapshot.data["lista"],);
              vista = Center(
                child: Text("Aqui esta lo bueno"),
              );
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
}
