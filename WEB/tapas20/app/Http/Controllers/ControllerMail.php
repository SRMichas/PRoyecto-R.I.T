<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Mail\DemoEmail;
use App\Mail\SendMail;
use Illuminate\Support\Facades\Mail;
class ControllerMail extends Controller
{
    //
    public function index()
    {
        return view('form');
    }
    public function send(Request $request)
    {
    //     $reponse = array(
    //         'respuesta' => 'Que bien que bien'
    //     );
        
        
         $data = array(
             'mensaje'   =>  'Gracias por registrarte, porfavor pulsa el boton para validar tu correo xDDDD',
             'correo' => $request->correo
         );
      $email = $request->correo;
      Mail::to($email)->send(new SendMail($data));
    //    //return $data['correo'];
       return $request;
    }
}

