#include <ESP8266HTTPClient.h>
#include <ESP8266WiFi.h>

const char* ssid = "UbeeD3C5";
const char* password = "RandomAccesTaco28";

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Conectando...");
  }
}

void loop() {
  esperarArduino();
}

void esperarArduino() {
  String mensaje = "";
  while (mensaje == "") {
    mensaje = Serial.readString();
  }
  Serial.write("Mensaje recibido");
}

void conexion() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin("http://5c9c6c2e.ngrok.io/api/cadena");
    int httpCode = http.POST("");

    if (httpCode > 0) {
      Serial.print("código de respuesta: " + httpCode);
      Serial.print("Cuerpo de la respuesta: " + http.getString());
    } else {
      Serial.print("No conectó");
    }
    http.end();
  }
  delay(60000);
}
