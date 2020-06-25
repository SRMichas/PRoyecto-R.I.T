import 'package:flutter/material.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;

class Noticias extends StatefulWidget {
  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {

  Future<Map<String,dynamic>> _futuro;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: eligeContenedor(2),
    );
  }

  Widget eligeContenedor(int ruta){
    Widget vista;
    switch(ruta){
      case 1:
        vista = _ModeloCarrusel();
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
}

class _ModeloCarrusel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            //height: MediaQuery.of(context).size.height * 0.22,
            child: Image.network(
                "http://192.168.1.111/RIT/img/noticias/localidad_tecmaland.png  ",
                /*width: double.infinity,
                cacheWidth: MediaQuery.of(context).size.width.toInt(),*/
            ),
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: SizeConfig.conversionAlto(10, false)),
            child: Text(
              "Encabezado de noticia",
              style: conts.Estilo.NEWS_TITLE,
            ),
          )
        ],
      ),
    );
  }
}

class _ModeloNoticia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double size = SizeConfig.conversionAlto(100, false);
    return Container(
      color: Colors.red,
      child: Card(
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.blue,
                    //width: SizeConfig.proporcionAncho(40),
                    child: Image.network(
                      "http://192.168.1.111/RIT/img/noticias/cul.png",
                      height: size,
                      width: size,
                    ),
                  )
              ),
              Expanded(
                flex: 4,
                child: Container(
                  color: Colors.green,
                  //width: SizeConfig.proporcionAncho(60),
                  margin: EdgeInsets.only(top: SizeConfig.conversionAlto(7, false)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                            "Encabezado000 0000 00000000 000000000000 00000000",
                            textAlign: TextAlign.start,
                            style:conts.Estilo.NEWS_TITLE,
                            softWrap: true,
                        ),
                      ),
                      SizedBox(height: SizeConfig.conversionAlto(15, false),),
                      Container(
                        child: Text("Descripcion breve",textAlign: TextAlign.start,style:conts.Estilo.NEWS_DESC ),
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

