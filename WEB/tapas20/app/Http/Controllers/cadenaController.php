<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Cadena;

class cadenaController extends Controller
{
	public function index()
	{
		return response()->json("Todo está bien", 200);
	}

	public function store(Request $request)
	{
		//cadena
		// id_maquina
		// status
		// tapas
		// puntos
		$puntos = $request->conteo * 3;
		$semilla = $request->conteo + $request->maquina + time();
		$cadena = substr(md5($semilla), 17);	//Sí, el código es un hash.
		$objetoCadena = [
			"cadena" => $cadena,
			"id_maquina" => $request->maquina,
			"status" => 1,
			"tapas" => $request->conteo,
			"puntos" => $puntos
		];
		Cadena::create($objetoCadena);
		return response()->json(['Codigo' => $cadena, 'Registro' => $objetoCadena]);
	}

	public function update(Request $request)
	{
		//Agregar comportamiento para el reclamo de cadenas.
	}
}
