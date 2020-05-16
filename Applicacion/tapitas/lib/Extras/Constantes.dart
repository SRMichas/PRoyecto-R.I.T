import 'package:tapitas/Entidades/item.dart';

class Constantes{

  static const String HOST = "192.168.1.111";
  static const String RT_SLT = "/RIT/Select/";
  static const String RT_ISR = "/RIT/Insert/";
  static const String RT_UDT = "/RIT/Update/";

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

  /*static const Color COL_EXITOSA = Color.fromRGBO(25, 191, 48, 1);
  static const Color COL_ADVERTENCIA = 2;
  static const Color COL_ERROR = 3;*/
  

}