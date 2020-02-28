
<?php

	$mensaje;
	$maquina = $_POST['maquina'];
	$tapitas = $_POST['tapas'];
	$semilla = "$maquina$tapitas";
	$codigo;
	
	class Respuesta
	{
		public $mensaje;
		public $codigo;

	}
	$res = new Respuesta();

	$conexion = new mysqli("localhost", "root", "", "tapitas");
	if($conexion -> connect_error)
	{
		die("Coneccion fallida" .$conexion->connect_error);
	}

	$codigo = hash("md5", $semilla, false);
	
	$query = "insert into pruebas(maquina, codigo, tapas) values($maquina, '$codigo', $tapitas)";
	
	if($conexion->query($query) === TRUE)
	{
		$res -> mensaje = 'Que bien que bien que todo está bien';
		$res -> codigo = $codigo; 
	}
	else
	{
		$res -> mensaje = "Error ".$query;
	}
	$conexion -> close();
	echo json_encode($res);
?>