import 'package:flutter/material.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;

class DrawerItem extends StatelessWidget {

  final String titulo;
  final IconData icono;
  final GestureTapCallback onTap;
  final bool seleccionado;

  DrawerItem({this.titulo,this.icono,this.seleccionado,this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: conts.Colores.DRAWER_ITEM,
      onTap: onTap ?? () => print("hola"),
      child: ListTile(
        leading: Icon(icono ?? Icons.ac_unit),
        title: Text(titulo ?? ""),
        selected: seleccionado ?? false,
      ),
    );
  }
}
