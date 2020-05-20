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
  double porcentaje = 1, container = SizeConfig.conversionAlto(115, false);
  int real, faltantes;
  BuildContext context;

  TextStyle estilo = TextStyle(
    fontSize: (3.62 * SizeConfig.heightMultiplier),//28
  );

  ShapeBorder estiloTarjeta = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)));

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return contenedorMaestro3();
  }

  double calculos2(int numeroReal) {
    double porcentaje = 0;
    porcentaje = numeroReal.toDouble() / 1000.0;
    porcentaje = double.parse(porcentaje.toStringAsPrecision(3));

    return porcentaje;
  }

  Future<Map<String, dynamic>> tapasInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = int.parse(prefs.getString("id"));
    var url = '${Constantes.HOST+Constantes.RT_SLT}';
    //url += "C-Tapas.php?usId=$id";
    url += "C-Tapas.php";
    Map header = {
      'Content-Type' : 'application/x-www-form-urlencoded'
    };
    print("$url ===> $id");
    Map parametos ={ "usId" : id};

    http.Response response = await http.post(url,body: parametos,headers: header);
    //http.Response response = await http.get(url);
    print(response.toString());
    var data = jsonDecode(response.body);

    return data;
  }

  Widget contenedorMaestro3() {
    return LayoutBuilder(
        builder: (context,constraint) {
          //SizeConfig().iniciar(constraint);
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: Container(
                child: FutureBuilder(
                    future: tapasInfo(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data != null) {
                        print(snapshot.data["mensaje"].toString());
                        return contenedorMaestro(
                            snapshot.data["tapasRestantes"] ?? 5,
                            snapshot.data["tapasAcumuladas"].toString()
                        );
                      } else {
                        return Container(
                          /*width: double.infinity,
                          height: double.infinity,*/
                          child: Center(
                            child: SizedBox(
                              width: 42 * SizeConfig.widthMultiplier,
                              height: 42 * SizeConfig.widthMultiplier,
                              child: CircularProgressIndicator(strokeWidth: 4 *
                                  SizeConfig.widthMultiplier /*18*/,),
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
    //calculos();
    double radio = (320 / SizeConfig.widthMultiplier) ;
    /*print("ln");
    print("Radio $radio");
    print("En una variable ${(320 / SizeConfig.widthMultiplier) * SizeConfig.widthMultiplier}");
    print("Diferentes ${radio * SizeConfig.widthMultiplier}");
    print("Otro mas ${75 * SizeConfig.widthMultiplier}");*/
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5.83 * SizeConfig.heightMultiplier,//45
          ),
          Container(
              child: Text(
                "$restantes Tapas para ayudar a un niño",
                style: estilo,
                textAlign: TextAlign.center,
              )),
          SizedBox(
            height: 3.88 * SizeConfig.heightMultiplier, //30
          ),
          Stack(
            children: <Widget>[
              Center(
                child: CircularPercentIndicator(
                    radius: radio * SizeConfig.widthMultiplier,//270
                    startAngle: 230,
                    //220,270
                    percent: calculos2(acumuladas),
                    //0.510 * porcentaje,//0.775,0.951
                    animation: true,
                    backgroundColor: Colors.transparent,
                    lineWidth: 4.17 * SizeConfig.widthMultiplier,//15
                    arcType: ArcType.HALF,
                    circularStrokeCap: CircularStrokeCap.round,
                    arcBackgroundColor: Colors.blueAccent,
                    center: Container(
                      padding: EdgeInsets.only(bottom: 3 * SizeConfig.heightMultiplier)/*20*/,
                      child: Text(
                        "$acumuladas Tapas\nContadas",
                        style: estilo,
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width,
                bottom: 7.76 * SizeConfig.heightMultiplier,//60
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
            //color: Colors.red,
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 1.94 * SizeConfig.heightMultiplier)/*15*/,
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
      //margin: EdgeInsets.only(right: 0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: container,
      child: Card(
        shape: estiloTarjeta,
        elevation: 0.52 * SizeConfig.heightMultiplier,//4
        child: Image.asset(
          'assets/img/apac.jpg',
          width: 10.41 * SizeConfig.widthMultiplier, //50
          height: imgHeigth,
          cacheHeight: imgHeigth.toInt(),
        ),
      ),
    );
  }

  Container tarjeta2() {
    return Container(
      //margin: EdgeInsets.only(left: 0),
      width: MediaQuery.of(context).size.width / 2,
      height: container,//100
      child: Card(
        shape: estiloTarjeta,
        elevation: 0.52 * SizeConfig.heightMultiplier,//4
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
      //margin: EdgeInsets.only(left: 10,right: 10),
      width: MediaQuery.of(context).size.width,
      height: largeContainer, //120
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
                /*width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.height/2,
              cacheHeight: (MediaQuery.of(context).size.height/2).toInt(),*/
              ),
            ],
          )),
    );
  }
}