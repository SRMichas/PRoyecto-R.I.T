<?php

namespace App\Http\Controllers;
use App;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Mail\DemoEmail;
use Illuminate\Support\Facades\Mail;

class loginController extends Controller
{
    //
    public function vistaLogin()
    {
        return view('login.index');
    }
    public function acceder(Request $request)
    { 
         $username = $request->username;
            
         $users = App\Usuario::where('email',$request->username);
         if(count($users->get())>0)
         {
          if($users->get()[0]['activo'] == 1)
          {
            $request->session()->put('usuario',$request->username);        
            return redirect()->action('usuariosController@vistaPrincipal');
          }
            return back()->with('nota','Usuario falta confirmacion de correo');
         }
         else{
             return back()->with('nota','contraseña o usuario incorrecto');
         }
     //  return $users->get()[0]['activo']; 
    }
    public function cerrar()
    {
        session()->flush();
        return redirect()->action('homeController@inicio');  
    }
}
