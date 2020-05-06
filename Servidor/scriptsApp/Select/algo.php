<?php



class a{
    public $msg;
    public $error;
    public $valores;
}
$aa = new a();
if( isset($_GET["va"]) ){
    $valor = $_GET["va"];

    if( $valor <= 5){
        $aa -> msg = "simon";
        $aa -> error = false;
        for( $i = 0; $i < $valor; $i++){
            $aa -> valores[] = $i;
        }
    }else{
        $aa -> msg = "NEL";
        $aa -> error = true;
    }

    echo json_encode($aa);
}
?>