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
    /**
     * 0 -> Sin error
     * 1 -> Fallo en la fecha
     * 2 -> Fallo en la consulta del historico
     * 3 -> No trajo nada la consulta
    */
}

class Historico{
    public $mes;
    public $puntos;

    public function __construct($mes, $puntos) {
        $this->mes = $mes;
        $this->puntos = $puntos;
    }
}

$res = new Respuesta();
$historico = new Historico("",0);
$estadistica = array();
$listaMeses = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"];
$todosLosMeses = [];

    $conexion = mysqli_connect($hostname,$username,$password,$database);
    
    if($conexion -> connect_error)
    {
        die("Coneccion fallida" .$conexion->connect_error);
    }
    
    $consulta = "SELECT MONTH(CURRENT_DATE),YEAR(CURRENT_DATE)";

    $resultado = mysqli_query($conexion,$consulta);

    if( $resultado ){
        $manejoFecha = mysqli_fetch_row($resultado);
        $mes = $manejoFecha[0];
        $ano = $manejoFecha[1];

        $meses = rangoMeses($mes);

        $consultaEstadisticas =     
                "SELECT 
                    SUM(CONVERT(SUBSTRING(c.cadena,1,4),UNSIGNED INTEGER)), 
                    ud.created_at, month(ud.created_at) 
                FROM usuario_detalles ud 
                INNER JOIN usuarios u ON u.id = ud.id_usuario 
                INNER JOIN cadenas c On c.id = ud.id_cadena 
                WHERE   MONTH(ud.created_at) in {$meses} and ud.id_usuario = {$usuario}
                        and YEAR(ud.created_at) = {$ano} and c.status = 0
                GROUP BY MONTH(ud.created_at)
                ORDER BY ud.created_at";

        /*$consultaEstadisticas =     
                "SELECT SUM(c.tapas_contadas), ud.fecha, month(ud.fecha) 
                 FROM usuariodetalle ud 
                 INNER JOIN usuario u ON u.id_usuario = ud.id_usuario 
                 INNER JOIN cadena_ctrl c On c.id_cadena = ud.id_cadena 
                 WHERE   MONTH(ud.fecha) in {$meses} and ud.id_usuario = {$usuario}
                         and YEAR(ud.fecha) = {$ano} and c.status = 1
                 GROUP BY MONTH(ud.fecha)
                 ORDER BY ud.fecha";*/

        $estadisticas = mysqli_query($conexion,$consultaEstadisticas);

        if( $estadisticas ){
            $bandera = false;
            $puntosAcumulados = 0;
            while($renglon = mysqli_fetch_array($estadisticas) ){
                $todosLosMeses[$renglon[2] - 1] = new Historico($listaMeses[$renglon[2]-1],$renglon[0]);
                $estadistica[] = new Historico($renglon[2],$renglon[0]);
                $puntosAcumulados += $renglon[0];
                $res -> fallo = false;
                $bandera = true;
            }

            $res -> puntos = $todosLosMeses;
            $res -> total = $puntosAcumulados;
            if( $bandera ){
                
                $res -> mensaje = "Se pudo traer las estadisticas";
                $res -> codigo = 0;
            }else{
                $res -> mensaje = "Ups!!! parece que no haz depositado";
                $res -> fallo = true;
                $res -> codigo = 1;
            }
        }else{
            $res -> mensaje = "No se puede Recuperar el historico";
            $res -> fallo = true;
            $res -> codigo = 2;
        }
    }else{
        $res -> mensaje = "No se puede Recuperar la fecha";
        $res -> fallo = true;
        $res -> codigo = 3;
    }

    mysqli_close($conexion);
    echo json_encode($res);


    function rangoMeses($limite){
        $cadena = "(";
        for ($i=1; $i <= $limite; $i++) { 
            if( $i == $limite ){
                $cadena = $cadena."".$i.")";
            }else{
                $cadena = $cadena."".$i.",";
            }
            $objeto = new Historico($GLOBALS["listaMeses"][$i-1],0);
            $GLOBALS["todosLosMeses"][] = $objeto;
        }
        return $cadena;
    }
    
    function divideCadena($cadena){
        $lista = explode("T", $cadena);
        return $lista[0];
    }
?>