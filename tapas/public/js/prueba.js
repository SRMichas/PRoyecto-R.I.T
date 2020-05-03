$(function()
{
    $('#btn_guardar').click(function()
    {
        var token =  $('input[name="csrfToken"]').attr('value'); 
        var request = new Object()
        request.email = $('#inp_email').val();
        request.pass = $('#inp_pass').val();

        $.ajax({
            url: 'http://localhost:8000/'
            , method: 'POST'
            ,headers: {
                'X-CSRF-Token': token 
           },
           data: request
        }).done(function (response) {
            
        }).fail(function (jqXhr, textStatus) {
    
        });
    })
})