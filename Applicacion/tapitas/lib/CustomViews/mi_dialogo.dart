import 'package:flutter/material.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/constantes.dart';
import 'dart:collection';
import 'dart:async';

class MiDialogo extends StatelessWidget {
  final String titulo, descripcion;
  final int tipoTitulo;
  Color fondoTitulo,colorLetra;
  final Function onRun;
  final Map<String,dynamic> datos;
  final bool soloCarga;
  //Widget _vista;
  BuildContext context;
  Timer _timer;

  MiDialogo({this.titulo, this.descripcion, this.tipoTitulo,this.datos,this.onRun,@required this.soloCarga});

  double espaciadoVertical = ( 10 * SizeConfig.heightMultiplier ) / SizeConfig.heightMultiplier,
          redondeado = (20 * SizeConfig.widthMultiplier) / SizeConfig.widthMultiplier;

  static const Color COL_EXITOSA = Color.fromRGBO(25, 191, 48, 1);
  static const Color COL_ADVERTENCIA = Color.fromRGBO(243, 172, 30, 1);//Color.fromRGBO(246, 249, 81, 1);
  static const Color COL_ERROR = Color.fromRGBO(236, 8, 8, 1);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    defineCabezera();
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contenido(context),
    );
  }

  Widget contenido(BuildContext context) {

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(redondeado)
      ),
      child: soloCarga ? cargando() : mensajes(),
    );
  }

  Future tareaAsync() async{

    _timer = new Timer(const Duration(seconds: 1), () {
      HashMap<String,Object> data = new HashMap<String,Object>();
      data.putIfAbsent("bandera", () => false);
      data.putIfAbsent("llama", () => true);
      Navigator.of(context).pop(data); // To close the dialog
      _timer.cancel();
    });
  }

  Widget cargando(){
    Widget carga = Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: SizeConfig.conversionAlto(16, false),),
          Center(
            child: SizedBox(
              height: SizeConfig.conversionAlto(100, false),
              width: SizeConfig.conversionAncho(100, false),
              child: CircularProgressIndicator(
                strokeWidth: SizeConfig.conversionAncho(10, false),
              ),
            ),
          ),
          SizedBox(height: SizeConfig.conversionAlto(16, false),)
        ],
      ),
    );
    return FutureBuilder(
      future: tareaAsync(),
      builder: (context, snapshot) {
        return carga;
      },
    );
  }

  Widget mensajes(){
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(redondeado),
                      topRight:Radius.circular(redondeado)
                  )
              ),
              color: fondoTitulo,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: espaciadoVertical),
                child: Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorLetra,
                      fontSize: (25 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: (35 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier,),
          Container(
            child: Text(
              descripcion,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: (20 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier
              ),
            ),
          ),
          SizedBox(height: (30 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier,),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(right:(10 * SizeConfig.widthMultiplier) / SizeConfig.widthMultiplier),
              child: FlatButton(
                  textColor: Color.fromRGBO(61,82,211,1),
                  onPressed: () {
                    HashMap<String,Object> data = new HashMap<String,Object>();
                    var res;
                    switch(tipoTitulo){
                      case  Constantes.C_EXITOSA:
                        res = true;
                        break;
                      case 0: //premios
                        res = false;
                        data.putIfAbsent("nuevosPuntos", ()=> int.parse(datos["puntos"].toString()));
                        break;
                      case Constantes.C_EXITOSA_REGISTRO:
                        res = false;
                        data.putIfAbsent("correcto", ()=> true);
                        break;
                      case Constantes.C_EXITOSA_LOGIN:
                        res = false;
                        data.putIfAbsent("llama", () => false);
                        break;
                      case Constantes.C_EXITOSA_LOGIN:
                        break;
                      case Constantes.C_ERROR:
                        res = false;
                        data.putIfAbsent("correcto", ()=> false);
                        break;
                      case Constantes.C_EXITOSA_COMPRA:
                        res = false;
                        break;
                      default:
                        res = false;
                        break;
                    }

                    data.putIfAbsent("bandera",()=> res);
                    Navigator.of(context).pop(data); // To close the dialog
                  },
                  child: Text(
                    "Cerrar",
                    style: TextStyle(
                        fontSize: (18 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier
                    ),
                  )
              ),
            ),
          )
        ],
      ),
    );
  }

  void defineCabezera(){
    switch(tipoTitulo){
      case Constantes.C_EXITOSA: case 0:case Constantes.C_EXITOSA_REGISTRO: case Constantes.C_EXITOSA_COMPRA:
        fondoTitulo = COL_EXITOSA;
        colorLetra = Colors.white;
        break;
      case Constantes.C_ADVERTENCIA:
        fondoTitulo = COL_ADVERTENCIA;
        colorLetra = Colors.black;
        break;
      case Constantes.C_ERROR:
        fondoTitulo = COL_ERROR;
        colorLetra = Colors.white;
        break;
    }
  }
}
