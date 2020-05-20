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