#include <ArduinoJson.h>
#include <ESP8266WiFi.h>

//const char* ssid = "UbeeD3C5";
const char* ssid = "Rinoceronte";
//const char* password = "RandomAccesTaco28";
const char* password = "Burrito35";

const char* host = "192.168.43.217";



void setup() {
  Serial.begin(9600);
  delay(5000);
  Serial.println("Conectado a ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while(WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }

  Serial.println("Conectado");
  Serial.println("IP: ");
  Serial.println("" + WiFi.localIP());

}
int value = 0; //quien sabe que hace la variable esta
void loop() {
  
  delay(2000);
  ++value;

  Serial.println("Conectado a: ");
  Serial.println(host);
  
  WiFiClient client;
  const int puerto = 80;

  if(!client.connect(host, puerto))
  {
    Serial.println("Conexión fallida");
    return;
  }

  String url = "http://192.168.43.217/script.php";
  String datos = "maquina=7&tapas=19";

  Serial.println("Realizando petición...");

  client.print(String("POST ") + url + " HTTP/1.0\r\n" + 
               "Host: " + host + "\r\n" +
               "Accept: *" + "/" + "*\r\n" +
               "Content-Length: " + datos.length() + "\r\n" +
               "Content-Type: multipart/form-data\r\n" + 
               "\r\n" + datos);
               
  delay(10);
  
  Serial.println("Respuesta: ");

  String linea = client.readString();
  
  //String linea = client.readStringUntil('\r');
  //Serial.write(linea);      
  Serial.println(linea);
}
