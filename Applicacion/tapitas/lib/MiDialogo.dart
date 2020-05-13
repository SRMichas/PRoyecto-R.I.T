import 'package:flutter/material.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/Constantes.dart';
import 'dart:collection';

class MiDialogo extends StatelessWidget {
  final String titulo, descripcion;
  final int tipoTitulo;
  Color fondoTitulo,colorLetra;
  final Function onRun;
  final Map<String,dynamic> datos;

  MiDialogo({this.titulo, this.descripcion, this.tipoTitulo,this.datos,this.onRun});

  double espaciadoVertical = ( 10 * SizeConfig.heightMultiplier ) / SizeConfig.heightMultiplier,
          redondeado = (20 * SizeConfig.widthMultiplier) / SizeConfig.widthMultiplier;

  Color COL_EXITOSA = Color.fromRGBO(25, 191, 48, 1);
  Color COL_ADVERTENCIA = Color.fromRGBO(243, 172, 30, 1);//Color.fromRGBO(246, 249, 81, 1);
  Color COL_ERROR = Color.fromRGBO(236, 8, 8, 1);

  @override
  Widget build(BuildContext context) {
    defineCabezera();
    return Dialog(
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
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
      child: Container(
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
                      if( tipoTitulo == Constantes.C_EXITOSA)
                        res = true;
                      else if( tipoTitulo == 0 ) {
                        res = false;
                        data.putIfAbsent("nuevosPuntos", ()=> int.parse(datos["puntos"].toString()));
                        //data.putIfAbsent("nuevo", 0);
                      }else
                        res = false;

                      /*if( onRun != null){
                        onRun;
                      }*/
                      //data.putIfAbsent("bandera", res);
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
      ),
    );
  }

  void defineCabezera(){
    switch(tipoTitulo){
      case Constantes.C_EXITOSA: case 0:
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
