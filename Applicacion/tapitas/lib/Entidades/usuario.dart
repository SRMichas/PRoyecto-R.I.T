class Usuario{
  
  final int id,edad,puntos;
  final String nombre,correo,ciudad,estado;
  
  Usuario({this.id,this.edad,this.puntos,this.nombre,this.correo,this.ciudad,this.estado});

  factory Usuario.transforma(String conver){
    List<String> lista = conver.split("|");
    return Usuario(
      nombre: lista[0],
      correo: lista[1],
      ciudad: lista[2],
      estado: lista[3],
      edad: int.parse(lista[4]),
      puntos: int.parse(lista[5])
    );
  }

  @override
  String toString() {
    return "$nombre|$correo|$ciudad|$estado|$edad|$puntos";
  }
}