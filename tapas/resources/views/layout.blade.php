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
</head>
<body>
  <div class="row">
    <div class="col-2 vertical" style="background-color: blue;"></div>
    <div class="col">
      <div class="row">
        <div class="col" style="background-color: white;">
          <header>
            <nav class="navbar navbar-expand-lg navbar-light  nav">
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
                    <a class="btn nav-link btn-block" href="#">Nostros</a>
                  </li>

                  <li class="nav-item">
                    <a class="btn nav-link btn-block" href="#">Tapaton</a>
                  </li>
                </ul>
                <form class="form-inline my-2 my-lg-0">
                  @if (session('usuario'))
                  <a href="{{route('usuario.perfil')}}">{{session('usuario')}}</a>
                  <a class="btn" href="{{route('cerrar.index')}}">Cerrar Sesion</a>
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