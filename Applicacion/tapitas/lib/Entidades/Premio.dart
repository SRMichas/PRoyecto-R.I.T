class Premio{

  final int id_premio,id_categoria,costo;
  final String nombre,descripcion,url;
  
  Premio({this.id_premio,this.id_categoria,this.nombre,this.descripcion,this.url,this.costo});
  
  factory Premio.fromJson(Map<String, dynamic> parsedJson){
    return Premio(
      id_premio: int.parse(parsedJson["id_premio"].toString()),
      id_categoria: int.parse(parsedJson["id_categoria"].toString()),
      nombre: parsedJson["nombre"].toString(),
      descripcion: parsedJson["descripcion"].toString(),
      url: parsedJson["urlLg"].toString(),
      costo: int.parse(parsedJson["costo"].toString())
    );
  }
}