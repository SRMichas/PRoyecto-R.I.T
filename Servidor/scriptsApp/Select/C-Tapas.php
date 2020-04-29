<?php
$hostname ="localhost";
$database ="proyectorit";
$username ="root";
$password ="";

$json = array();

class Respuesta{
    public $tapasAcumuladas;
    public $tapasRestantes;
    public $mensaje;
    public $fallo;
}

$res = new Respuesta();
if( isset($_GET["us_id"]) ){

    $us_id = $_GET["us_id"];

    $conexion = mysqli_connect($hostname,$username,$password,$database);
    if($conexion -> connect_error)
    {
        die("Coneccion fallida" .$conexion->connect_error);
    }
    

    $consulta = "SELECT cc.tapas_contadas 
                FROM usuarioDetalle usd 
                INNER JOIN usuario u ON usd.id_usuario = u.id_usuario 
                INNER JOIN cadena_ctrl cc ON usd.id_cadena = cc.id_cadena 
                INNER JOIN maquina m ON cc.id_maquina = m.id_maquina 
                WHERE u.id_usuario = '{$us_id}' and cc.status = 1";

    $resultado = mysqli_query($conexion,$consulta);

    if( $resultado ){
        $bandera = false;
        $acumulador = 0;
        while($us = mysqli_fetch_array($resultado) ){
            $acumulador += $us[0];
            $res -> fallo = false;
            $bandera = true;
        }
        
        if( $bandera ){
            $res -> mensaje = "Se pudo traer las categogiras";
            $bandera2 = true;
            $dato = 0;
            while( $bandera2 ){
                $dato = $acumulador - 1000;
                if( $dato <= 0 ){
                    $res -> tapasAcumuladas = $dato * (-1);
                    $res -> tapasRestantes = 1000 + $dato;
                    $bandera2 = false;
                }else
                    $acumulador = $dato;
                
            }
        }else{
            $res -> mensaje = "No se pudo traer las categorias";
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