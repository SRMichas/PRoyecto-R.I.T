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
		$semilla = $request->conteo + $request->maquina + time();
		$codigo = md5($semilla);	//Sí, el código es un hash.
		return response()->json(['Codigo' => substr($codigo, 17)]);
	}

	public function update(Request $request)
	{
		//Agregar comportamiento para el reclamo de cadenas.
	}
}
