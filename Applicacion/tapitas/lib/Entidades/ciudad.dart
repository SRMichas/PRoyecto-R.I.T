import 'package:tapitas/Entidades/maquina.dart';

class Ciudad{

  final int id,id_edo;
  final String nombre;

  Ciudad({this.id,this.id_edo,this.nombre});

  factory Ciudad.fromJson(Map<String, dynamic> parsedJson){
    return Ciudad(
      id: int.parse(parsedJson["id_ciudad"].toString()),
      id_edo: int.parse(parsedJson["id_estado"].toString()),
      nombre: parsedJson["nombre"].toString(),
    );
  }

  String objString(){
    return "$id | $id_edo | $nombre";
  }

  @override
  String toString() {
    return "$nombre";
  }
}

class CiudadMin{

  final int id;
  final String nombre, nombreEstado;
  final List<Maquina> machines;

  CiudadMin({this.id,this.nombre,this.machines,this.nombreEstado});

  factory CiudadMin.fromJson(Map<String, dynamic> parsedJson){
    List machinesTemp = parsedJson["maquinas"];
    return CiudadMin(
      id: int.parse(parsedJson["id_ciudad"].toString()),
      nombre: parsedJson["nombre"].toString(),
      machines: machinesTemp.map((valor) => Maquina.fromJson(valor)).toList()
    );
  }

  @override
  String toString() {
    return "$nombre, $nombreEstado";
  }
}