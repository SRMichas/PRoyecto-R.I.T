<?php
$hostname ="localhost";
$database ="proyectorit";
$username ="root";
$password ="";

$json = array();

class Respuesta{
    public $usuario;
    public $mensaje;
}

$res = new Respuesta();
if( isset($_GET["correo"]) && isset($_GET["contra"]) ){

    $correo = $_GET["correo"];
    $contra = $_GET["contra"];

    $conexion = mysqli_connect($hostname,$username,$password,$database);
    if($conexion -> connect_error)
	{
		die("Coneccion fallida" .$conexion->connect_error);
    }
    
    $consulta = "SELECT * FROM usuario
                WHERE 
                email = '{$correo}' and
                pass = '{$contra}'";

    $resultado = mysqli_query($conexion,$consulta);

    if( $resultado ){
        $us = mysqli_fetch_row($resultado);
        $res -> usuario = $us;
        $res -> mensaje = "El usuario existe";
    }else{
        $res -> mensaje = "El usuario NO existe";
    }

    mysqli_close($conexion);
	echo json_encode($res);

}

?>