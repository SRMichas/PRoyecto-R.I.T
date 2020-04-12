import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Resgistro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "Registro",
      home: new Scaffold(
        body: new CuerpoPrincipal(),
      ),
    );
  }

  void guarda() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("sesion", false);
    print("Guardado.....");
  }
}

class CuerpoPrincipal extends StatelessWidget {
  double margenHorizontal = 35.0,
      margenHorizontalBoton = 50.0,
      ancho = 50,
      divisor = 1,
  espaciado = 25.0;

  final _formulario = GlobalKey<FormState>();

  String nom, apeP, apeM, correo, Cont1, Cont2;
  List<TextEditingController> escritores = [];
  List<String> strings = [];
  BuildContext context;

  Container contenedor(int id,String hintT, int tipo, IconData icono) {
    TextEditingController controlador = new TextEditingController();

    TextFormField texto = TextFormField(
      controller: controlador,
      keyboardType: tipoTexto(tipo),
      obscureText: contrasena(tipo),
      //style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14.0),
          hintText: hintT,
          //hintStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(
            icono,
            //color: Colors.white
          ),
        errorStyle: TextStyle(
          fontSize: 16.0,

        )
      ),
      validator: (valor){
        if( id == 3) return null;
        else if( valor.isEmpty){
          return "No puede dejar vacio este campo";
        }else if( id == 4 && !valor.contains("@")){
          return "No es un correo valido";
        }
        return null;
      },
    );

    escritores.add(controlador);

    return Container(
      alignment: Alignment.centerLeft,
      decoration: decoracion(),
      height: 60.0,
      child: texto,
    );
  }

  BoxDecoration decoracion() {
    return BoxDecoration(
      border: Border.all(
        width: 0.8,
        //color: Colors.white
      ),
      borderRadius: BorderRadius.all(Radius.circular(50.0)),
    );
  }

  TextInputType tipoTexto(int tipo) {
    TextInputType respuesta = null;
    switch (tipo) {
      case 1:
        respuesta = TextInputType.text;
        break;
      case 2:
        respuesta = TextInputType.emailAddress;
        break;
      case 3:
        respuesta = TextInputType.visiblePassword;
        break;
    }

    return respuesta;
  }

  bool contrasena(int tipo) {
    return tipo == 3 ? true : false;
  }

  TextStyle titulo() {
    return TextStyle(fontSize: 32.0, letterSpacing: 5.0);
  }

  Container formulario(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 170.0,
        left: margenHorizontal,
        right: margenHorizontal,
      ),
      child: Form(
        key: _formulario,
        child: Column(
          children: <Widget>[
            /*Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(90))
                      ),
                    ),*/
            Text(
              "Registro",
              style: titulo(),
            ),
            SizedBox(
              height: 30.0,
            ),
            contenedor(1,"Nombre", 1, Icons.account_circle),
            SizedBox(
              height: espaciado,
            ),
            contenedor(2,"Apellido Paterno", 1, Icons.account_circle),
            SizedBox(
              height: espaciado,
            ),
            contenedor(3,"Apellido Materno", 1, Icons.account_circle),
            SizedBox(
              height: espaciado,
            ),
            contenedor(4,"Correo", 2, Icons.email),
            SizedBox(
              height: espaciado,
            ),
            contenedor(5,"Contraseña", 3, Icons.lock),
            SizedBox(
              height: espaciado,
            ),
            contenedor(6,"Confirmar Contraseña", 3, Icons.lock),
            SizedBox(height: 40.0),
            Container(
              width: double.infinity,
              height: 40.0,
              margin: EdgeInsets.only(
                  left: margenHorizontalBoton, right: margenHorizontalBoton),
              child: RaisedButton(
                elevation: 3.0,
                color: Colors.blueAccent,
                onPressed: /*() {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return muestraDialogo(mensaje());
                  },
                );
              }*/
                    /*() => _showDialog(context)*/
                (){
                  if (_formulario.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    /*Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Processing Data')));*/
                    _showDialog(context);
                  }
                },
                child: Text("Registrame",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        letterSpacing: 2.0)),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                  //side: BorderSide(color: Colors.white)
                ),
              ),
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }

  Stack contendorMaestro(){
    return Stack(
      children: <Widget>[
        /* Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    //alignment:Alignment.topLeft,
                    width: MediaQuery.of(context).size.width/divisor,
                    height: ancho,
                    margin: EdgeInsets.only(top: 70),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(90))
                    ),
                ),
            ),*/
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: 30),
            child: FlutterLogo(
              size: 120,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: formulario(context),
        ),
      ],
    );
  }

  String mensaje() {
    String mensaje = "";
    for (int i = 0; i < escritores.length; i++) {
      if (i == (escritores.length - 1)) {
        mensaje += escritores[i].text + ".";
      } else {
        mensaje += escritores[i].text + " ";
      }
    }
    return mensaje;
  }

  bool valida(){

    return true;
  }

  AlertDialog muestraDialogo(String mensaje) {
          return AlertDialog(
            // Retrieve the text the that user has entered by using the
            // TextEditingController.
            content: Text(mensaje),
          );
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    String mensajes = mensaje();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert Dialog title"),
          content: new Text("Se a registrado con exito \n"+mensajes),
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    this.context = context;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints){
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight
            ),
            child: contendorMaestro(),
          ),
        );
      },
    );
  }
}


