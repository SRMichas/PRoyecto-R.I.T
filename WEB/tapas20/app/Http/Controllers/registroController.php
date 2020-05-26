<?php

namespace App\Http\Controllers;


use Illuminate\Http\Request;
use App\Mail\SendMail;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\DB;

use App;
class registroController extends Controller
{
    //
    public $correo = " ";
    public function vistaRegistrar()
    {
        $ciudades = App\ciudad::get();
        $estados = App\estado::get();
        $array = array();
        array_push($array,$estados,$ciudades);
        return view('registro.index',compact('array')); 
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
        
        $usuarioCiudad = new App\Usuario_ciudad;
        $user = new App\Usuario;
        $persona = new App\Persona;

        $persona->nombre =$request->nombre;
        $persona->apellido = $request->apellido;
        $persona->edad = $request->edad;    
        $persona->save();
        
        
        
        $results =  DB::select('select * from personas order by id desc limit 1;');
        var_dump($results);
        if(count($results) > 0)
        {
           $user->persona_id = $results[0]->id;
        }
        else{
            return abort(404);
        }
        $user->email = $request->email;
        $user->pass = $request->pass;
        $user->tapas = 0;
        $user->puntos = 0;
        $user->activo = 0;
        $user->save();
        
        $u = App\Usuario::where('email',$request->email);
        $usuarioCiudad->id_usuario= $u->get()[0]['id'];
        $usuarioCiudad->id_ciudad = $request->ciudad;
        $usuarioCiudad->activo = 1;
        
        $usuarioCiudad->save();
        
         $data = array(
             'correo'      => $request->email,
             'mensaje'   =>  'Gracias por registrarte, porfavor pulsa el boton para validar tu correo'
         );
        $email = $request->email;
        Mail::to($email)->send(new SendMail($data));


        return redirect()->action('homeController@inicio')->with('msj','se ha enviado un correo de confirmacion a '.$email);       
        //return $u->get()[0]-;
    }
    public function confirmar($correo)
    {
        $results = DB::update('update usuarios set activo = 1 where email = ?', [$correo]);
        
        return redirect()->action('homeController@inicio');
    }

	public function getCiudades(Request $request)
	{
		$ciudades = App\ciudad::get();
		return json_encode($ciudades);
	}

}
