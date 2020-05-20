import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/vistas_estadisticas/vista_semanal.dart';
import 'package:tapitas/vistas_estadisticas/vista_mensual.dart';
import 'package:tapitas/vistas_estadisticas/vista_anual.dart';

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

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraint.maxHeight),
                    child: VistaSemanal(),
              )
            );
          },
        ),
        LayoutBuilder(
          builder: (context, constraint) {
            return LayoutBuilder(
              builder: (context, constraint) {
                return SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: (5 * SizeConfig.heightMultiplier) /
                          SizeConfig.heightMultiplier,
                    ),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: VistaMensual(),
                    )
                  ],
                ));
              },
            );
          },
        ),
        LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
                child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: VistaAnual(),
            ));
          },
        )
      ],
    );
  }
}