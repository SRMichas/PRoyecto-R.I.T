class Constantes{

  static const String HOST = "192.168.1.111";
  static const String RT_SLT = "/RIT/Select/";
  static const String RT_ISR = "/RIT/Insert/";
  static const String RT_UDT = "/RIT/Update/";

  static const String cerrarSesion = "Cerrar Sesion";

  static const List<String> menuInicio = <String>[
    cerrarSesion
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

  /*static const Color COL_EXITOSA = Color.fromRGBO(25, 191, 48, 1);
  static const Color COL_ADVERTENCIA = 2;
  static const Color COL_ERROR = 3;*/
  

}