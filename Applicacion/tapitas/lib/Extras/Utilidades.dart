class Impresiones{
  static String puntosBonitos(int puntos) {
    String resp = "";
    String aux = puntos.toString();
    String aux2 = "";
    int contador = 0;

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
    return resp;
  }
}

