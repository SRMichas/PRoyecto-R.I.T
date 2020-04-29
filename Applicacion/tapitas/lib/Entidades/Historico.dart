class Historico{
  final String dia;
  final int tapas;

  Historico({this.dia,this.tapas});

  factory Historico.fromJson(Map<String, dynamic> parsedJson){
    return Historico(
        dia: parsedJson['dia'].toString(),
        tapas : int.parse(parsedJson['puntos'].toString())
    );
  }

  /*factory Student.fromJson(Map<String, dynamic> parsedJson){
    return Student(
        studentId: parsedJson['id'],
        studentName : parsedJson['name'],
        studentScores : parsedJson ['score']
    );
  }*/
}

class HistoricoMensual{
  final DateTime fecha;
  final int tapas;

  HistoricoMensual({this.fecha,this.tapas});


  factory HistoricoMensual.fromJson(Map<String,dynamic> parsedJson){
    //print("Esta es la fecha ==>${parsedJson["fecha"].toString()}");
    return HistoricoMensual(
      fecha: DateTime.parse(parsedJson["fecha"].toString()),
      tapas: int.parse(parsedJson["puntos"].toString())
    );
  }
}

class HistoricoAnual{
  final String mes;
  final int tapas;

  HistoricoAnual({this.mes,this.tapas});

  factory HistoricoAnual.fromJson(Map<String, dynamic> parsedJson){
    return HistoricoAnual(
        mes: parsedJson['mes'].toString(),
        tapas : int.parse(parsedJson['puntos'].toString())
    );
  }
}