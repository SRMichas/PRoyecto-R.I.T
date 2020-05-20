import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapitas/CustomViews/input_registro.dart';
import 'package:tapitas/CustomViews/mi_drop_down.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/constantes.dart';
import 'package:tapitas/Entidades/estados.dart';
import 'package:tapitas/Entidades/ciudad.dart';
import 'package:tapitas/CustomViews/mi_dialogo.dart';

class Registro extends StatelessWidget {

  final Function function;

  Registro({this.function});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => cerrar(context),
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back,color: Colors.blueAccent,),
                  onPressed: () => cerrar(context)
              ),
            ),
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints( minHeight: viewportConstraints.maxHeight ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          alignment: Alignment.center,
                          child: FlutterLogo( size: 120, ),
                        ),
                        Text(
                          "Registro",
                          style: TextStyle(fontSize: 32.0, letterSpacing: 5.0),
                        ),
                        Formulario(function: function)
                      ],
                    ),
                  ),
                );
              },
            ),
          )
    );
  }
  
  Future<bool> cerrar(context) async{
    Navigator.pushReplacementNamed(context, "/login");
    return true;
  }
}

class Formulario extends StatefulWidget {

  final Function function;

  Formulario({this.function});

  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final _formulario = GlobalKey<FormState>();
  double margenHorizontal = SizeConfig.conversionAncho(22, false),
      margenHorizontalBoton = SizeConfig.conversionAlto(50, false);

  BuildContext context;
  Estado estado;
  Ciudad ciudad;
  var data;
  String contraUno,_estado = "Estado",_ciudad = "Ciudad";
  bool _visible = false,_valida = false,dialogoVisible;

  List<String> infoRecolectada = ["","","","","","","",""];
  List<Object> _estados = [""], _ciudades = [""];

  @override
  void initState(){
    algoAsincronico();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      margin: EdgeInsets.only(
        top: SizeConfig.conversionAlto(10, false),
        left: margenHorizontal,
        right: margenHorizontal,
      ),
      child: Form(
        key: _formulario,
        autovalidate: _valida,
        child: Column(
          children: <Widget>[
            InputRegistro(inputId: 1,hint: "Nombre", tipoEntrada: TextInputType.text,
              icono: Icons.person,function: algodata,),
            InputRegistro(
              inputId: 2,
              hint: "Apellido Paterno", tipoEntrada: TextInputType.text,
              icono: Icons.person,function: algodata,  ),
            InputRegistro(inputId: 3,
                hint: "Apellido Materno",
                tipoEntrada: TextInputType.text,
                icono: Icons.person,function: algodata,),
            InputRegistro(inputId: 4,
                hint: "Correo",
                tipoEntrada: TextInputType.emailAddress,
                icono: Icons.email,function: algodata,),
            InputRegistro(inputId: 5,
              hint: "Contraseña",
              ocultarTexto: true,
              icono: Icons.vpn_key,
              function: algodata,
              funcion2: guardaContra,
            ),
            InputRegistro(inputId: 6,
              hint: "Confirmar Contraseña",
              ocultarTexto: true,
              icono: Icons.vpn_key,
              function: algodata,
              funcion2: recuperaContra,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: InputRegistro(
                      inputId: 7,
                      hint: "Edad",
                      tipoEntrada: TextInputType.numberWithOptions(
                        decimal: false),
                      margenDerecho: 5,
                    function: algodata,),
                ),
                Expanded(
                  child: InputRegistro(
                    inputId: 8,
                    hint: "Codigo Postal",
                    tipoEntrada: TextInputType.numberWithOptions(
                        decimal: false, signed: false),
                    margenIzquierdo: 5,
                    icono: Icons.local_post_office,
                    function: algodata,
                  ),
                ),
              ],
            ),
            FormField(
                builder: (field) {
                  return MiDrop(
                    singleValue: _estado,
                    listValues: _estados,
                    hintValue: "Estado",
                    expandido: true,
                    route: 1,
                    function: cambiaDatos,
                    estado: field,
                    icono: Icons.location_city,
                  );
                },
                validator: (value){
                  return value != null ? null : "Por favor seleccione un estado";
                }
            ),
          SizedBox(height: SizeConfig.conversionAlto(20, false),),
          Visibility(
            child: FormField(
              builder: (field){
                return MiDrop(
                  singleValue: _ciudad,
                  listValues: _ciudades,
                  hintValue: "Ciudad",
                  expandido: true,
                  route: 0,
                  function: cambiaDatos,
                  estado: field,
                  icono: Icons.home,
                );
              },
                validator: (value){
                  return value != null ? null : "Por favor seleccione una ciudad";
                }
            ),
            maintainSize: _visible,
            maintainAnimation: true,
            maintainState: true,
            visible: _visible,
          ),
            SizedBox(height: SizeConfig.conversionAlto(40, false)),
            Container(
              width: double.infinity,
              height: SizeConfig.conversionAlto(40, false),
              margin: EdgeInsets.only( left: margenHorizontalBoton, right: margenHorizontalBoton ),
              child: RaisedButton(
                elevation: 3.0,
                color: Colors.blueAccent,
                onPressed: () {
                  if (_formulario.currentState.validate()) {
                    _formulario.currentState.save();
                    _checkDialog();
                  }else
                    setState(() { _valida = true; });
                },
                child: Text("Registrame",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        letterSpacing: 2.0)),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }

  void algodata(int idx,value){
    infoRecolectada[idx] = value;
  }

  void guardaContra(valor){ contraUno = valor;}
  String recuperaContra(){ return contraUno; }

  void cambiaDatos(val, int ruta,FormFieldState<Object> edo) {
    if (ruta == 1) {
      estado = val;
      setState(() {
        edo.didChange(val);
        _estado = estado.nombre;
        _ciudades = estado.ciudades;
        _visible = true;
      });
    } else {
      ciudad = val;
      setState(() {
        edo.didChange(val);
        _ciudad = ciudad.nombre;
      });
    }
  }

  void algoAsincronico() async{
    data = await getEstados();
    List lista = data["lista"];
    _estados = lista.map((valor) => Estado.fromJson(valor)).toList();
    setState(() {});
  }

  Future<Map<String,dynamic>> getEstados() async{
    var url = "http://${Constantes.HOST+Constantes.RT_SLT}";
    url += "C-Estados.php";
    http.Response res = await http.get(url);
    var data = jsonDecode(res.body);
    return data;
  }

  Future<Map<String, dynamic>> sube() async{
    var url = "http://${Constantes.HOST+Constantes.RT_ISR}";
    url += "I-Usuario2.php";

    Map parametros = {
      "nombre" : "${infoRecolectada[0]}",
      "apellido" : "${infoRecolectada[1]} ${infoRecolectada[2]}",
      "edad" : "${infoRecolectada[6]}",
      "cod_post" : "${infoRecolectada[7]}",
      "correo" : "${infoRecolectada[3]}",
      "contra" : "${infoRecolectada[4]}",
      "ciudad" : "${ciudad.id}"
    };

    http.Response response = await http.post(url,body: parametros);
    var data = jsonDecode(response.body);

    return data;
  }

  void _checkDialog() async {
    dialogoVisible = true;
    Map<String, dynamic> lista;
    Map<String, Object> res = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return FutureBuilder(
              future: sube(),
              builder: (context, snapshot) {
                Widget vista;
                if (snapshot.hasData) {
                  bool fallo = snapshot.data["fallo"].toString() == "true";
                  int codigoError =
                  int.parse(snapshot.data["codigo"].toString()),
                      codigoTitulo;
                  String titulo;

                  if (!fallo) {
                    titulo = "Felicidades";
                    codigoTitulo = Constantes.C_EXITOSA_REGISTRO;
                    lista = snapshot.data;
                  } else
                    switch (codigoError) {
                      case 1:
                        titulo = Constantes.T_ERROR;
                        codigoTitulo = Constantes.C_ERROR;
                        break;
                      case 2:
                        titulo = Constantes.T_ADVERTENCIA;
                        codigoTitulo = Constantes.C_ADVERTENCIA;
                        break;
                    }
                  vista = MiDialogo(
                    titulo: titulo,
                    descripcion: snapshot.data["mensaje"].toString(),
                    tipoTitulo: codigoTitulo,
                    datos: snapshot.data,
                    soloCarga: false,
                  );
                } else {
                  vista = SimpleDialog(
                    children: <Widget>[
                      Center(
                        child: SizedBox(
                          height: SizeConfig.conversionAlto(100, false),
                          width: SizeConfig.conversionAncho(100, false),
                          child: CircularProgressIndicator(
                            strokeWidth: SizeConfig.conversionAncho(10, false),
                          ),
                        ),
                      )
                    ],
                  );
                }

                return vista;
              });
        });

    if (!res["bandera"]) {
      dialogoVisible = false;
      if( res["correcto"] ){
        guarda(lista["usuario"]);
        Navigator.pushReplacementNamed(context, "/inicio");
      }
    }
  }

  void guarda(List data) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("sesion", true);
    await prefs.setString("id", data[1]);
    await prefs.setString("nombre", data[3]);
    await prefs.setString("apellido", data[4]);
    await prefs.setString("edad", data[5]);
    await prefs.setString("correo", data[7]);
    await prefs.setString("contra", data[8]);
    await prefs.setInt("puntos", int.parse(data[9].toString()));
    await prefs.setString("ciudad", data[10]);
    await prefs.setString("estado", data[11]);
  }
}