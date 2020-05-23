#include <LiquidCrystal.h>

LiquidCrystal lcd(7, 8, 9, 10, 11, 12);
int resultadoSensor = 0;
int boton = 2;
int conteo;
String cadena;
/*
   - Ingresar tapas
   - Conteo de tapas
   - Envío de conteo a ESP8266
   - Espera de respuesta del ESP8266
   - Mostrar respuesta de ESP8266
*/
void setup() {
  lcd.begin(16, 2);
  mostrarMensaje(0);
  pinMode(2, INPUT);
  Serial.begin(115200);
}

void loop() {
  if (botonPresionado()) {
    conteoTapas();
  } else {
    //Por algún motivo Arduino necesita este else aquí para no volverse loco.
  }
}

boolean botonPresionado() {
  return digitalRead(boton) == LOW;
}

void conteoTapas() {
  int lecturaSensor;
  conteo = 0;
  Serial.println("Se presionó el botón");
  delay(100);
  while (!botonPresionado()) {
    lecturaSensor = analogRead(A0);
    if (lecturaSensor > 500) {
      conteo++;
    }
    if (conteo == 0) {
      mostrarMensaje(1);
    } else {
      mostrarMensaje(2);
    }
    delay(300);
  }
  if (conteo > 0) {
    comunicarResultado();
  }
  mostrarMensaje(0);
}

void mostrarMensaje(int mensaje) {
  lcd.clear();
  lcd.setCursor(0, 0);
  switch (mensaje) {
    case 0:
      lcd.print("Presione el");
      lcd.setCursor(0, 1);
      lcd.print("boton.");
      break;
    case 1:
      lcd.print("Ingrese las");
      lcd.setCursor(0, 1);
      lcd.print("tapas.");
      break;
    case 2:
      lcd.print("Tapas ingresadas");
      lcd.setCursor(0, 1);
      lcd.print(conteo);
      break;
    case 3:
      lcd.print("Esperando");
      lcd.setCursor(0, 1);
      lcd.print("respuesta");
      break;
    case 4:
      lcd.print("Codigo:");
      lcd.setCursor(0, 1);
      lcd.print(cadena);
      break;
  }
}

void comunicarResultado() { //Aquí va la comunicación con el ESP8266.
  mostrarMensaje(3);
  cadena = "";
  Serial.println("\"Maquina\": 1,\n\"Conteo\": " + conteo);
  while (cadena == "")
    cadena = Serial.readString();
  Serial.println("Cadena recibida: " + cadena);
  mostrarMensaje(4);
  delay(10000);
}
