<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Cadena;

class cadenaController extends Controller
{
	public function cadena()
	{
		$code = 200;
		return json_encode($code);
	}
}
