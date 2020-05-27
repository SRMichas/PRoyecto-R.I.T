@extends('layout')
@section('content')
<div class="container mb-3 mt-3">
  <table id="example" class="display responsive nowrap mitabla" style="width:100%">
      <thead>
          <tr>
            <th scope="col">#</th>
            <th scope="col">Premio</th>
            <th scope="col">categoria</th>
            <th scope="col">Costo</th>
          </tr>
      </thead>
      <tbody>
        @foreach ($servicio as $item)
          <tr>
            <td>{{$item->id}}</td>
            <td>{{$item->nombre}}</td>
            <td>{{$item->categoria}}</td>
            <td>{{$item->costo}}</td>
          </tr>
          @endforeach
      </tfoot>
  </table>
</div>  
@endsection