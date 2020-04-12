import 'package:flutter/material.dart';

class ListaPremios extends StatelessWidget {
  ListaPremios(this.cate);

  final String cate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos Canjeables"),
      ),
      body: Cuerpo(Categoria: cate,),
    );
  }
}

class ModeloProducto extends StatelessWidget {
  final String nombre, descripcion;
  final int puntos;

  ModeloProducto(this.nombre, this.descripcion, this.puntos);
  BuildContext context;

  double margen;

  TextStyle estilo1 = TextStyle(
      fontSize: 22,
  ),
      estilo2 = TextStyle(
          fontSize: 22
      ),estilo3 = TextStyle(
      fontSize: 24
  );

  @override
  Widget build(BuildContext context) {
    this.context = context;
    margen = MediaQuery.of(context).size.width / 35;
    return Container(
      //color: Colors.pink,
      margin: EdgeInsets.only(left: margen, right: margen),
      child: Column(
        children: <Widget>[
          Row(
        children: <Widget>[
          Container(
            color: Colors.red,
            width: MediaQuery.of(context).size.width / 5,//MediaQuery.of(context).size.height
            child: Container(
              height: double.infinity,
              child: Icon(
                Icons.account_circle,
                size: 70,
              ),
            )
          ),
          Container(
            color: Colors.blue,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.purple,
                    child: Text(
                      nombre.toUpperCase(),
                      style: estilo1,)
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                    descripcion,
                    style: estilo2)
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            color: Colors.green,
            width: MediaQuery.of(context).size.width / 4.2,
            child: Container(child:Text("$puntos",style: estilo3,)),
          )
        ],
      ),
      Divider(height: 5, color: Colors.grey)
        ],
      ),
    );
  }
}

class Cuerpo extends StatefulWidget {

  Cuerpo({Key key,this.Categoria}) : super(key:key);

  final String Categoria;

  @override
  _CuerpoState createState() => _CuerpoState();
}

class _CuerpoState extends State<Cuerpo> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate:
            SliverChildBuilderDelegate((BuildContext context, int idx) {
              String nombreCat = widget.Categoria;
              return ModeloProducto("Nombre $nombreCat#$idx", "Descripcion $nombreCat#$idx", idx);
            }, childCount: 12),
          )
        ],
      ),
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
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int idx) {
              return ModeloProducto("Nombre #$idx", "Descripcion #$idx", idx);
            }, childCount: 12),
          )
        ],
      ),
    );
  }
}
