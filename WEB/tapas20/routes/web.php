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

Route::get('/','homeController@inicio');
Route::get('historial', 'usuariosController@historial')->name('usuario.historial');
Route::get('compras', 'usuariosController@compras')->name('usuario.compras');
Route::post('login','loginController@acceder')->name('login.index');

Route::post('cadena','usuariosController@cadena')->name('usuario.cadena');
Route::get('cerrar','loginController@cerrar')->name('cerrar.index');
Route::get('login','loginController@vistaLogin')->name('usuario.login');
Route::get('user','usuariosController@vistaPrincipal');
Route::get('perfil','usuariosController@perfil')->name('usuario.perfil');

Route::get('inicio', 'homeController@inicio')->name('home.inicio');
Route::get('rit', 'homeController@rit')->name('home.rit');
Route::get('premios', 'homeController@premios')->name('home.premios');
Route::get('tapaton','homeController@tapaton')->name('home.tapaton');
Route::get('nosotros','homeController@nosotros')->name('home.nosotros');

Route::get('confirmar/{correo}', 'registroController@confirmar')->name('registro.confirmar');

Route::get('registro', 'registroController@vistaRegistrar');
Route::post('gastar', 'homeController@gastarPuntos');

Route::post('/','registroController@registrar')->name('registro.crear');
//route::post('/','pruebasController@crear')->name('prueba.crear');
Route::post('ciudades', 'registroController@getCiudades');
// ruta de formulario
Route::get('/form', 'ControllerMail@index');
// ruta al enviar correo
Route::post('/send', 'ControllerMail@send');

Route::get('tables',function()
{
    return view('usuario.tabla');
});
