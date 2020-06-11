import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;
import 'package:tapitas/Entidades/mi_excepcion.dart';

/*class Puntuacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Puntuacion"),
      ),
      body: new Puntuacion(),
    );
  }
}*/

class Puntuacion extends StatefulWidget {
  @override
  _PuntuacionState createState() => _PuntuacionState();
}

class _PuntuacionState extends State<Puntuacion> {
  double container = SizeConfig.conversionAlto(115, false);
  BuildContext context;
  Future<Map<String,dynamic>> _future;
  bool bandera = false;

  TextStyle estilo = TextStyle(
    fontSize: (3.62 * SizeConfig.heightMultiplier),
  );

  ShapeBorder estiloTarjeta = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)));

  @override
  void initState() {
    _future = tapasInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return contenedorMaestro3();
  }

  double calculoPorcentaje(int numeroReal) {
    double porcentaje = 0;
    porcentaje = numeroReal.toDouble() / 1000.0;
    porcentaje = double.parse(porcentaje.toStringAsPrecision(3));

    return porcentaje;
  }

  Future<Map<String, dynamic>> tapasInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = "1";//prefs.getString("id");
    var url = '${conts.Constantes.HOST+conts.Constantes.RT_SLT}';
    url += "C-Tapas2.php";
    Map parametros ={ "usId" : id };

    /*http.Response response = await http.post(url,body: parametros);
    var data = jsonDecode(response.body);*/
    try{
      http.Response response = await http.post(url,body: parametros);
      int _status = response.statusCode;

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
      throw MiExcepcion("Error al conectar con el servidor \n${e.toString()}",2,Icons.info,e);
    } on Exception catch (e){
      //el servidor esta apagado -> a rechazado la conexion
      bandera = false;
      throw MiExcepcion("Se ha rechazado la conexión",1,Icons.signal_wifi_off,e);
    } on TypeError catch (e){
      bandera = false;
      throw MiExcepcion(e.toString(),1,Icons.signal_wifi_off,e);
    }

    //print(data.toString());

    //return data;
  }

  Widget contenedorMaestro3() {
    return LayoutBuilder(
        builder: (context,constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: Container(
                child: FutureBuilder(
                    future: _future,
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

                        if( !error ){
                          vista = contenedorMaestro(
                              snapshot.data["tapasRestantes"] ?? 5,
                              snapshot.data["tapasAcumuladas"].toString()
                          );
                        }else{
                          vista = Container(
                            alignment: Alignment.center,
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
                                  style: TextStyle( fontSize: SizeConfig.conversionAlto(28, false)),
                                ),
                                SizedBox(height:(30 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier),
                                FlatButton(
                                  onPressed: () => setState(() {
                                    bandera = false;
                                    try {
                                      _future = tapasInfo();
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
                                    _future = tapasInfo();
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
                      /*if (snapshot.data != null) {

                        return contenedorMaestro(
                            snapshot.data["tapasRestantes"] ?? 5,
                            snapshot.data["tapasAcumuladas"].toString()
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: SizedBox(
                              width: 42 * SizeConfig.widthMultiplier,
                              height: 42 * SizeConfig.widthMultiplier,
                              child: CircularProgressIndicator(strokeWidth: 4 *
                                  SizeConfig.widthMultiplier ,),
                          ),
                        ),
                      );
                    }*/
                  },
                ),
              ),
            ),
          );
        });
  }

  Container contenedorMaestro(int acumuladas,String restantes) {
    double radio = (320 / SizeConfig.widthMultiplier) ;
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5.83 * SizeConfig.heightMultiplier,
          ),
          Container(
              child: Text(
                "$restantes Tapas para ayudar a un niño",
                style: estilo,
                textAlign: TextAlign.center,
              )),
          SizedBox(
            height: 3.88 * SizeConfig.heightMultiplier, 
          ),
          Stack(
            children: <Widget>[
              Center(
                child: CircularPercentIndicator(
                    radius: radio * SizeConfig.widthMultiplier,
                    startAngle: 230,
                    percent: calculoPorcentaje(acumuladas),
                    animation: true,
                    backgroundColor: Colors.transparent,
                    lineWidth: 4.17 * SizeConfig.widthMultiplier,
                    arcType: ArcType.HALF,
                    circularStrokeCap: CircularStrokeCap.round,
                    arcBackgroundColor: Colors.blueAccent,
                    center: Container(
                      padding: EdgeInsets.only(bottom: 3 * SizeConfig.heightMultiplier),
                      child: Text(
                        "$acumuladas Tapas\nContadas",
                        style: estilo,
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width,
                bottom: 7.76 * SizeConfig.heightMultiplier,
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Puntos actuales",
                      style: estilo,
                      textAlign: TextAlign.center,
                    )),
              )
            ],
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 1.94 * SizeConfig.heightMultiplier),
            child: Row(
              children: <Widget>[tarjeta1(), tarjeta2()],
            ),
          ),
          tarjeta3()
        ],
      ),
    );
  }

  Container tarjeta1() {
    double imgHeigth = (90 / SizeConfig.heightMultiplier)  * SizeConfig.heightMultiplier;
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: container,
      child: Card(
        shape: estiloTarjeta,
        elevation: 0.52 * SizeConfig.heightMultiplier,
        child: Image.asset(
          'assets/img/apac.jpg',
          width: 10.41 * SizeConfig.widthMultiplier, 
          height: imgHeigth,
          cacheHeight: imgHeigth.toInt(),
        ),
      ),
    );
  }

  Container tarjeta2() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: container,
      child: Card(
        shape: estiloTarjeta,
        elevation: 0.52 * SizeConfig.heightMultiplier,
        child: Image.asset(
          'assets/img/casa_valentina.png',
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          cacheHeight: (MediaQuery.of(context).size.height / 2).toInt(),
        ),
      ),
    );
  }

  Container tarjeta3() {
    double largeContainer = (170 / SizeConfig.heightMultiplier)  * SizeConfig.heightMultiplier,
        image = (150 / SizeConfig.heightMultiplier) * SizeConfig.heightMultiplier;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: largeContainer, 
      child: Card(
          shape: estiloTarjeta,
          elevation: 0.52 * SizeConfig.heightMultiplier,
          child: Row(
            children: <Widget>[
              Image.asset(
                'assets/img/tecmn.png',
                width: MediaQuery.of(context).size.width * 0.65,
                height: image,
              ),
              Image.asset(
                'assets/img/teclogo_v2.png',
                scale: 4,
                alignment: AlignmentDirectional.centerEnd,
              ),
            ],
          )),
    );
  }
}