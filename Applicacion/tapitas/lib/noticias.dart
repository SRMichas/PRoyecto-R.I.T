import 'package:flutter/material.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tapitas/Extras/utilidades.dart' as util;
import 'package:carousel_pro/carousel_pro.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Entidades/news.dart';

import 'Entidades/mi_excepcion.dart';


class Noticias extends StatefulWidget {
  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {

  Future<Map<String,dynamic>> _futuro;
  int _status;
  bool bandera = false;
  Widget _vista;

  @override
  void initState() {
    _futuro = getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if( !bandera )
      _vista = futureBuilder();

    return Container(
      child: _vista,
    );
  }

  Widget noticiasChidas(List starred, List almostStarred){
    List<News> starredNews = starred != null? starred.map((value) => News.fromJson(value)).toList(): null,
        almostStarredNews = almostStarred != null? almostStarred.map((value) => News.fromJson(value)).toList() : null;
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index){
            //return Carrousel(news: util.DataGenerator.samplesnews);
            return CarouselPage(functionA: _navegador,newsList: starredNews,);
          },childCount: 1),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index){
            util.newsSample sample = util.DataGenerator.samplesSubNews[index];
            return _ModeloNoticia2(news: almostStarredNews[index],function: (url) => _navegador(url),);
          },childCount: util.DataGenerator.samplesSubNews.length),
        )
      ],
    );
  }

  Widget eligeContenedor(int ruta){
    Widget vista;
    switch(ruta){
      case 1:
        vista = Carrousel(news: util.DataGenerator.samplesnews);
        break;
      case 2:
        vista = _ModeloNoticia();
        break;
      default:
        vista = _VistaDefault();
        break;
    }
    return vista;
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
            //int codigo = snapshot.data["codigo"];

            if( !error ){
              List starredNews = snapshot.data["lista"],almostStarredNews = snapshot.data["lista2"];

              vista = noticiasChidas(starredNews,almostStarredNews);
            }else{
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
                      style: TextStyle( fontSize: SizeConfig.conversionAlto(28, false)),
                    ),
                    SizedBox(height:(30 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier),
                    FlatButton(
                      onPressed: () => setState(() {
                        bandera = false;
                        try {
                          _futuro = getNews();
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
                        _futuro = getNews();
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

  Future<void> _navegador(String url) async{
    if( await canLaunch(url)){
      await launch(
          url,
          forceSafariVC: false,
          forceWebView: false,
          headers: <String,String>{"header" : "cabezera"}
      );
    }else{
      throw "No se puede abrir: $url";
    }
  }

  Future<Map<String, dynamic>> getNews() async{
    var url = '${conts.Constantes.HOST+conts.Constantes.RT_SLT}';
    url += "C-Noticia.php";

    try{
      http.Response response = await http.post(url);
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
}

class Carrousel extends StatefulWidget {

  final List news;

  Carrousel({this.news});

  @override
  _CarrouselState createState() => _CarrouselState();
}

class _CarrouselState extends State<Carrousel> {

  int _idx = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      //height: MediaQuery.of(context).size.height * 0.2,
      child: Column(
        children: <Widget>[
          CarouselSlider(
            items: widget.news.map((e){
              util.newsSample sample = e;
              _ModeloCarrusel(url:sample.url,header:sample.header);
            }).toList(),
            options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _idx = index;
                  });
                }
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.news.map((url) {
              int index = widget.news.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _idx == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  //final List newsImages = widget.news.map((item) => _ModeloCarrusel());
}


class _ModeloCarrusel extends StatelessWidget {

  final String url,header,desc;
  final Function function;
  final News news;

  _ModeloCarrusel({this.header,this.desc,this.url,this.function,this.news});

  @override
  Widget build(BuildContext context) {
    //print("$url\n$header");
    return Container(
      //color: Colors.yellow,
      //height: MediaQuery.of(context).size.height * 0.2,
      child: Stack(
        children: <Widget>[
          /*Container(
            alignment: Alignment.center,
            //height: MediaQuery.of(context).size.height * 0.22,
            child:,
          ),*/
          Positioned.fill(
            child:Image.network(
              news != null ? news.urlImage :"http://192.168.1.111/RIT/img/noticias/localidad_tecmaland.png",
                fit: BoxFit.fill,
              /*width: double.infinity,
                cacheWidth: MediaQuery.of(context).size.width.toInt(),*/
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: SizeConfig.conversionAlto(12, false)),
            child: InkWell(
              child: Text(
                news != null? news.headLine : "Encabezado de noticia",
                style: conts.Estilo.NEWS_TITLE_CARR,
              ),
              onTap: () => function(news != null? news.urlArticle :"http://google.com"),
            ),
          )
        ],
      ),
    );
  }
}


class _ModeloNoticia extends StatelessWidget {

  final String url,tit,desc;
  final News news;
  final Function(String) function;

  _ModeloNoticia({this.url,this.desc,this.tit,this.function,this.news});

  @override
  Widget build(BuildContext context) {
    double size = SizeConfig.conversionAlto(100, false);
    final scaffold = Scaffold.of(context);
    return Container(
      //color: Colors.red,
      child: Card(
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.conversionAncho(10, false),
            vertical: SizeConfig.conversionAlto(7, false)
        ),
        elevation: 2,
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.blue,
                    //width: SizeConfig.proporcionAncho(40),
                    child: Image.network(
                      news != null? news.urlImage : "http://192.168.1.111/RIT/img/noticias/cul.png",
                      height: size,
                      width: size,
                      fit: BoxFit.fill,
                    ),
                  )
              ),
              Expanded(
                flex: 4,
                child: Container(
                  //color: Colors.green,
                  padding: EdgeInsets.only(left: SizeConfig.conversionAncho(5, false)),
                  //width: SizeConfig.proporcionAncho(60),
                  margin: EdgeInsets.only(top: SizeConfig.conversionAlto(7, false)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                            news != null? text() : "Encabezado",
                            textAlign: TextAlign.start,
                            style:conts.Estilo.NEWS_TITLE,
                            softWrap: true,
                        ),
                      ),
                      SizedBox(height: SizeConfig.conversionAlto(15, false),),
                      /*Container(
                        child: Text(
                            news != null ? news.subHeadLine : "Descripcion breve",
                            textAlign: TextAlign.start,
                            style:conts.Estilo.NEWS_DESC ),
                      ),*/
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: SizeConfig.conversionAncho(5, false)),
                        child: RaisedButton(
                          color: conts.Colores.NEWS_BTN_BCK,
                          shape: RoundedRectangleBorder(
                              borderRadius:BorderRadius.circular(SizeConfig.conversionAncho(7, false)),
                              //side: BorderSide(color: Colors.blue)
                          ),
                          child: Text("ver más",style: conts.Estilo.NEWS_BTN,),
                          onPressed: (){

                            function(news != null? news.urlArticle : "http://192.168.1.111/index.html");

                            scaffold.showSnackBar(
                                SnackBar(
                                  content: const Text("Se abrió el navegador"),
                                  action: SnackBarAction(
                                      label: "cerrar", onPressed: scaffold.hideCurrentSnackBar),
                                )
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String text(){
    String msg = "";
    int lim = 50;
    if( news.headLine.length > lim){
      msg = "${news.headLine.substring(0,lim-1)}...";
    }else
      msg = news.headLine;

    return msg;
  }
}

class _ModeloNoticia2 extends StatelessWidget {

  final String url,tit,desc;
  final News news;
  final Function(String) function;

  _ModeloNoticia2({this.url,this.desc,this.tit,this.function,this.news});

  @override
  Widget build(BuildContext context) {
    double size = SizeConfig.conversionAlto(100, false);
    final scaffold = Scaffold.of(context);
    return Container(
      //color: Colors.red,
      child: Card(
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.conversionAncho(10, false),
            vertical: SizeConfig.conversionAlto(7, false)
        ),
        elevation: 2,
        child: InkWell(
          onTap: () => function(news != null? news.urlArticle : "http://192.168.1.111/index.html"),
          child: Container(
            //padding: null,
            height: SizeConfig.conversionAlto(150, false),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  //flex: 3,
                    child: Container(
                      //color: Colors.blue,
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          top: SizeConfig.conversionAlto(3, false),
                          right: SizeConfig.conversionAncho(0.4, false),
                          left: SizeConfig.conversionAncho(0.4, false)
                      ),
                      //width: SizeConfig.proporcionAncho(40),
                      child: Image.network(
                        news != null? news.urlImage : "http://192.168.1.111/RIT/img/noticias/cul.png",
                        height: size,
                        width: size,
                        fit: BoxFit.fill,
                      ),
                    )
                ),
                Container(
                  //color: Colors.black12,
                  width: double.infinity,
                  padding: EdgeInsets.only(left: SizeConfig.conversionAncho(5, false)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        news != null? text() : "Encabezado",
                        textAlign: TextAlign.start,
                        style:conts.Estilo.NEWS_TITLE,
                        softWrap: true,
                        maxLines: 1,
                      ),
                      news != null ?
                      news.subHeadLine != "" ?
                      Text(
                        news != null? news.subHeadLine : "Descripcion",
                        textAlign: TextAlign.start,
                        style:conts.Estilo.NEWS_DESC,
                        softWrap: true,
                        maxLines: 1,
                      ) : Container() : Container()
                    ],
                  ),
                )
              ],
            ),
          ),
        )/*Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.blue,
                    //width: SizeConfig.proporcionAncho(40),
                    child: Image.network(
                      news != null? news.urlImage : "http://192.168.1.111/RIT/img/noticias/cul.png",
                      height: size,
                      width: size,
                      fit: BoxFit.fill,
                    ),
                  )
              ),
              Expanded(
                flex: 4,
                child: Container(
                  //color: Colors.green,
                  padding: EdgeInsets.only(left: SizeConfig.conversionAncho(5, false)),
                  //width: SizeConfig.proporcionAncho(60),
                  margin: EdgeInsets.only(top: SizeConfig.conversionAlto(7, false)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          news != null? text() : "Encabezado",
                          textAlign: TextAlign.start,
                          style:conts.Estilo.NEWS_TITLE,
                          softWrap: true,
                        ),
                      ),
                      SizedBox(height: SizeConfig.conversionAlto(15, false),),
                      /*Container(
                        child: Text(
                            news != null ? news.subHeadLine : "Descripcion breve",
                            textAlign: TextAlign.start,
                            style:conts.Estilo.NEWS_DESC ),
                      ),*/
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: SizeConfig.conversionAncho(5, false)),
                        child: RaisedButton(
                          color: conts.Colores.NEWS_BTN_BCK,
                          shape: RoundedRectangleBorder(
                            borderRadius:BorderRadius.circular(SizeConfig.conversionAncho(7, false)),
                            //side: BorderSide(color: Colors.blue)
                          ),
                          child: Text("ver más",style: conts.Estilo.NEWS_BTN,),
                          onPressed: (){

                            function(news != null? news.urlArticle : "http://192.168.1.111/index.html");

                            scaffold.showSnackBar(
                                SnackBar(
                                  content: const Text("Se abrió el navegador"),
                                  action: SnackBarAction(
                                      label: "cerrar", onPressed: scaffold.hideCurrentSnackBar),
                                )
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )*/,
      ),
    );
  }

  String text(){
    String msg = "";
    int lim = 50;
    if( news.headLine.length > lim){
      msg = "${news.headLine.substring(0,lim-1)}...";
    }else
      msg = news.headLine;

    return msg;
  }
}

class _VistaDefault extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: SizeConfig.conversionAlto(30, false),),
        Align(
          alignment: Alignment.center,
          child: Icon(Icons.home,size: SizeConfig.conversionAlto(250, false),),
        ),
        Container(
          margin: EdgeInsets.only(top: SizeConfig.conversionAlto(50, false)),
          child: Text(
            "Bienvenido de nuevo",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: SizeConfig.conversionAlto(28, false)),
          ),
        )
      ],
    );
  }
}

class CarouselPage extends StatelessWidget {

  final Function functionA;
  final List<News> newsList;

  CarouselPage({this.functionA,this.newsList});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: SizeConfig.conversionAlto(150, false),
              width: SizeConfig.ancho(),
              child: newsList != null ? Carousel(
                boxFit: BoxFit.cover,
                autoplay: true,
                //animationCurve: Curves.fastOutSlowIn,
                animationDuration: Duration(milliseconds: 1200),
                dotSize: SizeConfig.conversionAlto(4, false),
                dotIncreasedColor: conts.Colores.INDICATOR_ON,//Color(0xFFFF335C),
                dotColor: conts.Colores.INDICATOR_OFF,
                dotBgColor: Colors.transparent,
                dotPosition: DotPosition.bottomCenter,
                //dotVerticalPadding: 10.0,
                showIndicator: true,
                indicatorBgPadding: SizeConfig.conversionAlto(4, false),
                images: newsList.map((e) => _ModeloCarrusel(news: e,function: functionA,)).toList()
                //util.DataGenerator.samplesnews.map((e) => Image.network(e.url)).toList()
                /*[
              NetworkImage('https://cdn-images-1.medium.com/max/2000/1*GqdzzfB_BHorv7V2NV7Jgg.jpeg'),
              NetworkImage('https://cdn-images-1.medium.com/max/2000/1*wnIEgP1gNMrK5gZU7QS0-A.jpeg'),
              Center(child:Text("hola"))
              //ExactAssetImage("assets/images/LaunchImage.jpg"),
            ]*/,
              ):
              Container(
                alignment: Alignment.center,
                child: Text("NO hay noticias destacadas"),
              ),
            ),
            SizedBox(height: SizeConfig.conversionAlto(20, false),)

          ],
        ),
      );
  }
}