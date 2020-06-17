class Impresiones{
  static String puntosBonitos(double puntos,double dpi) {
    String resp = "";
    String aux;
    String aux2 = "";
    int contador = 0;
    double reducido = 0;
    bool excedente = false;


    if( dpi >= 320){
      if( puntos < 1000000){
        aux = "${puntos.toInt()}";
        excedente = false;
      }else{
          reducido = puntos / 1000000;
          aux = "${reducido.round()}";
          excedente = true;
      }
    }else if( dpi >= 240){
      aux = puntos.round().toString();
      if( aux.length > 9){
        reducido = puntos / 1000000;
        reducido = double.parse(reducido.toStringAsPrecision(5)).truncate().toDouble();
        /*print("division = $reducido");
        print("Preciso = ${double.parse(reducido.toStringAsPrecision(6))}");
        print("Redondeado = ${double.parse(reducido.toStringAsPrecision(5)).truncate()}");*/
        aux = "${reducido.round()}";
        excedente = true;
      }
    }else if( dpi >= 160){

    }else{

    }
    for (int i = aux.length - 1; i > -1; i--) {
      if (contador == 3) {
        contador = 1;
        aux2 += "," + aux[i];
      } else {
        aux2 += aux[i];
        contador++;
      }
    }
    int i = puntos < 1000 ? aux2.length - 1 : aux2.length-1;
    for (;i > -1; i--) resp += aux2[i];
//    display = resp;
    if( dpi >= 320){
      if( excedente ) resp += "M";
    }else if( dpi >= 240){ if( excedente ) resp += "M";
    }else if( dpi >= 160){
    }else{
    }
    return resp;
  }

  static String reacomodaFecha(String fechaPre){
    List<String> dividida = fechaPre.split("-");
    return "${dividida[2]}/${dividida[1]}/${dividida[0]}";
  }
}

class DataGenerator{
  static List<String> stringList =[
    "A","B","C","D","E", "F","G","H","I","J",
    "K","L","M","N","O", "P","Q","R","S","T",
    "U","V","W","X","Y", "Z",
  ];

  static List sample = [1,1,1,1];
}

