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
if( isset($_GET["correo"]) && isset($_GET["contra"]) &&
    isset($_GET["nombre"]) && isset($_GET["apellido"]) && isset($_GET["edad"]) && isset($_GET["cod_post"]) ){

    $correo = $_GET["correo"];
    $contra = $_GET["contra"];
    $nombre = $_GET["nombre"];
    $apellido = $_GET["apellido"];
    $edad = $_GET["edad"];
    $cod_post = $_GET["cod_post"];

    $conexion = mysqli_connect($hostname,$username,$password,$database);
    if($conexion -> connect_error)
    {
        die("Coneccion fallida" .$conexion->connect_error);
    }
    
    $ultimaPersona = "SELECT id_persona FROM persona ORDER BY id_persona DESC LIMIT 1";
    $ultimoUsuario = "SELECT id_usuario FROM usuario ORDER BY id_usuario DESC LIMIT 1";

    $resultado = mysqli_query($conexion,$ultimaPersona);

    if( $resultado ){
        if( $us = mysqli_fetch_row($resultado) ){
            $resultado2 = mysqli_query($conexion,$ultimoUsuario);
            if( $resultado2 ){
                if( $us2 = mysqli_fetch_row($resultado2) ){
                    $idPer = $us[0]+1;
                    $idUs = $us2[0]+1;
                    $insertPersona = "INSERT INTO persona VALUES ('{$idPer}','{$nombre}','{$apellido}','{$edad}','{$cod_post}')";
                    $insertUsuario = "INSERT INTO usuario VALUES ('{$idUs}','{$idPer}','{$correo}','{$contra}')";
                    
                    $query_persona = mysqli_query($conexion,$insertPersona);
                    $query_usuario = mysqli_query($conexion,$insertUsuario);

                    if( $query_persona && $query_usuario){
                        $res -> mensaje = "Si se pudo realizar la operacion";
                        $res -> fallo = false;
                        $res -> codigo = 0;
                    }
                }else{
                    $res -> mensaje = "No se pudo usuario";
                    $res -> fallo = false;
                    $res -> codigo = 4;
                }
            }else{
                $res -> mensaje = "No se pudo obtener el usuario";
                $res -> fallo = false;
                $res -> codigo = 3;
            }
        }else{
            $res -> mensaje = "No se pudo persona";
            $res -> fallo = false;
            $res -> codigo = 2;
        }   
    }else{
        $res -> mensaje = "No se pudo obtener la persona";
        $res -> fallo = false;
        $res -> codigo = 1;
    }

    mysqli_close($conexion);
    echo json_encode($res);

}else
    echo "Te faltan datos perro";

?>