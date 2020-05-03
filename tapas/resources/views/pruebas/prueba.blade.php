@extends('layout')

@section('content')
<input type="text" name="csrfToken" value="{{csrf_token()}} " hidden>
<table class="table">
    <thead>
      <tr>
        <th scope="col">ID</th>
        <th scope="col">EMAIL</th>
        <th scope="col">PASS</th>
      </tr>
    </thead>
    <tbody>
   @foreach ($user as $item)
      <tr>
        <th scope="row">{{$item->id }}</th>
        <td>{{$item->email}}</td>
        <td>{{$item->pass}}</td>
      </tr>
    @endforeach
    </tbody>
  </table>
  
   <form method="POST" action="{{route('prueba.crear')}}">
      <div class="row">
      @csrf
      <div class="col-4">
      <input type="text"name="email" id="inp_email" placeholder="Email"class="form-control mb-2"/>
      </div>
      <div class="col-4">
      <input type="text"name="pass" id="inp_pass" placeholder="Pass"  class="form-control mb-2"/>
      </div>
      <div class="col-2">
      <button class="btn btn-primary btn-block" id="btn_guardar" type="submit">Agregar</button>
    </div>  
    </div>
</form>

@endsection