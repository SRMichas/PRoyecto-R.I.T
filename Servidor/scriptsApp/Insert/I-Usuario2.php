<?php
$hostname ="localhost";
$database ="proyectorit";
$username ="root";
$password ="";

$json = array();

class Respuesta{
    //public $usuario;
    public $mensaje;
    public $fallo;
    public $codigo;
}

$res = new Respuesta();

    $correo = $_POST["correo"];
    $contra = $_POST["contra"];
    $nombre = $_POST["nombre"];
    $apellido = $_POST["apellido"];
    $edad = $_POST["edad"];
    $cod_post = $_POST["cod_post"];
    $ciudad = $_POST["ciudad"];

    $conexion = mysqli_connect($hostname,$username,$password,$database);
    if($conexion -> connect_error)
    {
        die("Coneccion fallida" .$conexion->connect_error);
    }
    
    $consulta = "CALL sp_creaUsuario(
                    '{$nombre}','{$apellido}',
                    {$edad},{$cod_post},
                    '{$correo}','{$contra}',
                    {$ciudad}
                );";

    $resultado = mysqli_query($conexion,$consulta);

    if( $resultado ){
        if( $us = mysqli_fetch_row($resultado) ){
            if( $us[0] == 0){
                $res -> usuario = $us;
                $res -> mensaje = "Usuario creado con exito";
                $res -> fallo = false;
                $res -> codigo = 0;
            }else{
                //$res -> usuario = $us;
                $res -> mensaje = $us[1];
                $res -> fallo = true;
                $res -> codigo = 1;
            }
        }else{
            $res -> mensaje = "No se pudo";
            $res -> fallo = true;
            $res -> codigo = 2;
        }   
    }else{
        $res -> mensaje = "El usuario NO existe";
        $res -> fallo = true;
        $res -> codigo = 3;
    }

    mysqli_close($conexion);
    echo json_encode($res);

?>