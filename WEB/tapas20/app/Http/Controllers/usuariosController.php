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
        $results =  DB::select('select * from cadenas where cadena = ? and status = 1 ;',[$request->cadena]);
        
        if(count($results)>0)
        {
            $resultsUs = DB::select('select id from usuarios where email = ?',[$request->session()->get('usuario')]);
            $usDet = new App\UsuarioDetalle;
            $usDet->id_usuario = $resultsUs[0]->id;
            $usDet->id_cadena = $results[0]->id;
            $usDet->id_maquina = 1;
            $usDet->save();
            DB::update('update cadenas set status = 0 where cadena = ?', [$request->cadena]);
            return back()->with('msj','Se agrego la Cadena Correctamente');
        }

        return back()->with('msjErr','No es una cadena Valida o Expiro');
       
    }
    public function historial(Request $request)
    {
        $cadenas = array();
        
        $results = DB::select('select id from usuarios where email = ?', [$request->session()->get('usuario')]);
        $info = App\usuarioDetalle::where('id_usuario',$results[0]->id)->get();
        foreach($info as $id_cadena => $valor)
        {
           array_push($cadenas,App\Cadena::where('id',$valor->id_cadena)->get()); //$valor->id_cadena;
        }
         return view('usuario.historial',compact('cadenas'));
        // return $cadenas;
    }
}
