import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'resgistro.dart';
import 'inicio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Extras/Constantes.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/CustomViews/InputRegistro.dart';
import 'MiDialogo.dart';

class Login extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
          title: 'Login',
          home: new Scaffold(
            body: new CuerpoLogin(),
            backgroundColor: Color.fromRGBO(97, 164, 241, 1.0),
          ),
          routes: <String,WidgetBuilder>{
            '/registro': (BuildContext context) => new Resgistro(),
            '/inicio': (BuildContext context) => new Inicio()
          },
    );
  }
}

class CuerpoLogin extends StatelessWidget {

  double margenHorizontal = 35.0;
  bool _valida = false,
      dialogoVisible = false;

  String correo, contra;
  List info;
  BuildContext context;
  final _formulario = GlobalKey<FormState>();

  TextStyle cabezera = TextStyle(
      color: Colors.white,
      fontSize: 24.0,
      fontWeight: FontWeight.bold
  ),
      etiqueta = TextStyle(
          color: Colors.white
      );

  Future<Map<String, dynamic>> getData() async {
    var url = "http://${Constantes.HOST + Constantes.RT_SLT}";
    url += "C-Usuario2.php";

    Map parametros = {
      "correo": correo,
      "contra": contra
    };
    http.Response response = await http.post(url, body: parametros);

    var data = jsonDecode(response.body);
    return data;
  }

  void otroMetodo() {
    guarda(info);
    Navigator.pushReplacementNamed(context, "/inicio");
  }

  void _checkDialog() async {
    dialogoVisible = true;
    Map<String, dynamic> lista;
    Map<String, Object> res = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                Widget vista;
                if (snapshot.hasData) {
                  bool fallo = snapshot.data["fallo"].toString() == "true", bandera;
                  int codigoError = int.parse(snapshot.data["codigo"].toString()), codigoTitulo;
                  String titulo;
                  Function funcion;

                  if (!fallo) {
                    titulo = "Felicidades";
                    codigoTitulo = Constantes.C_EXITOSA_LOGIN;
                    lista = snapshot.data;
                    info = snapshot.data["usuario"];
                    bandera = true;
                    funcion = otroMetodo;
                  } else
                    switch (codigoError) {
                      case 1:
                        titulo = Constantes.T_ERROR;
                        codigoTitulo = Constantes.C_ERROR;
                        bandera = false;
                        break;
                      case 2:
                        titulo = Constantes.T_ADVERTENCIA;
                        codigoTitulo = Constantes.C_ADVERTENCIA;
                        bandera = false;
                        break;
                    }
                  vista = MiDialogo(
                    titulo: titulo,
                    descripcion: snapshot.data["mensaje"].toString(),
                    tipoTitulo: codigoTitulo,
                    datos: snapshot.data,
                    onRun: funcion,
                    algo: bandera,
                  );
                } else if (snapshot.hasError) {

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
      if (res["llama"]) {
        guarda(lista["usuario"]);
        Navigator.pushReplacementNamed(context, "/inicio");
      }
    }
  }

  void metodo(int ruta, String res) {
    if (ruta == 1)
      correo = res;
    else
      contra = res;
  }

  Container contenedorMaestro() {
    return Container(
        margin: EdgeInsets.only(
          top: SizeConfig.conversionAlto(150, false),
          left: margenHorizontal,
          right: margenHorizontal,
        ),
        child: Form(
          key: _formulario,
          child: Column(
            children: <Widget>[
              Text(
                  "Log in",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.conversionAlto(32, false),
                  )
              ),
              SizedBox(height: SizeConfig.conversionAlto(40, false),),
              InputRegistro(
                inputId: 2,
                hint: "Correo",
                tipoEntrada: TextInputType.emailAddress,
                icono: Icons.email,
                color: Colors.white,
                estilo: TextStyle(color: Colors.white, fontSize: 20),
                function: metodo,
              ),
              SizedBox(height: SizeConfig.conversionAlto(40, false),),
              InputRegistro(
                inputId: 1,
                hint: "Contraseña",
                tipoEntrada: TextInputType.text,
                icono: Icons.vpn_key,
                color: Colors.white,
                ocultarTexto: true,
                estilo: TextStyle(color: Colors.white, fontSize: 20),
                function: metodo,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: FlatButton(
                    onPressed: () => print("Le picaste a olvidar contra"),
                    child: Text(
                      "¿Contraseña olvidada?",
                      style: etiqueta,
                    )
                ),
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {
                    if (_formulario.currentState.validate()) {
                      _formulario.currentState.save();
                      _checkDialog();
                    } /*else
                      setState(() { _valida = true; });*/
                  },
                  elevation: 5.0,
                  color: Colors.white,
                  child: Text("INGRESAR",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        letterSpacing: 2.0
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                      side: BorderSide(color: Colors.white)
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Text("¿No tiene cuenta?"),
                  FlatButton(
                      onPressed: () => iniciaRegistro(context),
                      child: Text( "Creala Aqui", style: etiqueta )
                  ),
                ],
              )
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        SizeConfig().iniciar(viewportConstraints);
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints( minHeight: viewportConstraints.maxHeight ),
            child: contenedorMaestro(),
          ),
        );
      },
    );
  }


  void guarda(List data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("sesion", true);
    await prefs.setString("id", data[0]);
    await prefs.setString("nombre", data[2]);
    await prefs.setString("apellido", data[3]);
    await prefs.setString("edad", data[4]);
    await prefs.setString("correo", data[6]);
    await prefs.setString("contra", data[7]);
    await prefs.setInt("puntos", int.parse(data[8].toString()));
    await prefs.setString("ciudad", data[9]);
    await prefs.setString("estado", data[10]);
  }

  void iniciaRegistro(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/registro");
  }

  BoxDecoration decoracion() {
    return BoxDecoration(
      border: Border.all(
          width: 0.8,
          color: Colors.white
      ),
      borderRadius: BorderRadius.all(
          Radius.circular(8.0)
      ),

    );
  }
}