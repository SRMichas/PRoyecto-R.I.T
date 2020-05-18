@extends('layout')

@section('content')
@if (session('usuario'))
<div class="card form-container bg-light mb-0 div-p">
    <div class="card-body">
        <form>
            <div class="form-group row">
                <label for="txt_nombre" class="col-sm-2 col col-form-label">Nombre</label>
                <div class="col-sm-3 mb-2 col-md-12 col-lg-3">
                    <input type="text" class="form-control" id="txt_nombre" placeholder="Nombre..." />
                </div>
                <label for="txt_id" class="col-sm-2 col col-form-label">Apellido</label>
                <div class="col-sm-3 mb-2 col-md-12 col-lg-3">
                    <input type="text" class="form-control" id="txt_id" placeholder="Apellido..." />
                </div>
            </div>
            <div class="form-group row">
                <label for="txt_email" class="col-sm-2 col-form-label">Email</label>
                <div class="col-sm-3 col-md-12 col-lg-3">
                    <input type="text" class="form-control" id="txt_email"  placeholder="email"/>
                </div>
                <label for="txt_ciudad" class="col-sm-2 col-form-label">Ciudad</label>
                <div class="col-sm-3 col-md-12 col-lg-3">
                    <input type="text" class="form-control" id="txt_ciudad"  placeholder="ciudad"/>
                </div>
            </div>
            <div class="form-group row">
                <label for="tapas" class="col-sm-2 col-form-label">Tapas</label>
                <div class="col-sm-3 col-md-12 col-lg-3">
                    <input type="text" class="form-control" id="tapas" disabled value="250"  placeholder="Tapas recolectadas "/>
                </div>
                <label for="puntos" class="col-sm-2 col-form-label">Puntos</label>
                <div class="col-md-12 col-sm-3 col-lg-3">
                    <input type="text" class="form-control" id="puntos" disabled value="2500" placeholder="Puntos"/>
                </div>
            </div>
            <div class="col-sm-12 col-lg-12">
                
                    <input type="button" class="btn btn-primary col-lg-4 col-sm-12" 
                       id="btn_add" value="Actualizar Informacion" />
                       
                    <a href="{{route('usuario.historial')}}"><input type="button" class="btn btn-info col-lg-4 col-sm-12" 
                       id="btn_his" value="Historial de Ingresos"  /></a>
            </div>            
        </form>
    </div>
</div>
@else
<h1>
    Area Restringida Maldito intruso
</h1>
@endif
@endsection