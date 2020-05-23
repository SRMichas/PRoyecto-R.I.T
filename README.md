# Proyecto-R.I.T
Repositorio de los archivos necesarios para el proyecto
 - Aplicación desarrollada en Flutter.
 - [Página con Laravel](#pagina).
 - Base de datos con MySQL.
 - [Máquina con arduino](#maquina).

# Pendientes:
- Máquina.
	- Establecer la comunicación por serial entre el ESP8266 y el Arduino.
	- Programar la lectura de datos del CNY70 (Posiblemente por medio de interrupciones).
	- Mejorar la forma en que se reciben las respuestas del servidor.
	- Implementar una pantalla (LCD deibido a la contingencia).
	- Limpiar el código.
- Aplicación.
	- [x] Hacer pruebas en iOS.<br>
		_Se eliminaron las dependencias de Flutter que permitían probar en iOS sin una mac, ahora depende de XCode y por lo tanto se necesita una mac_.
	- Meter cadena manual
	- Hacer un logo
- <a name ="pagina"></a>Página web.
	- Optimizar diseño. **Emmanuel**
	- Esconder al Vale para que no lo balaceen. **Loera**
	- Botón oculto de memes. **Loera**
	- Mensaje de confirmación en página de inicio.
- Tarea para todos.
	- Seleccionar los memes que más te gusten y mandárselos a Loera.
	- Trabajar en el vídeo.
---
 ### <a name = "maquina"></a>Máquina.
 La máquina utiliza el sensor óptico CNY70 para la detección de las tapas por colores y el microcontrolador ESP8266 para la conexión a internet. El ESP8266 realiza las peticiones al servidor.
