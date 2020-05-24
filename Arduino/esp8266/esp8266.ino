#include <ESP8266HTTPClient.h>
#include <ESP8266WiFi.h>
#include <ArduinoJson.h>

const char* ssid = "UbeeD3C5";
const char* password = "RandomAccesTaco28";
const int maquina = 1;
String codigo;
String conteo;

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
  }

  if (Serial.available()) {
    Serial.println("Conectando...");
  }
}

void loop() {
  esperarArduino();
}

void esperarArduino() {
  conteo = "";
  while (conteo == "") {
    conteo = Serial.readString();
    conexion();
  }
  Serial.print(codigo);
}

void conexion() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin("http://f790a17f.ngrok.io/api/cadena");
    int httpCode = http.POST("conteo=" + conteo + "&maquina=" + maquina);
    if (httpCode > 0) {
      String recepcion = http.getString();
      char json[recepcion.length() + 1];
      recepcion.toCharArray(json, recepcion.length());
      parserJson(json);
    } else {
      codigo = "error";
    }
    http.end();
  }
  delay(60000);
}

void parserJson(char* json) {
  DynamicJsonDocument documento(1024);
  deserializeJson(documento, json);
  String auxiliar = documento["Codigo"];
  codigo = auxiliar;
}
