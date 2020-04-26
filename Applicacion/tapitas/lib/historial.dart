import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Entidades/Historico.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Extras/Constantes.dart';

class Historial extends StatelessWidget {
  TextStyle estilo = TextStyle(
      fontSize: (22 * SizeConfig.textMultiplier) / SizeConfig.textMultiplier);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              bottom: TabBar(
                labelStyle: estilo,
                tabs: <Widget>[
                  Tab(
                    text: "Semanal",
                  ),
                  Tab(
                    text: "Mensual",
                  ),
                  Tab(
                    text: "Anual",
                  ),
                ],
              ),
              title: Text("Historial"),
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                },
              )),
          body: new Cuerpo(),
        ));
  }
}

class Cuerpo extends StatefulWidget {
  @override
  _CuerpoState createState() => _CuerpoState();
}

class _CuerpoState extends State<Cuerpo> {

  Future <Map<String, dynamic>> getInfo(int ruta) async {
    var id = 1;
    var url = 'http://${Constantes.HOST}';
    switch(ruta){
      case 1: url += '/RIT/Select/C-Estadisticas.php?usId=$id';
        break;
      case 2: url += '/RIT/Select/C-EstadisticasMes.php?usId=$id&mes=4';
        break;
      case 3: url += '/RIT/Select/C-Estadisticas.php?usId=$id';
        break;
    }

    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    //print(data);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
                child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: vistaSemanal(),
            ));
          },
        ),
        //contenedorMaestro(),
        LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
                child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: contenedorMaestro2(),
            ));
          },
        ),
        Center(
          child: Text("Pestana 3"),
        )
      ],
    );
  }

  Widget contenedorMaestro() {
    return Container(
      child: FutureBuilder(
          future: getInfo(0),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return LayoutBuilder(
                builder: (context, constraint) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Column(

                          children: <Widget>[
                            Expanded(child: TimeSeriesBar.withSampleData()),
                            SizedBox(
                              height: 150,
                            ),
                            Text("HOLAAAAAAAAAA")
                          ],
                        ),
                      ), //Text("hola"),
                    ),
                  );
                },
              );
            } else {
              return Container(
                /*width: double.infinity,
                    height: double.infinity,*/
                child: Center(
                  child: SizedBox(
                    width: 42 * SizeConfig.widthMultiplier,
                    height: 42 * SizeConfig.widthMultiplier,
                    child: CircularProgressIndicator(
                      strokeWidth: 4 * SizeConfig.widthMultiplier /*18*/,
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget contenedorMaestro2() {
    return Container(
      child: FutureBuilder(
          future: getInfo(2),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: charts.TimeSeriesChart( //TimeSeriesBar.withSampleData(),
                      _infoMensual(snapshot.data["puntos"]),
                      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
                      animate:false,
                    ),
                  ),
                  SizedBox(
                    height: 500,
                  ),
                  Text("HOLAAAAAAAAAA")
                ],
              );
            } else {
              return Container(
                /*width: double.infinity,
                    height: double.infinity,*/
                child: Center(
                  child: SizedBox(
                    width: 42 * SizeConfig.widthMultiplier,
                    height: 42 * SizeConfig.widthMultiplier,
                    child: CircularProgressIndicator(
                      strokeWidth: 4 * SizeConfig.widthMultiplier /*18*/,
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  //realmente es la semanal
  Widget vistaSemanal() {
    return Container(
      child: FutureBuilder(
          future: getInfo(1),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: charts.BarChart(
                      _infoSemanal(snapshot.data["puntos"]),
                      animate: false,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text("Tapas Acumuladas: ${snapshot.data["total"]}")
                ],
              );
            } else {
              return Container(
                /*width: double.infinity,
                    height: double.infinity,*/
                child: Center(
                  child: SizedBox(
                    width: 42 * SizeConfig.widthMultiplier,
                    height: 42 * SizeConfig.widthMultiplier,
                    child: CircularProgressIndicator(
                      strokeWidth: 4 * SizeConfig.widthMultiplier /*18*/,
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  static List<charts.Series<Historico, String>> _infoSemanal(List info) {

    List<Historico> data = info.map((val) =>  Historico.fromJson(val)).toList();
    /*print(info);
    print("!");
    var data = new List<Historico>.from(info);*/

    return [
      new charts.Series<Historico, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Historico historico, _) => historico.dia,
        measureFn: (Historico historico, _) => historico.tapas,
        data: data,
      )
    ];
  }

  static List<charts.Series<HistoricoMensual, DateTime>> _infoMensual(List info) {
    print("ENTROOOOOO: $info");
    List<HistoricoMensual> data = info.map((val) =>  HistoricoMensual.fromJson(val)).toList();

    return [
      new charts.Series<HistoricoMensual, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (HistoricoMensual mensual, _) => mensual.fecha,
        measureFn: (HistoricoMensual mensual, _) => mensual.tapas,
        data: data,
      )
    ];
  }

}

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with sample data and no transition.
  factory SimpleBarChart.withSampleData() {
    return new SimpleBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
      new OrdinalSales('2018', 125),
      new OrdinalSales('2019', 45)
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

/// Example of a time series chart using a bar renderer.
class TimeSeriesBar extends StatelessWidget {
  final List<charts.Series<TimeSeriesSales, DateTime>> seriesList;
  final bool animate;

  TimeSeriesBar(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory TimeSeriesBar.withSampleData() {
    return new TimeSeriesBar(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Set the default renderer to a bar renderer.
      // This can also be one of the custom renderers of the time series chart.
      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      // It is recommended that default interactions be turned off if using bar
      // renderer, because the line point highlighter is the default for time
      // series chart.
      defaultInteractions: false,
      // If default interactions were removed, optionally add select nearest
      // and the domain highlighter that are typical for bar charts.
      behaviors: [new charts.SelectNearest(), new charts.DomainHighlighter()],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2017, 9, 1), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 2), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 3), 25),
      new TimeSeriesSales(new DateTime(2017, 9, 4), 100),
      new TimeSeriesSales(new DateTime(2017, 9, 5), 75),
      new TimeSeriesSales(new DateTime(2017, 9, 6), 88),
      new TimeSeriesSales(new DateTime(2017, 9, 7), 65),
      new TimeSeriesSales(new DateTime(2017, 9, 8), 91),
      new TimeSeriesSales(new DateTime(2017, 9, 9), 100),
      new TimeSeriesSales(new DateTime(2017, 9, 10), 111),
      new TimeSeriesSales(new DateTime(2017, 9, 11), 90),
      new TimeSeriesSales(new DateTime(2017, 9, 12), 50),
      new TimeSeriesSales(new DateTime(2017, 9, 13), 40),
      new TimeSeriesSales(new DateTime(2017, 9, 14), 30),
      new TimeSeriesSales(new DateTime(2017, 9, 15), 2),
      new TimeSeriesSales(new DateTime(2017, 9, 16), 12),
      new TimeSeriesSales(new DateTime(2017, 9, 17), 30),
      new TimeSeriesSales(new DateTime(2017, 9, 18), 35),
      new TimeSeriesSales(new DateTime(2017, 9, 19), 40),
      new TimeSeriesSales(new DateTime(2017, 9, 20), 32),
      new TimeSeriesSales(new DateTime(2017, 9, 21), 32),
      new TimeSeriesSales(new DateTime(2017, 9, 22), 31),
      new TimeSeriesSales(new DateTime(2017, 9, 23), 24),
      new TimeSeriesSales(new DateTime(2017, 9, 24), 45),
      new TimeSeriesSales(new DateTime(2017, 9, 25), 2),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 17),
      new TimeSeriesSales(new DateTime(2017, 9, 27), 76),
      new TimeSeriesSales(new DateTime(2017, 9, 28), 56),
      new TimeSeriesSales(new DateTime(2017, 9, 29), 29),
      new TimeSeriesSales(new DateTime(2017, 9, 30), 100),
      new TimeSeriesSales(new DateTime(2017, 9, 31), 31),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
