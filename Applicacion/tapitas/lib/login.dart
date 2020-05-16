import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'resgistro.dart';
import 'inicio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Extras/Constantes.dart';
import 'package:tapitas/Extras/size_config.dart';

//void main() => runApp(Root());

class Root extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
          title: 'Login',
          home: new Scaffold(
            body: new LoginPndj(),
            backgroundColor: Color.fromRGBO(97, 164, 241, 1.0),
          ),
          routes: <String,WidgetBuilder>{
            '/login': (BuildContext context) => new Root(),
            '/registro': (BuildContext context) => new Resgistro(),
            '/inicio': (BuildContext context) => new Inicio()
          },
    );
  }

}

class LoginPndj extends StatelessWidget{

  double margenHorizontal = 35.0;

  List<TextEditingController> controladores = [
          new TextEditingController(),
          new TextEditingController()];

  final _formulario = GlobalKey<FormState>();

  TextStyle cabezera = TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        fontWeight: FontWeight.bold
  ),
  etiqueta = TextStyle(
        color: Colors.white
  );

  BuildContext contexto;

  Column contenedorCorreo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Correo",style: cabezera,),
        Container(
          alignment: Alignment.centerLeft,
          decoration: decoracion(),
          height: 60.0,
          child: TextFormField(
            controller: controladores[0],
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top:14.0),
                hintText: "Ingrese correo",
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                errorStyle: TextStyle(
                  fontSize: 16.0,

                )
            ),
            validator: (valor){
              if( valor.isEmpty){
                return "No puede dejar vacio este campo";
              }else if(!valor.contains("@")){
                return "No es un correo valido";
              }
              return null;
            },
          ),
        )
      ],
    );
  }

  Column contenedorContra(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Contraseña",style: cabezera,),
        Container(
          alignment: Alignment.centerLeft,
          decoration: decoracion(),
          height: 60.0,
          child: TextFormField(
            controller: controladores[1],
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top:14.0),
                hintText: "Ingrese contraseña",
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                errorStyle: TextStyle(
                  fontSize: 16.0,

                )
            ),
            validator: (valor){
              if( valor.isEmpty){
                return "No puede dejar vacio este campo";
              }
              return null;
            },
          ),
        )
      ],
    );
  }
  String email,pass;
  void getData() async{
    var url = "http://${Constantes.HOST+Constantes.RT_SLT}";
    url += "C-Usuario2.php?correo=$email&contra=$pass";
    //var url = 'http://192.168.1.64/hola.php';
    http.Response response = await http.get(url); 
    var data = jsonDecode(response.body);
    if( !data["fallo"] ){
      guarda(data["usuario"]);
      Navigator.pushReplacementNamed(contexto, "/inicio");
    }else{
      _showDialog2(data["mensaje"].toString());
    }
    /*String dato = data["mensaje"].toString();
    print(data);
    print(dato);
    _showDialog2(dato);*/
  }

  Container contenedorMaestro(){
    return Container(
        margin: EdgeInsets.only(
          top: 150.0,
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
                    fontSize: 32.0,
                  )
              ),
              SizedBox(height: 40.0,),

              contenedorCorreo(),

              SizedBox(height: 40.0,),

              contenedorContra(),

              Container(
                alignment: Alignment.centerRight,
                child: FlatButton(
                    onPressed: () => print("Le picaste a olviidar contra"),
                    child: Text(
                      "¿Contraseña olvidada?",
                      style: etiqueta,
                    )
                ),
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: (){
                    if (_formulario.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      /*Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));*/
                      //_showDialog(contexto);
                      //Navigator.of(contexto).pushReplacementNamed('/inicio');
                      //and

                      email = controladores[0].text;
                      pass = controladores[1].text;
                      getData();
                      //Navigator.pushReplacementNamed(contexto, "/inicio");
                      
                      
                      
                      
                      /*Navigator.pop(contexto);
                      Navigator.push(contexto,
                          MaterialPageRoute(
                            builder: (context) => Inicio(),
                          ));*/
                    }
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
                      onPressed: () => iniciaRegistro(contexto),
                      child: Text(
                          "Creala Aqui",
                          style: etiqueta
                      )
                  ),
                ],
              ),

              RaisedButton(
                onPressed: null,
                child: Text("Cambiar"),
              )
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    contexto = context;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints){
        SizeConfig().iniciar(viewportConstraints);
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight
            ),
            child: contenedorMaestro(),
          ),
        );
      },
    );

  }


  void guarda(List data) async{
    print(data.toString());
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
    print("Guardado.....");
  }

  void iniciaRegistro(BuildContext context){
    /*Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => Resgistro(function: cierra,),
        ));*/
    Navigator.pushReplacementNamed(context, "/registro");
    //Navigator.popAndPushNamed(contexto, "/registro");
    /*if( res )
      print("llegaste aqui");*/
      /*Navigator.pushReplacementNamed(context, "/inicio");
      Navigator.pushNamed(context, "/inicio");*/
  }

  void cierra(){
    Navigator.pop(contexto);
  }

  BoxDecoration decoracion(){
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

  void _showDialog(BuildContext context) {
    // flutter defined function
    String mensajes = controladores[0].text +" " +
        controladores[1].text;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Se a iniciado sesion con exito \n"+mensajes),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _showDialog2(String msg) {
    // flutter defined function
    /*String mensajes = controladores[0].text +" " +
        controladores[1].text;*/
    showDialog(
      context: contexto,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}