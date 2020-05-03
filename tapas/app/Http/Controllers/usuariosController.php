<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class usuariosController extends Controller
{
    //
    public function vistaPrincipal()
    {
        return view('home.index');
    }
    public function perfil()
    {
        return view('usuario.perfil');
    }
}
