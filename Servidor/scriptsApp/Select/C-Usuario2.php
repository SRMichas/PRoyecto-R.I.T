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
if( isset($_POST["correo"]) && isset($_POST["contra"]) ){

    $correo = $_POST["correo"];
    $contra = $_POST["contra"];

    $conexion = mysqli_connect($hostname,$username,$password,$database);
    if($conexion -> connect_error)
    {
        die("Coneccion fallida" .$conexion->connect_error);
    }
    
    $consulta = "CALL sp_retUsuario('{$correo}','{$contra}');";

    $resultado = mysqli_query($conexion,$consulta);

    if( $resultado ){
        if( $us = mysqli_fetch_row($resultado) ){
            $res -> usuario = $us;
            $res -> mensaje = "El usuario existe";
            $res -> fallo = false;
            $res -> codigo = 0;
        }else{
            $res -> mensaje = "No se pudo";
            $res -> fallo = true;
            $res -> codigo = 1;
        }   
    }else{
        $res -> mensaje = "El usuario NO existe";
        $res -> fallo = true;
        $res -> codigo = 2;
    }

    mysqli_close($conexion);
    echo json_encode($res);

}else{
    echo "llego null";
}

?>