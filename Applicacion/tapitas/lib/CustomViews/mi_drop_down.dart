import 'package:flutter/material.dart';
import 'package:tapitas/Extras/size_config.dart';

class MiDrop extends StatelessWidget {

  final String singleValue,hintValue;
  final List<Object> listValues;
  final Function function;
  final bool expandido;
  final int route;
  final FormFieldState<Object> estado;
  final IconData icono;
  MiDrop({this.singleValue,this.listValues,this.function,
          this.expandido,this.route,this.estado,this.hintValue,this.icono});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: hintValue ?? "no",
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
            hint: Text(singleValue ?? ""),
            items: listValues.map((Object val){
              return DropdownMenuItem<Object>(
                value: val,
                child: Text(val.toString()),
              );
            }).toList(),
            onChanged: (newVal){
              function(newVal,route,estado);
            },
          )
      ),
    );
  }
}
