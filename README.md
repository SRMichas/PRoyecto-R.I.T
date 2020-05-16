# Proyecto-R.I.T
Repositorio de los archivos necesarios para el proyecto
 - Aplicación desarrollada en Flutter.
 - Página con Laravel.
 - Base de datos con MySQL.
 - [Máquina con arduino](#maquina).

# Pendientes:
- Terminar la máquina.
	- Establecer la comunicación por serial entre el ESP8266 y el Arduino.
	- Programar la lectura de datos del CNY70 (Posiblemente por medio de interrupciones).
	- Mejorar la forma en que se reciben las respuestas del servidor.
	- Implementar una pantalla (LCD deibido a la contingencia).
	- Limpiar el código.
- Terminar la app.
	- [x] Hacer pruebas en iOS.<br>
		_Se eliminaron las dependencias de Flutter que permitían probar en iOS sin una mac, ahora depende de XCode y por lo tanto se necesita una mac_.
	* Hacer un logo
- Comenzar la página web.
	- Hacer un diseño decente.
	- Hacer todo básicamente. 
---
 ### <a name = "maquina"></a>Máquina.
 La máquina utiliza el sensor óptico CNY70 para la detección de las tapas por colores y el microcontrolador ESP8266 para la conexión a internet. El ESP8266 realiza las peticiones al servidor.
