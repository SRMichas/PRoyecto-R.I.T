@extends('layout')
@section('content')
<div class="card form-container bg-light mb-0 div-p">
    <div class="card-body">
{{-- <table class="table table-hover">
    <thead>
      <tr>
        <th scope="col-2">#</th>
        <th scope="col-2">Cadena</th>
        <th scope="col-2">id_maquina</th>
        <th scope="col-2">Fecha Registro</th>
      </tr>
    </thead>
    <tbody>
      @foreach ($cadenas as $item)
      <tr>
        <th scope="row">{{$item[0]->id}}</th>
        <td>{{$item[0]->cadena}}</td>
        <td>{{$item[0]->id_maquina}}</td>
        <td>{{$item[0]->created_at}}</td>
      </tr>
      @endforeach
    </tbody>
  </table> --}}
  <table class="table table-hover">
    <thead>
      <tr>
        <th scope="col">#</th>
        <th scope="col">Cadena</th>
        <th scope="col">id_maquina</th>
        <th scope="col">Fecha Registro</th>
        <th scope="col">Detalles</th>
      </tr>
    </thead>
    <tbody>
      @foreach ($cadenas as $item)
      <tr>
        <th scope="row">{{$item[0]->id}}</th>
        <td>{{$item[0]->cadena}}</td>
        <td>{{$item[0]->id_maquina}}</td>
        <td>{{$item[0]->created_at}}</td>
        <td><input type="button" class="button btn-outline-success" value="Detalles"></td>
      </tr>
      @endforeach
     
    </tbody>
  </table>
    </div>
</div>  

@endsection
