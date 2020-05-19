@extends('layoutcuenta')

@section('content')
@if(Session('usuario'))
<h1>Deslogueate primero Men no seas gacho con la paginta esa culey :c</h1>
<a class="btn button-primary" href="{{route('usuario.perfil')}}"><input type="button" class="btn btn-primary" value="Perfil"></a>
<a class="btn button-primary" href="{{route('cerrar.index')}}"><input type="button" class="btn btn-primary" value="Cerrar Sesion"></a>
@else
<input type="text" name="csrfToken" value="{{csrf_token()}} " hidden>
<link rel="stylesheet" href="{{ asset('css/login.css') }}">
<div class="main">
    <div class="item">
      <div class="content">
        <form method="POST" class="form-horizontal" action="{{route('registro.crear')}}">
          @if ($errors->any())
              <div class="alert alert-danger">
                  <ul>
                      @foreach ($errors->all() as $error)
                          <li>{{ $error }}</li>
                      @endforeach
                  </ul>
              </div>
          @endif
          <div class="logo"><img src="{{ asset('img/user1.png') }}"></div>
          <div class="input-group lg">
            <span class="input-group-addon"><i class="fa fa-user" aria-hidden="true"></i></span>
            <input type="text" name="nombre"  class="form-control" placeholder="Nombre" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Nombre'" id="inp_nombre">
          </div>
          <div class="input-group lg">
            <span class="input-group-addon"><i class="fa fa-user" aria-hidden="true"></i></span>
            <input type="text" name="apellido"  class="form-control" placeholder="Apellido" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Apellido'" id="inp_apellido">
          </div>
          <div class="input-group lg">
            <span class="input-group-addon"><i class="fa fa-envelope" aria-hidden="true"></i></span>
            <input type="email" name="email" class="form-control" placeholder="Email" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Email'" id="inp_email">
          </div> 
          <div class="input-group lg">
            <span class="input-group-addon"><i class="fa fa-envelope" aria-hidden="true"></i></span>
            <input type="number" name="edad" class="form-control" placeholder="edad" onfocus="this.placeholder = ''" onblur="this.placeholder = 'edad'" id="edad">
          </div> 
          <div class="input-group lg">
            <span class="input-group-addon"><i class="fa fa-lock" aria-hidden="true"></i></span>
            <input type="password" name="pass" class="form-control" placeholder="Contraseña" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Contraseña'" id="inp_contraseña">
          </div>  
          <div class="input-group lg">
            <span class="input-group-addon"><i class="fa fa-lock" aria-hidden="true"></i></span>
            <input type="password" name="pass_confirmation" class="form-control" placeholder="Confirmar contraseña" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Confirmar contraseña'" id="inp_conf_contraseña">
          </div>  
          <div class="form-group in">
          <input type="submit" name="reg" class="btn btn-info btn-block" value="Registrar" id="btn_entrar"><br>
          <button type="button" name="back" class="btn btn-danger btn-block" id="back"><a href="{{url('index')}}">INICIO</a></button>
          <!-- <input type="button"  class="btn btn-info btn-block" value=""> -->
          </div>
        </form>
      </div>
    </div>
  </div>
@endif

@endsection
