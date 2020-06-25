import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:tapitas/Entidades/item.dart';
import 'size_config.dart';
import 'package:tapitas/Extras/my_flutter_app_icons.dart';

class Constantes{
  //Local
  static const String HOST = "http://192.168.1.111";
  static const String RT_SLT = "/RIT/Local/Select/";
  static const String RT_ISR = "/RIT/Local/Insert/";
  static const String RT_UDT = "/RIT/Local/Update/";
  static const PruebaCons = "http://e77bf9f9.ngrok.io/send";

  //Remoto
 /*static const String HOST = "https://burronator.000webhostapp.com";
  static const String RT_SLT = "/RIT/scripts/Select/";
  static const String RT_ISR = "/RIT/scripts/Insert/";
  static const String RT_UDT = "/RIT/scripts/Update/";*/

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
  static const int REGISTRO_ROUTE = 1;

  //Seccion Login
  static const int C_EXITOSA_LOGIN = 7;

  //Seccion Compras;
  static const int C_EXITOSA_COMPRA = 8;

  //Seccion Maquina
  static const int MAQUINA_ROUTE = 2;
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

  // Drawer
  static const Color DRAWER_ITEM = Colors.blueAccent;
  static const Color DRAWER_HEADER_BACKGROUND = Colors.blueAccent;
  static const Color DRAWER_USER_BACKGROUND = Colors.white;
  static const Color DRAWER_USER_COLOR = Colors.blueAccent;
  static Color DRAWER_SECTION = Colors.grey[600];

  //titulo dialog
  static const Color COL_EXITOSA = Color.fromRGBO(25, 191, 48, 1);
  static const Color COL_ADVERTENCIA = Color.fromRGBO(243, 172, 30, 1);
  static const Color COL_ERROR = Color.fromRGBO(236, 8, 8, 1);

  //Historial de compras
  static const Color BOTON = Colors.blue;
}

class Estilo{
  static TextStyle estiloPre1 = TextStyle(
      fontSize:SizeConfig.conversionAlto(22, false));
  static TextStyle estiloError = TextStyle(
          fontSize: SizeConfig.conversionAlto(24, false));

  //Modelo compras
  static TextStyle estiloFecha = TextStyle(
      fontSize: SizeConfig.conversionAlto(18, false),
      color: Colors.blueAccent,
      letterSpacing: SizeConfig.conversionAncho(1.5, false)
  );
  //Seccion de compras
  static TextStyle estiloDescripcion = TextStyle(
    fontSize: SizeConfig.conversionAlto(20, false)
  );

  static TextStyle estiloTitulo = TextStyle(
      fontSize: SizeConfig.conversionAlto(20, false),
      fontWeight: FontWeight.bold,
      color: Colors.blueAccent
  );

  static TextStyle ESTILO_TEXTO_BOTON= TextStyle(
      fontSize: SizeConfig.conversionAlto(16, false),
      color: Colors.white,
      letterSpacing: SizeConfig.conversionAncho(1.2, false)
  );

  static TextStyle estiloUsado = TextStyle(
      fontSize: SizeConfig.conversionAlto(18, false),
  );

  //Seccion Maquinas
  static TextStyle ESTILO_TITULO_MAQUINA = TextStyle(
    fontSize: SizeConfig.conversionAlto(28, false)
  );
  static TextStyle HOLDER = TextStyle(
    fontSize: SizeConfig.conversionAlto(36, false)
  );

  static TextStyle CITY_CAPITAL_LETTER = TextStyle(
    fontSize: SizeConfig.conversionAlto(40, false),
    fontWeight: FontWeight.bold,
    color: Colors.white
  );

  static TextStyle CITY_NAME = TextStyle(
      fontSize: SizeConfig.conversionAlto(28, false)
  );

  static TextStyle DIRECCION = TextStyle(
      fontSize: SizeConfig.conversionAlto(20, false)
  );

  static TextStyle TEXT_BUTTON = TextStyle(
      fontSize: SizeConfig.conversionAlto(12, false),
      color: Colors.white
  );

  static TextStyle TEXT_BUTTON_BOTTOM = TextStyle(
      fontSize: SizeConfig.conversionAlto(18, false),
      color: Colors.blueAccent
  );

  //Seccion de las noticias
  static TextStyle NEWS_TITLE = TextStyle(
      fontSize: SizeConfig.conversionAlto(22, false),
      //color: Colors.white,
      fontWeight: FontWeight.bold
  );

  static TextStyle NEWS_DESC = TextStyle(
      fontSize: SizeConfig.conversionAlto(18, false),
      //color: Colors.white,
  );
}

class Otro{
  static Map<String,IconData> data(){
    HashMap<String,IconData> ret = new HashMap();

    return ret;
  }

  static Map<String,IconData> dato = {
    "Aguascalientes" : 	EstadosIcon.aguascalientes,
    "Baja California" : 	EstadosIcon.baja_california,
    "Baja California Sur" : 	EstadosIcon.baja_california_sur,
    "Campeche" : 	EstadosIcon.campeche,
    "Chiapas" : 	EstadosIcon.chiapas,
    "Chihuahua" : 	EstadosIcon.chihuahua,
    "Ciudad de Mexico" : 	EstadosIcon.ciudad_de_mexico,
    "Coahuila" : 	EstadosIcon.cuahuila,
    "Colima" : 	EstadosIcon.colima,
    "Durango" : 	EstadosIcon.durango,
    "Guanajuato" : 	EstadosIcon.guanajuato,
    "Guerrero" : 	EstadosIcon.gerrero,
    "Hidalgo" : 	EstadosIcon.hidalgo,
    "Jalisco" : 	EstadosIcon.jalisco,
    "Estado de Mexico" : 	EstadosIcon.estado_de_mexico,
    "Michoacan" : 	EstadosIcon.michoacan,
    "Morelos" : 	EstadosIcon.morelos,
    "Nayarit" : 	EstadosIcon.nayarit,
    "Nuevo Leon" : 	EstadosIcon.nuevo_leon,
    "Oaxaca" : 	EstadosIcon.oaxaca,
    "Puebla" : 	EstadosIcon.puebla,
    "Queretaro" : 	EstadosIcon.queretaro,
    "Quintana Roo" : 	EstadosIcon.quintana_roo,
    "San Luis Potosi" : 	EstadosIcon.san_luis_potosi,
    "Sinaloa" : 	EstadosIcon.sinaloa,
    "Sonora" : 	EstadosIcon.sonora,
    "Tabasco" : 	EstadosIcon.tabasco,
    "Tamaulipas" : 	EstadosIcon.tamaulipas,
    "Tlaxcala" : 	EstadosIcon.tlaxcala,
    "Veracruz" : 	EstadosIcon.veracruz,
    "Yucatan" : 	EstadosIcon.yucatan,
    "Zacatecas" :  EstadosIcon.zacatecas ,
  };
}