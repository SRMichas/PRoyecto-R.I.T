
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
$historico = new Historico("",0);
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
    if($conexion -> connect_error)
    {
        die("Coneccion fallida" .$conexion->connect_error);
    }
    
    $consulta = "SELECT week(CONVERT('2020-04-12',DATE)),week(CURRENT_DATE)";

    $resultado = mysqli_query($conexion,$consulta);

    if( $resultado ){
        $fecha = mysqli_fetch_row($resultado)[0];
        $sql2 = "SELECT c.tapas_contadas, DAYOFWEEK(ud.fecha),DAYNAME(ud.fecha) 
                 FROM usuariodetalle ud 
                 INNER JOIN usuario u ON u.id_usuario = ud.id_usuario 
                 INNER JOIN cadena_ctrl c On c.id_cadena = ud.id_cadena 
                 WHERE week(ud.fecha) = '{$fecha}' and ud.id_usuario='{$usuario}' and c.status = 1";

        $resultado2 = mysqli_query($conexion,$sql2);
        if( $resultado2 ){
            $bandera = false;
            $puntosAcumulados = 0;
            while($us2 = mysqli_fetch_array($resultado2) ){
                $semana[$us2[1] - 1] = new Historico($dias[$us2[1] - 1],$us2[0]);
                $puntosAcumulados += $us2[0];
                $res -> fallo = false;
                $bandera = true;
            }
            $res -> puntos = $semana;
            $res -> total = $puntosAcumulados;
            if( $bandera ){
                $res -> mensaje = "Se pudo traer las categogiras";
            }else{
                $res -> mensaje = "No se pudo traer las categorias";
                $res -> fallo = true;
        }

        }else{
            $res -> mensaje = "No se puede Recuperara el historico";
            $res -> fallo = true;
        }
    }else{
        $res -> mensaje = "No se puede Recuperara la fecha";
        $res -> fallo = true;
    }

    mysqli_close($conexion);
    echo json_encode($res);

?>