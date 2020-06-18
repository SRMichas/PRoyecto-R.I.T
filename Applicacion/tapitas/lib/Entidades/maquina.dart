import 'package:tapitas/Entidades/direccion.dart';

class Maquina{

  final int id, status;
  final String cityName,stateName;
  final Direccion direccion;

  Maquina({this.id,this.direccion,this.status,this.cityName,this.stateName});

  factory Maquina.fromJson(Map<String, dynamic> parsedJson,[String cn,String sn]){
    //List lista = parsedJson["ciudades"];
    Direccion dir = Direccion(
      id: int.parse(parsedJson["id_direccion"].toString()),
      calle: parsedJson["calle"].toString(),
      colonia: parsedJson["colonia"].toString(),
      localizacion: parsedJson["localizacion"].toString()
    );
    return Maquina(
        id: int.parse(parsedJson["id_maquina"].toString()),
        status: int.parse(parsedJson["estatus"].toString()),
        direccion: dir,
        cityName: parsedJson["ciudad"].toString() ?? "N/A",
        stateName: parsedJson["estado"].toString() ?? "N/A"
    );
  }

  String getDireccion(){
    return "${direccion.direccionBonita()}, $cityName, $stateName";
  }
}