@extends('layout')
@section('content')
<div class="container mb-3 mt-3">
  <table id="example" class="display responsive nowrap mitabla" style="width:100%">
      <thead>
          <tr>
            <th scope="col">#</th>
            <th scope="col">Cadena</th>
            <th scope="col">id_maquina</th>
            <th scope="col">Fecha Registro</th>
          </tr>
      </thead>
      <tbody>
        @foreach ($cadenas as $item)
          <tr>
            <td scope="row">{{$item[0]->id}}</td>
            <td>{{$item[0]->cadena}}</td>
            <td>{{$item[0]->id_maquina}}</td>
            <td>{{$item[0]->created_at}}</td>
          </tr>
          @endforeach
      </tfoot>
  </table>
</div>  
@endsection