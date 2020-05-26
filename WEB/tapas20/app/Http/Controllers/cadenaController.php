<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Cadena;
use Illuminate\Support\Facades\Log;

class cadenaController extends Controller
{
	public function index()
	{
		return response()->json("Todo está bien", 200);
	}

	public function store(Request $request)
	{
		$puntos = $request->conteo * 3;
		$semilla = $request->conteo + $request->maquina + time();
		$codigo = substr(md5($semilla), 17);	//Sí, el código es un hash.
		$objetoCadena = [
			"cadena" => $codigo,
			"id_maquina" => $request->maquina,
			"status" => 1,
			"tapas" => $request->conteo,
			"puntos" => $puntos
		];
		Cadena::create($objetoCadena);
		return json_encode(['Codigo' => $codigo]);
	}

	public function update(Request $request)
	{
		//Agregar comportamiento para el reclamo de cadenas.
	}
}
