import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/constantes.dart';

class Puntuacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Puntuacion"),
      ),
      body: new CuerpoEp(),
    );
  }
}

class CuerpoEp extends StatefulWidget {
  @override
  _CuerpoEpState createState() => _CuerpoEpState();
}

class _CuerpoEpState extends State<CuerpoEp> {
  double container = SizeConfig.conversionAlto(115, false);
  BuildContext context;
  Future<Map<String,dynamic>> _future;

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
    var id = prefs.getString("id");
    var url = '${Constantes.HOST+Constantes.RT_SLT}';
    url += "C-Tapas2.php";
    Map parametros ={ "usId" : id };

    http.Response response = await http.post(url,body: parametros);
    
    var data = jsonDecode(response.body);

    print(data.toString());

    return data;
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
                      if (snapshot.data != null) {

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
                    }
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