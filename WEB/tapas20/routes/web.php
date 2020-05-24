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
Route::post('login','loginController@acceder')->name('login.index');

Route::post('cadena','usuariosController@cadena')->name('usuario.cadena');
Route::get('cerrar','loginController@cerrar')->name('cerrar.index');
Route::get('login','loginController@vistaLogin');
Route::get('user','usuariosController@vistaPrincipal');
Route::get('perfil','usuariosController@perfil')->name('usuario.perfil');

Route::get('inicio', 'homeController@inicio')->name('home.inicio');
Route::get('tapaton','homeController@tapaton')->name('home.tapaton');
Route::get('nosotros','homeController@nosotros')->name('home.nosotros');
Route::post('inicio', 'registroController@comfirmar')->name('registro.comfirmar');

Route::get('registro', 'registroController@vistaRegistrar');
Route::post('/','registroController@registrar')->name('registro.crear');
//route::post('/','pruebasController@crear')->name('prueba.crear');

// ruta de formulario
Route::get('/form', 'ControllerMail@index');
// ruta al enviar correo
Route::post('/send', 'ControllerMail@send');

Route::get('tables',function()
{
    return view('usuario.tabla');
});