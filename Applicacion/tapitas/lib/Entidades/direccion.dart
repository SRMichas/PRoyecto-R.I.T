class Direccion{

  final id;
  final String calle,colonia, localizacion;

  Direccion({this.id,this.calle,this.colonia,this.localizacion});

  factory Direccion.fromJson(Map<String, dynamic> parsedJson){

    return Direccion(
        id: int.parse(parsedJson["id"].toString()),
        calle: parsedJson["calle"].toString(),
        colonia: parsedJson["colonia"].toString(),
        localizacion: parsedJson["loca"].toString()
    );
  }

  String direccionBonita(){
    String mensaje = "$calle, $colonia, ,";
    return mensaje;
  }
}