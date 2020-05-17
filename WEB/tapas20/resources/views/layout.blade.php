<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <title>Document</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
    integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
  <link rel="stylesheet" href="{{ asset('css/index.css') }}">
  <link rel="stylesheet" href="{{ asset('css/perfil.css') }}">
  <link href="{{asset('css/simple-sidebar.css')}}" rel="stylesheet">
</head>
<body>
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="#">
      <img src="{{ asset('img/tapaton.png') }}" id="img_nav" alt="">
    </a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarText">
      <ul class="navbar-nav mr-auto">
        <li class="nav-item nav-i active">
          <a class="nav-link" href="{{url('inicio')}}">Inicio <span class="sr-only">(current)</span></a>
        </li>
        <li class="nav-item nav-i active">
          <a class="nav-link" href="{{route('home.nosotros')}}">Nosotros</a>
        </li>
        <li class="nav-item nav-i active">
          <a class="nav-link" href="{{route('home.tapaton')}}">Tapaton</a>
        </li>
        
        @if (session('usuario'))
        
        <div class="dropdown d-lg-none d-xl-none li-1 d-sm-block">
          <a class="btn btn-secondary dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            {{session('usuario')}}</a>
          <div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
            <a class="dropdown-item" href="{{route('usuario.perfil')}}">Perfil</a>
            <a class="dropdown-item" href="{{route('cerrar.index')}}">cerrar sesion</a>
            
          </div>
        @else
        <li class="nav-item d-lg-none d-xl-none li-1 d-sm-block">
          <a class="nav-link" href="{{url('login')}}">Login</a>
        </li>
        <li class="nav-item d-lg-none d-xl-none d-sm-block">
          <a class="nav-link" href="{{url('Registro')}}">Registro</a>
        </li>
        </div>
        @endif
      </ul>
      @if (session('usuario'))
                <div class="dropdown btn-l d-lg-block">
                  <a class="btn btn-secondary dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    {{session('usuario')}}</a>
                  <div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                    <a class="dropdown-item" href="{{route('usuario.perfil')}}">Perfil</a>
                    <a class="dropdown-item" href="{{route('cerrar.index')}}">cerrar sesion</a>
                    
                  </div>
                </div>
      @else
      <div class="btn-l d-lg-block">
        <a class="btn" href="{{url('login')}}">Login</a>
      </div>
      <div class="btn-l d-lg-block">
        <a class="btn" href="{{url('registro')}}">Register</a>
      </div>
      @endif
    </div>
  </nav>
  <div class="row">
    <div class="col">
    @yield('content')
    
  </div>
  </div>

    <script src="{{ asset('js/jquery.js') }}"></script>
    <script src="{{asset('js/bootstrap.js')}}"></script>
    <script src="{{asset('js/bootstrap.bundle.js')}}"></script>
    <script src="{{asset('js/bootstrap.bundle.min.js')}}"></script>
    <script src="{{asset('js/inicio.js  ')}}"></script>

</body>

</html>