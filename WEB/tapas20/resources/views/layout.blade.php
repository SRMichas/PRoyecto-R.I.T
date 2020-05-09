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
  <div class="row">
    <div class="col-2 bg-light  border vertical" style="background-color: white;">
     
    </div>  
    <div class="col-10">
      <div class="row">
        <div class="col col-nav">
          <header>
            <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom nav">
              <div id="contenedor_img">
                <a class="navbar-brand" href="#">
                  <img src="{{ asset('img/tapaton.png') }}" id="img_nav" alt="">
                </a>
              </div>
              <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
              </button>
              <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mr-auto">

                  <li class="nav-item active">
                    <a class="btn nav-link btn-block" href="{{url('inicio')}}">Inicio</a>
                  </li>

                  <li class="nav-item">
                    <a class="btn nav-link btn-block" href="{{route('home.nosotros')}}">Nostros</a>
                  </li>

                  <li class="nav-item">
                    <a class="btn nav-link btn-block" href="{{route('home.tapaton')}}">Tapaton</a>
                  </li>
                </ul>
                <form class="form-inline my-2 my-lg-0">
                  @if (session('usuario'))
                  <div class="dropdown">
                    <a class="btn btn-secondary dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                      {{session('usuario')}}</a>
                    <div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                      <a class="dropdown-item" href="{{route('usuario.perfil')}}">Perfil</a>
                      <a class="dropdown-item" href="{{route('cerrar.index')}}">cerrar sesion</a>
                      
                    </div>
                  </div>
                  @else
                  <div class="row">
                    <div class="col">
                      <a class="btn" href="{{url('login')}}">Login</a>
                    </div>
                    <div class="col">
                      <a class="btn" href="{{url('registro')}}">Register</a>
                    </div>
                  </div>
                  @endif

                </form>
              </div>
            </nav>
          </header>
        </div>
      </div>
      <div class="row">
        <div class="col">
        @yield('content')
        
      </div>
      </div>
    </div>

    <script src="{{ asset('js/jquery.js') }}"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
      integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
      crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
      integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
      crossorigin="anonymous"></script>
</body>

</html>