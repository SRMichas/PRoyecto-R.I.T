import 'dart:math';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/Constantes.dart';


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
  double porcentaje = 1;
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
    //_tapasInfo();
  }
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return contenedorMaestro3();
  }

  void calculos() {
    var rng = new Random();
    real = rng.nextInt(1000) + 1;
    faltantes = 1000 - real;

    porcentaje = real.toDouble() / 1000.0;
    porcentaje = double.parse(porcentaje.toStringAsPrecision(3));
    //print(porcentaje.toString());
    /*porcentaje = double.parse(rng.nextDouble().toStringAsPrecision(2));
    double tmp = (porcentaje * 100);
    real = tmp.toInt() ;*/
  }

  double calculos2(int numeroReal) {
    double porcentaje = 0;

    porcentaje = numeroReal.toDouble() / 1000.0;
    porcentaje = double.parse(porcentaje.toStringAsPrecision(3));
    //print(porcentaje.toString());
    return porcentaje;
  }

  Future<Map<String, dynamic>> tapasInfo() async{
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    var cate = 1;
    var url = 'http://${Constantes.HOST}/RIT/Select/C-Tapas.php?us_id=$cate';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);

    if (!data["fallo"]) {

      print("lalslaslas");
    } else {
      print("seguridad");
    }

    return data;
  }

  Container contenedorMaestro2() {
    return Container(
      child:FutureBuilder(
          future: tapasInfo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if( snapshot.data != null){
              return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints viewportConstraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
                        child: contenedorMaestro(
                            snapshot.data["tapasRestantes"],
                            snapshot.data["tapasAcumuladas"].toString()
                        ),
                      ),
                    );
                  }
              );
            }else{
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
            }

            /*if(snapshot.connectionState == ConnectionState.done) {
              if( snapshot.hasData){

                return LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints viewportConstraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
                          child: contenedorMaestro(
                              snapshot.data["tapasRestantes"],
                              snapshot.data["tapasAcumuladas"].toString()
                          ),
                        ),
                      );
                    }
                );

                return contenedorMaestro(
                    snapshot.data["tapasRestantes"],
                    snapshot.data["tapasAcumuladas"].toString()
                );
              }

            } else {
              return Container(
                width: 250,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }*/

          }
      ),
    );
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
                        return contenedorMaestro(
                            snapshot.data["tapasRestantes"],
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
    print("ln");
    print("Radio $radio");
    print("En una variable ${(320 / SizeConfig.widthMultiplier) * SizeConfig.widthMultiplier}");
    print("Diferentes ${radio * SizeConfig.widthMultiplier}");
    print("Otro mas ${75 * SizeConfig.widthMultiplier}");
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

  double container = (115 / SizeConfig.heightMultiplier)  * SizeConfig.heightMultiplier;
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



class Cuerpo extends StatelessWidget {
  double porcentaje = 1;
  int real, faltantes;
  BuildContext context;

  TextStyle estilo = TextStyle(
    fontSize: 28,
  );

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: contenedorMaestro("1","123"),
          ),
        );
      },
    );
  }

  void calculos() {
    var rng = new Random();
    real = rng.nextInt(1000) + 1;
    faltantes = 1000 - real;

    porcentaje = real.toDouble() / 1000.0;
    porcentaje = double.parse(porcentaje.toStringAsPrecision(3));
    print(porcentaje.toString());
    /*porcentaje = double.parse(rng.nextDouble().toStringAsPrecision(2));
    double tmp = (porcentaje * 100);
    real = tmp.toInt() ;*/
  }


  Container contenedorMaestro(String acumuladas,String restantes) {
    //calculos();

    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 45,
          ),
          Container(
              child: Text(
            "$restantes Tapas para ayudar a un niño",
            style: estilo,
            textAlign: TextAlign.center,
          )),
          SizedBox(
            height: 30,
          ),
          Stack(
            children: <Widget>[
              Center(
                child: CircularPercentIndicator(
                    radius: 270.0,
                    startAngle: 230,
                    //220,270
                    percent: porcentaje,
                    //0.510 * porcentaje,//0.775,0.951
                    animation: true,
                    backgroundColor: Colors.transparent,
                    lineWidth: 15,
                    arcType: ArcType.HALF,
                    circularStrokeCap: CircularStrokeCap.round,
                    arcBackgroundColor: Colors.blueAccent,
                    center: Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "$real Tapas\nContadas",
                        style: estilo,
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width,
                bottom: 60,
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
            margin: EdgeInsets.only(bottom: 15),
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
    return Container(
      margin: EdgeInsets.only(right: 0),
      width: MediaQuery.of(context).size.width / 2,
      height: 100,
      child: Card(
        elevation: 4,
        child: Image.asset(
          'assets/img/apac.jpg',
          width: 50,
          height: 70,
          cacheHeight: 70,
        ),
      ),
    );
  }

  Container tarjeta2() {
    return Container(
      margin: EdgeInsets.only(left: 0),
      width: MediaQuery.of(context).size.width / 2,
      height: 100,
      child: Card(
        elevation: 4,
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
    return Container(
      //margin: EdgeInsets.only(left: 10,right: 10),
      width: MediaQuery.of(context).size.width,
      height: 120,
      child: Card(
          elevation: 4,
          child: Row(
            children: <Widget>[
              Image.asset(
                'assets/img/tecmn.png',
                width: MediaQuery.of(context).size.width / 2,
              ),
              Image.asset(
                'assets/img/teclogo_v2.png',
                scale: 5,
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

class Cuerpo2 extends StatelessWidget {
  double porcentaje = 1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularPercentIndicator(
        radius: 200.0,
        startAngle: 270,
        //220,270
        percent: 0.951 * porcentaje,
        //0.775,0.951
        animation: true,
        backgroundColor: Colors.transparent,
        center: Text(""),
      ),
    );
  }
}
//================================================================================================================================================================

class CustomText {
  final String label;
  final double fontSize;
  final String fontName;
  final int textColor;
  final int iconColor;
  final TextAlign textAlign;
  final int maxLines;
  final IconData icon;

  CustomText(
      {@required this.label,
      this.fontSize = 10.0,
      this.fontName,
      this.textColor = 0xFF000000,
      this.iconColor = 0xFF000000,
      this.textAlign = TextAlign.start,
      this.maxLines = 1,
      this.icon = Icons.broken_image});

  Widget text() {
    var text = new Text(
      label,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: new TextStyle(
        color: Color(textColor),
        fontSize: fontSize,
        fontFamily: fontName,
      ),
    );

    return new Row(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.all(10.0),
          child: new Icon(
            icon,
            color: Color(iconColor),
          ),
        ),
        text
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Card statsWidget() {
    return new Card(
        elevation: 1.5,
        margin: EdgeInsets.only(bottom: 280, left: 20.0, right: 20.0),
        color: Colors.white,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.all(20.0),
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Align(
                            alignment: Alignment.center,
                            child: new Text(
                              "Photos",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                            )),
                        new Align(
                            alignment: Alignment.center,
                            child: new Text(
                              "22k",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                color: Color(0xff167F67),
                              ),
                            )),
                      ],
                    ),
                    flex: 1,
                  ),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Align(
                            alignment: Alignment.center,
                            child: new Text(
                              "Followers",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                color: Colors.grey,
                                fontSize: 16.0,
                              ),
                            )),
                        new Align(
                            alignment: Alignment.center,
                            child: new Text(
                              "232k",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                color: Color(0xff167F67),
                              ),
                            )),
                      ],
                    ),
                    flex: 1,
                  ),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Align(
                            alignment: Alignment.center,
                            child: new Text(
                              "Following",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 16.0),
                            )),
                        new Align(
                            alignment: Alignment.center,
                            child: new Text(
                              "332k",
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                color: Color(0xff167F67),
                              ),
                            )),
                      ],
                    ),
                    flex: 1,
                  )
                ],
              ),
            )
          ],
        ));
  }

  @override
  build(BuildContext context) {
    return new Material(
        type: MaterialType.transparency,
        child: new Stack(
          children: [
            new Column(
              children: <Widget>[
                headerWidget(),
                bodyWidget(),
              ],
            ),
            new Center(
              child: statsWidget(),
            ),
          ],
        ));
  }

  Widget headerWidget() {
    var header = new Expanded(
      child: new Container(
        decoration: new BoxDecoration(
          color: const Color(0xff167F67),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Center(
              child: new Container(
                margin: EdgeInsets.only(bottom: 10.0),
                height: 80.0,
                width: 80.0,
                decoration: new BoxDecoration(
                  color: const Color(0xff167F67),
                  image: new DecorationImage(
                    image: new NetworkImage(
                        "https://4.bp.blogspot.com/-QXHUYmKycZU/W-Vv9G01aAI/AAAAAAAAATg/eF1ArYpCo7Ukm1Qf-JJhwBw3rOMcj-h6wCEwYBhgL/s1600/logo.png"),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.white, width: 2.0),
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(40.0)),
                ),
              ),
            ),
            new Text(
              "Developer Libs",
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Color(0xffffffff),
              ),
            )
          ],
        ),
      ),
      flex: 1,
    );

    return header;
  }

  Widget bodyWidget() {
    var bodyWidget = new Expanded(
      child: new Container(
          decoration: new BoxDecoration(
            color: const Color(0xffffffff),
          ),
          child: new Padding(
            padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 50.0),
            child: new Column(
              children: <Widget>[
                new CustomText(
                        label: "contact@developerlibs",
                        textColor: 0xff858585,
                        iconColor: 0xff167F67,
                        fontSize: 15.0,
                        icon: Icons.email)
                    .text(),
                new CustomText(
                        label: "+919999999999",
                        textColor: 0xff858585,
                        iconColor: 0xff167F67,
                        fontSize: 15.0,
                        icon: Icons.phone)
                    .text(),
                new CustomText(
                        label: "Developer libs",
                        textColor: 0xff858585,
                        iconColor: 0xff167F67,
                        fontSize: 15.0,
                        icon: Icons.youtube_searched_for)
                    .text(),
                new CustomText(
                        label: "Google Map",
                        textColor: 0xff858585,
                        iconColor: 0xff167F67,
                        fontSize: 15.0,
                        icon: Icons.add_location)
                    .text(),
              ],
            ),
          )),
      flex: 2,
    );
    return bodyWidget;
  }
}
