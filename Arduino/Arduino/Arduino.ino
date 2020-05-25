#include <LiquidCrystal.h>

LiquidCrystal lcd(7, 8, 9, 10, 11, 12);
int resultadoSensor = 0;
int boton = 2;
int conteo;
String cadena;

void setup() {
	lcd.begin(16, 2);
	mostrarMensaje(0);
	pinMode(2, INPUT);
	Serial.begin(9600);
}

void loop() {
	if (botonPresionado()) {
		conteoTapas();
	} else {
		// Por algún motivo Arduino necesita este else aquí para no volverse
		// loco.
	}
}

boolean botonPresionado() { return digitalRead(boton) == LOW; }

void conteoTapas() {
	int lecturaSensor;
	conteo = 0;
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
		delay(350);
	}
	if (conteo > 0) {
		comunicarResultado();
	}
	mostrarMensaje(0);
}

void mostrarMensaje(int mensaje) {
	switch (mensaje) {
		case 0:
			escribirLCD("Presione el", "boton.");
			break;
		case 1:
			escribirLCD("Ingrese las", "tapas.");
			break;
		case 2:
			escribirLCD("Tapas ingresadas:", "" + conteo);
			break;
		case 3:
			escribirLCD("Esperando", "respuesta");
			break;
		case 4:
			escribirLCD("Codigo:", cadena);
			break;
	}
}

void comunicarResultado() {  // Aquí va la comunicación con el ESP8266.
	mostrarMensaje(3);
	cadena = "";
	Serial.print(conteo);
	while (cadena.equals("")) {
		cadena = Serial.readString();
	}
	mostrarMensaje(4);
	delay(10000);
}

void escribirLCD(String linea1, String linea2) {
	lcd.clear();
	lcd.setCursor(0, 0);
	lcd.print(linea1);
	lcd.setCursor(0, 1);
	lcd.print(linea2);
}
