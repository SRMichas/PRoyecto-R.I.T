import 'package:flutter/material.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;

class DrawerItem extends StatelessWidget {

  final String titulo;
  final IconData icono;
  final Function(int) onTap;
  final int id,currentIndex;

  DrawerItem({@required this.id,@required this.currentIndex,this.titulo,this.icono,this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: conts.Colores.DRAWER_ITEM,
      onTap: (){
        if( onTap != null ){
          onTap(id);
        }/*else if( onTap2 != null){

        }*/else{
          print("hola");
        }

      },
      child: ListTile(
        leading: Icon(icono ?? Icons.ac_unit),
        title: Text(titulo ?? ""),
        selected: id == currentIndex ? true : false,
      ),
    );
  }
}
