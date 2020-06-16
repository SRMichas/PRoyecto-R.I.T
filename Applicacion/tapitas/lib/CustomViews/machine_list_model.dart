import 'package:flutter/material.dart';
import 'package:tapitas/Entidades/maquina.dart';
import 'package:tapitas/Entidades/ciudad.dart';
import 'package:tapitas/Extras/constantes.dart' as conts;
import 'package:tapitas/Extras/size_config.dart';

class MachineModel extends StatefulWidget {

  final Ciudad city;
  final List<Maquina> machines;
  final String testvalue;

  MachineModel({this.city,this.machines,this.testvalue});

  @override
  _MachineModelState createState() => _MachineModelState();
}

class _MachineModelState extends State<MachineModel> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: compress(),
    );
  }

  Widget compress(){
    Ciudad city = widget.city;
    double size = SizeConfig.conversionAlto(50, false);
    return Container(
      child: Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.conversionAncho(15, false),
            vertical: SizeConfig.conversionAlto(5, false)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.conversionAncho(12, false),
              vertical: SizeConfig.conversionAlto(8, false),
          ),
          child: Row(
            children: <Widget>[
              Container(
                //color: Colors.yellow,
                height: size,
                width: size,
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: SizeConfig.conversionAncho(5, false)),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue
                ),
                child: Text(
                  city != null? city.nombre[0] : widget.testvalue ?? "A",style: conts.Estilo.CITY_CAPITAL_LETTER,),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  color: Colors.red,
                  child: Text(city != null? city.nombre : widget.testvalue ?? "Nombre ciudad",style: conts.Estilo.CITY_NAME,),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  //color: Colors.green,
                  alignment: Alignment.center,
                  child:InkWell(
                    splashColor: Colors.green,
                    child: Center(
                      child: Icon(Icons.add,size: SizeConfig.conversionAlto(35, false),),
                    ),
                    onTap: () => print("hols"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
