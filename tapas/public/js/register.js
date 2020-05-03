$( document ).ready(function() {
    console.log( "ready!" );
    var token =  $('input[name="csrfToken"]').attr('value'); 
    $('#btn_entrar').click(function()
    {
        let registro = new Object()
        registro.nombre = $('#inp_nombre').val()
        registro.email = $('#inp_email').val()
        registro.contrasena = $('#inp_contraseña').val()
        registro.confirmacion = $('#inp_conf_contraseña').val()
        console.log(registro)
        
        $.each(registro, function( index, value ) {
            if(value === "")
            {
                alert("Debes de completar todos los campos")
                return false
            }
          });
         
         if(confirmar(registro.contrasena,registro.confirmacion))
         {
            $.ajax({
                url: 'http://localhost:8000/prueba2'
                , method: 'POST'
                ,headers: {
                    'X-CSRF-Token': token 
               },
               data: registro
            }).done(function (response) {
                console.log(response);
            }).fail(function (jqXhr, textStatus) {
        
            });
         }
         else{
             
            $('#inp_contraseña').val("")
            $('#inp_conf_contraseña').val("")   
         }
    })
    function confirmar(contrasena,confCont)
    {
        if(contrasena == confCont)
        {
            return true
        }
        else{
            alert("Los campos de contraseña no coinsiden")
            return false
        }

    }
});
