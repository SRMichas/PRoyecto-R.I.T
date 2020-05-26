<!DOCTYPE html>
<html>
 <head>
  <title>Message</title>
  <link href="https://fonts.googleapis.com/css?family=Nunito:200,600" rel="stylesheet">
  <!-- Styles -->
  <style>
      html, body {
          background-color: #fff;
          color: #636b6f;
          font-family: 'Nunito', sans-serif;
          font-weight: 200;
          height: 100vh;
          margin: 0;
      }
      .content { text-align: center; }
      .title { font-size: 84px; }
  </style>
 </head>
 <body>
  <br />
  <div class="container box" style="width: 970px;">
   <img src="./" alt="">
   <h3 align="center">{{$data['mensaje'] }}</h3>
   
   
    <input type="text"  name="correo" value="{{$data['correo']}}" style="display: none">
    
   <button><a href="{{url('confirmar/'.$data['correo'])}}"> Confirmar</a></button>
  </div>    
 </body>
 
</html> 