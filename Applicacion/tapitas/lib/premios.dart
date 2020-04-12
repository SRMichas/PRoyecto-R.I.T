import 'package:flutter/material.dart';
import 'ListaPremios.dart';

class Premios extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Premios"),
      ),
      body: new Cuerpo(),
    );
  }

}

class Cuerpo extends StatelessWidget{

  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return cuerpoPrincipal();
  }

  CustomScrollView cuerpoPrincipal(){
    return CustomScrollView(
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              //crossAxisSpacing: 20,
              mainAxisSpacing: 35,
              childAspectRatio: 1.4
          ),
          delegate: SliverChildBuilderDelegate((BuildContext context,int idx){
            /*return Container(
                color: Colors.red,
                alignment: Alignment.center,
                child: Text("Categoria # $idx"),
            );*/
            return ModeloCategoria("Titulo #$idx");
          },childCount: 5),
        )
      ],
    );
  }
}

class ModeloCategoria extends StatelessWidget {

  final String nombre;

  ModeloCategoria(this.nombre);

  TextStyle estilo = TextStyle(
    fontSize: 28
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      margin: EdgeInsets.only(left: 20,right: 20),
      child:GestureDetector(
        onTap: (){
          print(nombre);
          Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => ListaPremios(nombre),
              ));
        },
        child: Card(
            elevation: 2.5,
            child:Column(
              children: <Widget>[
                Icon(
                  Icons.add,
                  size: 100,
                ),
                Text(
                  nombre,
                  style: estilo,

                )
              ],
            )
        ),
      )
    );
  }
}


class HeaderWidget extends StatelessWidget {
  final String text;

  HeaderWidget(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Text(text),
      color: Colors.grey[200],
    );
  }
}

class BodyWidget extends StatelessWidget {
  final Color color;

  BodyWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      color: color,
      alignment: Alignment.center,

    );
  }
}

class Cuerpo2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                HeaderWidget("Header 1"),
                HeaderWidget("Header 2"),
                HeaderWidget("Header 3"),
                HeaderWidget("Header 4"),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                BodyWidget(Colors.blue),
                BodyWidget(Colors.red),
                BodyWidget(Colors.green),
                BodyWidget(Colors.orange),
                BodyWidget(Colors.blue),
                BodyWidget(Colors.red),
              ],
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            delegate: SliverChildListDelegate(
              [
                BodyWidget(Colors.blue),
                BodyWidget(Colors.green),
                BodyWidget(Colors.yellow),
                BodyWidget(Colors.orange),
                BodyWidget(Colors.blue),
                BodyWidget(Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
