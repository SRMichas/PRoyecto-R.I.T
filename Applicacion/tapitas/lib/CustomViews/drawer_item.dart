import 'package:flutter/material.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;

class DrawerItem extends StatelessWidget {

  String titulo;
  IconData icono;
  GestureTapCallback onTap;

  DrawerItem({this.titulo,this.icono,this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: conts.Colores.DRAWER_ITEM,
      onTap: onTap ?? () => print("hola"),
      child: ListTile(
        leading: Icon(icono ?? Icons.ac_unit),
        title: Text(titulo ?? ""),
      ),
    );
  }
}