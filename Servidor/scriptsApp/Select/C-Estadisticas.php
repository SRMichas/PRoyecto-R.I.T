<?php
$hostname ="bimlwt6nabnfzacy9sgn-mysql.services.clever-cloud.com";
$database ="bimlwt6nabnfzacy9sgn";
$username ="uxqi36i7rez3yxs2";
$password ="Cgh6yIaCCX03eDOFX3Ha";

$json = array();
$usuario = $_POST["usId"];

class Respuesta{
    public $puntos;
    public $total;
    public $mensaje;
    public $fallo;
    public $codigo;
}

class Historico{
    public $dia;
    public $puntos;

    public function __construct($dia, $puntos) {
        $this->dia = $dia;
        $this->puntos = $puntos;
    }
}

$res = new Respuesta();
$semana = array();
$dias = ["Domingo","Lunes","Martes","Miercoles","Jueves","Viernes","Sabado"];

    $semana[] = new Historico("Domingo",0);
    $semana[] = new Historico("Lunes",0);
    $semana[] = new Historico("Martes",0);
    $semana[] = new Historico("Miercoles",0);
    $semana[] = new Historico("Jueves",0);
    $semana[] = new Historico("Viernes",0);
    $semana[] = new Historico("Sabado",0);


    $conexion = mysqli_connect($hostname,$username,$password,$database);

    if( !$conexion ){
        die("Coneccion fallida"/*.mysqli_connect_error()*/);
    }
    
    $consulta = "SELECT CURRENT_DATE";

    $resultadoFecha = mysqli_query($conexion,$consulta);

    if( $resultadoFecha ){
        $fecha = mysqli_fetch_row($resultadoFecha);

        $consultaEstadisticas = "SELECT c.cadena, DAYOFWEEK(ud.created_at),DAYNAME(ud.created_at) 
                 FROM usuario_detalles ud 
                 INNER JOIN usuarios u ON u.id = ud.id_usuario 
                 INNER JOIN cadenas c On c.id = ud.id_cadena 
                 WHERE  week(ud.created_at) = week('{$fecha[0]}') and 
                        year(ud.created_at) = year('{$fecha[0]}') and 
                        ud.id_usuario = {$usuario} and c.status = 0";

        $estadisticas = mysqli_query($conexion,$consultaEstadisticas);

        if( $estadisticas ){
            $bandera = false;
            $puntosAcumulados = 0;
            $valor = 0;
            while($renglon = mysqli_fetch_array($estadisticas) ){
                $valor = intval(divideCadena($renglon[0]));
                $semana[$renglon[1] - 1] = new Historico($dias[$renglon[1] - 1],$valor);
                $puntosAcumulados += $valor;
                $res -> fallo = false;
                $bandera = true;
            }
            $res -> puntos = $semana;
            $res -> total = $puntosAcumulados;

            if( $bandera ){
                $res -> mensaje = "Se muestran los datos reales";
                $res -> fallo = false;
                $res -> codigo = 0;
            }else{
                $res -> mensaje = "Se muestran los datos por defectos";
                $res -> fallo = false;
                $res -> codigo = 0;
            }
        }else{
            $res -> mensaje = "Error al recuperar el historico";
            $res -> fallo = true;
            $res -> codigo = 1;
        }
    }else{
        $res -> mensaje = "No se puede Recuperar la fecha";
        $res -> fallo = true;
        $res -> codigo = 2;
    }

    mysqli_close($conexion);
    echo json_encode($res);

    function divideCadena($cadena){
        $lista = explode("T", $cadena);
        return $lista[0];
    }

?>