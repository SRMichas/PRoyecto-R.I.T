<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class homeController extends Controller
{
    //
    public function inicio()
    {
        return view('home.index');
    }
    public function tapaton()
    {
        return view('home.tapaton');
    }
    public function nosotros()
    {
        return view('home.nosotros');
    }
}
