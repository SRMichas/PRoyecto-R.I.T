import 'package:flutter/material.dart';
import 'package:tapitas/compras/activos.dart';
import 'package:tapitas/compras/gastos.dart';

class Compras extends StatefulWidget {
  @override
  _ComprasState createState() => _ComprasState();
}

class _ComprasState extends State<Compras> {

  int _indice = 0;
  Widget _vista;

  @override
  void initState() {
    _vista = Activo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _vista,
      bottomNavigationBar: BottomNavigationBar(
          onTap: pestana,
          currentIndex: _indice,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.whatshot),
              title: Text("Activos")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.access_time),
                title: Text("Gastados")
            )
          ],
      ),
    );
  }

  void pestana(int idx){
    setState(() {
      _indice = idx;
      if( idx == 0)
        _vista = Activo();
      else
        _vista = Gasto();
    });
  }
}
