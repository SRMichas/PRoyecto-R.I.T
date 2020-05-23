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
    public function perfil(Request $request)
    {
        $usuario = App\Usuario::where('email',$request->session()->get('usuario'));
        $persona = App\Persona::find($usuario->get('persona_id'));
        //return view('usuario.perfil');
        $array = array();
        array_push($array,$usuario->get(),$persona);
        return view('usuario.perfil',compact('array'));
        //return $array;
    }
    public function cadena(Request $request)
    {
         $cadena = $request->cadena;
         $validatedData = $request->validate([
              'cadena'     => 'required|max:15|min:15'
        
            ]);
         
               $users = App\Usuario::where('email',$request->session()->get('usuario'));        
               $resultsUs = DB::select('select id from usuarios where email = ?',[$request->session()->get('usuario')]);
               $results =   DB::select('CALL sp_manejo_cadena(? , ?)',[ $resultsUs[0]->id,$request->cadena]);
               if($results[0]->Bandera == 1 || $results[0]->Bandera == 2 )
               {
                 return back()->with('msjErr','No es una cadena Valida o Expiro');
               }
               else{
                return back()->with('msj','Cadena Insertada correctamente xDD te la rifas morro alv perror caile a las guamas');
               }
                
         //return $results;
       
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
