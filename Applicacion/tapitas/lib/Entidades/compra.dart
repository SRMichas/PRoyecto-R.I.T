import 'package:tapitas/Extras/utilidades.dart';

class Activos{
  final String urlFoto,descripcion,fecha;
  final int id;

  Activos({this.urlFoto,this.descripcion,this.fecha,this.id});

  factory Activos.fromJson(Map<String, dynamic> parsedJson){
    String nuevaFecha = Impresiones.reacomodaFecha(parsedJson["fecha"].toString());
    int idS = int.parse(parsedJson["id"].toString());
    print("\t\tEste es el ID ====> $idS");
    return Activos(
        urlFoto: parsedJson["url"].toString(),
        descripcion: parsedJson["descripcion"].toString(),
        fecha: nuevaFecha,
        id: idS
    );
  }
}

class Gastado{
  final String urlFoto,descripcion,fecha,nombre;
  final int conteo;

  Gastado({this.urlFoto,this.descripcion,this.fecha,this.nombre,this.conteo});

  factory Gastado.fromJson(Map<String, dynamic> parsedJson){
    String nuevaFecha = Impresiones.reacomodaFecha(parsedJson["fecha"].toString());
    return Gastado(
        urlFoto: parsedJson["url"].toString(),
        descripcion: parsedJson["descripcion"].toString(),
        fecha: nuevaFecha,
        nombre: parsedJson["nombre"].toString(),
        conteo: int.parse(parsedJson["conteo"].toString())
    );
  }
}