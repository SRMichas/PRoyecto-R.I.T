import 'package:flutter/material.dart';
import 'package:tapitas/Extras/size_config.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;

class MiDrop extends StatelessWidget {

  final String hintValue,labelValue;
  final List<Object> listValues;
  final Function function;
  final bool expandido;
  final int route,widgetRoute;
  final FormFieldState<Object> estado;
  final IconData icono;

  MiDrop({this.hintValue,this.listValues,this.function,
          this.expandido,this.route,this.estado,this.labelValue,this.icono,this.widgetRoute});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelValue ?? "",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(SizeConfig.conversionAlto(36, false)))
        ),
        isDense: true,
        alignLabelWithHint: true,
        errorText: estado != null ? estado.hasError ? estado.errorText : null : null,
      ),
      child: DropdownButtonHideUnderline(
          child: DropdownButton<Object>(
            icon: Icon(icono ?? Icons.color_lens),
            isExpanded: expandido ?? false,
            isDense: true,
            hint: Text(hintValue ?? "Holder"),
            items: listValues != null ?listValues.map((Object val){
              return DropdownMenuItem<Object>(
                value: val,
                child: Text(val.toString()),
              );
            }).toList() : null,
            onChanged: (newVal){
              //print(newVal);
              switch(widgetRoute){
                case conts.Constantes.REGISTRO_ROUTE:
                  function(newVal,route,estado);
                  break;
                case conts.Constantes.MAQUINA_ROUTE:
                  function(newVal);
                  break;
                default:
                  print("no hay funcion asociada");
                  break;
              }
              /*if( function != null ){
                function(newVal,route,estado);
              }else{
                print("no hay funcion asociada");
              }*/
            },
          )
      ),
    );
  }
}
