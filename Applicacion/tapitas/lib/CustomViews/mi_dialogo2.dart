import 'package:flutter/material.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;
import 'dart:collection';
import 'dart:async';

class MiDialogo2 extends StatefulWidget {
  final String titulo, descripcion;
  final int tipoTitulo;

  final Function onRun;
  final Map<String,dynamic> datos;
  final bool soloCarga;
  final Color colorTitulo;

  MiDialogo2({  this.titulo, this.descripcion, this.tipoTitulo,
                this.datos,this.onRun,@required this.soloCarga,
                this.colorTitulo
  });

  @override
  _MiDialogo2State createState() => _MiDialogo2State();
}

class _MiDialogo2State extends State<MiDialogo2> {
  Color fondoTitulo, colorLetra;
  BuildContext context;
  Timer _timer;
  final controller = TextEditingController();

  final _formu = GlobalKey<FormState>();

  String _textoDialog;
  int estado = 1;
  Widget _vista;

  double espaciadoVertical = (10 * SizeConfig.heightMultiplier) /
      SizeConfig.heightMultiplier,
      redondeado = SizeConfig.conversionAlto(15, false),
      redondeadoSup = SizeConfig.conversionAlto(15, false);

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: contenido(),
    );
  }

  Widget contenido() {
    ruta();
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(redondeado),
              bottomLeft: Radius.circular(redondeado),
              topRight: Radius.circular(redondeadoSup),
              topLeft: Radius.circular(redondeadoSup)
          )
      ),
      child: _vista,
    );
  }

  void ruta() {
    switch (estado) {
      case 1:
        _vista = mensajes();
        break;
      case 2:
        _vista = widget.onRun(
          _textoDialog,
          respuestas
        );
        break;
    }
  }

  Future tareaAsync() async {
    _timer = new Timer(const Duration(seconds: 1), () {
      HashMap<String, Object> data = new HashMap<String, Object>();
      data.putIfAbsent("bandera", () => false);
      data.putIfAbsent("llama", () => true);
      Navigator.of(context).pop(data); // To close the dialog
      _timer.cancel();
    });
  }

  Widget cargando() {
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

  Widget mensajes() {
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
                      topLeft: Radius.circular(redondeadoSup),
                      topRight: Radius.circular(redondeadoSup)
                  )
              ),
              color: widget.colorTitulo ?? Colors.black,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: espaciadoVertical),
                child: Text(
                  "Ingrese cadena",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: (20 * SizeConfig.heightMultiplier) /
                          SizeConfig.heightMultiplier
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: (35 * SizeConfig.heightMultiplier) /
              SizeConfig.heightMultiplier,),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(
                  left: SizeConfig.conversionAncho(20, false)),
              child: Text(
                "Cadena:",
                style: TextStyle(
                    fontSize: (20 * SizeConfig.heightMultiplier) /
                        SizeConfig.heightMultiplier
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.conversionAncho(20, false)),
            child: Form(
              key: _formu,
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(

                ),
                validator: (value) => validaTexto(value),
                onSaved: (newValue) => _textoDialog = newValue,
              ),
            ),
          ),
          SizedBox(height: SizeConfig.conversionAlto(20, false),),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                child: FlatButton(
                    textColor: Color.fromRGBO(61, 82, 211, 1),
                    onPressed: () => cierraDialog(),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                          fontSize: SizeConfig.conversionAlto(18, false)
                      ),
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    right: SizeConfig.conversionAncho(0, false)),
                child: FlatButton(
                    textColor: Color.fromRGBO(61, 82, 211, 1),
                    onPressed: () {
                      if (_formu.currentState.validate()) {
                        _formu.currentState.save();
                        print(_textoDialog);
                        setState(() {
                          estado = 2;
                        });
                      }
                    },
                    child: Text(
                      "Ingresar",
                      style: TextStyle(
                          fontSize: SizeConfig.conversionAlto(18, false)
                      ),
                    )
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  String validaTexto(String value) {
    if (value.isEmpty)
      return "No puede ser vacio";

    return null;
  }

  void cierraDialog(){
    HashMap<String,Object> data = new HashMap<String,Object>();
    data.putIfAbsent("bandera",()=> false);
    Navigator.of(context).pop(data);
  }

  void defineCabezera2(int tipotitulo) {
    switch (tipotitulo) {
      case conts.Constantes.C_EXITOSA:
      case 0:
      case conts.Constantes.C_EXITOSA_REGISTRO:
        fondoTitulo = conts.Colores.COL_EXITOSA;
        colorLetra = Colors.white;
        break;
      case conts.Constantes.C_ADVERTENCIA:
        fondoTitulo = conts.Colores.COL_ADVERTENCIA;
        colorLetra = Colors.black;
        break;
      case conts.Constantes.C_ERROR:
        fondoTitulo = conts.Colores.COL_ERROR;
        colorLetra = Colors.white;
        break;
    }
  }

  Widget respuestas(String titulo, String descripcion, int tipoTitulo) {
    defineCabezera2(tipoTitulo);
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
                      topRight: Radius.circular(redondeado)
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
                      fontSize: (25 * SizeConfig.heightMultiplier) /
                          SizeConfig.heightMultiplier
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: (35 * SizeConfig.heightMultiplier) /
              SizeConfig.heightMultiplier,),
          Container(
            child: Text(
              descripcion,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: (20 * SizeConfig.heightMultiplier) /
                      SizeConfig.heightMultiplier
              ),
            ),
          ),
          SizedBox(height: (30 * SizeConfig.heightMultiplier) /
              SizeConfig.heightMultiplier,),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(right: (10 * SizeConfig.widthMultiplier) /
                  SizeConfig.widthMultiplier),
              child: FlatButton(
                  textColor: Color.fromRGBO(61, 82, 211, 1),
                  onPressed: () {
                    HashMap<String, Object> data = new HashMap<String,Object>();
                    var res;

                    switch (tipoTitulo) {
                      case conts.Constantes.C_EXITOSA:
                        res = true;
                        data.putIfAbsent("correcto", () => true);
                        break;
                      case 0: //premios
                        res = false;
                        //data.putIfAbsent("nuevosPuntos", ()=> int.parse(datos["puntos"].toString()));
                        break;
                      case conts.Constantes.C_EXITOSA_REGISTRO:
                        res = false;
                        data.putIfAbsent("correcto", () => true);
                        break;
                      case conts.Constantes.C_EXITOSA_LOGIN:
                        res = false;
                        data.putIfAbsent("llama", () => false);
                        break;
                      case conts.Constantes.C_EXITOSA_LOGIN:
                        break;
                      case conts.Constantes.C_ERROR:
                        res = false;
                        data.putIfAbsent("correcto", () => false);
                        break;
                      case conts.Constantes.C_ADVERTENCIA:
                        res = false;
                        data.putIfAbsent("correcto", () => false);
                        break;
                      default:
                        res = false;
                        break;
                    }

                    data.putIfAbsent("bandera", () => res);
                    Navigator.of(context).pop(data); // To close the dialog
                  },
                  child: Text(
                    "Cerrar",
                    style: TextStyle(
                        fontSize: (18 * SizeConfig.heightMultiplier) /
                            SizeConfig.heightMultiplier
                    ),
                  )
              ),
            ),
          )
        ],
      ),
    );
  }

}