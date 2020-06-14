import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Entidades/historico.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Extras/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapitas/Entidades/mi_excepcion.dart';

class VistaSemanal extends StatefulWidget {
  @override
  _VistaSemanalState createState() => _VistaSemanalState();
}

class _VistaSemanalState extends State<VistaSemanal>
    with AutomaticKeepAliveClientMixin<VistaSemanal> {
  String _preMensaje = "", _seleccionado = "";
  Future<Map<String, dynamic>> _futuroSemanal;
  int _status = 0;
  Widget _vista;
  bool bandera = false;

  TextStyle estiloS = TextStyle(
          fontSize:
              (28 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier),
      estiloPre1 = TextStyle(
          fontSize:
              (22 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier),
      estiloResal = TextStyle(
          fontSize:
              (24 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier,
          fontWeight: FontWeight.bold),
      estiloError = TextStyle(
          fontSize: (24 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier);

  Future<Map<String, dynamic>> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    var url = '${Constantes.HOST + Constantes.RT_SLT}';
    url += 'C-Estadisticas.php';

    Map parametros = { "usId" : id };
    try{
      http.Response response = await http.post(url,body: parametros);
      _status = response.statusCode;

      if( _status == 200) {
        var data = jsonDecode(response.body);
        bandera = false;
        return data;
      }else{
        throw Exception("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      }
    } on FormatException catch (e){
      //no se puede conectar con la base de datos -> a rechazado la conexion
      bandera = false;
      throw MiExcepcion("Error al conectar con el servidor",2,Icons.info,e);
    } on Exception catch (e){
      //el servidor esta apagado -> a rechazado la conexion
      bandera = false;
      throw MiExcepcion("Se ha rechazado la conexión",1,Icons.signal_wifi_off,e);
    }
  }

  List<charts.Series<Historico, String>> _infoSemanal(List info) {
    List<Historico> data = info.map((val) => Historico.fromJson(val)).toList();
    return [
      new charts.Series<Historico, String>(
        id: "semanal",
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Historico historico, _) => historico.dia,
        measureFn: (Historico historico, _) => historico.tapas,
        data: data,
      )
    ];
  }

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    String tapas = "", mensaje = "",dia="";

    if (selectedDatum.isNotEmpty) {
      tapas = selectedDatum.first.datum.tapas.toString();
      dia = selectedDatum.first.datum.dia.toString();
      if (tapas == "0") {
        tapas = "";
        mensaje = "";
        dia = "";
      } else {
        mensaje = "Tapas depositadas el $dia: ";
      }
    }

    setState(() {
      _preMensaje = mensaje;
      _seleccionado = tapas;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _futuroSemanal = getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if( !bandera ){
      _vista = futureBuilder();
    }
    return Container(
      child: _vista,
    );
  }

  Widget futureBuilder(){
    return FutureBuilder(
        future: _futuroSemanal,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget vista;

          if( snapshot.connectionState == ConnectionState.waiting){
            return Container(
              child: Center(
                child: SizedBox(
                  width: 42 * SizeConfig.widthMultiplier,
                  height: 42 * SizeConfig.widthMultiplier,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                    strokeWidth: 4 * SizeConfig.widthMultiplier ,
                  ),
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            bool fallo = snapshot.data["fallo"].toString() == "true";

            if (!fallo) {
              vista = Column(
                children: <Widget>[
                  SizedBox(height: ( 10 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier,),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: charts.BarChart(
                      _infoSemanal(snapshot.data["puntos"]),
                      animate: false,
                      selectionModels: [
                        new charts.SelectionModelConfig(
                            type: charts.SelectionModelType.info,
                            changedListener: _onSelectionChanged)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: (50 * SizeConfig.heightMultiplier) /
                        SizeConfig.heightMultiplier,
                  ),
                  Text(
                    "Tapas acumuladas en esta semana: ",
                    style: estiloPre1,
                  ),
                  SizedBox(
                    height: (10 * SizeConfig.heightMultiplier) /
                        SizeConfig.heightMultiplier,
                  ),
                  Text(
                    snapshot.data["total"].toString(),
                    style: estiloResal,
                  ),
                  SizedBox(
                    height: (30 * SizeConfig.heightMultiplier) /
                        SizeConfig.heightMultiplier,
                  ),
                  Text(
                    _preMensaje,
                    style: estiloPre1,
                  ),
                  SizedBox(
                    height: (10 * SizeConfig.heightMultiplier) /
                        SizeConfig.heightMultiplier,
                  ),
                  Text(
                    _seleccionado,
                    style: estiloResal,
                  )
                ],
              );
            } else {
              vista = Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                        Icons.error,
                        color: Colors.red,
                        size:(200 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier),
                    Text(
                      snapshot.data["mensaje"].toString(),
                      textAlign: TextAlign.center,
                      style: estiloS,
                    ),
                    SizedBox(height:(30 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier),
                    FlatButton(
                      onPressed: () => setState(() {
                        bandera = false;
                        try {
                          _futuroSemanal = getInfo();
                        }catch(e){
                          print("ESTE EST EL ERROR =====> ${e.toString()}");
                        }
                      }),
                      child: Text("Reitentar",style: estiloPre1,),
                      textColor: Colors.blue,
                    )
                  ],
                ),
              );
            }
          } else if (snapshot.hasError) {
            MiExcepcion e = snapshot.error;

            vista = Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(e.icono,size:( 200 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier,),
                  Text("${e.mensaje}",style: estiloError,),
                  SizedBox(height:(30 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier),
                  FlatButton(
                    onPressed: () => setState(() {
                      bandera = false;
                      try {
                          _futuroSemanal = getInfo();
                      }catch(e){
                        print("ESTE EST EL ERROR =====> ${e.toString()}");
                      }
                    }),
                    child: Text("Reintentar",style: estiloPre1,),
                    textColor: Colors.blue,
                  )
                ],
              ),
            );
          }
          return vista;
        });
  }
}

