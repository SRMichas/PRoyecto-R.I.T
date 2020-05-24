<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Cadena extends Model
{
	protected $table = 'cadenas';
	protected $fillable = [
		'cadena',
		'id_maquina',
		'status',
		'tapas',
		'puntos'
	];
}
