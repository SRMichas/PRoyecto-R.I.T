import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'resgistro.dart';
import 'inicio.dart';

//void main() => runApp(Root());

class Root extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
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
                      Navigator.pushReplacementNamed(contexto, "/inicio");
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
                onPressed: guarda,
                child: Text("Cambiar"),
              )
            ],
          ),
        )
    );
  }
  /*@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
      child: new Text(
        "Aparentement Funciono!!!",
        style: new TextStyle(
            fontSize: 20.0),),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    contexto = context;
    return /*Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  title: Text(
                      "Bienvenido de Nuevo",
                      style: TextStyle(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold
                      ),
                  ),
                  subtitle: Text(
                      "Usuario",
                      style: TextStyle(fontSize: 24.0),
                  ),
                )
              ],
            ),
      );*/
    LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints){
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


  void guarda() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("sesion", true);
    print("Guardado.....");
  }

  void iniciaRegistro(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => Resgistro(),
        ));
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
}




class MemberProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromRGBO(1, 89, 99, 1.0), Colors.grey],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text("Name : Sam Cromes",
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 19.0)),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text("Sex : Male",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 19.0))),
                  Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text("Age : 42",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 19.0))),
                  Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text("Status : Divorced",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 19.0))),
                  Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text("Tramatic Event : ",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 19.0))),
                  Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text("Motorcycle Accident July 2005, TBI",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 19.0))),
                  Container(
                      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Text("Bio :",
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 19.0))),
                  Container(
                    margin: EdgeInsets.only(
                        left: 30.0, top: 100.0, bottom: 30.0, right: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(20.0),
                          child: OutlineButton(
                            child: Text('Offer support'),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            onPressed: () {
                              // Navigator.of(context).push( MaterialPageRoute(builder: (BuildContext context) =>  CheckInQ()));
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            //here
          ),
        ],
      ),
    );
  }
}