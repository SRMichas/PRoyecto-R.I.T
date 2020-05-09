<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});
Route::post('login','loginController@acceder')->name('login.index');
Route::get('cerrar','loginController@cerrar')->name('cerrar.index');
Route::get('login','loginController@vistaLogin');
Route::get('user','usuariosController@vistaPrincipal');
Route::get('perfil','usuariosController@perfil')->name('usuario.perfil');

Route::get('inicio', 'homeController@inicio')->name('home.inicio');
Route::get('tapaton','homeController@tapaton')->name('home.tapaton');
Route::get('nosotros','homeController@nosotros')->name('home.nosotros');


Route::get('registro', 'registroController@vistaRegistrar');
Route::post('/','registroController@registrar')->name('registro.crear');
//route::post('/','pruebasController@crear')->name('prueba.crear');
