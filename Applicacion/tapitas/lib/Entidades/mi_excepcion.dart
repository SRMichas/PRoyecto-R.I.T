import 'package:flutter/material.dart';

class MiExcepcion implements Exception{

  final String mensaje;
  final int codigo;
  final IconData icono;
  final Object stackTrace;

  const MiExcepcion([this.mensaje="",this.codigo=0,this.icono,this.stackTrace]);

  String toString() => 'Mensaje: $mensaje, codigo: $codigo';

}