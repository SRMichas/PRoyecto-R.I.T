<?php
$hostname ="localhost";
$database ="proyectorit";
$username ="root";
$password ="";

$json = array();
$usuario = $_GET["usId"];

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
    
    $consulta = "SELECT CONVERT('2020-04-12',DATE),CURRENT_DATE";

    $resultadoFecha = mysqli_query($conexion,$consulta);

    if( $resultadoFecha ){
        $fecha = mysqli_fetch_row($resultadoFecha);

        $consultaEstadisticas = "SELECT c.tapas_contadas, DAYOFWEEK(ud.fecha),DAYNAME(ud.fecha) 
                 FROM usuariodetalle ud 
                 INNER JOIN usuario u ON u.id_usuario = ud.id_usuario 
                 INNER JOIN cadena_ctrl c On c.id_cadena = ud.id_cadena 
                 WHERE week(ud.fecha) = week('{$fecha[0]}') and year(ud.fecha) = year('{$fecha[0]}')
                 and ud.id_usuario = {$usuario} and c.status = 1";

        $estadisticas = mysqli_query($conexion,$consultaEstadisticas);

        if( $estadisticas ){
            $bandera = false;
            $puntosAcumulados = 0;
            while($renglon = mysqli_fetch_array($estadisticas) ){
                $semana[$renglon[1] - 1] = new Historico($dias[$renglon[1] - 1],$renglon[0]);
                $puntosAcumulados += $renglon[0];
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

?>