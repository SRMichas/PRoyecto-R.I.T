import 'package:flutter/material.dart';
import 'package:tapitas/Entidades/item.dart';
import 'size_config.dart';

class Constantes{
  //Local
  /*static const String HOST = "http://192.168.1.111";
  static const String RT_SLT = "/RIT/Select/";
  static const String RT_ISR = "/RIT/Insert/";
  static const String RT_UDT = "/RIT/Update/";*/
  static const PruebaCons = "http://e77bf9f9.ngrok.io/send";

  //Remoto
  static const String HOST = "https://burronator.000webhostapp.com";
  static const String RT_SLT = "/RIT/scripts/Select/";
  static const String RT_ISR = "/RIT/scripts/Insert/";
  static const String RT_UDT = "/RIT/scripts/Update/";

  //Menu Inicio
  static const String cerrarSesion = "Cerrar Sesion";
  static const String perfil = "Perfil";

  static const List<Item> menuInicio = <Item>[
    Item(titulo: perfil,codigo: 1),
    Item(titulo: cerrarSesion,codigo: 0)
  ];

  //Seccion QR
  static const int C_EXITOSA = 1;
  static const int C_ADVERTENCIA = 2;
  static const int C_ERROR = 3;

  static const String T_EXITOSA = "Felicidades!!";
  static const String T_ADVERTENCIA = "Parece que hay un incoveniente";
  static const String T_ERROR = "Uppps!!!!";

  static const String MENSAJE_QR = "Posicione el lector sobre el codigo QR de la maquina, "+
                                   "si no hay, puede agregar manualmente tocando el menu de arriba";

  //Seccion Estadisticas
  static const List<String> MESES = [
    "Enero","Febrero","Marzo","Abril","Mayo","Junio",
    "Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"];

  static const String SIN_TAPAS = "Intenta depositar algunas tapas para ver tus estadisticas";

  //Seccion Premios
  static const int C_EXITOSA_PREMIOS = 5;

  //Seccion Registro
  static const int C_EXITOSA_REGISTRO = 6;

  //Seccion Login
  static const int C_EXITOSA_LOGIN = 7;

}

class Colores{

  // App Bar
  static const Color APP_BAR_BACKGROUND_COLOR = Colors.blue;
  static const Color APP_BAR_WIDGET_COLOR = Colors.white;
  static const Color INPUT_DIALOG_TITLE = Color.fromRGBO(24,136,209,1);
  static const TextStyle ESTILO_TITULO = TextStyle(
    color: APP_BAR_WIDGET_COLOR,
  );
  static TextStyle ESTILO_ERROR = TextStyle(
    fontSize: SizeConfig.conversionAlto(24, false)
  );

  //titulo dialog
  static const Color COL_EXITOSA = Color.fromRGBO(25, 191, 48, 1);
  static const Color COL_ADVERTENCIA = Color.fromRGBO(243, 172, 30, 1);
  static const Color COL_ERROR = Color.fromRGBO(236, 8, 8, 1);
}