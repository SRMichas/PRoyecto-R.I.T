<?php

namespace App\Http\Controllers;
use App;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

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
    public function cadena(Request $request)
    {
        $cadena = $request->cadena;
        $validatedData = $request->validate([
            'cadena'     => 'required|max:20|min:20'
            
        ]);
        return redirect()->back()->with('msj','La cadena Se ha guardado correctamente');;
    }
    public function historial()
    {
        return view('usuario.historial');
    }
}
