import 'package:tapitas/Entidades/Premio.dart';

class Categoria{
  final int id;
  final String nombre,url;
  final List<Premio> premios;

  Categoria({this.id,this.nombre,this.url,this.premios});

  factory Categoria.fromJson(Map<String, dynamic> parsedJson){
    List lista = parsedJson["premios"];
    return Categoria(
      id: int.parse(parsedJson["id"].toString()),
      nombre: parsedJson["nombre"].toString(),
      url: parsedJson["url"].toString(),
      premios: lista.map((valor) => Premio.fromJson(valor)).toList()
    );
  }
  
  /*List convierteLista(List lista){
    return lista.map((valor) => Premio.fromJson(valor)).toList();
  }*/
}