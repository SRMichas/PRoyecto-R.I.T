import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static double _screenWidth;
  static double _screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double textMultiplier;
  static double imageSizeMultiplier;
  static double heightMultiplier;
  static double widthMultiplier;
  static double DPI;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;

    print(_screenWidth);
  }

  void iniciar(BoxConstraints constraints,MediaQueryData query){
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;

    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;

    if( query != null) {
      DPI = query.devicePixelRatio * 160.0;
      //print("DPI ==========> ${query.devicePixelRatio * 160.0}");
    }
    /*print("Ancho -> ${_screenWidth}");
    print("Ancho -> ${_screenHeight}");

    print("Bloc Ancho -> ${_blockWidth}");
    print("Bloc Alto -> ${_blockHeight}");*/
  }

  static double ancho(){
    return _screenWidth;
  }
  static double alto(){
    return _screenHeight;
  }

  static conversionAncho(double tamano, bool entero){
    double res = ( tamano * widthMultiplier) / widthMultiplier;
    if( entero)
      return res.toInt();
    else
        return res;
  }

  static conversionAlto(double tamano, bool entero){
    double res = ( tamano * heightMultiplier) / heightMultiplier;
    if( entero )
      return res.toInt();
    else
      return res;
  }
}