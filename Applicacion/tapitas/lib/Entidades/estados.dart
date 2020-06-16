import 'package:tapitas/Entidades/ciudad.dart';

class Estado{

  final int id;
  final String nombre;
  final List<Ciudad> ciudades;

  Estado({this.id,this.nombre,this.ciudades});

  factory Estado.fromJson(Map<String, dynamic> parsedJson){
    List lista = parsedJson["ciudades"];
    return Estado(
        id: int.parse(parsedJson["id"].toString()),
        nombre: parsedJson["nombre"].toString(),
        ciudades: lista.map((valor) => Ciudad.fromJson(valor)).toList()
    );
  }

  String objString(){
    return "$id | $nombre";
  }

  @override
  String toString() {
    //return super.toString();
    return "$nombre";
  }
}

class EstadoMin{
  final int id;
  final String nombre;

  EstadoMin({this.id,this.nombre});

  factory EstadoMin.fromJson(Map<String, dynamic> parsedJson){
    return EstadoMin(
        id: int.parse(parsedJson["id"].toString()),
        nombre: parsedJson["nombre"].toString(),
    );
  }

  @override
  String toString() {
    //return super.toString();
    return "$nombre";
  }
}