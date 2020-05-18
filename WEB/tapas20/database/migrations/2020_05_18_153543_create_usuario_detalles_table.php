<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUsuarioDetallesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('usuario_detalles', function (Blueprint $table) {
            $table->primary(['id_usuario','id_cadena']);
            $table->foreignId('id_cadena')->references('id')->on('cadenas');
            $table->foreignId('id_usuario')->references('id')->on('usuarios');
            $table->timestamps('');
            $table->integer('id_maquina');
        });
    }
    /*
        id_usuario int not null,
	id_cadena int not null,
	fecha DATE(50) not null,
	id_maquina int not null,
	PRIMARY KEY(id_usuario,id_cadena)
    */

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('usuario_detalles');
    }
}
