@extends('layoutcuenta')

@section('content')
<link rel="stylesheet" href="{{ asset('css/login.css') }}">
@if (session('usuario'))
<h1>Ya estas Logueado Men sacate a a la verga tu <a href="{{route('usuario.perfil')}}">perfil</a> . . ..  guapo 7u7</h1>
@else
<div class="main">
    <div class="item">
      <div class="content">
        <form action="{{route('login.index')}}" czlass="form-horizontal" method="POST">
          @if(session('nota'))
            <div class="alert alert-danger">{{session('nota')}}</div>
          @endif
          <div class="logo">
              <img src="{{ asset('img/user1.png') }}">
            </div>
          <div class="input-group lg">
            <span class="input-group-addon"><i class="fa fa-user" aria-hidden="true"></i></span>
            <input type="text" name="username" class="form-control" placeholder="Username" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Username'">
          </div>
          <div class="input-group lg">
            <span class="input-group-addon"><i class="fa fa-lock" aria-hidden="true"></i></span>
            <input type="password" name="password" class="form-control" placeholder="Password" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Password'">
          </div>  
 
          <div class="form-group in">
          <input type="submit" name="reg" class="btn btn-info btn-block" value="LOGIN"><br>
          <button type="button" name="signup" class="btn btn-success btn-block" id="back"><a href="register.php">SIGN UP</a></button>
          </div>
        </form>
      </div>
    </div>
  </div>
  @endif
@endsection