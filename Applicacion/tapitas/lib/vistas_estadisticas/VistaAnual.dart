import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Entidades/Historico.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Extras/Constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapitas/MiExcepcion.dart';

class VistaAnual extends StatefulWidget {
  @override
  _VistaAnualState createState() => _VistaAnualState();
}

class _VistaAnualState extends State<VistaAnual>
    with AutomaticKeepAliveClientMixin<VistaAnual> {
  String _preMensaje = "", _seleccionado = "";
  Future<Map<String, dynamic>> _futuroAnual;
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
    var id = int.parse(prefs.getString("id"));
    var url = 'http://${Constantes.HOST + Constantes.RT_SLT}';
    url += '/C-EstadisticasAno.php?usId=$id';

    try{
      http.Response response = await http.get(url);
      _status = response.statusCode;

      if( _status == 200) {
        var data = jsonDecode(response.body);
        print(data.toString());
        bandera = false;
        return data;
      }else{
        throw MiExcepcion("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",0,Icons.print);
      }
    } on FormatException catch (e){
      bandera = false;
      throw MiExcepcion("Error al conectar con el servidor",2,Icons.info,e);
    } on Exception catch (e){
      //el servidor esta apagado -> a rechazado la conexion
      bandera = false;
      throw MiExcepcion("Se ha rechazado la conexión",1,Icons.signal_wifi_off,e);
    }
  }

  static List<charts.Series<HistoricoAnual, String>> _infoAnual(List info) {
    List<HistoricoAnual> data =
    info.map((val) => HistoricoAnual.fromJson(val)).toList();

    return [
      new charts.Series<HistoricoAnual, String>(
        id: 'anual',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (HistoricoAnual historico, _) => historico.mes,
        measureFn: (HistoricoAnual historico, _) => historico.tapas,
        data: data,
      )
    ];
  }

  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    String algo = "", algoAntes = "";

    if (selectedDatum.isNotEmpty) {
      algo = selectedDatum.first.datum.tapas.toString();
      if (algo == "0") {
        algo = "";
        algoAntes = "";
      } else {
        algoAntes = "Tapas seleccionadas: ";
      }
      print(algo);
    }

    setState(() {
      _preMensaje = algoAntes;
      _seleccionado = algo;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _futuroAnual = getInfo();
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
        future: _futuroAnual,
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
                    strokeWidth: 4 * SizeConfig.widthMultiplier /*18*/,
                  ),
                ),
              ),
            );
          }

          if( snapshot.hasData){
            bool error = snapshot.data["fallo"].toString() == "true";
            int codigo = snapshot.data["codigo"];

            if (error) {
              switch (codigo) {
                case 1:
                  vista = Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                            Icons.adb,
                            color: Colors.red,
                            size:(200 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier),
                        Text(
                          snapshot.data["mensaje"].toString(),
                          textAlign: TextAlign.center,
                          style: estiloS,
                        ),
                        SizedBox(height:(30 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier),
                        Text(
                          Constantes.SIN_TAPAS,
                          textAlign: TextAlign.center,
                          style: estiloS,
                        ),
                      ],
                    ),
                  );
                  break;
                default:
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
                              _futuroAnual = getInfo();
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
                  break;
              }
            } else {
              vista = Column(
                children: <Widget>[
                  SizedBox(height: ( 10 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier,),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: charts.BarChart(
                      _infoAnual(snapshot.data["puntos"]),
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
                    "Tapas acumuladas en este año: ",
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
            }
          }else if( snapshot.hasError){
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
                        _futuroAnual = getInfo();
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
