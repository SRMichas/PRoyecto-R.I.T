
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
    /**
     * 0 -> Sin error
     * 1 -> Fallo en la fecha
     * 2 -> Fallo en la consulta del historico
     * 3 -> 
    */
}

class Historico{
    public $fecha;
    public $puntos;

    public function __construct($fecha, $puntos) {
        $this->fecha = $fecha;
        $this->puntos = $puntos;
    }
}

$res = new Respuesta();
$historico = new Historico("",0);
$estadistica = array();
$meses30 = [4,6,9,11];
$meses31 = [1,3,5,7,8,10,12];
$todosLosMeses = [];
$totales = [];

    $conexion = mysqli_connect($hostname,$username,$password,$database);
    if($conexion -> connect_error)
    {
        die("Coneccion fallida" .$conexion->connect_error);
    }
    
    $consulta = "SELECT CURRENT_DATE,MONTH(CURRENT_DATE),YEAR(CURRENT_DATE)";//"SELECT CONVERT('2020-04-17',DATE)";

    $resultado = mysqli_query($conexion,$consulta);

    if( $resultado ){
        $manejoFecha =mysqli_fetch_row($resultado);
        $fecha = $manejoFecha[0];
        $mes = $manejoFecha[1];
        $ano = $manejoFecha[2];
        $meses = rangoMeses($mes,$fecha);
        

        $consultaEstadistica =
                 "SELECT c.tapas_contadas, ud.fecha, month(ud.fecha),day(ud.fecha) 
                  FROM usuariodetalle ud 
                  INNER JOIN usuario u ON u.id_usuario = ud.id_usuario 
                  INNER JOIN cadena_ctrl c On c.id_cadena = ud.id_cadena 
                  WHERE   MONTH(ud.fecha) in {$meses} and ud.id_usuario = {$usuario}
                          and YEAR(ud.fecha) = {$ano} and c.status = 1
                  ORDER BY ud.fecha";

        $estadisticas = mysqli_query($conexion,$consultaEstadistica);
        if( $estadisticas ){
            $bandera = false;
            $puntosAcumulados = 0;
            while($renglon = mysqli_fetch_array($estadisticas) ){
                
                $todosLosMeses[$renglon[2] - 1][$renglon[3]-1] = new Historico($renglon[1],$renglon[0]);
                $totales[$renglon[2] - 1] += $renglon[0];
                $estadistica[] = new Historico($renglon[1],$renglon[0]);
                $puntosAcumulados += $renglon[0];
                $res -> fallo = false;
                $bandera = true;
            }

            $res -> puntos = $estadistica;
            $res -> total = $totales;

            if( $bandera ){
                $res -> mensaje = "Se pudo traer las estadisticas";
                $res -> puntos = $todosLosMeses;
                $res -> codigo = 0;
            }else{
                $res -> mensaje = "Ups!!! parece que no haz depositado";
                $res -> fallo = true;
                $res -> codigo = 1;
            }
        }else{
            $res -> mensaje = "No se puede recuperar las estadisticas";
            $res -> fallo = true;
            $res -> codigo = 2;
        }
    }else{
        $res -> mensaje = "No se puede recuperar la fecha";
        $res -> fallo = true;
        $res -> codigo = 3;
    }

    mysqli_close($conexion);
    echo json_encode($res);


    function rangoMeses($limite,$fecha){
        $dividido = explode("-",$fecha);
        $ano = $dividido[0];
        $mes = $dividido[1];
        $dia = $dividido[2];

        $cadena = "(";
        for ($i=1; $i <= $limite; $i++) { 
            if( $i == $limite ){
                $cadena = $cadena."".$i.")";
                rangoFechas($ano,$i,intval($dia),true);
            }else{
                $cadena = $cadena."".$i.",";
                rangoFechas($ano,$i,0,false);
            }
            $GLOBALS["totales"][] = 0;
        }

        return $cadena;
    }

    function rangoFechas($ano,$mes,$dia,$bandera){

        if( $mes == 2){ //febrero
            otroFechas($ano,$mes,$bandera ? $dia : 28);
        }else if( in_array($mes,$GLOBALS["meses30"])){
            otroFechas($ano,$mes,$bandera ? $dia : 30);
        }else{
            otroFechas($ano,$mes,$bandera ? $dia : 31);
        }

    }

    function otroFechas($ano,$mes,$limite){
        $arreglo = [];
        $cadenaFecha = "";
        for ($i=1; $i <= $limite; $i++) { 
            $cadenaFecha = $ano."-".$mes."-".$i;
            $fecha = strtotime($cadenaFecha);
            $newformat = date('Y-m-d',$fecha);
            $arreglo[] = new Historico($newformat,0);
        }
        $GLOBALS["todosLosMeses"][] = $arreglo;
    }

?>