<?php

namespace App\Http\Controllers;
use App;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class homeController extends Controller
{
    //
    public function inicio()
    {
        return view('home.index');
    }
    public function tapaton()
    {
        return view('home.tapaton');
    }
    public function nosotros()
    {
        return view('home.nosotros');
    }
    public function premios()
    { 
        $categorias = App\categoriaPremio::get();
        $premios = App\premio::get(); 
        $arreglo = array();
        array_push($arreglo,$categorias,$premios);
        return view('premios.premios',compact('arreglo'));
        //return $arreglo;
    }
    public function gastarPuntos(Request $request)
    {
         $email = $request->session()->get('usuario');
         $usuario = App\Usuario::where('email',$email);
         $id = $usuario->get('id');
         $puntos = $usuario->get('puntos');
         $p = $puntos[0]->puntos - $request->costo;
         if($p < 0)
         {
              return json_encode([1,"no tienes fondos suficientes"]);
         }
         $results =   DB::select('CALL sp_compra(?,?,?,?)',[ $id[0]->id,$request->id,$p,$request->costo]);
         return json_encode([0,'Se a aquirido el premio correctamente']);//return $usuario->get('puntos');
       // return json_encode($user);
    }
}
