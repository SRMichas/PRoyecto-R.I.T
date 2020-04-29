<?php
$hostname ="localhost";
$database ="proyectorit";
$username ="root";
$password ="";

$json = array();

class Respuesta{
    public $categorias;
    public $mensaje;
    public $fallo;
}

$res = new Respuesta();

    $conexion = mysqli_connect($hostname,$username,$password,$database);
    if($conexion -> connect_error)
    {
        die("Coneccion fallida" .$conexion->connect_error);
    }
    
    $consulta = "SELECT * FROM categoriapremio";

    $resultado = mysqli_query($conexion,$consulta);

    if( $resultado ){
        $bandera = false;
        while($us = mysqli_fetch_array($resultado) ){
            $res -> categorias[] = $us;
            $res -> fallo = false;
            $bandera = true;
        }
        if( $bandera )
            $res -> mensaje = "Se pudo traer las categogiras";
        else{
            $res -> mensaje = "No se pudo traer las categorias";
            $res -> fallo = true;
        }
    }else{
        $res -> mensaje = "El usuario NO existe";
        $res -> fallo = true;
    }

    mysqli_close($conexion);
    echo json_encode($res);

?>