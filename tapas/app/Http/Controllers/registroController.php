<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

use App;
class registroController extends Controller
{
    //

    public function vistaRegistrar()
    {
        return view('registro.index'); 
    }
    public function registrar(Request $request)
    {          
        $validatedData = $request->validate([
            'email'     => 'required|email|unique:usuarios',
            'pass'  => 'required|confirmed',
            'nombre'  => 'required',
            'apellido'  => 'required',
            'edad' => 'required'
        ]);

        $user = new App\Usuario;
        $persona = new App\Persona;

        $persona->nombre =$request->nombre;
        $persona->apellido = $request->apellido;
        $persona->edad = $request->edad;    
        $persona->save();

        $results =  DB::select('select * from personas order by id_persona desc limit 1;');
        var_dump($results);
        if(count($results) > 0)
        {
           $user->persona_id = $results[0]->id_persona;
        }
        else{
            return abort(404);
        }
    
        $user->email = $request->email;
        $user->pass = $request->pass;
        $user->save();

        return redirect()->action('homeController@inicio');       
    }
}
