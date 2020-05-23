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
    public function send()
    {
        $data = array(
            'mensaje'   =>  'message'
        );

        $email = 'eliasmisael_@hotmail.com';
        Mail::to($email)->send(new SendMail($data));
       //return $data['correo'];
    }
}
