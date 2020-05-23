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
   
   <h3 align="center">{{$data['mensaje'] }}</h3>
   
   <form  action="{{route('registro.comfirmar')}}" method="POST">
    <input type="text" hidden name="correo" value="{{$data['correo']}}">
    <button type="submit">Comfirmar</button>
   </form>
  </div>
 </body>
 
</html> 