<?php
$hostname ="bimlwt6nabnfzacy9sgn-mysql.services.clever-cloud.com";
$database ="bimlwt6nabnfzacy9sgn";
$username ="uxqi36i7rez3yxs2";
$password ="Cgh6yIaCCX03eDOFX3Ha";

    $us = $_POST["usId"];
    $cadena = $_POST["cadena"];

    $conexion = mysqli_connect($hostname,$username,$password,$database);
    if($conexion -> connect_error)
    {
        die("Coneccion fallida" .$conexion->connect_error);
    }

    class Respuesta{
        public $mensaje;
        public $nuevos;
        public $fallo;
        public $codigo;
        public $algo;
    }

    $res = new Respuesta();

    $consulta = "CALL sp_manejo_cadena({$us},'{$cadena}')";

    $resultado = mysqli_query($conexion,$consulta);

    if( $resultado ){
        $respuesta = mysqli_fetch_row($resultado);
        
        switch ($respuesta[0]) {
            case 0: //todo correcto
                $res -> mensaje = "Has obtenido {$respuesta[4]} tapas";
                $res -> nuevos = $respuesta[5];
                $res -> fallo = false;
                $res -> codigo = $respuesta[0];
                break;
            case 1: //la cadena no existe
                $res -> mensaje = "{$respuesta[1]}";
                $res -> fallo = true;
                $res -> codigo = $respuesta[0];
                break;
            case 2: //la cadena ya esta ocupada
                $res -> mensaje = "{$respuesta[1]}";
                $res -> fallo = true;
                $res -> codigo = $respuesta[0];
                break;
        }
        /*if( $respuesta != null){
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
        }*/
    }else{
        $res -> mensaje = "Error al procedimiento";
        $res -> fallo = true;
        $res -> codigo = 1;
        $res -> algo = $respuesta;
    }
    
    mysqli_close($conexion);
    echo json_encode($res);
?>