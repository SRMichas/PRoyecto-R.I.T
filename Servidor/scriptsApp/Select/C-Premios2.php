<?php
$hostname ="bimlwt6nabnfzacy9sgn-mysql.services.clever-cloud.com";
$database ="bimlwt6nabnfzacy9sgn";
$username ="uxqi36i7rez3yxs2";
$password ="Cgh6yIaCCX03eDOFX3Ha";

$id = $_POST["usId"];

class Respuesta{
    public $puntos;
    public $lista;
    public $fallo;
    public $mensaje;
    public $codigo;
}

class Categoria{
    public $id; //Int
    public $nombre, $url; //String
    public $premios;

    public function __construct($id,$nombre,$url) {
        $this->id = $id;
        $this->nombre = $nombre;
        $this->url = $url;
    }

    public function __toString(){
        try{
            return (String) ((String)$this->id)." | ".$this->nombre." | ".$this->url." | ".json_encode($this->premios);
        } 
        catch (Exception $exception){
            return '';
        }
    }
}

class Premio{
    public $id_premio,$id_categoria,$costo;
    public $nombre,$descripcion,$urlLg;

    public function __construct($id, $idC,$logo, $nombre,$desc, $costo) {
        $this->id_premio = $id;
        $this->id_categoria = $idC;
        $this->urlLg = $logo;
        $this->nombre = $nombre;
        $this->descripcion = $desc;
        $this->costo = $costo;
    }
}

$respuesta = new Respuesta();

    $conexion = mysqli_connect($hostname,$username,$password,$database);

    if( !$conexion ){
        die("Coneccion fallida"/*.mysqli_connect_error()*/);
    }


    $sql = "CALL sp_infoPremios({$id});";

    $res = mysqli_multi_query($conexion,$sql);

    if( $res ){
        $contador = 1;
        $contadorC = 0;
        do{
            if ($result = mysqli_store_result($conexion)) {
                while ($row = mysqli_fetch_row($result)) {
                    switch($row[0]){
                        case 1:
                            $respuesta -> puntos = $row[1];
                            $contadorC += 1;
                        break;
                        case 2:
                            if( $contadorC == 0){
                                $contadorC += 1;
                            }else if( $contadorC == 1){
                                $contadorC += 1;
                            }
                            $respuesta -> lista[] = new Categoria($row[1],$row[2],$row[3]);
                        break;
                        case 3:
                            if( $contadorC == 0){
                                $contadorC += 1;
                            }else if( $contadorC == 1){
                                $contadorC += 1;
                            }else if( $contadorC == 2){
                                $contadorC += 1;
                            }
                            $respuesta -> lista[$row[2]-1] -> premios[] = new Premio($row[1],$row[2],$row[3],$row[4],$row[5],$row[6]);
                        break;
                    }
                    //echo "<br>".json_encode($row)."<br>";
                }
                mysqli_free_result($result);
              }
              
              if (mysqli_more_results($conexion)) {}
              
        }while(mysqli_next_result($conexion));
        if( $contadorC == 3){
            $respuesta -> fallo = false;
            $respuesta -> mensaje = "Ningun fallo";
            $respuesta -> codigo = 0;
          }else{
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