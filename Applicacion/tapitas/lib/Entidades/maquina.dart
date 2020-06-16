import 'package:tapitas/Entidades/direccion.dart';

class Maquina{

  final id;
  final Direccion direccion;

  Maquina({this.id,this.direccion});

  factory Maquina.fromJson(Map<String, dynamic> parsedJson){
    //List lista = parsedJson["ciudades"];
    return Maquina(
        id: int.parse(parsedJson["id"].toString()),
        direccion: Direccion.fromJson(parsedJson),
    );
  }
}