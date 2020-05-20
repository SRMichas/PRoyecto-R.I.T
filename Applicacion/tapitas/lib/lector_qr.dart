import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/constantes.dart';
import 'package:tapitas/CustomViews/mi_dialogo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LectorQR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Escaner"),
      ),
      body: new Pagina(),
    );
  }
}

class Pagina extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Cuerpo();
}

class _Cuerpo extends State<Pagina> {
  GlobalKey qrKey = GlobalKey();
  var qrtext = "";
  QRViewController controller;
  bool bandera = false,dialogoVisible = false;

  TextStyle estilo = TextStyle(
    fontSize: ( 15 * SizeConfig.heightMultiplier) / SizeConfig.heightMultiplier,
    fontWeight: FontWeight.bold
  );

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                  borderRadius: 10,
                  borderColor: Colors.red,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300),
              onQRViewCreated: _onQr),
        )
      ],
    );
  }

  Future<Map<String,dynamic>> getInfo(String json) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = int.parse(prefs.getString("id"));
    var url = 'http://${Constantes.HOST}';
    url += "${Constantes.RT_UDT}U-Cadena.php?usId=$id&cadena=$json";

    http.Response response = await http.get(url);
    var data = jsonDecode(response.body);

    return data;
  }

  void _onQr(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {

          if( !dialogoVisible ){
            qrtext = scanData;
            try{
              var data = jsonDecode(qrtext);
              _checkDialog(data.toString());
            }catch(e){
              _showDialog("El formato proporcionado es incorrecto",Constantes.C_ERROR);
            }
          }
      });
    });
  }

  void _checkDialog(json) async{
    dialogoVisible = true;
    var res = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return FutureBuilder(
              future: getInfo(json),
              builder: (context,snapshot){
                Widget vista;
                if( snapshot.hasData){
                  bool fallo = snapshot.data["fallo"].toString() == "true";
                  int codigoError = int.parse(snapshot.data["codigo"].toString()),
                      codigoTitulo;
                  String titulo;

                  if( !fallo ){
                    titulo = "Felicidades";
                    codigoTitulo = Constantes.C_EXITOSA;
                  }else switch(codigoError){
                    case 1:
                      titulo = Constantes.T_ERROR;
                      codigoTitulo = Constantes.C_ERROR;
                      break;
                    case 2:
                      titulo = Constantes.T_ADVERTENCIA;
                      codigoTitulo = Constantes.C_ADVERTENCIA;
                      break;
                    case 3:
                      titulo = Constantes.T_ERROR;
                      codigoTitulo = Constantes.C_ERROR;
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

    if( res )
      Navigator.of(context).pop();
    else
      dialogoVisible = false;
  }
  
  void _showDialog(cuerpo,tipo) async{
    dialogoVisible = true;
    Map<String,dynamic> res = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => MiDialogo(titulo: Constantes.T_ERROR, descripcion: cuerpo, tipoTitulo:tipo,soloCarga: false,)
    );

    if( res["bandera"] )
      Navigator.of(context).pop();
    else
      dialogoVisible = false;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

