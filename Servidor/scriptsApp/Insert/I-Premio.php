<?php
$hostname ="bimlwt6nabnfzacy9sgn-mysql.services.clever-cloud.com";
$database ="bimlwt6nabnfzacy9sgn";
$username ="uxqi36i7rez3yxs2";
$password ="Cgh6yIaCCX03eDOFX3Ha";


$id = $_POST["idU"];
$idP = $_POST["idP"];
$ptnAct = $_POST["act"];
$ptnGas = $_POST["gas"];

class Respuesta{
    public $puntos;
    public $fallo;
    public $mensaje;
    public $codigo;
}

$respuesta = new Respuesta();

    $conexion = mysqli_connect($hostname,$username,$password,$database);

    if( !$conexion ){
        die("Coneccion fallida"/*.mysqli_connect_error()*/);
    }


    $sql = "CALL sp_compra({$id},{$idP},{$ptnAct},{$ptnGas});";

    $res = mysqli_multi_query($conexion,$sql);

    if( $res ){
        do{
            if ($result = mysqli_store_result($conexion)) {
                while ($row = mysqli_fetch_row($result)) {
                    $respuesta -> puntos = $row[0];
                    $respuesta -> mensaje = "Se realizo la compra satisfactoriamente!!!";
                    $respuesta -> codigo = 0;
                    //echo "<br>".json_encode($row)."<br>";
                }
                mysqli_free_result($result);
              }
              
              if (mysqli_more_results($conexion)) {}
              
        }while(mysqli_next_result($conexion));
    }else{
        $respuesta -> fallo = true;
        $respuesta -> mensaje = "Fallo en el SP";
        $respuesta -> codigo = 2;
    }

    mysqli_close($conexion);
    echo json_encode($respuesta);

?>