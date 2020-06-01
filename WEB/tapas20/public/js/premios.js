$( document ).ready(function() {
    console.log( "ready! premios" );
    
    $(".bb").click(function(){
        $(".loader").show();
        var button = this;
        var costo = $(this).parent().parent().children().eq(2)
        var id = $(this).parent().parent().children().eq(0)
        var json = new Object();

        json.costo = costo.text();
        json.id = id.text();
        $.ajax({
             url:'http://9f384f460fee.ngrok.io/gastar',
             dataType: "json"
             , method: 'POST'
             , data : json
         }).done(function (response) {
            if(response[0] == 0)
            {
                $(".loader").hide();
                $('#div_mensaje').html('<div class="alert alert-success" style="text-align: center;">'+response[1]+'</div>');
                $('#div_mensaje').show(1000);
                setTimeout(function() {
                    $("#div_mensaje").hide(1500);
                },3000);
            }
            else{
                $(".loader").hide();
                $('#div_mensaje').html('<div class="alert alert-danger" style="text-align: center;">'+response[1]+'</div>');
                $('#div_mensaje').show(1000);
                setTimeout(function() {
                    $("#div_mensaje").hide(1500);
                },3000);
            }
           
            
            console.log(response)
        }).fail(function (jqXhr, textStatus) {
    
        });
        
    });
});
