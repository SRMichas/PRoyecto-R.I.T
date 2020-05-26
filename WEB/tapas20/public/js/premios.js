$( document ).ready(function() {
    console.log( "ready! premios" );
    $(".bb").click(function(){
        $('#div_mensaje').html('<div class="loading alert alert-info" style="text-align: center;"><img  src="https://i.kinja-img.com/gawker-media/image/upload/s--LytxZcab--/c_fit,fl_progressive,q_80,w_636/1481054780733836946.gif" width="50px" alt="loading" /><br/>Un momento, por favor...</div>');
        var button = this;
        // $('#inp_costo').html('<div class="loading"><img src="https://i.kinja-img.com/gawker-media/image/upload/s--LytxZcab--/c_fit,fl_progressive,q_80,w_636/1481054780733836946.gif" width="50px" alt="loading" /><br/>Un momento, por favor...</div>');
        // console.log($('select[id=select_estados]').val()); 
        // $.get("http://localhost:8000/costos/"+$("#selec_premio").val(), function(data, status){
        //     alert("Data: " + data + "\nStatus: " + status);
        //   });
        var costo = $(this).parent().parent().children().eq(2)
        var id = $(this).parent().parent().children().eq(0)
        var json = new Object();

        json.costo = costo.text();
        json.id = id.text();
        $.ajax({
             url:'http://localhost:8000/gastar',
             dataType: "json"
             , method: 'POST'
             , data : json
         }).done(function (response) {
            $('#div_mensaje').html('<div class="alert alert-success" style="text-align: center;">Se ha adquirido el premio Correctamente . . .  Guapo </div>');
            console.log(response)
        }).fail(function (jqXhr, textStatus) {
    
        });
        
    });
});
