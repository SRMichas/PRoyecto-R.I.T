import 'package:flutter/material.dart';
import 'ListaPremios.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/Constantes.dart';

class Premios extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Premios"),
      ),
      body: new CuerpoE(),
    );
  }

}

class CuerpoE extends StatefulWidget {
  @override
  _CuerpoEState createState() => _CuerpoEState();
}

class _CuerpoEState extends State<CuerpoE> {

  List categorias;
  int size = 0;
  BuildContext context;

@override
  void initState() {
    super.initState();
    //getCategorias();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return LayoutBuilder(
      builder: (context,constraints){
        SizeConfig().iniciar(constraints);
        return cuerpoPrincipal2();
      },
    );
  }

  Widget controladorTab(){
    
  }

  Future getCategorias() async{
    var url = 'http://${Constantes.HOST}/RIT/Select/C-Categorias.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    //print(data.toString());
    if( !data["fallo"] ){
      categorias = data["categorias"];
      size = categorias.length;
      print(size);
    }else{
    }
  }

  Future<List> _getCategorias() async{
    var url = 'http://${Constantes.HOST}/RIT/Select/C-Categorias.php';
    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);
    //print(data.toString());
    if( !data["fallo"] ){
      categorias = data["categorias"];
      size = categorias.length;
      print(size);
    }

    return data["categorias"];
  }

  

  CustomScrollView cuerpoPrincipal(var snapshot,int longitud){
    return CustomScrollView(
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              //crossAxisSpacing: 20,
              mainAxisSpacing: 2.07 * SizeConfig.heightMultiplier, //16
              //childAspectRatio: 0.15 * SizeConfig.heightMultiplier //1.15
          ),
          delegate: SliverChildBuilderDelegate((BuildContext context,int idx){
              var nombre = snapshot[idx]["nombre"],url = snapshot[idx]["icono"];
              int categoria = int.parse(snapshot[idx]["id_categoria"]);
              return ModeloCategoria(nombre,url,categoria);


          },childCount: longitud,),
        )
      ],
    );
  }

  Container cuerpoPrincipal2(){
    return Container(
      child: FutureBuilder(
          future: _getCategorias(),
          builder:(BuildContext context,AsyncSnapshot snapshot){
              if( snapshot.data == null){
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: SizedBox(
                      width: 42 * SizeConfig.widthMultiplier,
                      height: 42 * SizeConfig.widthMultiplier,
                      child: CircularProgressIndicator(strokeWidth: 4 * SizeConfig.widthMultiplier/*18*/,),
                    ),
                  ),
                );
              }else{
                return cuerpoPrincipal(snapshot.data,snapshot.data.length);
              }
          }
      ),
    );
  }
}

class Categoria{

}


/*class Cuerpo extends StatelessWidget{

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
}*/

class ModeloCategoria extends StatelessWidget {

  final String nombre,url;
  final int categoria;

  ModeloCategoria(this.nombre,this.url,this.categoria);

  TextStyle estilo = TextStyle(
    fontSize: 3.7 * SizeConfig.textMultiplier,//28
  );

  double margen = 2.5 * SizeConfig.widthMultiplier,// ~~> 12
          tamano = 12.95 * SizeConfig.heightMultiplier, //100
          tamanoCache = 129.37 * SizeConfig.heightMultiplier, //1000
          espaciado = 1.95 * SizeConfig.heightMultiplier; //15;

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 10,
      margin: EdgeInsets.only(left: margen,right: margen),//EdgeInsets.only(left: 20,right: 20)
      child:GestureDetector(
        onTap: (){
          //print(nombre);
          Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => ListaPremios(nombre,categoria),
              ));
        },
        child: Card(
            elevation: 0.33 * SizeConfig.heightMultiplier,// 2.5
            child:Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /*Icon(
                  Icons.add,
                  size: 100,
                ),*/
                  Image.network(
                    url,
                    width: tamano, //100
                    height: tamano,
                    cacheWidth: tamanoCache.toInt(), //1000
                    cacheHeight: tamanoCache.toInt(),
                  ),
                  SizedBox(height:espaciado), //15
                  Text(
                    nombre,
                    style: estilo,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  )
                ],
              ),
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
