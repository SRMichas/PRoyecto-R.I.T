$( document ).ready(function() {
    console.log( "ready!" );
    $("#select_estados").change(function(){
        $('#div_ciudad').html('<div class="loading"><img src="https://i.kinja-img.com/gawker-media/image/upload/s--LytxZcab--/c_fit,fl_progressive,q_80,w_636/1481054780733836946.gif" width="50px" alt="loading" /><br/>Un momento, por favor...</div>');
        console.log($('select[id=select_estados]').val()); 
        
        $.ajax({
            url: 'http://9f384f460fee.ngrok.io/ciudades',
            dataType: "json"
            , method: 'POST'
        }).done(function (response) {
            console.log(response);
            $('#div_ciudad').html('<select name="ciudad" class="custom-select mr-sm-2" id="select_ciudades"></select>');
            $('#select_ciudades').html("");
            $.each(response, function(i, value) {
                console.log(value);
             $('#select_ciudades').html($('#select_ciudades').html()+'<option value="'+value.id_ciudad+'">'+value.nombre+'</option>');     
            }); 
        }).fail(function (jqXhr, textStatus) {
    
        });

    });
});
