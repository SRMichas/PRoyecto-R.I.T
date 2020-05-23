<?php
$hostname ="bimlwt6nabnfzacy9sgn-mysql.services.clever-cloud.com";
$database ="bimlwt6nabnfzacy9sgn";
$username ="uxqi36i7rez3yxs2";
$password ="Cgh6yIaCCX03eDOFX3Ha";
class Respuesta{
    public $lista;
    public $fallo;
    public $mensaje;
    public $codigo;
}

class Estado{
    public $id; //Int
    public $nombre;
    public $ciudades;

    public function __construct($id,$nombre) {
        $this->id = $id;
        $this->nombre = $nombre;
    }

    public function __toString(){
        try{
            return (String) ((String)$this->id)." | ".$this->nombre." | ".json_encode($this->premios);
        } 
        catch (Exception $exception){
            return '';
        }
    }
}

class Ciudad{
    public $id_ciudad,$id_estado;
    public $nombre;

    public function __construct($id, $idC,$nombre) {
        $this->id_ciudad = $id;
        $this->id_estado = $idC;
        $this->nombre = $nombre;
    }
}

$respuesta = new Respuesta();

    $conexion = mysqli_connect($hostname,$username,$password,$database);

    if( !$conexion ){
        die("Coneccion fallida"/*.mysqli_connect_error()*/);
    }


    $sql = "CALL sp_retEstados();";

    $res = mysqli_multi_query($conexion,$sql);

    if( $res ){
        $contador = 1;
        $contadorC = 0;
        do{
            if ($result = mysqli_store_result($conexion)) {
                while ($row = mysqli_fetch_row($result)) {

                    if( $row[0] == 1){
                        if( $contadorC == 0){
                            $contadorC += 1;
                        }
                        $respuesta -> lista[] = new Estado($row[1],$row[2]);
                    }else{
                        if( $contadorC == 1){
                            $contadorC += 1;
                        }
                        $respuesta -> lista[$row[3]-1] -> ciudades[] = new Ciudad($row[1],$row[3],$row[2]);
                    }
                    //echo "<br>".json_encode($row)."<br>";
                }
                mysqli_free_result($result);
              }
              
              if (mysqli_more_results($conexion)) {}
              
        }while(mysqli_next_result($conexion));
        if( $contadorC == 2){
            $respuesta -> fallo = false;
            $respuesta -> mensaje = "Ningun fallo";
            $respuesta -> codigo = 0;
          }else{
            echo "Fallo<br><br>";
            $respuesta -> fallo = true;
            $respuesta -> mensaje = "";
            $respuesta -> codigo = $contadorC;
          }
    }else{
        $respuesta -> fallo = true;
        $respuesta -> mensaje = "Fallo en el SP";
        $respuesta -> codigo = 4;
    }

    mysqli_close($conexion);
    echo json_encode($respuesta);

?>