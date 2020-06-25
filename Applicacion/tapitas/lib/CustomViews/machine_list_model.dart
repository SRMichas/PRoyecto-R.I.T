import 'package:flutter/material.dart';
import 'package:tapitas/Entidades/maquina.dart';
import 'package:tapitas/Entidades/ciudad.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;
import 'package:tapitas/Extras/size_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tapitas/Extras/my_flutter_app_icons.dart';

class MachineModel extends StatefulWidget {

  final CiudadMin city;
  final List<Maquina> machines;
  final List listSample;
  final String testvalue;
  final int idx;
  final Function(int,bool) funcion;
  bool expanded = false;

  MachineModel({this.city,this.machines,this.testvalue,this.listSample,this.idx,this.expanded,this.funcion});

  @override
  _MachineModelState createState() => _MachineModelState();
}

class _MachineModelState extends State<MachineModel> {

  Widget _viewExpanded;

  @override
  void initState() {
    //_viewExpanded = compress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _viewExpanded = widget.expanded ? expended() : compress();

    return Container(
      child: _viewExpanded,
    );
  }

  Widget compress(){
    CiudadMin city = widget.city;
    double size = SizeConfig.conversionAlto(50, false);
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(SizeConfig.conversionAncho(20, false)))
            ),
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.conversionAncho(15, false),
                vertical: SizeConfig.conversionAlto(5, false)
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.conversionAncho(12, false),
                vertical: SizeConfig.conversionAlto(8, false),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    //color: Colors.yellow,
                    height: size,
                    width: size,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: SizeConfig.conversionAncho(5, false)),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue
                    ),
                    child: Text(
                      city != null? city.nombre[0] : widget.testvalue ?? "A",style: conts.Estilo.CITY_CAPITAL_LETTER,),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      //color: Colors.red,
                      child: Text(city != null? city.nombre : widget.testvalue ?? "Nombre ciudad",style: conts.Estilo.CITY_NAME,),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      //color: Colors.green,
                      alignment: Alignment.center,
                      child:InkWell(
                        child: Center(
                          child: Icon(Icons.expand_more,size: SizeConfig.conversionAlto(35, false),),
                        ),
                        onTap: (){ widget.funcion(widget.idx,widget.expanded);
                          /*setState((){
                            _viewExpanded = expended();
                          });*/
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget expended(){
    CiudadMin city = widget.city;
    double size = SizeConfig.conversionAlto(50, false),
        divider = SizeConfig.conversionAlto(2, false);
    return Container(
      child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(SizeConfig.conversionAncho(20, false)))
            ),
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.conversionAncho(15, false),
                vertical: SizeConfig.conversionAlto(5, false)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.conversionAncho(12, false),
                    vertical: SizeConfig.conversionAlto(8, false),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        //color: Colors.yellow,
                        height: size,
                        width: size,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: SizeConfig.conversionAncho(5, false)),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue
                        ),
                        child: Text(
                          city != null? city.nombre[0] : widget.testvalue ?? "A",style: conts.Estilo.CITY_CAPITAL_LETTER,),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          //color: Colors.yellow,
                          child: Text(city != null? city.nombre : widget.testvalue ?? "Nombre ciudad",style: conts.Estilo.CITY_NAME,),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          //color: Colors.green,
                          alignment: Alignment.center,
                          child:InkWell(
                            splashColor: Colors.green,
                            child: Center(
                              child: Icon(Icons.expand_less,size: SizeConfig.conversionAlto(35, false),),
                            ),
                            onTap: () => setState((){widget.funcion(widget.idx,widget.expanded); /*_viewExpanded = compress();*/}),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(height: divider,thickness: divider,),
                Container(
                  //height: SizeConfig.conversionAlto(91.5 * (widget.machines != null ? widget.machines.length : 0).toDouble(), false),
                  child: Column(
                    children: widget.machines.map((valor) => _MachineSubModel(maquina: valor,)).toList(),
                  )/*CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate:SliverChildBuilderDelegate((context, index){
                          if( widget.machines != null)
                            return _MachineSubModel(maquina: widget.machines[index]);
                          else
                            return _MachineSubModel();
                        },childCount: widget.machines != null ? widget.machines.length: widget.listSample.length ?? 0),
                      ),
                    ],
                  )*/,
                ),
                Container(
                  alignment: Alignment.center,
                  child: FlatButton(
                      onPressed: () => setState((){ _viewExpanded = compress();}),
                      child: Text("Cerrar",style: conts.Estilo.TEXT_BUTTON_BOTTOM,)),
                )
              ],
            ),
          ),
    );
  }
}

class _MachineSubModel extends StatelessWidget {

  final Maquina maquina;
  //var scaffold;

  _MachineSubModel({this.maquina});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    double divider = SizeConfig.conversionAlto(2, false);
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.conversionAlto(10, false),
                horizontal: SizeConfig.conversionAncho(10, false)
            ),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: SizeConfig.conversionAncho(10, false)),
                  child: Icon(EstadosIcon.maquina_8,size: SizeConfig.conversionAlto(35, false),),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    //color: Colors.green,
                    child: Text(
                      maquina != null? maquina.getDireccion() : "Calle, Colonia, Ciudad, Estado",
                      style: conts.Estilo.DIRECCION,
                      softWrap: true,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    //color: Colors.orange,
                    height: SizeConfig.conversionAlto(25, false),
                    width: SizeConfig.conversionAncho(85, false),
                    child: RaisedButton(
                      onPressed: (){

                        _navegador(maquina.getLocation()/*"https://www.google.com.mx/maps/@24.7889898,-107.3978129,19.54z"*/);
                      }/*(){
                        scaffold.showSnackBar(
                          SnackBar(
                            content: const Text("Se abrió el navegador"),
                            action: SnackBarAction(
                                label: "cerrar", onPressed: scaffold.hideCurrentSnackBar),
                          )
                        );
                      }*/,
                      elevation: 0.0,
                      color: conts.Colores.BOTON,
                      shape: RoundedRectangleBorder(
                          borderRadius:BorderRadius.circular(20),
                          side: BorderSide(color: Colors.blue)
                      ),
                      child: Text("Ver mapa",style: conts.Estilo.TEXT_BUTTON,),
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(height: divider,thickness: divider,)
        ],
      ),
    );
  }

  Future<void> _navegador(String url) async{
    if( await canLaunch(url)){
      await launch(
          url,
          forceSafariVC: false,
          forceWebView: false,
          headers: <String,String>{"header" : "cabezera"}
      );
    }else{
      throw "No se puede abrir: $url";
    }
  }

  Future<void> _webView(String url) async{
    if( await canLaunch(url)){
      await launch(
          url,
          forceSafariVC: true,
          forceWebView: true,
          enableJavaScript: true,
          headers: <String,String>{"header" : "cabezera"}
      );
    }else{
      throw "No se puede abrir: $url";
    }
  }
}

