<?php
$hostname ="localhost";
$database ="proyectorit";
$username ="root";
$password ="";

$json = array();

class Respuesta{
    public $premios;
    public $mensaje;
    public $fallo;
}

$res = new Respuesta();
if( isset($_GET["categoria"])){

    $categoria = $_GET["categoria"];

    $conexion = mysqli_connect($hostname,$username,$password,$database);
    if($conexion -> connect_error)
    {
        die("Coneccion fallida" .$conexion->connect_error);
    }
    
    $consulta = "SELECT 
                p.id_premio,p.nombre,p.descripcion,p.costo,
                l.urlIcono 
                FROM premio p 
                INNER JOIN  logo l ON p.id_logo = l.id_logo 
                WHERE p.id_categoria = '{$categoria}'";

    $resultado = mysqli_query($conexion,$consulta);

    if( $resultado ){
        $bandera = false;
        while($us = mysqli_fetch_array($resultado) ){
            $res -> premios[] = $us;
            $res -> fallo = false;
            $bandera = true;
        }
        if( $bandera )
            $res -> mensaje = "Se pudo traer los premios";
        else{
            $res -> mensaje = "No se pudo traer los premios";
            $res -> fallo = true;
        }
    }else{
        $res -> mensaje = "El usuario NO existe";
        $res -> fallo = true;
    }

    mysqli_close($conexion);
    echo json_encode($res);

}

?>