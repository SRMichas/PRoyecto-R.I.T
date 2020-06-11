import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:http/http.dart' as http;
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/CustomViews/mi_dialogo.dart';
import 'package:tapitas/CustomViews/mi_dialogo2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;
import 'dart:convert';

class LectorQR extends StatefulWidget {

  Function fun;
  Function fun2;
  int valor = 1;


  LectorQR({this.fun});

  @override
  State<StatefulWidget> createState() => CuerpoLector();



}

class CuerpoLector extends State<LectorQR> {
  GlobalKey qrKey = GlobalKey();
  var qrtext = "";
  QRViewController controller;
  bool dialogoVisible = false;
  SharedPreferences prefs;
  BuildContext context;

  TextStyle estilo = TextStyle(
    fontSize: ( 15 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier,
    fontWeight: FontWeight.bold
  );

  @override
  void initState() {
    widget.fun = dialogo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    inciaShared();
    double margenHorizontal = SizeConfig.conversionAncho(20, false);
    return Stack(
      children: <Widget>[
        QRView(
            key: qrKey,
            overlay: QrScannerOverlayShape(
                borderRadius: 10,
                borderColor: Colors.red,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300),
            onQRViewCreated: _onQr),
        Container(
          //color: Colors.black,
          margin: EdgeInsets.only(bottom: 85,left: margenHorizontal,right: margenHorizontal),
          alignment: Alignment.bottomCenter,
          child: Text(
              conts.Constantes.MENSAJE_QR,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )
          ),
        )
      ],
    );/*Scaffold(
      appBar: AppBar(
        backgroundColor: conts.Colores.APP_BAR_BACKGROUND_COLOR,
        title: Text("Escaner",style: conts.Colores.ESTILO_TITULO,),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: SizeConfig.conversionAlto(10, false)),
            child: IconButton(
                onPressed: () => dialogo(),
                icon: Icon(Icons.edit,color: conts.Colores.APP_BAR_WIDGET_COLOR,),
            ),
          )
        ],
        leading: IconButton(
            icon: Icon(Icons.arrow_back,color: conts.Colores.APP_BAR_WIDGET_COLOR,),
            onPressed: () => Navigator.of(context).pop(),
        )
      ),
      body: Stack(
      children: <Widget>[
        QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                  borderRadius: 10,
                  borderColor: Colors.red,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300),
              onQRViewCreated: _onQr),
        Container(
          //color: Colors.black,
          margin: EdgeInsets.only(bottom: 85,left: margenHorizontal,right: margenHorizontal),
          alignment: Alignment.bottomCenter,
          child: Text(
            conts.Constantes.MENSAJE_QR,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )
          ),
        )
      ],
    ),
    );*/
  }

  Future<Map<String,dynamic>> getInfo(String cadena) async{
    var id = await prefs.getString("id");
    var url = '${conts.Constantes.HOST+conts.Constantes.RT_UDT}';
    url += "U-Cadena2.php";

    Map parametros = {
      "usId" : id,
      "cadena" : cadena ?? qrtext
    };

    http.Response response = await http.post(url,body:parametros);
    var data = jsonDecode(response.body);

    return data;
  }

  void _onQr(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {

      if( !dialogoVisible ){
        qrtext = scanData;
        try{
          _checkDialog();
          
        }catch(e){
          //_showDialog("El formato proporcionado es incorrecto",conts.Constantes.C_ERROR);
        }
      }
    });
  }

  void _checkDialog() async{
    dialogoVisible = true;
    Map<String,dynamic> res = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return FutureBuilder(
              future: getInfo(null),
              builder: (context,snapshot){
                Widget vista;
                if( snapshot.hasData){
                  bool fallo = snapshot.data["fallo"].toString() == "true";
                  int codigoError = int.parse(snapshot.data["codigo"].toString()),
                      codigoTitulo;
                  String titulo;

                  if( !fallo ){
                    titulo = "Felicidades";
                    codigoTitulo = conts.Constantes.C_EXITOSA;
                    
                    String numtxt = snapshot.data["nuevos"];
                    
                    if( numtxt != null ) {
                      
                      prefs.setInt("puntos", int.parse(numtxt.toString()));
                    }
                  }else switch(codigoError){
                    case 1:
                      titulo = conts.Constantes.T_ERROR;
                      codigoTitulo = conts.Constantes.C_ERROR;
                      break;
                    case 2:
                      titulo = conts.Constantes.T_ADVERTENCIA;
                      codigoTitulo = conts.Constantes.C_ADVERTENCIA;
                      break;
                    case 3:
                      titulo = conts.Constantes.T_ERROR;
                      codigoTitulo = conts.Constantes.C_ERROR;
                      break;
                  }
                  vista = MiDialogo(titulo: titulo,
                    descripcion: snapshot.data["mensaje"].toString(),
                    tipoTitulo: codigoTitulo,soloCarga: false,);
                }else{
                  vista = SimpleDialog(
                    children: <Widget>[
                      Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator(strokeWidth: 10,),
                        ),
                      )
                    ],
                  );
                }

                return vista;
              }
          );
        }
    );

    if( res["bandera"] )
      Navigator.of(context).pop();
    else
      dialogoVisible = false;
  }

  void inciaShared() async{
    prefs = await SharedPreferences.getInstance();
  }

  void dialogo() async{
    dialogoVisible = true;
    Map<String,dynamic> res = await showDialog(
        context: context,
        builder: (context) => MiDialogo2(
          colorTitulo: conts.Colores.INPUT_DIALOG_TITLE,soloCarga: false,
          onRun: algoFondo,
        )
    );
    if (res["bandera"]) {
      if( res["correcto"] ){
        Navigator.pop(context);
      }
    }else{
      dialogoVisible = false;
    }
  }

  Widget algoFondo(String cad,Function metRes){
    double tamano = SizeConfig.conversionAlto(90, false);
    return FutureBuilder(
        future: getInfo(cad),
        builder: (context, snapshot) {
          Widget vista;

          if( snapshot.connectionState == ConnectionState.waiting){
            return Container(
               height: 200,
              child: Center(
                child: SizedBox(
                  width: tamano,
                  height: tamano,
                  child: CircularProgressIndicator(

                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                    strokeWidth: 12,
                  ),
                ),
              ),
            );
          }

          if( snapshot.hasData){
            bool fallo = snapshot.data["fallo"].toString() == "true";
            int codigo = int.parse(snapshot.data["codigo"].toString());

            if (!fallo) {
              
              String numtxt = snapshot.data["nuevos"];

              if( numtxt != null )
                prefs.setInt("puntos", int.parse(numtxt.toString()));

              vista = metRes(
                  conts.Constantes.T_EXITOSA,
                  snapshot.data["mensaje"].toString(),
                  conts.Constantes.C_EXITOSA
              );
            }else{
              String titulo = "";
              int tipo = 0;
              switch(codigo){
                case 1:
                  titulo = conts.Constantes.T_ERROR;
                  tipo = conts.Constantes.C_ERROR;
                  break;
                case 2:
                  titulo = conts.Constantes.T_ADVERTENCIA;
                  tipo = conts.Constantes.C_ADVERTENCIA;
                  break;
              }
              vista = metRes( titulo,snapshot.data["mensaje"].toString(),tipo);
            }
          }else if( snapshot.hasError){

          }
          return vista;
        },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

