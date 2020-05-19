<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Cadena;

class cadenaController extends Controller
{
	public function cadena()
	{
		return response()->json(Cadena::get(), 200);
	}
}
