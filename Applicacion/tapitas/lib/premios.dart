import 'package:flutter/material.dart';
import 'package:tapitas/Entidades/categoria.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/constantes.dart';
import 'package:tapitas/Entidades/mi_excepcion.dart';
import 'lista_premios.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

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

class _CuerpoEState extends State<CuerpoE> with AutomaticKeepAliveClientMixin<CuerpoE>{

  List categorias;
  int size = 0,_status,puntos;
  BuildContext context;
  Future<Map<String, dynamic>> _futuro;
  bool bandera = false,bandera2 = false;
  Widget _vista;
  SharedPreferences prefs;

  TextStyle estiloPre1 = TextStyle(
          fontSize:
          (22 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier),
      estiloError = TextStyle(
          fontSize: (24 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier);


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _futuro = getCategorias();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    this.context = context;

    if( !bandera ){
      _vista = futureBuilder();
    }

    return Container(
      child: _vista,
    );
  }

  Future<Map<String, dynamic>> getCategorias() async{
    prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    var url = '${Constantes.HOST+Constantes.RT_SLT}';
    url += "C-Premios2.php";

    Map parametros = {"usId" : id};

    try{
      http.Response response = await http.post(url,body: parametros);
      _status = response.statusCode;

      if( _status == 200) {
        var data = jsonDecode(response.body);
        bandera = false;
        return data;
      }else{
        throw MiExcepcion("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",0,Icons.print);
      }
    } on FormatException catch (e){
      bandera = false;
      throw MiExcepcion("Error al conectar con el servidor \n${e.toString()}",2,Icons.info,e);
    } on Exception catch (e){
      //el servidor esta apagado -> a rechazado la conexion
      bandera = false;
      throw MiExcepcion("Se ha rechazado la conexión",1,Icons.signal_wifi_off,e);
    } on TypeError catch (e){
      bandera = false;
      throw MiExcepcion(e.toString(),1,Icons.signal_wifi_off,e);
    }
  }

  void cambiaPuntos(int nuevosP)async{
    prefs = await SharedPreferences.getInstance();
    if( nuevosP != puntos ) {
      await prefs.setInt("puntos", nuevosP);
      prefs.reload();
    }
   setState(() {
      puntos = nuevosP;
      bandera2 = true;
    });
  }

  Widget futureBuilder(){
    return FutureBuilder(
        future: _futuro,
        builder:(BuildContext context,AsyncSnapshot snapshot){
          Widget vista;

          if( snapshot.connectionState == ConnectionState.waiting){
            return Container(
              child: Center(
                child: SizedBox(
                  width: 42 * SizeConfig.widthMultiplier,
                  height: 42 * SizeConfig.widthMultiplier,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                    strokeWidth: 4 * SizeConfig.widthMultiplier /*18*/,
                  ),
                ),
              ),
            );
          }

          if( snapshot.hasData){
            bool error = snapshot.data["fallo"].toString() == "true";
            //int codigo = snapshot.data["codigo"];

            if( !error ){
              puntos = bandera2 ? puntos : int.parse(snapshot.data["puntos"].toString());
              vista = cuerpoPrincipal(snapshot.data["lista"],snapshot.data["lista"].length);
            }else{
              vista = Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                        Icons.error,
                        color: Colors.red,
                        size:(200 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier),
                    Text(
                      snapshot.data["mensaje"].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle( fontSize: SizeConfig.conversionAlto(28, false)),
                    ),
                    SizedBox(height:(30 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier),
                    FlatButton(
                      onPressed: () => setState(() {
                        bandera = false;
                        try {
                          _futuro = getCategorias();
                        }catch(e){
                          print("ESTE EST EL ERROR =====> ${e.toString()}");
                        }
                      }),
                      child: Text("Reintentar",style: estiloPre1,),
                      textColor: Colors.blue,
                    )
                  ],
                ),
              );
            }

          }else if( snapshot.hasError){
            MiExcepcion e = snapshot.error;

            vista = Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(e.icono,size:SizeConfig.conversionAlto(100, false),),
                  Text("${e.mensaje}",style: estiloError,),
                  SizedBox(height: SizeConfig.conversionAlto(30, false)),
                  FlatButton(
                    onPressed: () => setState(() {
                      bandera = false;
                      try {
                        _futuro = getCategorias();
                      }catch(e){
                        print("ESTE EST EL ERROR =====> ${e.toString()}");
                      }
                    }),
                    child: Text("Reintentar",style: estiloPre1,),
                    textColor: Colors.blue,
                  )
                ],
              ),
            );
          }
          return vista;
        }
    );
  }

  Widget cuerpoPrincipal(List snapshot,int longitud){
    List<Categoria> cates = snapshot.map((valor) => Categoria.fromJson(valor)).toList();

    return CustomScrollView(
      slivers: <Widget>[
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 2.07 * SizeConfig.heightMultiplier, //16
            //childAspectRatio: 0.15 * SizeConfig.heightMultiplier //1.15
          ),
          delegate: SliverChildBuilderDelegate((BuildContext context,int idx){
            Categoria cate = cates[idx];

            return ModeloCategoria(categoriaO: cate,puntos: puntos,funcion: cambiaPuntos,);
          },childCount: longitud,),
        )
      ],
    );
  }
}

class ModeloCategoria extends StatelessWidget {

  final String nombre,url;
  final int categoria;
  int puntos;
  final Categoria categoriaO;
  final Function funcion;

  ModeloCategoria({this.nombre,this.url,this.categoria,this.categoriaO,this.puntos,this.funcion});

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
        onTap: ()async{
          var res = await Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => ListaPremios(premios: categoriaO.premios,puntos: puntos,cate: categoriaO.nombre,),
              ));
          puntos = res;
          funcion(puntos);
        },
        child: Card(
            elevation: 0.33 * SizeConfig.heightMultiplier,// 2.5
            child:Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.network(
                    categoriaO.url,
                    width: tamano, //100
                    height: tamano,
                    cacheWidth: tamanoCache.toInt(), //1000
                    cacheHeight: tamanoCache.toInt(),
                  ),
                  SizedBox(height:espaciado), //15
                  Text(
                    categoriaO.nombre,
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
