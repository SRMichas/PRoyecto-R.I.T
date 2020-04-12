import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';

class LectorQR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
        ),
        Expanded(
            flex: 1,
            child: Center(
              child: Text("Resultado: $qrtext"),
            ))
      ],
    );
  }

  void _onQr(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrtext = scanData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  /*Center(
      child: Icon(
        Icons.camera_alt,
        size: 250,
        color: Colors.blueAccent,
      ),
    )
  */
}
