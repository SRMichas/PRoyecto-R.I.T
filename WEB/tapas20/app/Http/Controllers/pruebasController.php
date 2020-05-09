<?php

namespace App\Http\Controllers;
use App;
use Illuminate\Http\Request;

class pruebasController extends Controller
{
    //
    public function inicio()
    {
        $user = App\Usuario::all();
        return view('pruebas.prueba',compact('user'));  
    }
    public function crear(Request $request)
    {

        
        $user = new App\Usuario;
        $user->email = $request->email;
        $user->pass = $request->pass;
        $user->save();
        return back()->red;
    }
}
