-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 26-04-2020 a las 02:07:29
-- Versión del servidor: 10.4.8-MariaDB
-- Versión de PHP: 7.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `proyectorit`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cadena_ctrl`
--

CREATE TABLE `cadena_ctrl` (
  `id_cadena` int(11) NOT NULL,
  `cadena` varchar(50) NOT NULL,
  `id_maquina` int(11) NOT NULL,
  `tapas_contadas` int(11) NOT NULL,
  `status` bit(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `cadena_ctrl`
--

INSERT INTO `cadena_ctrl` (`id_cadena`, `cadena`, `id_maquina`, `tapas_contadas`, `status`) VALUES
(1, 'aaaaaa', 1, 352, b'1'),
(2, 'adasdasasdasda', 1, 80, b'1'),
(3, 'qwdasdad', 1, 189, b'1'),
(4, '{\"tapas\":\"152\",\"mensaje\":\"holaaaa\"}', 1, 152, b'1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoriapremio`
--

CREATE TABLE `categoriapremio` (
  `id_categoria` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `icono` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `categoriapremio`
--

INSERT INTO `categoriapremio` (`id_categoria`, `nombre`, `icono`) VALUES
(1, 'Netflix', 'http://192.168.1.111/RIT/img/netflix_icon.png'),
(2, 'Google Play', 'http://192.168.1.111/RIT/img/google_play_icon.png'),
(3, 'Tiempo Aire', 'http://192.168.1.111/RIT/img/recarga_icon.png'),
(4, 'Xbox', 'http://192.168.1.111/RIT/img/xbox_icon.png'),
(5, 'Play Station', 'http://192.168.1.111/RIT/img/playstation_icon.webp'),
(6, 'Spotify', 'http://192.168.1.111/RIT/img/spotify_icon.png'),
(7, 'Steam', 'http://192.168.1.111/RIT/img/steam_icon2.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `logo`
--

CREATE TABLE `logo` (
  `id_logo` int(11) NOT NULL,
  `nombreEmp` varchar(50) NOT NULL,
  `urlIcono` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `logo`
--

INSERT INTO `logo` (`id_logo`, `nombreEmp`, `urlIcono`) VALUES
(1, 'netflix', 'http://192.168.1.111/RIT/img/netflix_icon.png'),
(2, 'google play', 'http://192.168.1.111/RIT/img/google_play_icon.png'),
(3, 'telcel', 'http://192.168.1.111/RIT/img/telcel_icon.png'),
(4, 'At&t', 'http://192.168.1.111/RIT/img/at&t_icon.png'),
(5, 'Movistar', 'http://192.168.1.111/RIT/img/movistar_icon.png'),
(6, 'Xbox cash', 'http://192.168.1.111/RIT/img/xbox_cash.png'),
(7, 'Play station cash', 'http://192.168.1.111/RIT/img/playstation_icon.webp'),
(8, 'Spotify', 'http://192.168.1.111/RIT/img/spotify_icon.png'),
(9, 'Steam', 'http://192.168.1.111/RIT/img/steam_icon2.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `maquina`
--

CREATE TABLE `maquina` (
  `id_maquina` int(11) NOT NULL,
  `tapas_contadas` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `maquina`
--

INSERT INTO `maquina` (`id_maquina`, `tapas_contadas`) VALUES
(1, 352);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE `persona` (
  `id_persona` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `apellido` varchar(50) NOT NULL,
  `edad` char(3) NOT NULL,
  `codigo_postal` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`id_persona`, `nombre`, `apellido`, `edad`, `codigo_postal`) VALUES
(1, 'Elias', 'Soria', '0', '00000'),
(2, 'alberto', 'loera', '0', '000000');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `premio`
--

CREATE TABLE `premio` (
  `id_premio` int(11) NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_logo` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(50) NOT NULL,
  `costo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `premio`
--

INSERT INTO `premio` (`id_premio`, `id_categoria`, `id_logo`, `nombre`, `descripcion`, `costo`) VALUES
(1, 1, 1, 'Tarjeta de $150', 'Tarjeta Prepagada de 150', 1500),
(2, 1, 1, 'Tarjeta de $300', 'Tarjeta Prepagada de 300', 3000),
(3, 1, 1, 'Tarjeta de $500', 'Tarjeta Prepagada de 500', 5000),
(4, 1, 1, 'Tarjeta de $1000', 'Tarjeta Prepagada de 1000', 9000),
(5, 2, 2, 'Tarjeta de $100', 'Tarjeta Prepagada de 100', 15490),
(6, 2, 2, 'Tarjeta de $200', 'Tarjeta Prepagada de 200', 14890),
(7, 2, 2, 'Tarjeta de $300', 'Tarjeta Prepagada de 300', 10680),
(8, 3, 3, 'Telcel', 'Saldo de $10', 1030),
(9, 3, 4, 'AT&T', 'Saldo de $10', 1030),
(10, 3, 5, 'Movistar', 'Saldo de $10', 1030),
(11, 4, 6, 'Xbox $150', 'Tarjeta Pregada de 150', 1549),
(12, 4, 6, 'Xbox $300', 'Tarjeta Pregada de 300', 17940),
(13, 4, 6, 'Xbox $600', 'Tarjeta Pregada de 600', 18019),
(14, 5, 7, 'Tarjeta de $10', 'Tarjeta Prepagada de 10', 155470),
(15, 5, 7, 'Tarjeta de $20', 'Tarjeta Prepagada de 20', 479810),
(16, 5, 7, 'Tarjeta de $30', 'Tarjeta Prepagada de 30', 134690),
(17, 6, 8, 'Tarjeta de $100', 'Tarjeta Prepagada de 100', 15490),
(18, 6, 8, 'Tarjeta de $200', 'Tarjeta Prepagada de 200', 148960),
(19, 6, 8, 'Tarjeta de $300', 'Tarjeta Prepagada de 300', 21780),
(20, 7, 9, 'Tarjeta de $100', 'Tarjeta Prepagada de 100', 87460),
(21, 7, 9, 'Tarjeta de $200', 'Tarjeta Prepagada de 200', 74230),
(22, 7, 9, 'Tarjeta de $300', 'Tarjeta Prepagada de 300', 78150),
(23, 7, 9, 'Tarjeta de $400', 'Tarjeta Prepagada de 400', 75330);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `id_persona` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `pass` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `id_persona`, `email`, `pass`) VALUES
(1, 1, 'a@', '1234'),
(2, 2, 'ee@', '123');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuariodetalle`
--

CREATE TABLE `usuariodetalle` (
  `id_usuario` int(11) NOT NULL,
  `id_cadena` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `id_maquina` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuariodetalle`
--

INSERT INTO `usuariodetalle` (`id_usuario`, `id_cadena`, `fecha`, `id_maquina`) VALUES
(1, 1, '2020-04-12', 1),
(1, 2, '2020-04-01', 1),
(1, 3, '2020-03-18', 1),
(1, 4, '2020-04-16', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cadena_ctrl`
--
ALTER TABLE `cadena_ctrl`
  ADD PRIMARY KEY (`id_cadena`),
  ADD KEY `FK_cadena_maquina` (`id_maquina`);

--
-- Indices de la tabla `categoriapremio`
--
ALTER TABLE `categoriapremio`
  ADD PRIMARY KEY (`id_categoria`);

--
-- Indices de la tabla `logo`
--
ALTER TABLE `logo`
  ADD PRIMARY KEY (`id_logo`);

--
-- Indices de la tabla `maquina`
--
ALTER TABLE `maquina`
  ADD PRIMARY KEY (`id_maquina`);

--
-- Indices de la tabla `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`id_persona`);

--
-- Indices de la tabla `premio`
--
ALTER TABLE `premio`
  ADD PRIMARY KEY (`id_premio`),
  ADD KEY `FK_premio_categoria` (`id_categoria`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD KEY `FK_usuarios_persona` (`id_persona`);

--
-- Indices de la tabla `usuariodetalle`
--
ALTER TABLE `usuariodetalle`
  ADD PRIMARY KEY (`id_usuario`,`id_cadena`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cadena_ctrl`
--
ALTER TABLE `cadena_ctrl`
  MODIFY `id_cadena` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `persona`
--
ALTER TABLE `persona`
  MODIFY `id_persona` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cadena_ctrl`
--
ALTER TABLE `cadena_ctrl`
  ADD CONSTRAINT `FK_cadena_maquina` FOREIGN KEY (`id_maquina`) REFERENCES `maquina` (`id_maquina`);

--
-- Filtros para la tabla `premio`
--
ALTER TABLE `premio`
  ADD CONSTRAINT `FK_premio_categoria` FOREIGN KEY (`id_categoria`) REFERENCES `categoriapremio` (`id_categoria`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `FK_usuarios_persona` FOREIGN KEY (`id_persona`) REFERENCES `persona` (`id_persona`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
