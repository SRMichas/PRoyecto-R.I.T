<?php
$hostname ="bimlwt6nabnfzacy9sgn-mysql.services.clever-cloud.com";
$database ="bimlwt6nabnfzacy9sgn";
$username ="uxqi36i7rez3yxs2";
$password ="Cgh6yIaCCX03eDOFX3Ha";

$json = array();

class Respuesta{
    public $usuario;
    public $mensaje;
    public $fallo;
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
    
    $consulta = "SELECT u.id_usuario,p.*,u.email,u.pass,u.puntos_actuales 
                FROM usuario u 
                INNER JOIN persona p ON u.id_persona = p.id_persona 
                WHERE u.email = '{$correo}' and u.pass = '{$contra}'";

    $resultado = mysqli_query($conexion,$consulta);

    if( $resultado ){
        if( $us = mysqli_fetch_row($resultado) ){
            $res -> usuario = $us;
            $res -> mensaje = "El usuario existe";
            $res -> fallo = false;
        }else{
            $res -> mensaje = "No se pudo";
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