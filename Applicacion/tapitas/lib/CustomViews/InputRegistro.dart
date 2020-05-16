import 'package:flutter/material.dart';
import 'package:tapitas/Extras/size_config.dart';

class InputRegistro extends StatefulWidget {

  final int inputId;
  final String hint;
  final TextInputType tipoEntrada;
  final IconData icono;
  final bool ocultarTexto;
  final double alto,ancho,margenIzquierdo,margenDerecho;
  final Color color;
  Function function,funcion2;

  InputRegistro({this.inputId,this.hint,this.tipoEntrada,this.ocultarTexto,
    this.icono,this.alto,this.ancho,this.color,this.margenIzquierdo,
   this.margenDerecho,this.function,this.funcion2});


  @override
  _InputRegistroState createState() => _InputRegistroState();
}

class _InputRegistroState extends State<InputRegistro> {

  TextEditingController controlador;
  String mensaje;
  String prueba;

  TextStyle estilillo({double letra,bool negrita,bool cursiva,Color color}){
    return TextStyle(
      color: color ?? Colors.black,
      fontSize: SizeConfig.conversionAlto(letra ?? 12, false),
      fontStyle: cursiva != null?  (cursiva? FontStyle.italic : FontStyle.normal) : FontStyle.normal,
      fontWeight: negrita != null? (negrita? FontWeight.bold : FontWeight.normal) : FontWeight.normal,
    );
  }

  String validacion(String valor){
    switch(widget.inputId){
      case 4: //correo
        final exp = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
        if( !exp.hasMatch(valor))
            return "No es un correo valido";
        break;
      case 5: //contra 1
        /*if( valor.length < 6)
          return "Contraseña minimo de 6 caracteres";*/
        widget.funcion2(valor);
        break;
      case 6: //contra 2
        prueba = widget.funcion2.call();
        if( valor != prueba)
          return "Las contraseñas no coinciden";
        break;
      case 7: //edad
        if( valor.contains(".") || valor.contains("-"))
          return "Numero NO Soportado";

        int edad = int.parse(valor);
        if( edad < 4 && edad > 110)
          return "Edad invalida";
        break;
      case 8: //codPostal
        if( valor.length != 5 && ( valor.contains(".") || valor.contains("-")))
          return "Cod Postal invalido";
        break;
    }

    return null;
  }

  Widget contenido(){
    TextFormField texto = TextFormField(
      controller: controlador,
      keyboardType: widget.tipoEntrada ?? TextInputType.text,
      obscureText: widget.ocultarTexto ?? false,
      decoration: InputDecoration(
          labelText: widget.hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(SizeConfig.conversionAlto(16, false)))
          ),
          hintText: widget.hint,
          contentPadding: EdgeInsets.only(top: SizeConfig.conversionAlto(30, false)),
          prefixIcon: Icon(widget.icono ?? Icons.clear,color: Colors.blueAccent,),
          errorStyle: estilillo(letra: 16,color: Colors.red),
          labelStyle: estilillo(letra: 16)
      ),
      onSaved: (newValue) => widget.function(widget.inputId-1,newValue.toString()),
      validator: (valor){
        if( widget.inputId != 3) {
          if( valor.isEmpty )
            return "No puede ser vacio";
          else
            return validacion(valor);
        }
        return null;
      },
    );

    return texto;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color ?? Colors.transparent,
      margin: EdgeInsets.only(
        bottom: SizeConfig.conversionAlto(6, false),
        left: SizeConfig.conversionAncho(widget.margenIzquierdo ?? 0, false),
        right: SizeConfig.conversionAncho(widget.margenDerecho ?? 0, false),
      ),
      alignment: Alignment.centerLeft,
      height: SizeConfig.conversionAlto(60, false),
      child: contenido(),
    );
  }
}