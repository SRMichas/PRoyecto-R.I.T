@extends('layout')

@section('content')
@if(session('usuario')) 
<div id="div_mensaje" style="display:none">
</div>
<div class="row rowp">
    @foreach ($arreglo[0] as $item)
    <div class="col-sm-6 col-md-4 col-lg-3 col-6 col-a" style="margin-top: 10px" >
        <div class="card cardp" >
            <img src="{{$item->icono}}" class="card-img-top imgc" alt="...">
            <div class="card-body">
              <h5 class="card-title">{{$item->nombre}}</h5>
              <p class="card-text">{{$item->descripcion}}</p>
              <a href="#" class="btn btn-primary col-12" data-toggle="modal" data-target="#M{{$item->id_categoria}}">Ver</a>
            </div>
          </div>
    </div>
<div class="modal fade" id="M{{$item->id_categoria}}" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-labelledby="staticBackdropLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="staticBackdropLabel">{{$item->nombre}}</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <table class="table table-borderless">
            <thead>
              
              <tr>
                <th scope="col">id</th>
                <th scope="col">nombre</th>
                <th scope="col">costo</th>
              </tr>
            </thead>
            <tbody>
                @foreach ($arreglo[1] as $item2)
                @if ($item2->id_categoria == $item->id_categoria)
                <tr>
                  <td>{{$item2->id_premio}}</td>
                  <td>{{$item2->nombre}}</td>
                  <td>{{$item2->costo}}</td>
                  <td><input type="button" value="Elegir" data-dismiss="modal" class="btn-success bb" id="{{$item2->id_premio}}" ></td>
                </tr>
                @endif
                @endforeach
              </tbody> 
           </table>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>
 @endforeach 
  </div>
@else 
 <p>Esta seccion de premios esta restringida para usuarios no logueados por favor inicia sesion <a href="{{route('usuario.login')}}">login</a></a></p>
@endif 
@endsection