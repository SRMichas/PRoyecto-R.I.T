<?php
$hostname ="bimlwt6nabnfzacy9sgn-mysql.services.clever-cloud.com";
$database ="bimlwt6nabnfzacy9sgn";
$username ="uxqi36i7rez3yxs2";
$password ="Cgh6yIaCCX03eDOFX3Ha";

$json = array();

class Respuesta{
    public $tapasAcumuladas;
    public $tapasRestantes;
    public $mensaje;
    public $fallo;
    public $codigo;
}

$res = new Respuesta();
//if( isset($_POST["usId"]) ){

    $usId = $_POST["usId"];

    $conexion = mysqli_connect($hostname,$username,$password,$database);
    if($conexion -> connect_error)
    {
        die("Coneccion fallida" .$conexion->connect_error);
    }
    

    $consulta = "CALL sp_puntuacion({$usId})";

    $resultado = mysqli_query($conexion,$consulta);

    if( $resultado ){
        
        $valor = 0;
        $result = mysqli_fetch_row($resultado);
        if( $result[0] == 0 ){
            $acumulador = $result[1]; 
            $bandera = true;
            $res -> codigo = 0;
            $res -> fallo = false;
        }else if( $result[0] == 1 ){
            $bandera = false;
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
            $res -> mensaje = $result[1];
            $res -> fallo = true;
            $res -> codigo = 1;
        }  
    }else{
        $res -> mensaje = "El usuario NO existe";
        $res -> fallo = true;
    }

    mysqli_close($conexion);
    echo json_encode($res);

    function divideCadena($cadena){
        $lista = explode("T", $cadena);
        return $lista[0];
    }

/*}else{
	echo "llego vacio";	
}*/
?>