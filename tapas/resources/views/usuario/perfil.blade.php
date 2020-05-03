@extends('layout')

@section('content')
<div class="card form-container mb-1 div-p">
    <div class="card-body">
        <form>
            <div class="form-group row">
                <label for="txt_nombre" class="col-sm-2 col-form-label">Nombre</label>
                <div class="col-sm-3 mb-2">
                    <input type="text" class="form-control" id="txt_nombre" placeholder="Factura..." />
                </div>
                <label for="txt_id" class="col-2 col-form-label">Apellido</label>
                <div class="col-sm-3 mb-2">
                    <input type="text" class="form-control" id="txt_id" placeholder="Factura..." />
                </div>
            </div>
            <div class="form-group row">
                <label for="txt_email" class="col-sm-2 col-form-label">Email</label>
                <div class="col-sm-3">
                    <input type="text" class="form-control" id="txt_email"  placeholder="email"/>
                </div>
                <label for="txt_ciudad" class="col-sm-2 col-form-label">Ciudad</label>
                <div class="col-sm-3">
                    <input type="text" class="form-control" id="txt_ciudad"  placeholder="ciudad"/>
                </div>
            </div>
            <div class="form-group row">
                <label for="tapas" class="col-sm-2 col-form-label">Tapas</label>
                <div class="col-sm-3">
                    <input type="text" class="form-control" id="tapas" value="250"  placeholder="Tapas recolectadas "/>
                </div>
                <label for="puntos" class="col-sm-2 col-form-label">Puntos</label>
                <div class="col-sm-3">
                    <input type="text" class="form-control" id="puntos" value="2500" placeholder="Puntos"/>
                </div>
            </div>
            <div class="col-sm-3 offset-7 ">
                <input type="button" class="btn btn-primary col-sm-12" 
                       id="btn_add" value="Actualizar Informacion" />
            </div>
        </form>
    </div>
</div>
@endsection