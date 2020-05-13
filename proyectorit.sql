SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

CREATE DATABASE IF NOT EXISTS proyectorit DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE proyectorit;

DELIMITER $$
DROP PROCEDURE IF EXISTS `sp_compra`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_compra` (IN `id` INT, IN `premio` INT, IN `actuales` INT, IN `gastados` INT)  NO SQL
BEGIN
DECLARE gastadosA INT;
DECLARE servicioB INT;
SELECT puntos_gastados INTO gastadosA FROM usuario WHERE id_usuario = id;

INSERT INTO servicio VALUES (NULL,premio,1);

SELECT max(id_servicio) INTO servicioB FROM servicio;

INSERT INTO usuarioservicio VALUES (id,servicioB,CURRENT_DATE,1);

SET gastadosA = gastadosA + gastados;

UPDATE usuario SET puntos_actuales = actuales, puntos_gastados= gastadosA WHERE id_usuario = id;

SELECT puntos_actuales FROM usuario WHERE id_usuario = id;

END$$

DROP PROCEDURE IF EXISTS `sp_creaUsuario`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_creaUsuario` (IN `nombre` VARCHAR(50), IN `apellido` VARCHAR(100), IN `edad` INT(2), IN `codPos` INT, IN `correo` VARCHAR(100), IN `contr` VARCHAR(100))  NO SQL
BEGIN

DECLARE ultPersona INT;
DECLARE ultUsuario INT;

INSERT INTO persona VALUES (null,nombre,apellido,edad,codPos);

SELECT max(id_persona) INTO ultPersona FROM persona;

INSERT INTO usuario VALUES (null,ultPersona,correo,contr,0,0);

SELECT u.id_usuario,p.nombre,p.apellido,p.edad,
u.email,u.pass,u.puntos_actuales 
FROM usuario u 
INNER JOIN persona p ON u.id_persona = p.id_persona
WHERE p.id_persona = ultPersona;

END$$

DROP PROCEDURE IF EXISTS `sp_infoPremios`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_infoPremios` (IN `id` INT)  BEGIN
  DECLARE cate INTEGER;
    
    SELECT 1 as Bandera,puntos_actuales FROM usuario WHERE id_usuario = id;
    
    SELECT 2 as Bandera,cp.* FROM categoriapremio cp;
    
    SELECT 3 as Bandera,p.id_premio,p.id_categoria,
    l.urlIcono,p.nombre,p.descripcion,p.costo
    FROM premio p
    INNER JOIN logo l ON p.id_logo = l.id_logo;
END$$

DROP PROCEDURE IF EXISTS `sp_manejo_cadena`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_manejo_cadena` (IN `id` INT, IN `cadenaB` VARCHAR(100))  NO SQL
BEGIN
   DECLARE id_cad INT;
   DECLARE conteo INT;
   DECLARE cadenaR VARCHAR(100);

   SELECT 
      cc.id_cadena ,
      cc.cadena,
      cc.tapas_contadas INTO conteo
   FROM usuariodetalle ud
   INNER JOIN cadena_ctrl cc ON ud.id_cadena = cc.id_cadena 
   WHERE ud.id_usuario = id AND cc.cadena = cadenaB
   AND cc.status = 0;

  /* SELECT puntos_actuales INTO @actuales 
   FROM usuario WHERE id_usuario = id;


   UPDATE cadena_ctrl set status = 1 WHERE id_cadena = id_cad;

   UPDATE usuario SET puntos_actuales = (conteo + @actuales) WHERE id_usuario = id;*/

END$$

DELIMITER ;

DROP TABLE IF EXISTS cadena_ctrl;
CREATE TABLE IF NOT EXISTS cadena_ctrl (
  id_cadena int(11) NOT NULL AUTO_INCREMENT,
  cadena varchar(150) NOT NULL,
  id_maquina int(11) NOT NULL,
  tapas_contadas int(11) NOT NULL,
  status bit(1) NOT NULL,
  PRIMARY KEY (id_cadena),
  KEY FK_cadena_maquina (id_maquina)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS categoriapremio;
CREATE TABLE IF NOT EXISTS categoriapremio (
  id_categoria int(11) NOT NULL,
  nombre varchar(30) NOT NULL,
  icono varchar(255) NOT NULL,
  PRIMARY KEY (id_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS ciudad;
CREATE TABLE IF NOT EXISTS ciudad (
  id_ciudad int(11) NOT NULL AUTO_INCREMENT,
  nombre varchar(50) NOT NULL,
  id_estado int(11) NOT NULL,
  activo bit(1) NOT NULL,
  PRIMARY KEY (id_ciudad)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS estado;
CREATE TABLE IF NOT EXISTS estado (
  id_estado int(11) NOT NULL AUTO_INCREMENT,
  nombre varchar(50) NOT NULL,
  activo bit(1) NOT NULL,
  PRIMARY KEY (id_estado)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS logo;
CREATE TABLE IF NOT EXISTS logo (
  id_logo int(11) NOT NULL,
  nombreEmp varchar(50) NOT NULL,
  urlIcono varchar(255) NOT NULL,
  PRIMARY KEY (id_logo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS maquina;
CREATE TABLE IF NOT EXISTS maquina (
  id_maquina int(11) NOT NULL,
  tapas_contadas int(11) NOT NULL,
  PRIMARY KEY (id_maquina)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS persona;
CREATE TABLE IF NOT EXISTS persona (
  id_persona int(11) NOT NULL AUTO_INCREMENT,
  nombre varchar(50) NOT NULL,
  apellido varchar(50) NOT NULL,
  edad char(3) NOT NULL,
  codigo_postal varchar(10) NOT NULL,
  PRIMARY KEY (id_persona)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS premio;
CREATE TABLE IF NOT EXISTS premio (
  id_premio int(11) NOT NULL,
  id_categoria int(11) NOT NULL,
  id_logo int(11) NOT NULL,
  nombre varchar(50) NOT NULL,
  descripcion varchar(50) NOT NULL,
  costo int(11) NOT NULL,
  PRIMARY KEY (id_premio),
  KEY FK_premio_categoria (id_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS servicio;
CREATE TABLE IF NOT EXISTS servicio (
  id_servicio int(11) NOT NULL AUTO_INCREMENT,
  id_premio int(11) NOT NULL,
  activo bit(1) NOT NULL,
  PRIMARY KEY (id_servicio)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS usuario;
CREATE TABLE IF NOT EXISTS usuario (
  id_usuario int(11) NOT NULL AUTO_INCREMENT,
  id_persona int(11) NOT NULL,
  email varchar(50) NOT NULL,
  pass varchar(50) NOT NULL,
  puntos_actuales int(11) NOT NULL,
  puntos_gastados int(11) NOT NULL,
  PRIMARY KEY (id_usuario),
  KEY FK_usuarios_persona (id_persona)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS usuariodetalle;
CREATE TABLE IF NOT EXISTS usuariodetalle (
  id_usuario int(11) NOT NULL,
  id_cadena int(11) NOT NULL,
  fecha date NOT NULL,
  id_maquina int(11) NOT NULL,
  PRIMARY KEY (id_usuario,id_cadena),
  KEY FK_detalle_cadena (id_cadena)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DROP TABLE IF EXISTS usuarioservicio;
CREATE TABLE IF NOT EXISTS usuarioservicio (
  id_usuario int(11) NOT NULL,
  id_servicio int(11) NOT NULL,
  fecha date NOT NULL,
  activo bit(1) NOT NULL,
  PRIMARY KEY (id_usuario,id_servicio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


ALTER TABLE cadena_ctrl
  ADD CONSTRAINT FK_cadena_maquina FOREIGN KEY (id_maquina) REFERENCES maquina (id_maquina);

ALTER TABLE premio
  ADD CONSTRAINT FK_premio_categoria FOREIGN KEY (id_categoria) REFERENCES categoriapremio (id_categoria);

ALTER TABLE usuario
  ADD CONSTRAINT FK_usuarios_persona FOREIGN KEY (id_persona) REFERENCES persona (id_persona);

ALTER TABLE usuariodetalle
  ADD CONSTRAINT FK_detalle_cadena FOREIGN KEY (id_cadena) REFERENCES cadena_ctrl (id_cadena),
  ADD CONSTRAINT FK_detalle_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario);
COMMIT;
