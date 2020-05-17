@extends('layout')

@section('content')

<div class="col-xl-6 col-md-8 col-sm-8 div-c bg-white" style="border: 1px solid black;">
<div id="carouselExampleIndicators" class="carousel slide border-danger" data-ride="carousel">
    <ol class="carousel-indicators">
      <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
      <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
      <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
    </ol>
    <div class="carousel-inner">
      <div class="carousel-item active">
        <img class="d-block w-100 img-c" src="{{asset('img/itctapas.jpg')}}" alt="Third slide">
        <div class="carousel-caption  d-md-block">
            <h3>Tec Apoyando Al Tapaton</h3>
            <font size="5px"><p>Con la iniciativa del apoyo, el tecnologico de culiacan decide apoyar de manera altruista</p></font>
          </div>
        
      </div>
      <div class="carousel-item">
        <img class="d-block w-100 img-c" src="{{asset('img/OP.jpg')}}" alt="First slide">
        <div class="carousel-caption d-md-block">
            <h3>Vamos Apoyando!!</h3>
            <font size="5px"> <p>en distintos sectores se apoya teniendo puntos de recaudacion</p></font>
          </div>
        
      </div>
      <div class="carousel-item">
        <img class="d-block w-100 img-c"src="{{asset('img/tapas.jpg')}}" alt="Second slide">
        <div class="carousel-caption d-md-block">
            <h3>Tapas Permitidas</h3>
            <font size="5px"> <p>Tapas permitidas que puedes donas, Juntos hagamos una buena accion</p></font>
          </div>
        
      </div>
    </div>
    <a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
      <span class="sr-only">Previous</span>
    </a>
    <a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
      <span class="carousel-control-next-icon" aria-hidden="true"></span>
      <span class="sr-only">Next</span>
    </a>
  </div>
</div>
@endsection