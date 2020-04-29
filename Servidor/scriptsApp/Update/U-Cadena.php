<?php
$hostname ="localhost";
$database ="proyectorit";
$username ="root";
$password ="";

    $us = $_GET["usId"];
    $cadena = $_GET["cadena"];

    $conexion = mysqli_connect($hostname,$username,$password,$database);
    if($conexion -> connect_error)
    {
        die("Coneccion fallida" .$conexion->connect_error);
    }

    class Respuesta{
        public $mensaje;
        public $fallo;
        public $codigo;
        public $algo;
    }

    $res = new Respuesta();

    $consulta = "SELECT cc.id_cadena,cc.cadena 
                    FROM usuariodetalle ud
                    INNER JOIN cadena_ctrl cc ON ud.id_cadena = cc.id_cadena 
                    WHERE ud.id_usuario = {$us} AND cc.cadena = '{$cadena}'
                    AND cc.status = 0";

    $resultado = mysqli_query($conexion,$consulta);

    if( $resultado ){
        $respuesta = mysqli_fetch_row($resultado);
        
        if( $respuesta != null){
            $sql = "UPDATE cadena_ctrl set status = 1 WHERE id_cadena = {$respuesta[0]}";

            $resultado2 = mysqli_query($conexion,$sql);
    
            if( $resultado2 ){
                $res -> mensaje = "se pudo modificar la cadena";
                $res -> fallo = false;
                $res -> codigo = 0;
                $res -> algo = $respuesta;
            }else{
                $res -> mensaje = "Error al modificar la cadena";
                $res -> fallo = true;
                $res -> codigo = 1;
                $res -> algo = $respuesta;
            }
        }else{
            $res -> mensaje = "La cadena ya no es valida";
            $res -> fallo = true;
            $res -> codigo = 2;
            $res -> algo = $respuesta;
        }
    }else{
        $res -> mensaje = "Error al obtener la cadena";
        $res -> fallo = true;
        $res -> codigo = 3;
        $res -> algo = $respuesta;
    }
    
    mysqli_close($conexion);
    echo json_encode($res);
?>