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

        $sql2 =     "SELECT SUM(c.tapas_contadas), ud.fecha, month(ud.fecha) 
                    FROM usuariodetalle ud 
                    INNER JOIN usuario u ON u.id_usuario = ud.id_usuario 
                    INNER JOIN cadena_ctrl c On c.id_cadena = ud.id_cadena 
                    WHERE   MONTH(ud.fecha) in {$meses} and ud.id_usuario={$usuario}
                            and YEAR(ud.fecha) = {$ano} and c.status = 1
                    GROUP BY MONTH(ud.fecha)
                    ORDER BY ud.fecha";

        $resultado2 = mysqli_query($conexion,$sql2);

        if( $resultado2 ){
            $bandera = false;
            $puntosAcumulados = 0;
            while($us2 = mysqli_fetch_array($resultado2) ){
                $todosLosMeses[$us2[2] - 1] = new Historico($listaMeses[$us2[2]-1],$us2[0]);
                $estadistica[] = new Historico($us2[2],$us2[0]);
                $puntosAcumulados += $us2[0];
                $res -> fallo = false;
                $bandera = true;
            }

            $res -> puntos = $todosLosMeses;
            $res -> total = $puntosAcumulados;
            if( $bandera ){
                
                $res -> mensaje = "Se pudo traer las estadisticas";
                $res -> codigo = 0;
            }else{
                $res -> mensaje = "El usuario no tiene registros";
                $res -> fallo = true;
                $res -> codigo = 3;
            }
        }else{
            $res -> mensaje = "No se puede Recuperar el historico";
            $res -> fallo = true;
            $res -> codigo = 2;
        }
    }else{
        $res -> mensaje = "No se puede Recuperar la fecha";
        $res -> fallo = true;
        $res -> codigo = 1;
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

?>