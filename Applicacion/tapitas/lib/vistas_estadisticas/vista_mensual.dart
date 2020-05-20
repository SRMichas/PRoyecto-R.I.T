import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Entidades/historico.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Extras/constantes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapitas/Entidades/mi_excepcion.dart';

class VistaMensual extends StatefulWidget {
  @override
  _VistaMensualState createState() => _VistaMensualState();
}

class _VistaMensualState extends State<VistaMensual>
    with AutomaticKeepAliveClientMixin<VistaMensual> {
  String _preMensaje = "", _seleccionado = "";
  Future<Map<String, dynamic>> _futuroMensual;
  int _indice = 0, maximo;
  bool bandera = false,bandera2 = false;
  int _status = 0;
  Widget _vista;

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
  TextStyle estiloNombreMes = TextStyle(
    fontSize: (20 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier,
  );

  double tamanoFlecha =
      (30 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier;

  Future<Map<String, dynamic>> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = int.parse(prefs.getString("id"));
    var url = 'http://${Constantes.HOST + Constantes.RT_SLT}';
    url += 'C-EstadisticasMes.php?usId=$id';

    try{
      http.Response response = await http.get(url);
      _status = response.statusCode;

      if( _status == 200) {
        var data = jsonDecode(response.body);
        bandera2 = false;
        return data;
      }else{
        throw MiExcepcion("algo paso aqui",3,Icons.print);
      }
    } on FormatException catch (e){
      //no se puede conectar con la base de datos -> a rechazado la conexion
      bandera2 = false;
      throw MiExcepcion("Error al conectar con el servidor",2,Icons.info,e);
    } on Exception catch (e){
      //el servidor esta apagado -> a rechazado la conexion
      bandera2 = false;
      throw MiExcepcion("Se ha rechazado la conexión",1,Icons.signal_wifi_off,e);
    }
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
    }

    // Request a build.
    setState(() {
      _preMensaje = algoAntes;
      _seleccionado = algo;
    });
  }

  List<charts.Series<HistoricoMensual, DateTime>> _infoMensual(List info, List info2) {
    List<HistoricoMensual> data =
    info.map((val) => HistoricoMensual.fromJson(val)).toList();

    return [
      new charts.Series<HistoricoMensual, DateTime>(
        id: 'mensual',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (HistoricoMensual mensual, _) => mensual.fecha,
        measureFn: (HistoricoMensual mensual, _) => mensual.tapas,
        data: data,
      )
    ];
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _futuroMensual = getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if( !bandera2 ){
      _vista = futureBuilder();
    }

    return Container(
      child: _vista,
    );
  }

  Widget futureBuilder(){
    return FutureBuilder(
        future: _futuroMensual,
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
            //_indice = snapshot.data["puntos"].length - 1;
            bool fallo = snapshot.data["fallo"].toString() == "true";
            int code = int.parse(snapshot.data["codigo"].toString());

            if( !fallo ){
              if (!bandera) {
                maximo = snapshot.data["puntos"].length - 1;
                _indice = maximo;
                bandera = true;
              }
              vista = Column(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        SizedBox(height: ( 10 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier,),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _indice--;
                                if (_indice < 0) {
                                  _indice = maximo;
                                }
                                _preMensaje = "";
                                _seleccionado = "";
                              });
                            },
                            child: Icon(
                              Icons.chevron_left,
                              size: tamanoFlecha,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "${Constantes.MESES[_indice]}",
                            textAlign: TextAlign.center,
                            style: estiloNombreMes,
                          ),
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: tamanoFlecha,
                          alignment: Alignment.center,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _indice++;
                                if (_indice > maximo) {
                                  _indice = 0;
                                }
                              });
                            },
                            child: Icon(
                              Icons.chevron_right,
                              size: tamanoFlecha,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: charts.TimeSeriesChart(
                      //TimeSeriesBar.withSampleData(),
                      _infoMensual(snapshot.data["puntos"][_indice],
                          snapshot.data["puntos"]),
                      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
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
                    "Tapas acumuladas en este mes: ",
                    style: estiloPre1,
                  ),
                  SizedBox(
                    height: (10 * SizeConfig.heightMultiplier) /
                        SizeConfig.heightMultiplier,
                  ),
                  Text(
                    snapshot.data["total"][_indice].toString(),
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
            }else switch(code){
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
                          _futuroMensual = getInfo();
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
                        _futuroMensual = getInfo();
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